local utils = require("WindowChatter.utils")
local logger = require("WindowChatter.logger")

local selection_manager = require("WindowChatter.selection_manager")


---------------------- init key binding  --------------------------------
-------------------------------------------------------------------------------
-- local opt = { noremap = true, silent = true }
-- vim.api.nvim_set_keymap("x", "<leader>sl", "<C-u>:'<,'>lua require(\"WindowChatter\").send_visual_selection_to_window()<CR>", opt)




local function send_visual_selection_to_window()
    local current_win = vim.api.nvim_get_current_win()
    local current_pos = vim.api.nvim_win_get_cursor(current_win)
	local current_filename = vim.api.nvim_buf_get_name(0)

    local start_line, start_col = unpack(vim.fn.getpos("'<"), 2, 3)
    local end_line, end_col = unpack(vim.fn.getpos("'>"), 2, 3)
    local lines = vim.fn.getline(start_line, end_line)

    lines[1] = string.sub(lines[1], start_col)
    lines[#lines] = string.sub(lines[#lines], 1, end_col)

    local setId = selection_manager.getCurrentSetId()

	selection_manager.recordVisualSelection(setId, current_filename, start_line, start_col, end_line, end_col)

    highlight_selection(index, start_line, start_col, end_line, end_col)

	vim.schedule(function()
		create_or_update_window(index, lines)
	end)
	
end




---------------------- add checkhealth methods --------------------------------
-------------------------------------------------------------------------------
local health = require('WindowChatter.health')

vim.api.nvim_create_user_command('WindowChatterCheckHealth', function()
  health.check()
end, {})
-------------------------------------------------------------------------------

return {
	send_visual_selection_to_window = send_visual_selection_to_window,
	update_window_on_change = update_window_on_change,
	remove_selected_highlighted_area = remove_selected_highlighted_area
}
