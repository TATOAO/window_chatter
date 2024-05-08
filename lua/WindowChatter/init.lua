local utils = require("WindowChatter.utils")
local buf_list, win_list, mask_ns_id_list = {}, {}, {}

for i = 1, 5 do
    table.insert(mask_ns_id_list, vim.api.nvim_create_namespace('MaskNamespace' .. i))
end

local function create_or_update_window(index, text)
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
        row = index * (height + 1),
        col = vim.o.columns - max_width - 1,
        focusable = true,
        border = "rounded",
    }

    if not buf_list[index] or not vim.api.nvim_buf_is_valid(buf_list[index]) then
        buf_list[index] = vim.api.nvim_create_buf(false, true)
    end

    if not win_list[index] or not vim.api.nvim_win_is_valid(win_list[index]) then
        win_list[index] = vim.api.nvim_open_win(buf_list[index], false, opts)
    else
        vim.api.nvim_win_set_config(win_list[index], opts)
    end

    vim.api.nvim_buf_set_lines(buf_list[index], 0, -1, false, truncated_lines)
end

local masked_regions = {}

local function highlight_selection(index, start_line, start_col, end_line, end_col)
    vim.api.nvim_buf_clear_namespace(0, mask_ns_id_list[index], 0, -1)

    vim.api.nvim_buf_add_highlight(0, mask_ns_id_list[index], "MaskHighlight", start_line - 1, start_col - 1, end_col)
    for i = start_line + 1, end_line - 1 do
        vim.api.nvim_buf_add_highlight(0, mask_ns_id_list[index], "MaskHighlight", i - 1, 0, -1)
    end
    vim.api.nvim_buf_add_highlight(0, mask_ns_id_list[index], "MaskHighlight", end_line - 1, 0, end_col)
end

local function send_visual_selection_to_window()
    local current_win = vim.api.nvim_get_current_win()
    local current_pos = vim.api.nvim_win_get_cursor(current_win)

    local start_line, start_col = unpack(vim.fn.getpos("'<"), 2, 3)
    local end_line, end_col = unpack(vim.fn.getpos("'>"), 2, 3)
    local lines = vim.fn.getline(start_line, end_line)

    lines[1] = string.sub(lines[1], start_col)
    lines[#lines] = string.sub(lines[#lines], 1, end_col)

    local index = #masked_regions + 1
    if index > 5 then
        print("Maximum number of selection boxes reached.")
        return
    end

    table.insert(masked_regions, {start_line = start_line, start_col = start_col, end_line = end_line, end_col = end_col})
    highlight_selection(index, start_line, start_col, end_line, end_col)
    create_or_update_window(index, lines)

    vim.api.nvim_set_current_win(current_win)
    vim.api.nvim_win_set_cursor(current_win, current_pos)
end

-- Set up an autocmd to listen for changes
local function update_window_on_change()
    for i, region in ipairs(masked_regions) do
        local start_line, start_col, end_line, end_col = region.start_line, region.start_col, region.end_line, region.end_col
        local lines = vim.fn.getline(start_line, end_line)

        lines[1] = string.sub(lines[1], start_col)
        lines[#lines] = string.sub(lines[#lines], 1, end_col)

        create_or_update_window(i, lines)
    end
end

vim.cmd([[
    augroup UpdateFloatingWindow
        autocmd!
        autocmd TextChanged,TextChangedI <buffer> lua require("WindowChatter").update_window_on_change()
    augroup END
]])

return {
	send_visual_selection_to_window = send_visual_selection_to_window,
	update_window_on_change = update_window_on_change
}

