 Install lunarvim and dependencies
brew install ripgrep  # For ignoring node_modules folder from search
brew install neovim
LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)


ln -s $PWD/zshrc ~/.zshrc
ln -s $PWD/bash_profile ~/.bash_profile
ln -s $PWD/config.lua ~/.config/lvim/config.lua
