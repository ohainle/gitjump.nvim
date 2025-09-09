local ERROR_PREFIXES = {
  "fatal:",
  "error:",
  "warning:",
  "usage:",
}

local M = {}

local function get_raw_git_jump_output(args)
  -- TODO vim.fn.jobstart for async

  local handle, err = io.popen(string.format([[
    git jump --stdout %s 2>&1
  ]], args))

  if handle == nil then error(err) end

  local raw = handle:read("*a")

  local _, _, exit_code = handle:close()

  if exit_code ~= nil and exit_code ~= 0 then
    error("git jump exited with error code " .. exit_code)
  end

  for _, prefix in ipairs(ERROR_PREFIXES) do
    if raw:sub(1, #prefix) == prefix then
      error(raw)
    end
  end

  return raw
end

function M.get_qfitems(args)
  local raw = get_raw_git_jump_output(args)

  local qfitems = vim.split(raw, "[\n\r]")

  -- TODO handle `git jump ws` multiline output

  if #qfitems ~= 0 then
    if qfitems[#qfitems] == "" then
      table.remove(qfitems, #qfitems)
    end
  end

  return qfitems
end

return M
