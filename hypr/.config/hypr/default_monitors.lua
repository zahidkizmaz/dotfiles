-- Static default monitors managed by us.
-- monitors.lua is managed by nwg-displays instead.
--
-- Virtual-1 appears when running inside a VM (e.g. QEMU/Spice).
-- nwg-displays won't touch this, so it always works in VMs.
hl.monitor({
  output = "Virtual-1",
  mode = "1920x1080",
  position = "auto",
  scale = "1.0",
})
