local get_qfitems = require("gitjump.git").get_qfitems
local resolve_qfitem_filepathes = require("gitjump.fs").resolve_qfitem_filepathes

-- TODO signatures
-- TODO tests

local M = {}

function M.jump(mode)
  local status, qfitems_or_err = pcall(get_qfitems, mode)

  if not status then
    vim.notify("git jump failed: " .. qfitems_or_err, vim.log.levels.WARN)
    return
  end

  local qfitems = qfitems_or_err

  vim.fn.setqflist({}, " ", {
    lines = resolve_qfitem_filepathes(qfitems),
  })
end

return M
