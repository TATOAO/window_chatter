local utils = require("WindowChatter.utils")
local buf, win

vim.cmd("highlight MyFloatWin guibg=#1e222a guifg=#abb2bf") -- Example highlight group



local function create_or_update_window(text)
    local max_height = 10
    local max_words = 10
    local max_width = 40 -- Set the desired fixed width for the window

    -- Truncate and wrap lines
    local truncated_lines = utils.truncate_text(text, max_words, max_width)

    local height = math.min(#truncated_lines, max_height)
    local opts = {
        style = "minimal",
        relative = "editor",
        width = max_width,
        height = height,
        row = 1,
        col = vim.o.columns - max_width - 1,
        focusable = true,
        border = "rounded",
        noautocmd = true
    }

    if not buf or not vim.api.nvim_buf_is_valid(buf) then
        buf = vim.api.nvim_create_buf(false, true)
    end

    if not win or not vim.api.nvim_win_is_valid(win) then
        win = vim.api.nvim_open_win(buf, false, opts)
    else
        vim.api.nvim_win_set_config(win, opts)
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, truncated_lines)
end


-- Function to capture visual selection and update the floating window
local function send_visual_selection_to_window()
    local current_win = vim.api.nvim_get_current_win()
    local current_pos = vim.api.nvim_win_get_cursor(current_win)

    -- Capture the visual selection
    local start_line, start_col = unpack(vim.fn.getpos("'<"), 2, 3)
    local end_line, end_col = unpack(vim.fn.getpos("'>"), 2, 3)
    local lines = vim.fn.getline(start_line, end_line)

    -- Adjust for partial lines
    lines[1] = string.sub(lines[1], start_col)
    lines[#lines] = string.sub(lines[#lines], 1, end_col)

    -- Update or create the floating window with selected text
    create_or_update_window(lines)

    vim.api.nvim_set_current_win(current_win)
    vim.api.nvim_win_set_cursor(current_win, current_pos)
end


local function toggle_window()
    if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true) -- Close the window if it is open
        win = nil
    else
        send_visual_selection_to_window() -- Create a new window if not open
    end
end

-- Expose the toggle function to Neovim
return {
    toggle_window = toggle_window,
	send_visual_selection_to_window = send_visual_selection_to_window
}

