local M = {}

-- windows[id] = {buf = buf, win_id = win_id}
local windows = {}

-- Helper function to create a floating window
local function create_floating_window(content, position)
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    -- Define the size and position of the window
    local win_height = math.ceil(height * 0.2 - 4)
    local win_width = math.ceil(width * 0.3)
    local row = position.row or math.ceil((height - win_height) / 2)
    local col = position.col or math.ceil((width - win_width) / 2)

	local buf = vim.api.nvim_create_buf(false, true) -- Create a new buffer for the window
    local win_id = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        border = 'single',
    })

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {content}) -- Set initial content
    return buf, win_id
end

function M.create_window(id, content, position)
    -- Create and display a new window, and save to Windows{}
	--[[ 
		uni_test: lua require("WindowChatter.window_manager").create_window(0, "hi", {row= 10, col= 10})
	]]--


    position = position or {row = 0, col = vim.api.nvim_get_option("columns") - math.ceil(vim.api.nvim_get_option("columns") * 0.3)}
    if windows[id] then
        error("Window with this ID already exists.")
    end
    local buf, win_id = create_floating_window(content, position)
    windows[id] = {buf = buf, win_id = win_id}
end

function M.update_window(id, new_content)
    -- Update the content of an existing window
    local window = windows[id]
    if not window then
        error("No window with ID: " .. id)
    end
    vim.api.nvim_buf_set_lines(window.buf, 0, -1, false, {new_content})
end

function M.close_window(id)
    -- Close the specified window
    local window = windows[id]
    if not window then
        error("No window with ID: " .. id)
    end
    vim.api.nvim_win_close(window.win_id, true)
    vim.api.nvim_buf_delete(window.buf, {force = true})
    windows[id] = nil
end

function M.arrange_windows()
    -- Arrange windows to prevent overlap and optimize space
    -- Simple example: stack windows horizontally
    local offset = 0
    for _, window in pairs(windows) do
        local win_width = vim.api.nvim_win_get_width(window.win_id)
        vim.api.nvim_win_set_config(window.win_id, {col = offset})
        offset = offset + win_width + 2 -- 2 for window border
    end
end

return M

