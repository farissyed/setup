#!/usr/bin/env bash
set -e

# ──────────────────────────────────────────────────────────────
# Faris's Mac Dev Environment Setup
# Non-destructive: always backs up existing configs before copying
# ──────────────────────────────────────────────────────────────

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ── Helper: safe copy with timestamped backup ────────────────
safe_copy() {
    src="$1"; dest="$2"
    if [ -f "$dest" ]; then
        backup="${dest}.backup.$(date +%Y-%m-%d_%H%M%S)"
        echo "  Backing up $dest → $backup"
        cp "$dest" "$backup"
    fi
    cp "$src" "$dest"
}

echo "================================================"
echo " Dev Environment Setup"
echo " Dotfiles dir: $DOTFILES_DIR"
echo "================================================"
echo ""

# ── 1. Install Homebrew ──────────────────────────────────────
echo "[1/11] Homebrew"
if command -v brew &>/dev/null; then
    echo "  Already installed."
else
    echo "  Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
echo ""

# ── 2. Install Oh My Zsh ────────────────────────────────────
echo "[2/11] Oh My Zsh"
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "  Already installed."
else
    echo "  Installing Oh My Zsh (keeping existing .zshrc)..."
    KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi
echo ""

# ── 3. Install CLI tools via Homebrew ────────────────────────
echo "[3/11] CLI tools (tmux, fzf, ripgrep, fd, lazygit, git-delta, neovim)"
brew install tmux fzf ripgrep fd lazygit git-delta neovim
echo ""

# ── 4. Install Ghostty ──────────────────────────────────────
echo "[4/11] Ghostty"
if brew list --cask ghostty &>/dev/null; then
    echo "  Already installed."
else
    echo "  Installing Ghostty..."
    brew install --cask ghostty
fi
echo ""

# ── 5. Copy tmux.conf ───────────────────────────────────────
echo "[5/11] tmux.conf"
safe_copy "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
echo "  Installed ~/.tmux.conf"
echo ""

# ── 6. Copy gitconfig ───────────────────────────────────────
echo "[6/11] gitconfig"
safe_copy "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"
if [ -z "$(git config --global user.name)" ]; then
    read -rp "  Git user.name: " git_name
    git config --global user.name "$git_name"
fi
if [ -z "$(git config --global user.email)" ]; then
    read -rp "  Git user.email: " git_email
    git config --global user.email "$git_email"
fi
echo "  Installed ~/.gitconfig"
echo ""

# ── 7. Copy Ghostty config ──────────────────────────────────
echo "[7/11] Ghostty config"
mkdir -p "$HOME/.config/ghostty"
safe_copy "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"
echo "  Installed ~/.config/ghostty/config"
echo ""

# ── 8. Clone LazyVim starter ────────────────────────────────
echo "[8/11] LazyVim starter"
if [ -d "$HOME/.config/nvim" ]; then
    echo "  ~/.config/nvim already exists, skipping clone."
else
    echo "  Cloning LazyVim starter..."
    git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
    rm -rf "$HOME/.config/nvim/.git"
    echo "  Cloned and detached from starter repo."
fi
echo ""

# ── 9. Copy nvim plugin overrides ───────────────────────────
echo "[9/11] Neovim plugin overrides"
mkdir -p "$HOME/.config/nvim/lua/plugins"
cp "$DOTFILES_DIR/nvim/lua/plugins/colorscheme.lua" "$HOME/.config/nvim/lua/plugins/colorscheme.lua"
cp "$DOTFILES_DIR/nvim/lua/plugins/example.lua" "$HOME/.config/nvim/lua/plugins/example.lua"
cp "$DOTFILES_DIR/nvim/lua/plugins/noice.lua" "$HOME/.config/nvim/lua/plugins/noice.lua"
echo "  Copied colorscheme.lua, example.lua, noice.lua"
echo ""

# ── 10. Copy lazy-lock.json ─────────────────────────────────
echo "[10/11] lazy-lock.json"
safe_copy "$DOTFILES_DIR/nvim/lazy-lock.json" "$HOME/.config/nvim/lazy-lock.json"
echo "  Installed ~/.config/nvim/lazy-lock.json"
echo ""

# ── 11. Ensure PATH in zshrc ────────────────────────────────
echo "[11/11] Ensuring \$HOME/bin in PATH"
if grep -q '\$HOME/bin' "$HOME/.zshrc" 2>/dev/null; then
    echo "  Already present in ~/.zshrc"
else
    echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.zshrc"
    echo "  Appended to ~/.zshrc"
fi
echo ""

echo "================================================"
echo " Setup complete!"
echo " Restart your terminal or run: source ~/.zshrc"
echo "================================================"
