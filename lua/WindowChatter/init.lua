local buf, win

vim.cmd("highlight MyFloatWin guibg=#1e222a guifg=#abb2bf") -- Example highlight group


local function create_window()
    local current_win = vim.api.nvim_get_current_win() -- Save current window
    local current_pos = vim.api.nvim_win_get_cursor(current_win) -- Save current cursor position

    buf = vim.api.nvim_create_buf(false, true) -- Create buffer if not exist
    local width = 20
    local height = 1
    local opts = {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = 1, -- Position row to the top-right
        col = vim.o.columns - width - 1, -- Position col to the right
        focusable = true, -- Allow the window to be focusable
		border = "rounded",
    }
    win = vim.api.nvim_open_win(buf, false, opts) -- Open window with focus=false
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"hello world"}) -- Set buffer content

	-- Set the highlight group for the window
    vim.api.nvim_win_set_option(win, 'winhighlight', 'NormalFloat:MyFloatWin')

    -- Restore focus and cursor position
    vim.api.nvim_set_current_win(current_win)
    vim.api.nvim_win_set_cursor(current_win, current_pos)
end

local function toggle_window()
    if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true) -- Close the window if it is open
        win = nil
    else
        create_window() -- Create a new window if not open
    end
end

-- Expose the toggle function to Neovim
return {
    toggle_window = toggle_window
}

