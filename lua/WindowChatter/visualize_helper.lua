-- Define highlight group for the mask
vim.cmd("highlight MaskHighlight guibg=#1e222a")

local function highlight_selection(start_line, start_col, end_line, end_col)
    -- Clear any previous virtual text
    vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
    -- Apply highlight to the selected lines
    vim.api.nvim_buf_add_highlight(0, -1, "MaskHighlight", start_line - 1, start_col - 1, end_col)
    for i = start_line + 1, end_line - 1 do
        vim.api.nvim_buf_add_highlight(0, -1, "MaskHighlight", i - 1, 0, -1)
    end
    vim.api.nvim_buf_add_highlight(0, -1, "MaskHighlight", end_line - 1, 0, end_col)
end

return {
	highlight_selection = highlight_selection
}
