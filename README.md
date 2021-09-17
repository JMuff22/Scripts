# zsh scripts
 collection of zsh scripts


### Useful one-liners

Printing colours 0 to 255 in your terminal prompt.

```
for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
```

`git pull` multiple repos at once 

```
find . -mindepth 1 -maxdepth 1 -type d -print -exec git -C {} pull \;
```

Set an alias in `~./zshrc`:

```
alias multipull="find . -mindepth 1 -maxdepth 1 -type d -print -exec git -C {} pull \;"
```
