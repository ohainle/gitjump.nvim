-- TODO check plenary.nvim is installed
-- TODO check git is above the git-jump --stdout version
-- TODO ask users to alias git-jump in git config

vim.api.nvim_create_user_command(
  "Gitjump",
  function(opts)
    local mode = require("gitjump.mode").get_mode(opts.args)

    if mode == nil then
      vim.notify("Invalid GitJump mode: " .. opts.args, vim.log.levels.WARN)
      return
    end

    require("gitjump").jump(mode)
  end,
  {
    desc = "Run `git jump [mode]` and redirect the output to the quickfix list",
    nargs = 1,
    complete = function(_, line)
      local completions = require("gitjump.mode").commands

      local params = vim.split(line, "%s+", { trimempty = true })

      if #params == 1 then
        return completions
      elseif #params == 2 then
        return vim.tbl_filter(function(arg)
          return vim.startswith(arg, params[2])
        end, completions)
      end
    end,
  }
)
