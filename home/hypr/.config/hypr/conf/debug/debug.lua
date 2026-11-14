-------------------
------ DEBUG ------
-------------------

function debug(data)
	local file = io.open("/tmp/hyprland-debug.log", "a")
	if file then
		file:write(tostring(data) .. "\n")
		file:close()
	end
end
