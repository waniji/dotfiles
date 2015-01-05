#!/bin/sh

cd $(dirname $0)

git clone https://github.com/Shougo/neobundle.vim.git ./.vim/bundle/neobundle.vim

for filename in .?*
do
    [ $filename = ".." ] && continue
    [ $filename = ".git" ] && continue
    [ $filename = ".gitignore" ] && continue
    [ $filename = ".gitmodules" ] && continue

    ln -is "$PWD/$filename" "$HOME"
done

