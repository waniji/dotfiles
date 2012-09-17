setlocal makeprg=$HOME/.vim/vimparse.pl\ -c\ %\ $*
setlocal errorformat=%f:%l:%m

au BufWritePost <buffer> silent make

