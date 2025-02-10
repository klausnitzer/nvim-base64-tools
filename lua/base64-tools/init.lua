local M = {}

-- Detect macOS
local is_mac = vim.loop.os_uname().sysname == "Darwin"

-- Helper function to get selected text
local function get_selected_text()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2] - 1
  local start_col = start_pos[3] - 1
  local end_line = end_pos[2] - 1
  local end_col = end_pos[3]

  -- Get selected text safely
  local lines = vim.api.nvim_buf_get_text(0, start_line, start_col, end_line, end_col, {})

  -- Handle case where nothing is selected
  if not lines or #lines == 0 then
    vim.notify("No text selected for encoding/decoding.", vim.log.levels.WARN)
    return nil
  end

  return table.concat(lines, "\n"), start_line, start_col, end_line, end_col
end

-- Helper function to replace text safely
local function replace_selected_text(start_line, start_col, end_line, end_col, new_text)
  if new_text and #new_text > 0 then
    vim.api.nvim_buf_set_text(0, start_line, start_col, end_line, end_col, { new_text })
  else
    vim.notify("Failed to replace text. Output was empty.", vim.log.levels.ERROR)
  end
end

M.base64_encode = function()
  local text, start_line, start_col, end_line, end_col = get_selected_text()
  if not text then return end   -- Avoid errors if no text is selected

  -- Handle macOS & Linux encoding
  local command = is_mac and "base64" or "base64 -w 0"
  local encoded = vim.fn.system(command, text):gsub("\n", "")

  replace_selected_text(start_line, start_col, end_line, end_col, encoded)
end

M.base64_decode = function()
  local text, start_line, start_col, end_line, end_col = get_selected_text()
  if not text then return end   -- Avoid errors if no text is selected

  -- Decode text
  local decoded = vim.fn.system("base64 -d", text)

  replace_selected_text(start_line, start_col, end_line, end_col, decoded)
end

return M

