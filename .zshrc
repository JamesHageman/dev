export ZSH="/root/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export PROMPT="%F{magenta}%n%f@%F{blue}%m ${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)"
