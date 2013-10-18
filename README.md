This is a reboot of my .vim config.

I hope to make it more architecture independent and easier to adapt to
anyone's needs.

Install:

git clone https://github.com/jesvs/simpledotvim.git ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
cd ~/.vim
git submodule init
git submodule update

Launche vim and run the BundleInstall command.
:BundleInstall

This config uses [airline](https://github.com/bling/vim-airline) for
the status bar.
Installing a [powerline patched font](https://github.com/Lokaltog/powerline-fonts)
is a must.

The LEADER is mapped to ,

,ev edits the vimrc file.
