local M = {}

function M.check()
  local health = vim.health
  health.report_start('WindowChatter health check')

  -- Check for dependencies
  if vim.fn.executable('curl') == 1 then
    health.report_ok('curl is installed')
  else
    health.report_error('curl is not installed')
  end


  -- TODO check llm is connected

  -- Check for configuration issues
  -- if vim.g.myplugin_config then
  --   health.report_ok('Configuration found')
  -- else
  --   health.report_warn('Configuration not found, using defaults')
  -- end

  -- Add more checks as needed
end

return M

