local M = {}

-- Function to encode selected text in Base64
M.base64_encode = function()
  local start_pos, end_pos = vim.fn.getpos("'<"), vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_text(0, start_pos[2] - 1, start_pos[3], end_pos[2] - 1, end_pos[3], {})
  local text = table.concat(lines, "\n")
  local encoded = vim.fn.system("base64 --wrap=0", text):gsub("\n", "")
  vim.api.nvim_buf_set_text(0, start_pos[2] - 1, start_pos[3], end_pos[2] - 1, end_pos[3], { encoded })
end

-- Function to decode selected Base64 text
M.base64_decode = function()
  local start_pos, end_pos = vim.fn.getpos("'<"), vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_text(0, start_pos[2] - 1, start_pos[3], end_pos[2] - 1, end_pos[3], {})
  local text = table.concat(lines, "\n")
  local decoded = vim.fn.system("base64 -d", text)
  vim.api.nvim_buf_set_text(0, start_pos[2] - 1, start_pos[3], end_pos[2] - 1, end_pos[3], { decoded })
end

return M
