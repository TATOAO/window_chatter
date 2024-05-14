-- api_integration.lua

local Job = require('plenary.job')
local Logger = require('WindowChatter.logger')

local M = {}

local API_URL = "https://api.openai.com/v1/chat/completions"
local api_key = os.getenv('OPENAI_API_KEY')

local function post(url, data, headers, callback)
  local args = {
    '-s',        -- Silent mode
    '-X', 'POST', -- HTTP method
  }

  -- Add headers to the args
  for key, value in pairs(headers) do
    table.insert(args, '-H')
    table.insert(args, key .. ': ' .. value)
  end

  -- Add the data
  table.insert(args, '-d')
  table.insert(args, data)

  -- Add the URL
  table.insert(args, url)

  Job:new({
    command = 'curl',
    args = args,
    on_exit = function(j, return_val)
      vim.schedule_wrap(function()
        callback(table.concat(j:result(), "\n"))
      end)()
    end,
  }):start()
end

function M.send_to_llm(message, callback)
  -- Send a request to the specified API endpoint
  local url = API_URL

  local request_body = vim.fn.json_encode({
    model = "gpt-3.5-turbo", -- Specify the model you are using, e.g., "gpt-3.5-turbo".
    messages = {{
      role = "user",
      content = message
    }}
  })

  local headers = {
    ["Content-Type"] = "application/json",
    ["Authorization"] = "Bearer " .. api_key,
    ["Content-Length"] = tostring(#request_body)
  }

  post(url, request_body, headers, function(response)
    vim.schedule_wrap(function()
      local parsed_response = vim.fn.json_decode(response)
      if parsed_response and parsed_response.error then
        Logger.log("INFO", "API request failed: " .. parsed_response.error.message)
        callback(nil, "Error: " .. parsed_response.error.message)
      else
        Logger.log("INFO", "API request success")
        callback(parsed_response, nil)
      end
    end)()
  end)
end

return M

