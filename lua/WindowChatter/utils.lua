local M = {}

function M.printTable(tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        local formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            M.printTable(v, indent+1)
        elseif type(v) == 'boolean' then
            print(formatting .. tostring(v))      
        else
            print(formatting .. v)
        end
    end
end


function M.truncate_text(text, max_words, max_width)
    local words = {}
    for _, line in ipairs(text) do
        for word in line:gmatch("%S+") do
            table.insert(words, word)
        end
    end

    local total_words = #words
    local truncated_lines = {}

    local truncated_text
    if total_words <= max_words * 2 then
        truncated_text = table.concat(words, " ")
    else
        truncated_text = table.concat(vim.list_slice(words, 1, max_words), " ") ..
                   " ... " ..
                   table.concat(vim.list_slice(words, total_words - max_words + 1), " ")
    end

    -- Split truncated text into lines based on max_width
    for line in truncated_text:gmatch("[^\r\n]+") do
        while #line > max_width do
            table.insert(truncated_lines, line:sub(1, max_width))
            line = line:sub(max_width + 1)
        end
        table.insert(truncated_lines, line)
    end

    return truncated_lines
end

return M
