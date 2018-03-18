#!/usr/bin/env bash

# ask for password before all the scripts

sudo echo "ask for password before all the scripts"

# install homebrew
/usr/bin/ruby -e "(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install oh-my-zsh
#brew install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# set .zshrc
wget -O $HOME/.zshrc https://gist.githubusercontent.com/veggiemonk/f7dc67b05400905973e2db050dffd05b/raw/433d43edc07339c181b20b83406d1f5053583688/.zshrc

# install oh-my-zsh plugins
git clone https://github.com/djui/alias-tips.git $HOME/.oh-my-zsh/custom/plugins/alias-tips
git clone https://github.com/supercrabtree/k $HOME/.oh-my-zsh/custom/plugins/k
git clone https://github.com/rupa/z $HOME/.oh-my-zsh/custom/plugins/z
git clone https://github.com/Valiev/almostontop.git $HOME/.oh-my-zsh/custom/plugins/almostontop

git clone https://github.com/zsh-users/zsh-completions $HOME/.oh-my-zsh/custom/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions

## Some utils
#brew install coreutils findutils wget curl tree tig git socat ssh-copy-id htop mosh rlwrap maven httpie pv
#brew tap caskroom/cask
## Some apps
#brew cask install java visual-studio-code google-chrome docker virtualbox vagrant vagrant-manager the-unarchiver

# setup dev env
mkdir -p $HOME/code

# node.js
git clone https://github.com/tj/n.git $HOME/code/n
cd $HOME/code/n && make install
sudo chown -R $USER /usr/local # Not secure if on a server
n lts

# pure prompt & other goodies
npm install -g pure-prompt browser-sync eslint diff-so-fancy ntl ghwd
    
## MAC CLI
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/guarinogabriel/mac-cli/master/mac-cli/tools/install)"

## FONTS
#brew tap caskroom/fonts
#brew cask install font-fira-code

git clone https://github.com/powerline/fonts.git $HOME/code/fonts
cd $HOME/code/fonts && ./install.sh 
