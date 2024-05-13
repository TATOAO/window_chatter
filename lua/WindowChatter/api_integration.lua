-- api_integration.lua
--
print('xx')

local Http = require('http')
local json = require('json')
local Logger = require('WindowChatter.logger')

local M = {}

local API_URL = "https://api.openai.com/v1/chat/completions"

function M.send_request(message, callback)
    -- Send a request to the specified API endpoint
    local url = API_URL
	local api_key = os.getenv('OPENAI_API_KEY')

    local request_body = json.encode({
        model = "gpt-3.5-turbo", -- Specify the model you are using, e.g., "gpt-3.5-turbo".
        messages = {{
            role = "user",
            content = message
        }}
    })
	local headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. api_key,
            ["Content-Length"] = #request_body
        }


    Http.post(url, request_body, headers, function(response)
        if response.status ~= 200 then
            Logger.log("API request failed: " .. response.body)
            callback(nil, "Error: " .. response.body)
        else
            local result = json.decode(response.body)
            callback(result, nil)
        end
    end)
end



return M
