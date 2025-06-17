-- TODO check plenary.nvim is installed
-- TODO check git is above the git-jump --stdout version
-- TODO ask users to alias git-jump in git config

local COMPLETIONS = {
  "merge",
  "diff",
  "grep",
  "ws",
}

vim.api.nvim_create_user_command(
  "Gitjump",
  function(opts)
    local mode = nil
    for _, cmd in ipairs(COMPLETIONS) do
      if opts.args == cmd then
        mode = cmd
        break
      end
    end

    if false and mode == nil then
      vim.notify("Invalid Gitjump mode: " .. opts.args, vim.log.levels.WARN)
      return
    end

    require("gitjump").jump(opts.args)
  end,
  {
    desc = "Run `git jump [args]` and redirect the output to the quickfix list",
    nargs = 1,
    complete = function(_, line)
      local params = vim.split(line, "%s+", { keepempty = true })

      if #params == 1 then
        return COMPLETIONS
      elseif #params == 2 then
        return vim.tbl_filter(function(arg)
          return vim.startswith(arg, params[2])
        end, COMPLETIONS)
      end
    end,
  }
)
