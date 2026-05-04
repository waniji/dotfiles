#!/bin/sh

set -eu

cd "$(dirname "$0")"

link_file() {
    src="$1"
    dest="$2"

    mkdir -p "$(dirname "$dest")"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "skip:   $dest already exists"
        return
    fi

    ln -s "$src" "$dest"
    echo "linked: $dest -> $src"
}

find . \
  -type f \
  ! -path "./.git/*" \
  ! -name ".gitignore" \
  ! -name ".gitmodules" \
  ! -name "setup.sh" \
  | while IFS= read -r file
do
    rel="${file#./}"
    link_file "$PWD/$rel" "$HOME/$rel"
done
