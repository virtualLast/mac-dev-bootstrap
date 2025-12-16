# ---------------------------------------
# Starship prompt
# ---------------------------------------
eval "$(starship init zsh)"

# ---------------------------------------
# PATH priorities
# ---------------------------------------
typeset -U path
path=(/opt/homebrew/bin /opt/homebrew/sbin ~/.composer/vendor/bin ~/.local/bin /opt/homebrew/opt/coreutils/libexec/gnubin $path)
export PATH="$PATH"

# ---------------------------------------
# NVM / Node.js
# ---------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# ---------------------------------------
# Symfony CLI
# ---------------------------------------
export PATH="$HOME/.symfony/bin:$PATH"

# ---------------------------------------
# Docker CLI
# ---------------------------------------
export DOCKER_SSH_AGENT_AUTH_SOCK=/run/host-services/ssh-auth.sock
export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
fpath=(/Users/mikelast/.docker/completions $fpath)
autoload -Uz compinit
compinit

# ---------------------------------------
# Aliases
# ---------------------------------------
alias addalias='code ~/.zshrc'
alias reload='source ~/.zshrc'
alias sshhome="cd ~/.ssh"
alias sshconfig="code ~/.ssh/config"
alias gitconfig="code ~/.gitconfig"

# ---------------------------------------
# Git Aliases
# ---------------------------------------
# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gb='git branch'
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gf='git fetch'
alias gm='git merge'
alias gst='git stash'
alias gsp='git stash pop'
alias gd='git diff'
alias gds='git diff --staged'
alias glog='git log --oneline --graph --decorate --all'
alias gss='git show --stat'


# ---------------------------------------
# History & shell options
# ---------------------------------------
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000000
export SAVEHIST=10000000
export HISTORY_IGNORE="(ls|pwd|cd)*"
export HIST_STAMPS="%T %d.%m.%y"

setopt EXTENDED_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE

# ---------------------------------------
# Misc
# ---------------------------------------
export PHP_CS_FIXER_IGNORE_ENV=1
export GIT_MERGE_AUTOEDIT=no
