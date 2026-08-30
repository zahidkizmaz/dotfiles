-- run.lua: Start/restart programs with logging, running in Hyprland's Lua context
-- so it inherits hl.env variables automatically.

---@diagnostic disable: undefined-global
---@type HL.API
local hl = hl or {}

local home = os.getenv("HOME")
if not home then
  error("HOME environment variable not set")
end
local log_dir = home .. "/.cache/hyprland/logs"

---@class RunModule
local M = {}

-- Internal: ensure log directory exists
local function ensure_log_dir()
  os.execute("mkdir -p " .. log_dir)
end

-- Internal: append to log file
---@param name string
---@param msg string
local function log(name, msg)
  local log_file = log_dir .. "/" .. name .. ".log"
  local f = io.open(log_file, "a")
  if f then
    f:write(string.format("[%s] %s\n", os.date("%Y-%m-%d %H:%M:%S"), msg))
    f:close()
  end
end

-- Internal: escape string for pgrep pattern
---@param s string
---@return string
local function escape_pattern(s)
  return s:gsub("([%%%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
end

-- Internal: check if process exists by basename (word boundary match)
---@param program string
---@return boolean
local function pid_exists(program)
  local basename = program:match("([^/]+)$")
  -- Match basename as word boundary in command line (handles nix store paths)
  -- Pattern: start of line OR space/slash, then basename, then end of line OR space
  local pattern = "(^|[/ ])" .. escape_pattern(basename) .. "($| )"
  local handle = io.popen(string.format("pgrep -f '%s' 2>/dev/null", pattern))
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result and result ~= ""
  end
  return false
end

-- Internal: wait for condition with polling (no fixed sleeps)
---@param condition_fn fun(): boolean
---@param timeout_ms? integer
---@param interval_ms? integer
---@return boolean
local function wait_for(condition_fn, timeout_ms, interval_ms)
  timeout_ms = timeout_ms or 1000
  interval_ms = interval_ms or 30
  local elapsed = 0
  while elapsed < timeout_ms do
    if condition_fn() then
      return true
    end
    os.execute(string.format("sleep %.3f", interval_ms / 1000))
    elapsed = elapsed + interval_ms
  end
  return false
end

-- Internal: kill processes by basename (word boundary match)
---@param program string
---@param name string
---@return boolean
local function kill_pids(program, name)
  local basename = program:match("([^/]+)$")
  -- Match basename as word boundary in command line
  local pattern = "(^|[/ ])" .. escape_pattern(basename) .. "($| )"

  local handle = io.popen(string.format("pgrep -f '%s' 2>/dev/null", pattern))
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result and result ~= "" then
      local pids = result:gsub("\n", " ")
      log(name, "restarting, killing PID(s): " .. pids)
      os.execute(string.format("pkill -f '%s' 2>/dev/null || true", pattern))
      -- Poll until processes are actually gone
      wait_for(function()
        return not pid_exists(program)
      end, 1000, 30)
      return true
    end
  end
  return false
end

-- Internal: build command string with proper shell escaping and env prefix
---@param program string
---@param args? string[]
---@return string
local function build_cmd(program, args)
  local parts = {
    "WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-wayland-1}",
    "QT_WAYLAND_DISABLE_WINDOWDECORATION=1",
    "QT_STYLE_OVERRIDE=", -- Unset for QML apps like librepods (kvantum breaks QML)
    "nohup",
    program,
  }
  if args then
    for _, arg in ipairs(args) do
      table.insert(parts, "'" .. arg:gsub("'", "'\\''") .. "'")
    end
  end
  return table.concat(parts, " ")
end

---Start a program if not already running
---@param program string  Program name or path
---@param args? string[]  Optional arguments
function M.start(program, args)
  local name = program:match("([^/]+)$")
  ensure_log_dir()

  if pid_exists(program) then
    return -- already running
  end

  local log_file = log_dir .. "/" .. name .. ".log"
  local f = io.open(log_file, "w")
  if f then
    f:close()
  end -- truncate

  log(name, name .. " starting")

  local cmd = build_cmd(program, args)
  hl.exec_cmd(cmd .. " >>" .. log_file .. " 2>&1 &")
end

---Restart a program (kill existing, then start)
---@param program string  Program name or path
---@param args? string[]  Optional arguments
function M.restart(program, args)
  local name = program:match("([^/]+)$")
  ensure_log_dir()

  if not kill_pids(program, name) then
    log(name, name .. " starting (was not running)")
  end

  local cmd = build_cmd(program, args)
  hl.exec_cmd(cmd .. " >>" .. log_dir .. "/" .. name .. ".log 2>&1 &")
end

return M
