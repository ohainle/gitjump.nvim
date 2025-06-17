# gitjump.nvim

`:GitJump [diff [args]|merge|grep [args]| ws]`

This plugin calls the [git-jump contrib script](https://github.com/git/git/tree/master/contrib/git-jump) from within an existing neovim client.
Quickfix item filepathes are amended to be relative to the current working directory, rather than the git top-level directory.

## Prerequisites

### Git

Git version [2.40.0](https://github.com/git/git/releases/tag/v2.40.0) or later, to ensure that `git jump` supports the `--stdout` arg.

### [contrib/git-jump](https://github.com/git/git/tree/master/contrib/git-jump/README.md)

Contrib scripts are not packaged with every git distribution.
If you have a version of git that does not include it, you will need to install it manually.

#### Locating `contrib/git-jump`

You can check if your git installation includes the `git-jump` contrib script by finding your git installation directory:

```sh
ls ${brew --prefix git}/share/git-core/contrib
ls /usr/share/git/contrib
ls /usr/local/bin/git/contrib
ls /usr/bin/git/contrib
```

If not present, you can manually download the `git-jump` script from the git repository.

```sh
curl https://raw.githubusercontent.com/git/git/refs/heads/master/contrib/git-jump/git-jump > /usr/local/bin/git-jump
```

#### Enabling `contrib/git-jump`

The contrib script must then be aliased to `git jump` in your global git configuration:

```gitconfig
[alias]
  jump = "!$(brew --prefix git)/share/git-core/contrib/git-jump/git-jump"
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

`:GitJump [diff [args]|merge|grep [args]| ws]`

## Issues

Please report bugs to [https://github.com/ohainle/gitjump.nvim/issues](https://github.com/ohainle/gitjump.nvim/issues).
