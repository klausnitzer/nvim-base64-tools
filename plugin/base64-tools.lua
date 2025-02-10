local base64 = require("base64-tools")

-- Keybindings for encoding/decoding selected text
vim.keymap.set("v", "<leader>be", function() base64.base64_encode() end, { noremap = true, silent = true })
vim.keymap.set("v", "<leader>bd", function() base64.base64_decode() end, { noremap = true, silent = true })

-- Keybindings for encoding/decoding whole file
vim.keymap.set('n', '<leader>bee', function() require("base64-tools").base64_encode_file() end,
  { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bdd', function() require("base64-tools").base64_decode_file() end,
  { noremap = true, silent = true })

