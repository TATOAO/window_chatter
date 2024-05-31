local selectionManager = {}

-- Table to store all visual selection sets
selectionManager.selectionSets = {}
-- selectionWorkplace of IDs rather than just the indices.
selectionManager.currentSetId = 1

-- Create a new visual selection set
function selectionManager.createVisualSelectionSet()
    local setId = #selectionManager.selectionSets + 1
    selectionManager.selectionSets[setId] = { id = setId, selections = {} }
    return setId
end

-- Record a visual selection into a set
function selectionManager.recordVisualSelection(setId, fileName, startLine, startCol, endLine, endCol)
    local set = selectionManager.selectionSets[setId]
    if not set then
        error("Set ID does not exist.")
    end
    table.insert(set.selections, {
        fileName = fileName,
        start_point = { line = startLine, col = startCol },
        end_point = { line = endLine, col = endCol }
    })
end

-- Save the visual selection sets to a file
function selectionManager.saveVisualSelectionSets()
    local filePath = vim.fn.stdpath('data') .. '/visual_selection_sets.txt'
    local file = io.open(filePath, 'w')
    if file then
        file:write(vim.inspect(selectionManager.selectionSets))
        file:close()
    end
end

-- Load the visual selection sets from a file
function selectionManager.loadVisualSelectionSets()
    local filePath = vim.fn.stdpath('data') .. '/visual_selection_sets.txt'
    local file = io.open(filePath, 'r')
    if file then
        local data = file:read('*a')
        selectionManager.selectionSets = vim.inspect.decode(data)
    end
end

-- Get visual selections by the set ID
function selectionManager.getVisualSelectionsBySetId(setId)
    return selectionManager.selectionSets[setId]
end

-- Get the current visual selection set ID
function selectionManager.getCurrentSetId()
    return selectionManager.currentSetId
end

-- Get the next visual selection set ID (cycling through sets)
function selectionManager.getNextSetId()
    local nextId = selectionManager.currentSetId + 1
    if nextId > #selectionManager.selectionSets then
        nextId = 1
    end
    selectionManager.currentSetId = nextId
    return nextId
end

-- Remove a visual selection from a set
function selectionManager.removeVisualSelection(setId, selectionIndex)
    local set = selectionManager.selectionSets[setId]
    if set and set.selections[selectionIndex] then
        table.remove(set.selections, selectionIndex)
    end
end

-- Remove a visual selection set and adjust the current set ID if necessary
function selectionManager.removeVisualSelectionSet(setId)
    if selectionManager.selectionSets[setId] then
        table.remove(selectionManager.selectionSets, setId)
        -- Adjust currentSetId if necessary
        if setId == selectionManager.currentSetId or selectionManager.currentSetId > #selectionManager.selectionSets then
            selectionManager.currentSetId = #selectionManager.selectionSets > 0 and 1 or nil
        end
    end
end




return selectionManager


