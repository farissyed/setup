# Mac Dev Environment Setup

Portable dotfiles and setup script to reproduce my terminal dev environment on any new Mac.

## What's Included

| Config | Description |
|--------|-------------|
| `tmux.conf` | vi-mode, true color, escape-time 0, gray statusbar |
| `zshrc` | Oh My Zsh with robbyrussell theme |
| `gitconfig` | delta as pager with side-by-side diffs |
| `ghostty/config` | 90% background opacity |
| `nvim/` | LazyVim with tokyonight (transparent), noice.nvim disabled |

### Tools Installed

tmux, fzf, ripgrep, fd, lazygit, git-delta, neovim, Ghostty

## Quick Start

```bash
git clone https://github.com/farissyed/setup.git
cd setup
./setup.sh
```

## How It Works

`setup.sh` is idempotent and **non-destructive** — it never overwrites an existing config without creating a timestamped backup first (e.g. `~/.tmux.conf.backup.2026-02-20_143022`).

The script will:

1. Install Homebrew (if missing)
2. Install Oh My Zsh (preserves existing `.zshrc`)
3. Install CLI tools via `brew install`
4. Install Ghostty via `brew install --cask`
5. Copy tmux, git, and Ghostty configs (with backup)
6. Clone the [LazyVim starter](https://github.com/LazyVim/starter) (only if `~/.config/nvim` doesn't exist)
7. Copy Neovim plugin overrides (colorscheme, noice) into the LazyVim plugins directory
8. Copy `lazy-lock.json` for pinned plugin versions
9. Ensure `$HOME/bin` is in PATH

## Key Customizations

- **Neovim**: tokyonight colorscheme with full transparency, noice.nvim disabled
- **tmux**: vi-mode keys, 50k history, true color, fast escape for Neovim
- **Git**: delta pager with side-by-side diffs and line numbers
- **Ghostty**: 90% background opacity

## File Structure

```
├── setup.sh               ← run this on a new Mac
├── tmux.conf
├── zshrc
├── gitconfig
├── ghostty/
│   └── config
├── nvim/
│   ├── init.lua
│   ├── lazy-lock.json
│   └── lua/
│       ├── plugins/
│       │   ├── colorscheme.lua
│       │   ├── example.lua
│       │   └── noice.lua
│       └── config/
│           ├── lazy.lua
│           ├── autocmds.lua
│           ├── keymaps.lua
│           └── options.lua
└── system-info.txt        ← snapshot of installed packages
```
