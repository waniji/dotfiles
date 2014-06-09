"--------------------------------------------------------------------------------
"--- NeoBundle

set nocompatible
filetype off

if has('vim_starting')
  set runtimepath+=$HOME/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('$HOME/.vim/bundle/'))

NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/vimproc', { 'build' : {
    \     'windows' : 'make -f make_mingw32.mak',
    \     'cygwin'  : 'make -f make_cygwin.mak',
    \     'mac'     : 'make -f make_mac.mak',
    \     'unix'    : 'make -f make_unix.mak',
    \    },
    \ }
NeoBundle 'vim-scripts/errormarker.vim'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'fakeclip'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'glidenote/memolist.vim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'vim-perl/vim-perl', {
    \ 'autoload' : {
    \   'filetypes' : ['perl', 'pl'],
    \   },
    \ }
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'thinca/vim-visualstar'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'osyo-manga/vim-over'
NeoBundle 'tpope/vim-fugitive'

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
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

"--------------------------------------------------------------------------------
"--- unite

" バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" 全部
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')

"--------------------------------------------------------------------------------
"--- Tagbar

" ctagsのパス指定
if has("win32")
    let g:tagbar_ctags_bin = '$HOME\bin\ctags.exe'
endif

"--------------------------------------------------------------------------------
"--- vim-over

" over.vimの起動
nnoremap <silent> ,s :OverCommandLine<CR>
" カーソル下の単語をハイライト付きで置換
nnoremap sub :OverCommandLine<CR>%s/<C-r><C-w>//g<Left><Left>
" コピーした文字列をハイライト付きで置換
nnoremap subp y:OverCommandLine<CR>%s!<C-r>=substitute(@0, '!', '\\!', 'g')<CR>!!gI<Left><Left><Left>

"--------------------------------------------------------------------------------
"--- lightline

let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component': {
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ }

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
" 256色モードで起動
set t_Co=256
" 背景文字色
colorscheme hybrid
" タイトルを表示
set title
" 常にステータスラインを表示
set laststatus=2
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
" ヤンクした内容をクリップボードにコピー
set clipboard+=autoselect
set clipboard+=unnamed

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
"--- ファイル種別

autocmd BufRead,BufNewFile *.md  setlocal filetype=markdown
autocmd! FileType markdown hi! def link markdownItalic Normal

"--------------------------------------------------------------------------------
"--- キーバインド関係

" 行単位で移動(1行が長い場合に便利)
nnoremap j gj
nnoremap k gk
nnoremap <Space>. :<C-u>edit $MYVIMRC<CR>
nnoremap <Space>, :<C-u>source $MYVIMRC<CR>
nnoremap <silent> ,gg :<C-u>GitGutterToggle<CR>
nnoremap <silent> ,gh :<C-u>GitGutterLineHighlightsToggle<CR>

" カーソル配下の単語を置換
nnoremap g/ :<C-u>%s/<C-R><C-w>//gc<Left><Left><Left>

" ハイライトを削除
noremap <Esc><Esc> :nohlsearch<CR><Esc>

" 行末までコピー
nnoremap Y y$

" バッファ周り
nmap <silent> <C-l> :bnext<CR>
nmap <silent> <C-h> :bprevious<CR>
nmap <silent> <C-e> :NERDTreeToggle<CR>
nmap <silent> <C-Tab> :tabn<CR>
nmap <silent> <C-S-Tab> :tabN<CR>
nmap <silent> <C-o> :TagbarToggle<CR>

" 検索などで飛んだらそこを真ん中に
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz
nmap G Gzz

imap <c-j> <c-[>

