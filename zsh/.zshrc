# ---- Claude Code ----
export DISABLE_AUTOUPDATER=1

# ---- Completions ----
autoload -Uz compinit && compinit

# ---- PATH edits first ----
PATH=$PATH:/Users/ben/Library/Android/sdk/platform-tools
PATH="$HOME/.local/bin:$PATH"
PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
PATH="/Users/ben/local/lua-5.1/bin/:$PATH"
export PATH


# PS1='$ %~/ '
setopt prompt_subst

git_branch() {
      ref=$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
        [[ -n "$ref" ]] && echo "($ref)"
}

PS1='$ %~ $(git_branch) '


source <(fzf --zsh)

alias dot="cd ~/dotfiles"
alias zet="cd ~/second-brain"

setopt globdots

# Added for Raspberry PI Pico development
export PICO_SDK_PATH=~/sandbox/tools/pico-sdk/

export TERM=xterm-256color

# Added by Antigravity
export PATH="/Users/ben/.antigravity/antigravity/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

