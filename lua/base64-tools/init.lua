local M = {}

-- Function to encode selected text in Base64
M.base64_encode = function()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2] - 1
  local start_col = start_pos[3] - 1
  local end_line = end_pos[2] - 1
  local end_col = end_pos[3]

  -- Ensure end_col is at least one character ahead
  if start_line == end_line and start_col == end_col then
    end_col = end_col + 1
  end

  -- Ensure end_col does not exceed the line length
  local last_line_length = #vim.api.nvim_buf_get_lines(0, end_line, end_line + 1, false)[1] or 0
  if end_col > last_line_length then
    end_col = last_line_length
  end

  -- Get selected text
  local lines = vim.api.nvim_buf_get_text(0, start_line, start_col, end_line, end_col, {})
  local text = table.concat(lines, "\n")

  -- Cross-platform Base64 encoding
  local encoded
  if vim.fn.has("mac") == 1 then
    encoded = vim.fn.system("base64 -b 0", text):gsub("\n", "")
  else
    encoded = vim.fn.system("base64 --wrap=0", text):gsub("\n", "")
  end

  -- Replace selected text
  vim.api.nvim_buf_set_text(0, start_line, start_col, end_line, end_col, { encoded })
end

-- Function to decode selected Base64 text
M.base64_decode = function()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2] - 1
  local start_col = start_pos[3] - 1
  local end_line = end_pos[2] - 1
  local end_col = end_pos[3]

  -- Ensure end_col is at least one character ahead
  if start_line == end_line and start_col == end_col then
    end_col = end_col + 1
  end

  -- Ensure end_col does not exceed the line length
  local last_line_length = #vim.api.nvim_buf_get_lines(0, end_line, end_line + 1, false)[1] or 0
  if end_col > last_line_length then
    end_col = last_line_length
  end

  -- Get selected text
  local lines = vim.api.nvim_buf_get_text(0, start_line, start_col, end_line, end_col, {})
  local text = table.concat(lines, "\n")

  -- Cross-platform Base64 decoding
  local decoded
  if vim.fn.has("mac") == 1 then
    decoded = vim.fn.system("base64 -D", text)
  else
    decoded = vim.fn.system("base64 -d", text)
  end

  -- Replace selected text
  vim.api.nvim_buf_set_text(0, start_line, start_col, end_line, end_col, { decoded })
end

return M

