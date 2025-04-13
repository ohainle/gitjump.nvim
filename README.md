# gitjump.nvim

`:GitJump [diff|merge]`

This plugin calls the [git-jump contrib script](https://github.com/git/git/tree/master/contrib/git-jump) from within an existing neovim client.
Quickfix item filepathes are amended to be relative to the current working directory, rather than the git top-level directory.

## Prerequisites

- Git version [2.40.0](https://github.com/git/git/releases/tag/v2.40.0) or later.

- The contrib script must be aliased to `git jump` in your global git configuration:

#### MacOS with Homebrew

```gitconfig
[alias]
  jump = "!$(brew --prefix git)/share/git-core/contrib/git-jump/git-jump"
```
#### Other

```sh
curl https://raw.githubusercontent.com/git/git/refs/heads/master/contrib/git-jump/git-jump > /usr/local/bin/git-jump
```

```gitconfig
[alias]
  jump = "/usr/local/bin/git-jump"
```

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "ohainle/gitjump.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
}
```

> [!IMPORTANT]
> [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim) is a required dependency.

## Usage

`:GitJump [diff|merge]`

## Issues

Please report bugs to [https://github.com/ohainle/gitjump.nvim/issues](https://github.com/ohainle/gitjump.nvim/issues).
