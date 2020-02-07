curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
pip install 'python-language-server[all]'
ln -s $PWD/vimrc ~/.vimrc
ln -s $PWD/bash_profile ~/.bash_profile
