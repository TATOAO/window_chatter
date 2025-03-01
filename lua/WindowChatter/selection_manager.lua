local selectionManager = {}

-- Table to store all visual selection sets
selectionManager.selectionSets = {}
selectionManager.currentSetId = 1

-- Function to create a new visual selection set
function selectionManager.createVisualSelectionSet()
    local setId = #selectionManager.selectionSets + 1
    selectionManager.selectionSets[setId] = { id = setId, selections = {} }
    return setId
end

-- Function to record a visual selection into a set
function selectionManager.recordVisualSelection(setId, fileName, startLine, startCol, endLine, endCol)
    local set = selectionManager.selectionSets[setId]
    if not set then
        error("Set ID does not exist.")
    end
    table.insert(set.selections, {
        fileName = fileName,
        start = { line = startLine, col = startCol },
        end = { line = endLine, col = endCol }
    })
end

-- Function to save the visual selection sets to a file
function selectionManager.saveVisualSelectionSets()
    local filePath = vim.fn.stdpath('data') .. '/visual_selection_sets.json'
    local file = io.open(filePath, 'w')
    if file then
        file:write(vim.fn.json_encode(selectionManager.selectionSets))
        file:close()
    end
end

-- Function to load the visual selection sets from a file
function selectionManager.loadVisualSelectionSets()
    local filePath = vim.fn.stdpath('data') .. '/visual_selection_sets.json'
    local file = io.open(filePath, 'r')
    if file then
        local data = file:read('*a')
        selectionManager.selectionSets = vim.fn.json_decode(data)
        file:close()
    end
end

-- Function to get visual selections by the set ID
function selectionManager.getVisualSelectionsBySetId(setId)
    return selectionManager.selectionSets[setId]
end

-- Function to get the current visual selection set ID
function selectionManager.getCurrentSetId()
    return selectionManager.currentSetId
end

-- Function to get the next visual selection set ID (cycling through sets)
function selectionManager.getNextSetId()
    local nextId = selectionManager.currentSetId + 1
    if nextId > #selectionManager.selectionSets then
        nextId = 1
    end
    selectionManager.currentSetId = nextId
    return nextId
end

-- Function to remove a visual selection from a set
function selectionManager.removeVisualSelection(setId, selectionIndex)
    local set = selectionManager.selectionSets[setId]
    if set and set.selections[selectionIndex] then
        table.remove(set.selections, selectionIndex)
    end
end

-- Function to remove a visual selection set and adjust the current set ID if necessary
function selectionManager.removeVisualSelectionSet(setId)
    if selectionManager.selectionSets[setId] then
        table.remove(selectionManager.selectionSets, setId)
        -- Adjust currentSetId if necessary
        if setId == selectionManager.currentSetId or selectionManager.currentSetId > #selectionManager.selectionSets then
            selectionManager.currentSetId = #selectionManager.selectionSets > 0 and 1 or nil
        end
    end
end

-- Function to find visual selections by file name, starting points, and ending points
function selectionManager.findVisualSelections(fileName, startLine, startCol, endLine, endCol)
    local result = {}
    for _, set in ipairs(selectionManager.selectionSets) do
        for _, selection in ipairs(set.selections) do
            if selection.fileName == fileName and
               ((selection.start.line >= startLine and selection.start.line <= endLine) or
                (selection.end.line >= startLine and selection.end.line <= endLine) or
                (selection.start.line < startLine and selection.end.line > endLine)) then
                table.insert(result, selection)
            end
        end
    end
    return result
end

-- Function to update selections based on text modifications
local function updateSelections(buffer, startLine, oldEndLine, newEndLine)
    local lineDiff = newEndLine - oldEndLine
    for _, set in ipairs(selectionManager.selectionSets) do
        for _, selection in ipairs(set.selections) do
            if selection.fileName == vim.api.nvim_buf_get_name(buffer) then
                if selection.start.line > startLine then
                    selection.start.line = selection.start.line + lineDiff
                    selection.end.line = selection.end.line + lineDiff
                elseif selection.end.line > startLine then
                    selection.end.line = selection.end.line + lineDiff
                end
            end
        end
    end
end

-- on_lines callback function
local function on_lines(_, buffer, _, firstline, lastline, new_lastline, _, _, _)
    updateSelections(buffer, firstline, lastline, new_lastline)
end

-- Attach the listener to each buffer when needed
local function attach_buffer()
    local buf = vim.api.nvim_get_current_buf()
    local attached = vim.api.nvim_buf_attach(buf, false, {
        on_lines = on_lines
    })
    if not attached then
        print("Failed to attach to buffer", buf)
    else
        print("Attached to buffer", buf)
    end
end

-- Attach the buffer when opening a file
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = attach_buffer
})

return selectionManager

