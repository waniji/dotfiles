"--------------------------------------------------------------------------------
"--- NeoBundle

set nocompatible
filetype off

if has('vim_starting')
  set runtimepath+=$HOME/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('$HOME/.vim/bundle/'))

NeoBundle 'scrooloose/nerdtree'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neocomplcache-snippets-complete'
NeoBundle 'vim-scripts/errormarker.vim'

filetype plugin indent on

if neobundle#exists_not_installed_bundles()
  echomsg 'Not installed bundles : ' .
  \ string(neobundle#get_not_installed_bundle_names())
echomsg 'Please execute ":NeoBundleInstall" command.'
endif

"--------------------------------------------------------------------------------
"--- neocomlpcache

" 起動時に有効化
let g:neocomplcache_enable_at_startup = 1
" 大文字が入力されるまで大文字小文字の区別を無視
let g:neocomplcache_enable_smart_case = 1
" _区切りの補完を有効化
let g:neocomplcache_enable_underbar_completion = 1
" シンタックスをキャッシュする時の最小文字長
let g:neocomplcache_min_syntax_length = 4
" ファイルタイプ別の辞書設定
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'perl' : $HOME . '/.vim/dict/perl.dict'
    \ }
" スニペットの展開
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
" 前回行われた補完をキャンセル
inoremap <expr><C-g>     neocomplcache#undo_completion()
" 補完候補の中からk腰痛する部分を補完
inoremap <expr><C-l>     neocomplcache#complete_common_string()
" ポップアップを削除
inoremap <expr><CR>  neocomplcache#smart_close_popup()."\<CR>"
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  neocomplcache#smart_close_popup()."\<C-h>"
" 現在選択している候補を確定
inoremap <expr><C-y>  neocomplcache#close_popup()
" 現在選択している候補をキャンセルしポップアップを閉じる
inoremap <expr><C-e>  neocomplcache#cancel_popup()
" 補完候補の切り替えをTABキーにする
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" オムニ補完の設定
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" Enable heavy omni completion.
"if !exists('g:neocomplcache_omni_patterns')
"  let g:neocomplcache_omni_patterns = {}
"endif
"let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

" snippetの配置場所
let g:neocomplcache_snippets_dir = $HOME . '/.vim/snippets'
" snippetの呼び出し
imap <C-k> <plug>(neocomplcache_snippets_expand)
smap <C-k> <plug>(neocomplcache_snippets_expand)

"--------------------------------------------------------------------------------
"--- 基本

" vi互換をOFF
set nocompatible
" スクロール時の余白確保
set scrolloff=5
" 自動で折り返しをしない
set textwidth=0
" バックアップを取らない
set nobackup
" 他で書き換えられたら自動で読み直す
set autoread
" スワップファイルを作成しない
set noswapfile
" 編集中でも他のファイルを開けるようにする
set hidden
" バックスペースでなんでも消せるように
set backspace=indent,eol,start 
" テキスト整形オプション，マルチバイト系を追加
set formatoptions=lmoq
" ビープをならさない
set vb t_vb=
" Exploreの初期ディレクトリ
set browsedir=buffer
" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,] 
" タブを常に表示
set showtabline=2

"--------------------------------------------------------------------------------
"--- 表示

" 強調表示
syntax on
" 背景文字色
colorscheme desert
" 背景色
set background=dark
" タイトルを表示
set title
" 常にステータスラインを表示
set laststatus=2
" ステータスラインの書式
set statusline=%<%F\ %r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%4v(ASCII=%03.3b,HEX=%02.2B)\ %l/%L(%P)%m
" コマンドをステータス行に表示
set showcmd
" 括弧の対応をハイライト
set showmatch
" 入力中のコマンドを表示
set showcmd
" 行番号表示
set number
" 不可視文字表示
set list
" 不可視文字の表示形式
set listchars=tab:>.,trail:_,extends:>,precedes:<
" 印字不可能文字を16進数で表示
set display=uhex
" メニュー非表示
set guioptions-=m
" エラー時の画面フラッシュをOFF
set novisualbell
" 全角スペースをハイライト
if has("syntax")
    syntax on
    function! ActivateInvisibleIndicator()
    syntax match InvisibleJISX0208Space "　" display containedin=ALL
    highlight InvisibleJISX0208Space term=underline ctermbg=Cyan guibg=Cyan
    "        syntax match InvisibleTrailedSpace "[ \t]\+$" display containedin=ALL
    "        highlight InvisibleTrailedSpace term=underline ctermbg=Red guibg=Red
    "        syntax match InvisibleTab "\t" display containedin=ALL
    "        highlight InvisibleTab term=underline ctermbg=Cyan guibg=Cyan
endf
    augroup invisible
    autocmd! invisible
    autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
    augroup END
endif
" カレントウィンドウにのみ罫線を引く
augroup cch
autocmd! cch
autocmd WinLeave * set nocursorline
autocmd WinEnter,BufRead * set cursorline
augroup END

if exists('&ambiwidth')
    set ambiwidth=double
endif

"--------------------------------------------------------------------------------
"--- インデント

" 新しい行を開始時に自動的にインデントする
set autoindent
" 新しい行を開始時に高度なインデントを行う
set smartindent
" Tabキー押下時の空白の数
set tabstop=4
" 自動インデント時の空白の数
set shiftwidth=4
" INSERTでTabを挿入するときに、代わりに適切な数の空白を挿入する
set expandtab

"--------------------------------------------------------------------------------
"--- 補完・履歴

" リスト表示，最長マッチ
set wildmode=list:longest
" コマンド・検索パターンの履歴数
set history=1000
" 補完に辞書ファイル追加
set complete+=k

"--------------------------------------------------------------------------------
"--- 検索設定

" 大文字小文字無視
set ignorecase
" 大文字ではじめたら大文字小文字無視しない
set smartcase
" インクリメンタルサーチ
set incsearch
" 検索文字をハイライト
set hlsearch

"--------------------------------------------------------------------------------
"--- エンコーディング関連

" 改行文字
set ffs=unix,dos
" デフォルトエンコーディング
set encoding=utf-8

"--------------------------------------------------------------------------------
"--- キーバインド関係

" 行単位で移動(1行が長い場合に便利)
nnoremap j gj
nnoremap k gk

" バッファ周り
nmap <silent> <C-l> :bnext<CR>
nmap <silent> <C-h> :bprevious<CR>
nmap <silent> ,l    :BufExplorer<CR>
nmap <silent> <C-e> :NERDTreeToggle<CR>

" 検索などで飛んだらそこを真ん中に
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz
nmap G Gzz

imap <c-j> <c-[>

