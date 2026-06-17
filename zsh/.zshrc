# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git dnf zsh-syntax-highlighting fzf)

source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    export TERM=xterm-256color
fi

# Aliases

alias hv="nvim $HOME/.config/hypr/hyprland.conf"
alias zshconf="nvim ~/.zshrc"
alias ls='eza -a --icons auto -s type'
alias ll='eza -al --icons auto'
alias lt='eza -a --tree --level=1 --icons'
alias l='eza --icons auto'
alias py='python'
alias lsf='ls|fzf'
alias ff="fastfetch --logo $HOME/.config/fastfetch/ascii.txt --logo-position left"
alias run="~/.config/scripts/user/run.sh"
# alias zed="flatpak run dev.zed.Zed $1"
alias nivm='nvim'

# Custom functions
function yac() {
    local tmp="$(mktemp)"
    yazi --cwd-file="$tmp" "$@"

    if [ -f "$tmp" ]; then
        local dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && cd "$dir"
    fi
}

# fzf-zoxide-widget() {
#   setopt localoptions pipefail no_aliases 2> /dev/null
#   local dir="$(
#     FZF_DEFAULT_COMMAND=${FZF_ALT_C_COMMAND:-} \
#     FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=dir,follow,hidden --scheme=path" "${FZF_ALT_C_OPTS-} +m") \
#     FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) < /dev/tty)"
#   if [[ -z "$dir" ]]; then
#     zle redisplay
#     return 0
#   fi
#   zle push-line # Clear buffer. Auto-restored on next prompt.
#   BUFFER="builtin cd -- ${(q)dir:a}"
#   zle accept-line
#   local ret=$?
#   unset dir # ensure this doesn't end up appearing in prompt expansion
#   zle reset-prompt
#   return $ret
# }
# if [[ "${FZF_ALT_C_COMMAND-x}" != "" ]]; then
#   zle     -N             fzf-cd-widget
#   bindkey -M emacs '\ec' fzf-cd-widget
#   bindkey -M vicmd '\ec' fzf-cd-widget
#   bindkey -M viins '\ec' fzf-cd-widget
# fi

# Custom Keybind
zle -N yac
bindkey '^Y' yac
bindkey '^ ' autosuggest-accept

# PATHs
export PATH=$PATH:~/.cargo/bin/
export PATH=$PATH:~/.local/bin/
export EDITOR=/usr/bin/nvim
export PATH=$PATH:~/.cargo/bin/
export PATH=$PATH:/usr/bin/
export QT_QPA_PLATFORM="wayland;xcb"

eval "$(zoxide init zsh)"
eval $(thefuck --alias)
eval $(thefuck --alias fk)


# fzf plugins
source <(fzf --zsh)
# HISTFILE=~/.zsh_history
# SAVEHIST=10000

export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"

export FZF_DEFAULT_OPTS=" \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

export FZF_DEFAULT_OPTS=" \
  --color=bg+:#1f1f1f,fg:#e2e2e2,fg+:#b01949 \
  --color=hl:#ffffff,hl+:#ad5f77,info:#919191,prompt:#ffffff \
  --color=pointer:#AD0034,marker:#c6c6c6,spinner:#919191,header:#c6c6c6 \
  --color=border:#474747,label:#c6c6c6,query:#e2e2e2,separator:#474747 \
  --color=gutter:-1,scrollbar:#474747,preview-bg:#1b1b1b \
  --padding=0,0 \
  --margin=0,0 \
  --prompt=\" 󰍉 \" \
  --pointer=\" \" \
  --marker=\"✓\" \
  --layout=reverse \
  --info=inline \
  --height=60% \
  --preview-window=right:50%:border-left"

# Eza
export EZA_COLORS="di=31"

# Some custom colors
# source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

. "$HOME/.local/bin/env"

# opencode
export PATH=/home/bdora/.opencode/bin:$PATH
export PATH=/home/bdora/dotfiles/scripts/.config/scripts/user/:$PATH

