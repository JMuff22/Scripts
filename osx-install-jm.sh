
xcode-select --install #should ignore prompt but may still give
sleep 1
osascript <<EOD
  tell application "System Events"
    tell process "Install Command Line Developer Tools"
      keystroke return
      click button "Agree" of window "License Agreement"
    end tell
  end tell
EOD
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install --cask mactex
brew install wget
brew install htop
brew install git
brew install gh
brew install autoconf
brew install python3
#install anaconda 
brew install --cask sublime-text
ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/bin/subl
wget "https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal" #visual studio code
wget "https://central.github.com/deployments/desktop/desktop/latest/darwin" #github desktop
brew upgrade