# zsh scripts
 collection of zsh scripts


### Useful one-liners

Printing colours 0 to 255 in your terminal prompt.

```
for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
```