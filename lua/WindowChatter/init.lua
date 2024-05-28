local utils = require("WindowChatter.utils")
local logger = require("WindowChatter.logger")


---------------------- init key binding  --------------------------------
-------------------------------------------------------------------------------
-- local opt = { noremap = true, silent = true }
-- vim.api.nvim_set_keymap("x", "<leader>sl", "<C-u>:'<,'>lua require(\"WindowChatter\").send_visual_selection_to_window()<CR>", opt)




---------------------- add checkhealth methods --------------------------------
-------------------------------------------------------------------------------
local health = require('WindowChatter.health')

vim.api.nvim_create_user_command('WindowChatterCheckHealth', function()
  health.check()
end, {})
-------------------------------------------------------------------------------

