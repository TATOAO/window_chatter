
Please help me write a piece of code for my Neovim plugin project. 

Now we only force on a small part of the whole functionality.

Here is a file called "window_manager.lua" that should be filled. 

Like the name, the code should make the following happen.


The window is floating in the top-right corner in Neovim editting page. 

One window display all the text that recorded in a Selection Set that in selection_manager.

A selection set is defined as a table:

```
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


-- Get visual selections by the set ID
function selectionManager.getVisualSelectionsBySetId(setId)
    return selectionManager.selectionSets[setId]
end
```

So please try to complete these functionalities:
1. create a floating window with displaying (update) a selection set in the window. Input: selection set id, Output: 
3. 

Now please output the file "window_manager.lua" wrapped in 
``` code ``` 
coding blocks.  

