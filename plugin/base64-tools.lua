local base64 = require("base64-tools")

vim.keymap.set("v", "<leader>be", function() base64.base64_encode() end, { noremap = true, silent = true })
vim.keymap.set("v", "<leader>bd", function() base64.base64_decode() end, { noremap = true, silent = true })
