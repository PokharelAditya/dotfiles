--------------------------
---- WORKSPACE RULES  ----
--------------------------

local specialWorkspaces = {
	["⌘"] = {
		app = "kitty btop",
		monitors = {
			{ name = "lenovoMonitor", full = 1 },
			{ name = "huaweiTab", full = 2 },
		},
		key = "Escape",
	},
	["♬"] = {
		app = "pear-desktop",
		monitors = {
			{ name = "huaweiTab", full = 2 },
			{ name = "lenovoMonitor", full = 1 },
		},
		key = "M",
	},
	["◉"] = {
		app = "discord",
		monitors = {
			{ name = "lenovoMonitor", full = 1 },
			{ name = "huaweiTab", full = 2 },
		},
		key = "D",
	},
}

hl.on("workspace.created", function(ws)
  local short = ws.name:match("^special:(.+)$")
	local pro = specialWorkspaces[short]
	if pro and ws.is_empty then
		hl.exec_cmd(pro.app)
	end
end)

for name, pro in pairs(specialWorkspaces) do
	local ws = "special:" .. name

	hl.bind(MOD .. pro.key, function()
		local w = hl.get_active_window()
		local focused = w ~= nil and w.workspace ~= nil and w.workspace.name == ws

		if focused then
			hl.dispatch(hl.dsp.workspace.toggle_special(name))
		else
			local active = {}
			local visible = false
			for _, m in ipairs(hl.get_monitors()) do
				local sp = m.active_special_workspace
				if sp and sp.name == ws then
					visible = true
				end
				active[m.name] = true
			end

			local monitor = nil
			local full = 1
			for _, entry in ipairs(pro.monitors) do
				if active[entry.name] then
					monitor = entry.name
					full = entry.full
					break
				end
			end

			hl.window_rule({
				name = "fs-" .. name,
				match = { workspace = "special:" .. name },
				fullscreen_state = full,
			})

			if visible then
				if monitor then
					hl.dispatch(hl.dsp.focus({ monitor = monitor }))
				end
			else
				if monitor then
					hl.dispatch(hl.dsp.focus({ monitor = monitor }))
				end
				hl.dispatch(hl.dsp.workspace.toggle_special(name))
			end
		end
	end)
end

hl.on("monitor.added", function()
  hl.exec_cmd("systemctl --user restart skwd-walld.service")
end)
