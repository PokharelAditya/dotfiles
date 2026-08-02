# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -Uz compinit && compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export WORDCHARS='*?_-.~=&;!#$%^(){}<>' 

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=99999999999
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


# Shell integrations for fzf
eval "$(fzf --zsh)"

# Theme for fzf
fg=#CBE0F0
bg_highlight=#143652
purple=#B388FF
blue=#06BCE4
cyan=#66b2dd
theme="--color=fg:${fg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},border:${cyan},info:${blue},prompt:${blue},pointer:${blue},marker:${purple},spinner:${cyan},header:${blue},scrollbar:${blue}"

# Height for fzf
height="--height=28"

# Border for fzf
border="--border=rounded"

# Separator for fzf
separator="--no-separator"

# Separator for fzf
scrollbar="--no-scrollbar"

# Diretory or file preview for fzf
file_or_dir_preview='
if [ -d {} ]; then
  eza --tree --icons --color=always -L 2 {}

elif [ -f {} ]; then
  ftype=$(file --mime-type -b {})

  case "$ftype" in
    text/* | */xml | */json)
      bat -n --color=always --line-range :100 {} 
      ;;
    image/*)
      dim=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}
      kitten icat --clear --transfer-mode=memory --unicode-placeholder --stdin=no --place="$dim@0x0" {}
      ;;
    *)
      echo {}
      ;;
  esac
fi'
preview="--preview='$file_or_dir_preview'"
previewWindow="--preview-window=:noinfo:noborder"
previewToggle="--bind=?:toggle-preview"

export FZF_DEFAULT_OPTS="${height} ${border} ${separator} ${scrollbar} ${theme} ${preview} ${previewWindow} ${previewToggle}"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude /proc --exclude /sys --exclude /dev --exclude /run --exclude /lost+found --exclude /var/log --exclude /var/lib --exclude /tmp --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type=d"

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-flags "--bind=tab:accept" "${height}" "${border}" "${separator}" "${scrollbar}" "${theme}" "${previewWindow}" "${previewToggle}"

#Directory or file preview for fzf-tab
tab_preview='
if [[ -d "$realpath" ]]; then
  eza --tree --icons --color=always -L 2 "$realpath"

elif [[ -f "$realpath" ]]; then
  ftype=$(file --mime-type -b "$realpath")

  case "$ftype" in
    text/* | */xml | */json)
      bat -n --color=always --line-range :100 "$realpath"
      ;;
    image/*)
      dim=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}
      kitten icat --clear --transfer-mode=memory --unicode-placeholder --stdin=no --place="$dim@0x0" "$realpath" 
      ;;
    *)
      echo "$realpath"
      ;;
  esac

fi
'
zstyle ':fzf-tab:complete:*:*' fzf-preview "${tab_preview}"


# Aliases
alias ls='eza --icons --color=always'
alias tree='eza --tree --icons --color=always'
alias vim='nvim'
alias ff='clear; fastfetch'
alias leetcode='nvim leetcode.nvim'

# Custom Commands
export PATH="$HOME/.local/bin:$PATH"
