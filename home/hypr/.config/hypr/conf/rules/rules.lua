--------------------------
---- WORKSPACE RULES  ----
--------------------------

-- local function fit_widths(is_open)
--     local ws = hl.get_active_workspace()
--     if not ws then return end
--     if tostring(ws.name):match("^special:") then return end  -- leave special workspaces alone
--
--     local n = #hl.get_workspace_windows(ws.id)
--
--     if n == 1 then
--         hl.dispatch(hl.dsp.layout("colresize all 0.8"))
--     elseif n == 2 and is_open then
--         hl.dispatch(hl.dsp.layout("colresize all 0.5"))
--     end
-- end
--
-- hl.on("window.open",    function() fit_widths(true)  end)
-- hl.on("window.destroy", function() fit_widths(false) end)

local specialWorkspaces = {
  ["⌘"] = {
    app = "kitty btop",
    monitor = "lenovoMonitor",
    key = "Escape",
    full = 1
  },
  ["♬"] = {
    app = "pear-desktop",
    monitor = "huaweiTab",
    key = "M",
    full = 2
  },
  ["◉"] = {
    app = "discord",
    monitor = "lenovoMonitor",
    key = "D",
    full = 1
  }
}

hl.on("workspace.created", function(ws)
  local short = ws.name:match("^special:(.+)$")
	local pro = specialWorkspaces[short]
	if pro and ws.is_empty then
		hl.exec_cmd(pro.app)
	end
end)

for name,pro in pairs(specialWorkspaces) do
	hl.window_rule({
		name = "fs-" .. name,
		match = { workspace = "special:" .. name },
		fullscreen_state = pro.full,
	})

  hl.bind(MOD .. pro.key, function()
      local ws = "special:" .. name

      local visible = false
      for _, m in ipairs(hl.get_monitors()) do
          local sp = m.active_special_workspace
          if sp and sp.name == ws then visible = true end
      end

      local w = hl.get_active_window()
      local focused = w ~= nil and w.workspace ~= nil and w.workspace.name == ws

      if focused then
          hl.dispatch(hl.dsp.workspace.toggle_special(name))
      elseif visible then
          hl.dispatch(hl.dsp.focus({ monitor = pro.monitor }))
      else
          hl.dispatch(hl.dsp.focus({ monitor = pro.monitor }))
          hl.dispatch(hl.dsp.workspace.toggle_special(name))
      end
  end)
end
