# ── oh-my-zsh ─────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git dnf zsh-syntax-highlighting fzf)

zstyle ':omz:update' mode disabled
DISABLE_MAGIC_FUNCTIONS="true"

source $ZSH/oh-my-zsh.sh

# ── Environment ───────────────────────────────────────────────
# vim over SSH, nvim locally. Must come before any later EDITOR export.
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
  export TERM=xterm-256color
fi

export QT_QPA_PLATFORM="wayland;xcb"

path=(
  ~/.cargo/bin
  ~/.local/bin
  ~/.opencode/bin
  ~/dotfiles/scripts/.config/scripts/user
  $path
)

# ── Aliases ───────────────────────────────────────────────────
alias hv="nvim $HOME/.config/hypr/hyprland.conf"
alias niriconf="nvim $HOME/.config/niri/config.kdl"
alias zshconf="nvim ~/.zshrc"

alias ls='eza -a --icons auto -s type'
alias ll='eza -al --icons auto'
alias lt='eza -a --tree --level=1 --icons'
alias l='eza --icons auto'
alias lsf='ls|fzf'

alias ff="echo && fastfetch --logo /home/bdora/.config/fastfetch/picture.png --logo-width 19 --logo-position left"
alias run="~/.config/scripts/user/run.sh"
alias nivm='nvim'   # typo insurance

# ── Functions ─────────────────────────────────────────────────
# yazi, then cd to wherever it left off
function yac() {
    local tmp="$(mktemp)"
    yazi --cwd-file="$tmp" "$@"

    if [ -f "$tmp" ]; then
        local dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && cd "$dir"
    fi

    zle && zle reset-prompt 2>/dev/null
}

# ── Keybinds ──────────────────────────────────────────────────
zle -N yac
bindkey '^Y' yac
bindkey '^ ' autosuggest-accept

# ── Ink theme ─────────────────────────────────────────────────
# Mirrors colors.toml. Accent (#b01949) marks the cursor line only.
export FZF_DEFAULT_OPTS=" \
  --color=bg+:#1b1b1b,fg:#a8a8a8,fg+:#b01949 \
  --color=hl:#f0ebd8,hl+:#d94a72,info:#6a6a6a,prompt:#f0ebd8 \
  --color=pointer:#b01949,marker:#a8a8a8,spinner:#6a6a6a,header:#a8a8a8 \
  --color=border:#2a2a2a,label:#a8a8a8,query:#f0ebd8,separator:#2a2a2a \
  --color=gutter:-1,scrollbar:#2a2a2a,preview-bg:#0e0e0e \
  --padding=0,0 \
  --margin=0,0 \
  --prompt=\" 󰍉 \" \
  --pointer=\" \" \
  --marker=\"✓\" \
  --layout=reverse \
  --info=inline \
  --height=60% \
  --preview-window=right:50%:border-left"

export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"

# Directories bold-white, not accent-red — red is reserved for focus/urgent.
export EZA_COLORS="di=1;37"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# ── Tools ─────────────────────────────────────────────────────
eval "$(zoxide init zsh)"
eval "$(thefuck --alias)"
eval "$(thefuck --alias fk)"
source <(fzf --zsh)
. "$HOME/.local/bin/env"

setopt HIST_IGNORE_SPACE
