local utils = require("WindowChatter.utils")
local buf_list, win_list, mask_ns_id_list = {}, {}, {}

local masked_regions = {}
-- table.insert(masked_regions, {start_line = start_line, start_col = start_col, end_line = end_line, end_col = end_col})

local window_heights = {}


vim.cmd [[
highlight MaskHighlight1 guibg=Red
highlight MaskHighlight2 guibg=Yellow
highlight MaskHighlight3 guibg=Green
highlight MaskHighlight4 guibg=Blue
highlight MaskHighlight5 guibg=Grey
]]


for i = 1, 5 do
    table.insert(mask_ns_id_list, vim.api.nvim_create_namespace('MaskNamespace' .. i))
end

local function highlight_selection(index, start_line, start_col, end_line, end_col)
    local highlight_group = "MaskHighlight" .. index  -- Select highlight group based on index
    vim.api.nvim_buf_clear_namespace(0, mask_ns_id_list[index], 0, -1)

    vim.api.nvim_buf_add_highlight(0, mask_ns_id_list[index], highlight_group, start_line - 1, start_col - 1, end_col)
    for i = start_line + 1, end_line - 1 do
        vim.api.nvim_buf_add_highlight(0, mask_ns_id_list[index], highlight_group, i - 1, 0, -1)
    end
    vim.api.nvim_buf_add_highlight(0, mask_ns_id_list[index], highlight_group, end_line - 1, 0, end_col)
end


local function calculate_vertical_offset(index)
    local offset = 1  -- Start with a small offset from the top
    for i = 1, index - 1 do
        offset = offset + window_heights[i] + 2  -- Add the height of each window plus a small gap
    end
    return offset
end


local function create_or_update_window(index, text)
    local max_height = 10
    local max_words = 10
    local max_width = 40 -- Set the desired fixed width for the window

    -- Truncate and wrap lines
    local truncated_lines = utils.truncate_text(text, max_words, max_width)

    local height = math.min(#truncated_lines, max_height)
	window_heights[index] = height  -- Store the height of each window

    local opts = {
        style = "minimal",
        relative = "editor",
        width = max_width,
        height = height,
        row = calculate_vertical_offset(index),
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


local function on_lines(_, buf, _, firstline, lastline, new_lastline, _)
    for i, region in ipairs(masked_regions) do
        if region.start_line <= firstline and region.end_line >= lastline then
            -- Adjust the region end line based on the difference in line changes
            local line_diff = new_lastline - lastline
            region.end_line = region.end_line + line_diff

            -- Fetch the new lines within the region
            local lines = vim.fn.getline(region.start_line, region.end_line)

            -- Update the floating window with new content
            create_or_update_window(i, lines)

            -- Update highlighting
            update_highlight(i, region.start_line, 0, region.end_line, #lines[#lines])
        end
    end
end

-- Attach the listener to each buffer when needed
local function attach_buffer()
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_attach(buf, false, {
        on_lines = on_lines
    })
end



-- Updated highlight function, assumes global access to mask_ns_id_list
local function update_highlight(index, start_line, start_col, end_line, end_col)
    local highlight_group = "MaskHighlight" .. index
    vim.api.nvim_buf_clear_namespace(0, mask_ns_id_list[index], 0, -1)

    vim.api.nvim_buf_add_highlight(0, mask_ns_id_list[index], highlight_group, start_line - 1, start_col, -1)
    for line = start_line + 1, end_line - 1 do
        vim.api.nvim_buf_add_highlight(0, mask_ns_id_list[index], highlight_group, line - 1, 0, -1)
    end
    vim.api.nvim_buf_add_highlight(0, mask_ns_id_list[index], highlight_group, end_line - 1, 0, end_col)
end


-- Function to update the floating window and the highlight when the text changes
local function update_window_on_change()
    -- This function might be simplified or even unnecessary if `on_lines` handles all updates
    for i, region in ipairs(masked_regions) do
        local lines = vim.fn.getline(region.start_line, region.end_line)
        create_or_update_window(i, lines)
        update_highlight(i, region.start_line, 0, region.end_line, #lines[#lines])
    end
end



-- local function update_window_on_change()
--     for i, region in ipairs(masked_regions) do
--         local start_line, start_col, original_end_line, original_end_col = region.start_line, region.start_col, region.end_line, region.end_col
--         local lines = vim.fn.getline(start_line, original_end_line)
--
--         if start_line == original_end_line then
--             lines[1] = string.sub(lines[1], start_col, original_end_col)
--         else
--             lines[1] = string.sub(lines[1], start_col)
--             lines[#lines] = string.sub(lines[#lines], 1, original_end_col)
--         end
--
--         -- Update window content
--         create_or_update_window(i, lines)
--
--         -- Determine new end_line based on the number of new lines added within the original region
--         local new_end_line = start_line + #lines - 1
--
--         -- Adjust end line if new lines have been added within the highlighted area
--         local current_line_count = original_end_line - start_line + 1
--         local new_line_count = new_end_line - start_line + 1
--         if new_line_count > current_line_count then
--             region.end_line = region.end_line + (new_line_count - current_line_count)
--         elseif new_line_count < current_line_count then
--             region.end_line = region.end_line - (current_line_count - new_line_count)
--         end
--
--         -- Recalculate end_col of the last line if the last line is edited
--         region.end_col = #vim.fn.getline(region.end_line)
--
--         -- Update the highlight region
--         update_highlight(i, start_line, 0, region.end_line, region.end_col)
--     end
-- end
--

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

