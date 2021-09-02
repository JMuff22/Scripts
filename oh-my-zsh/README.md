### Installing zsh

[Oh My Zsh](https://ohmyz.sh/).
You can install and configure it by cd'ing to the root
of this repository and executing the following commands.

```
sudo apt-get update
sudo apt-get install zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Installation of additional plugins,
[zsh-autocomplete](https://github.com/marlonrichert/zsh-autocomplete),
[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
and
[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting):
```
mkdir -p ${ZSH_CUSTOM}/plugins
cd ${ZSH_CUSTOM}/plugins
git clone git@github.com:marlonrichert/zsh-autocomplete.git
git clone git@github.com:zsh-users/zsh-autosuggestions.git
git clone git@github.com:zsh-users/zsh-syntax-highlighting.git
```

For configuring the plugins:

`zsh-autocomplete` - Check `/.oh-my-zsh/plugins/zsh-autocomplete/.zshrc` and copy+change lines over to your `$HOME/.zshrc`



Installation of the
[Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme:
first download all the
[MesloLGS theme files](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k)
and set it as your default terminal font.
Then run the following commands.
```
mkdir -p ${ZSH_CUSTOM}/themes
cd ${ZSH_CUSTOM}/themes
git clone git@github.com:romkatv/powerlevel10k.git
```

### Issues: 

```
chpwd recent filehandler:29: no such file or directory: $HOME/.local/zsh/chpwd-recent-dirs
```

Fix --> Simply make directory in `$Home/.local/zsh` and zsh populates this. 

```
$HOME/.bashrc.casino:4: command not found: shopt
```
ZSH doesn't like `shopt`. Solution from https://github.com/larz258/Zshopt. 

Download to your choice of `/bin/`
```
wget https://raw.githubusercontent.com/larz258/Zshopt/master/shopt
```

Remember to `chmod +x shopt`.

Add alias in `.zshrc`

```
alias shopt='/home/jakemuff/.local/bin/shopt'
```

Thanks Mika! Credit for this: https://github.com/AgenttiX/linux-scripts/tree/master/zsh

