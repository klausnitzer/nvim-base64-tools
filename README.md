# nvim-base64-tools

A simple Neovim plugin for Base64 encoding and decoding text.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "klausnitzer/nvim-base64-tools",
  config = function()
    require("base64-tools") -- Auto-load the plugin
  end
}
