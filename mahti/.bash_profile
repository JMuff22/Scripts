# .bash_profile
export PROJ=/projappl/project_2002888
export SCRATCH=/scratch/project_2002888/jakemuff
# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin:/users/jakemuff/.local/bin

export PATH
PS1="[\u@\h \A \W]\$ "
EDITOR=nano
export PS1
alias ls="ls --color=auto"
