local M = {}

-- Function to encode selected text in Base64
M.base64_encode = function()
  local start_pos, end_pos = vim.fn.getpos("'<"), vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_text(0, start_pos[2] - 1, start_pos[3], end_pos[2] - 1, end_pos[3], {})
  local text = table.concat(lines, "\n")

  -- Cross-platform compatibility
  local encoded
  if vim.fn.has("mac") == 1 then
    encoded = vim.fn.system("base64 -b 0", text):gsub("\n", "")
  else
    encoded = vim.fn.system("base64 --wrap=0", text):gsub("\n", "")
  end

  vim.api.nvim_buf_set_text(0, start_pos[2] - 1, start_pos[3], end_pos[2] - 1, end_pos[3], { encoded })
end

-- Function to decode selected Base64 text
M.base64_decode = function()
  local start_pos, end_pos = vim.fn.getpos("'<"), vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_text(0, start_pos[2] - 1, start_pos[3], end_pos[2] - 1, end_pos[3], {})
  local text = table.concat(lines, "\n")

  -- Cross-platform compatibility
  local decoded
  if vim.fn.has("mac") == 1 then
    decoded = vim.fn.system("base64 -D", text)
  else
    decoded = vim.fn.system("base64 -d", text)
  end

  vim.api.nvim_buf_set_text(0, start_pos[2] - 1, start_pos[3], end_pos[2] - 1, end_pos[3], { decoded })
end

return M
