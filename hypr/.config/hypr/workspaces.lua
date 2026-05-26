hl.workspace_rule({ workspace = "1", monitor = "desc:BOE 0x0BCA", default = true })
hl.workspace_rule({ workspace = "2", monitor = "desc:BOE 0x0BCA" })
hl.workspace_rule({ workspace = "3", monitor = "desc:BOE 0x0BCA" })
hl.workspace_rule({ workspace = "4", monitor = "desc:BOE 0x0BCA" })
hl.workspace_rule({ workspace = "5", monitor = "desc:BOE 0x0BCA" })
hl.workspace_rule({ workspace = "6", monitor = "desc:Samsung Electric Company S27D850 0x304C3533", default = true })
hl.workspace_rule({ workspace = "7", monitor = "desc:Samsung Electric Company S27D850 0x304C3533" })
hl.workspace_rule({ workspace = "8", monitor = "desc:Samsung Electric Company S27D850 0x304C3533" })
hl.workspace_rule({ workspace = "9", monitor = "desc:Samsung Electric Company S27D850 0x304C3533" })
hl.workspace_rule({ workspace = "10", monitor = "desc:Samsung Electric Company S27D850 0x304C3533" })

-- Smart gaps: remove gaps on single-tiled or fullscreen workspaces
hl.workspace_rule({ workspace = "w[tv1]", gaps_in = 0, gaps_out = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_in = 0, gaps_out = 0 })
