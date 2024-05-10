local directory = ".log/"
local log_file_path = directory .. os.date("%Y-%m-%d") .. ".log"  -- Change this to the desired path

-- Define log levels
local logLevels = {
    DEBUG = 1,
    INFO = 2,
    WARNING = 3,
    ERROR = 4
}

-- Current log level (change this as needed, e.g., via configuration)
local currentLogLevel = logLevels.INFO

local function ensure_log_directory_exists()
    if vim.fn.isdirectory(directory) == 0 then
        -- Directory does not exist, so create it
        vim.fn.mkdir(directory, "p")  -- The "p" flag creates parent directories as needed
        print("Directory created: " .. directory)
    else
        print("Directory already exists: " .. directory)
    end
end

local function log(level, ...)
    if logLevels[level] < currentLogLevel then
        return  -- Skip logging messages below the current log level
    end

    local messages = {...}
    for i, v in ipairs(messages) do
        messages[i] = tostring(v)
    end

    local ms = math.floor((os.clock() % 1) * 1000)
    local message = os.date("[%Y-%m-%d %H:%M:%S:") .. ms .. "] " .. level .. ": " .. table.concat(messages, " ") .. "\n"

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
    log = log,
    logLevels = logLevels
}

