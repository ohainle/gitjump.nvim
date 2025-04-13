local P = require("plenary.path")
local Mode = require("gitjump.mode").Mode

-- TODO signatures
-- TODO tests

local M = {}

local function is_inside_git_work_tree()
  local handle = io.popen([[
    git rev-parse --is-inside-work-tree 2>/dev/null
  ]])

  if handle == nil then
    return false
  end

  local raw = handle:read("*a")
  handle:close()

  return raw == "true\n"
end

local function get_qfitems(mode)
  -- TODO vim.fn.jobstart for async
  local handle = io.popen(string.format([[
    git jump --stdout %s 2>/dev/null
  ]], Mode[mode]))

  if handle == nil then return end

  local raw = handle:read("*a")
  handle:close()

  local qfitems = vim.split(raw, "[\n\r]")

  if #qfitems ~= 0 then
    if qfitems[#qfitems] == "" then
      table.remove(qfitems, #qfitems)
    end
  end

  return qfitems
end

local function get_git_top_level()
  local handle = io.popen([[
    git rev-parse --show-toplevel 2>/dev/null
  ]])

  if handle == nil then
    return nil
  end

  local raw = handle:read("*a")
  handle:close()

  return raw:sub(1, -2)
end

local function extract_path_from_qfitem(qfitem)
  local i = qfitem:find(":")

  if i == nil then
    return "", ""
  end

  return qfitem:sub(1, i - 1), qfitem:sub(i)
end

local function includes(xs, y)
  for _, x in ipairs(xs) do
    if x == y then
      return true
    end
  end
end

local function resolve_qfitem_filepath_outside_cwd(git_top_level, cwd, absolute_path)
  local parents = absolute_path:parents()

  local absolute_base = P:new(cwd):parent()
  local relative_base = P:new("..")

  while not includes(parents, absolute_base.filename) do
    if absolute_base.filename == git_top_level then
      return absolute_path
    end

    relative_base = relative_base:joinpath("..")
    absolute_base = absolute_base:parent()
  end

  return relative_base:joinpath(absolute_path:make_relative(absolute_base.filename))
end

local function resolve_qfitem_filepath(git_top_level, cwd, qfitem)
  local path, rest = extract_path_from_qfitem(qfitem)

  path = P:new(P:new(git_top_level, path):make_relative(cwd))

  if path:is_absolute() then
    path = resolve_qfitem_filepath_outside_cwd(git_top_level, cwd, path)
  end

  return path .. rest
end

local function resolve_qfitem_filepathes(qfitems)
  local cwd = vim.uv.cwd()
  local git_top_level = get_git_top_level()

  local resolved_qfitems = {}
  for _, qfitem in ipairs(qfitems) do
    table.insert(
      resolved_qfitems,
      resolve_qfitem_filepath(git_top_level, cwd, qfitem)
    )
  end

  return resolved_qfitems
end

function M.jump(mode)
  if not is_inside_git_work_tree() then
    vim.notify("Not in a git worktree", vim.log.levels.WARN)
    return
  end

  vim.fn.setqflist({}, " ", {
    lines = resolve_qfitem_filepathes(get_qfitems(mode)),
  })
end

return M
