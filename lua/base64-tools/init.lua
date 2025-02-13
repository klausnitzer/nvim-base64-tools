local M = {}

-- Detect macOS
local is_mac = vim.loop.os_uname().sysname == "Darwin"

-- Helper function to get the selected text
local function get_selected_text()
  -- Ensure buffer is not empty
  if vim.api.nvim_buf_line_count(0) == 1 and vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == "" then
    vim.notify("Buffer is empty. Nothing to encode/decode.", vim.log.levels.WARN)
    return nil
  end

  local mode = vim.fn.mode() -- Get current mode (v, V, <C-v>)
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2] - 1
  local start_col = start_pos[3] - 1
  local end_line = end_pos[2] - 1
  local end_col = end_pos[3]

  -- Fix for line-wise selection
  if mode == "V" then
    start_col = 0
    end_col = #vim.api.nvim_buf_get_lines(0, end_line, end_line + 1, false)[1]
  end

  -- Ensure start_col is always less than end_col
  if start_line == end_line and start_col > end_col then
    start_col, end_col = end_col, start_col
  end

  -- Get selected text safely
  local lines = vim.api.nvim_buf_get_text(0, start_line, start_col, end_line, end_col, {})
  if not lines or #lines == 0 then
    vim.notify("No text selected.", vim.log.levels.WARN)
    return nil
  end

  return table.concat(lines, "\n"), start_line, start_col, end_line, end_col
end

local function replace_selected_text(start_row, start_col, end_row, end_col, replacement)
  local bufnr = vim.api.nvim_get_current_buf()

  -- Adjust end_col for exclusive indexing
  end_col = end_col + 1

  -- Ensure end_col does not exceed line length
  local line_length = vim.fn.col({ end_row + 1, '$' }) - 1
  if end_col > line_length then
    end_col = line_length
  end

  vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { replacement })
end

-- Function to encode the whole file (without selection)
M.base64_encode_file = function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local text = table.concat(lines, "\n")

  -- Encode: Handle macOS/Linux
  local command = is_mac and "base64" or "base64 -w 0"
  local encoded = vim.fn.system(command, text):gsub("\n", "")

  -- Replace the entire buffer's content with the encoded text
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.split(encoded, "\n"))
end

-- Function to decode the whole file (without selection)
M.base64_decode_file = function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local text = table.concat(lines, "\n")

  -- Decode: Handle macOS/Linux
  local decoded = vim.fn.system("base64 -d", text)

  -- Replace the entire buffer's content with the decoded text
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.split(decoded, "\n"))
end

-- Function to encode selected text
M.base64_encode = function()
  local text, start_line, start_col, end_line, end_col = get_selected_text()
  if not text then return end

  -- Encode: Handle macOS/Linux
  local command = is_mac and "base64" or "base64 -w 0"
  local encoded = vim.fn.system(command, text):gsub("\n", "")

  replace_selected_text(start_line, start_col, end_line, end_col, encoded)
end

-- Function to decode selected text
M.base64_decode = function()
  local text, start_line, start_col, end_line, end_col = get_selected_text()
  if not text then return end

  -- Decode: Handle macOS/Linux
  local decoded = vim.fn.system("base64 -d", text)

  replace_selected_text(start_line, start_col, end_line, end_col, decoded)
end

-- Function to decode clipboard content into a new buffer
M.decode_clipboard = function()
  local encoded_text = vim.fn.getreg('+') -- Get clipboard content
  if encoded_text == "" then
    vim.notify("Clipboard is empty or not base64 encoded!", vim.log.levels.WARN)
    return
  end

  -- Decode: Handle macOS/Linux
  local decoded_text = vim.fn.system("base64 -d", encoded_text)

  -- Open a new buffer and insert the decoded text
  vim.cmd("new")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(decoded_text, "\n"))
end

-- Register command for easy access
vim.api.nvim_create_user_command("Base64DecodeClipboard", M.decode_clipboard, {})

return M

