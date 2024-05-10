local log_file_path = ".log/"..os.date("%Y-%m-%d")..".log"  -- Change this to the desired path

local function log(...)
    local messages = {...}
    for i, v in ipairs(messages) do
        messages[i] = tostring(v)
    end
    local message = table.concat(messages, " ") .. "\n"

    -- Append message to the log file
    local file = io.open(log_file_path, "a")  -- Open the file in append mode
    if file then
        file:write(message)
        file:close()  -- Always close the file after writing
    else
        error("Failed to open log file")
    end
end

return {
	log = log
}

