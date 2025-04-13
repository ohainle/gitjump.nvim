local M = {}

M.Mode = {
  DIFF = "diff",
  MERGE = "merge",
}

local function get_commands()
  local commands = {}

  for _, command in pairs(M.Mode) do
    table.insert(commands, command)
  end

  return commands
end

M.commands = get_commands()

function M.get_mode(arg)
  for mode, command in pairs(M.Mode) do
    if arg == command then
      return mode
    end
  end
end

return M
