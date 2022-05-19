#!/bin/sh

cd $(dirname $0)

for filename in .?*
do
    [ $filename = ".." ] && continue
    [ $filename = ".git" ] && continue
    [ $filename = ".gitignore" ] && continue
    [ $filename = ".gitmodules" ] && continue

    ln -is "$PWD/$filename" "$HOME"
done

