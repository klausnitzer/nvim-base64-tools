# nvim-base64-tools

A simple Neovim plugin for Base64 encoding and decoding text.

## Features

- Encode and decode selected text or entire files using Base64.
- Decode Base64-encoded content directly from the system clipboard into a new buffer 


## Requirements

- Neovim 0.5 or higher

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "klausnitzer/nvim-base64-tools",
  config = function()
    require("base64-tools")
  end
}
```

## Usage

The plugin provides the following keybindings:

- **Visual Mode**:

  - `<leader>be`: Encode selected text
  - `<leader>bd`: Decode selected text

- **Normal Mode**:

  - `<leader>bee`: Encode the entire file
  - `<leader>bdd`: Decode the entire file

- **Decode clipboard funktion**:

  - start vim 
  - `:Base64DecodeClipboard`: Decode text from clipboard to new buffer
 
These keybindings are defined in the plugin's [base64-tools.lua](https://github.com/klausnitzer/nvim-base64-tools/blob/main/plugin/base64-tools.lua) file:
 
```lua
local base64 = require("base64-tools")

-- Keybindings for encoding/decoding selected text
vim.keymap.set("v", "<leader>be", function() base64.base64_encode() end, { noremap = true, silent = true })
vim.keymap.set("v", "<leader>bd", function() base64.base64_decode() end, { noremap = true, silent = true })

-- Keybindings for encoding/decoding whole file
vim.keymap.set('n', '<leader>bee', function() base64.base64_encode_file() end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bdd', function() base64.base64_decode_file() end, { noremap = true, silent = true })
```

You can customize these keybindings in your Neovim configuration as needed.



## License

This plugin is licensed under the MIT License.
