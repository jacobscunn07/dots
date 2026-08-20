[[ -z "$XDG_CONFIG_HOME" ]] && export XDG_CONFIG_HOME="$HOME/.config"
[[ -d "$XDG_CONFIG_HOME/zsh" ]] && export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
[[ -r "$XDG_CONFIG_HOME/zsh/.zshenv" ]] && source "$XDG_CONFIG_HOME/zsh/.zshenv"