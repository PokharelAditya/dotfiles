local M = {}

local openedByAltTab = false
local previousConfig

local overviewOn = hl.plugin.scrolloverview.overview("on")
local overviewOff = hl.plugin.scrolloverview.overview("off")
local navigateLeft = hl.plugin.scrolloverview.navigate("left")
local navigateRight = hl.plugin.scrolloverview.navigate("right")

local function object_value(value, key)
    if value == nil then
        return nil
    end

    local ok, result = pcall(function()
        return value[key]
    end)

    return ok and result or nil
end

local function selection_state()
    local workspaceId = object_value(hl.get_active_workspace(), "id")
    local windowAddress = object_value(hl.get_active_window(), "address")
    return tostring(workspaceId) .. ":" .. tostring(windowAddress)
end

local function navigate_to_first_column()
    local previousState
    local maxSteps = #(hl.get_windows() or {}) + #(hl.get_workspaces() or {}) + 1

    for _ = 1, maxSteps do
        local currentState = selection_state()
        if currentState == previousState then
            return
        end

        previousState = currentState
        hl.dispatch(navigateLeft)
    end
end

local function navigate_next_column()
    local previousState = selection_state()
    hl.dispatch(navigateRight)

    if selection_state() == previousState then
        navigate_to_first_column()
    end
end

function M.restore()
    if previousConfig then
        hl.config({ plugin = { scrolloverview = previousConfig } })
        previousConfig = nil
    end

    openedByAltTab = false
end

function M.next()
    if not openedByAltTab then
        -- Leave an already-open Super+Tab overview unchanged.
        if hl.get_current_submap() == "scrolloverview" then
            return
        end

        previousConfig = {
            layout = hl.get_config("plugin:scrolloverview:layout"),
            scale = hl.get_config("plugin:scrolloverview:scale"),
        }

        hl.config({
            plugin = {
                scrolloverview = {
                    layout = "horizontal",
                    scale = 0.8,
                },
            },
        })
        hl.dispatch(overviewOn)
        openedByAltTab = true
    end

    navigate_next_column()
end

function M.close()
    if openedByAltTab then
        hl.dispatch(overviewOff)
        M.restore()
    end
end

return M
