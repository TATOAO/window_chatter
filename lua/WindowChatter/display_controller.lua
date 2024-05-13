-- display_controller.lua

local WindowManager = require('WindowChatter.window_manager')
local Utils = require('WindowChatter.utils')

local M = {}

function M.display_output(output, window_id)
    -- Display output in a specified window or a new window if window_id is nil
    if window_id and WindowManager.exists(window_id) then
        WindowManager.update_window(window_id, output)
    else
        local new_window_id = Utils.generate_id()
        WindowManager.create_window(new_window_id, output, 'top_right')
        return new_window_id -- Return the new window ID
    end
end

function M.display_error(message, window_id)
    -- Display error messages in a specific window or create a new one if not specified
    if window_id and WindowManager.exists(window_id) then
        WindowManager.update_window(window_id, message)
    else
        local error_window_id = Utils.generate_id()
        WindowManager.create_window(error_window_id, message, 'top_right')
        return error_window_id -- Return the new window ID
    end
end

function M.clear_display(window_id)
    -- Clear the display content of the specified window
    if WindowManager.exists(window_id) then
        WindowManager.update_window(window_id, "") -- Clear the content
    else
        error("Window ID does not exist")
    end
end

function M.rearrange_displays()
    -- Trigger an arrangement of all display windows to prevent overlap
    WindowManager.arrange_windows()
end

return M

