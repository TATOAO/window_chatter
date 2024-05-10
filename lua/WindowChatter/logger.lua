local directory = ".log/"
local log_file_path = directory..os.date("%Y-%m-%d")..".log"  -- Change this to the desired path

local function ensure_log_directory_exists()
	if vim.fn.isdirectory(directory) == 0 then
		-- Directory does not exist, so create it
		vim.fn.mkdir(directory, "p")  -- The "p" flag creates parent directories as needed
		print("Directory created: " .. directory)
	else
		print("Directory already exists: " .. directory)
	end
end


local function log(...)
    local messages = {...}
    for i, v in ipairs(messages) do
        messages[i] = tostring(v)
    end

	local ms = math.floor((os.clock() % 1) * 1000)

    local message = os.date("[%Y-%m-%d %H:%M:%S:").. ms.."]".. table.concat(messages, " ") .. "\n"



    -- Append message to the log file
    local file = io.open(log_file_path, "a")  -- Open the file in append mode
    if file then
        file:write(message)
        file:close()  -- Always close the file after writing
    else
        error("Failed to open log file")
    end
end

ensure_log_directory_exists()

return {
	log = log
}

