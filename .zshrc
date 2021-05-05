
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/jake/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/jake/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/jake/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/jake/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
plugins=(
  git
  bundler
  dotenv
  osx
  rake
  rbenv
  ruby
  autojump
  zsh-syntax-highlighting
  zsh-autosuggestions
)# <<< conda initialize <<<

