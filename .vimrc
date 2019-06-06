"--------------------------------------------------------------------------------
"--- NeoBundle

if has('vim_starting')
    set nocompatible
    set runtimepath+=$HOME/.vim/bundle/neobundle.vim/
    set runtimepath+=$GOROOT/misc/vim
    set runtimepath+=$GOPATH/src/github.com/nsf/gocode/vim
endif

call neobundle#begin(expand('$HOME/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make -f make_mac.mak',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }
NeoBundle 'majutsushi/tagbar'
NeoBundle 'glidenote/memolist.vim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'szw/vim-tags'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'hashivim/vim-terraform'

" Git
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-rhubarb'
NeoBundle 'cohama/agit.vim'
NeoBundle 'idanarye/vim-merginal'

" 操作
NeoBundle 'gcmt/wildfire.vim'
NeoBundle 'kana/vim-operator-user'
NeoBundle 'rhysd/vim-operator-surround'
NeoBundle 'tpope/vim-repeat'

" 表示
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'Yggdroot/indentLine'

" 検索
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'rking/ag.vim'
NeoBundle 'dyng/ctrlsf.vim'
NeoBundle 'thinca/vim-visualstar'
NeoBundle 'haya14busa/incsearch.vim'

" Perl
NeoBundle 'vim-perl/vim-perl'
NeoBundle 'hotchpotch/perldoc-vim'
NeoBundle 'motemen/xslate-vim'

" Ruby
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'tpope/vim-rails'

" HTML
NeoBundle 'othree/html5.vim'

" Golang
NeoBundle 'fatih/vim-go'

call neobundle#end()
filetype plugin indent on
NeoBundleCheck

"--------------------------------------------------------------------------------
"--- neocomplete

" 起動時に有効化
let g:neocomplete#enable_at_startup = 1
" 大文字が入力されるまで大文字小文字の区別を無視
let g:neocomplete#enable_smart_case = 1
" シンタックスをキャッシュする時の最小文字長
let g:neocomplete#sources#syntax#min_keyword_length= 3
" ファイルタイプ別の辞書設定
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'perl' : $HOME . '/.vim/dict/perl.dict'
    \ }
" 補完候補の切り替えをTABキーにする
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif

"--------------------------------------------------------------------------------
"--- neosnippet

" snippetの配置場所
let g:neosnippet#snippets_directory = [
    \'~/.vim/snippets',
    \]

" snippetの呼び出し
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=0 concealcursor=i
endif

"--------------------------------------------------------------------------------
"--- Tagbar

" ctagsのパス指定
if has("win32")
    let g:tagbar_ctags_bin = '$HOME\bin\ctags.exe'
endif

nmap <silent> <C-o> :TagbarToggle<CR>

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
"--- syntastic

let g:syntastic_enable_perl_checker = 1

"--------------------------------------------------------------------------------
"--- ctrlp

" ファイル名検索をデフォルトにする
let g:ctrlp_by_filename = 1
" 終了時にキャッシュをクリアしない
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_by_filename = 0

"--------------------------------------------------------------------------------
"--- NERDTree

nmap <silent> <C-e> :NERDTreeToggle<CR>

" 起動時にNERDTreeを有効化
autocmd vimenter * NERDTree
" NERDTreeのみとなった場合にVimを終了する
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"--------------------------------------------------------------------------------
"--- vim-quickrun

let g:quickrun_config = {
\   "_" : {
\       "runner" : "vimproc",
\       "runner/vimproc/updatetime" : 10,
\   },
\}

"--------------------------------------------------------------------------------
"--- vim-operator-surround

map <silent>sa <Plug>(operator-surround-append)
map <silent>sd <Plug>(operator-surround-delete)
map <silent>sr <Plug>(operator-surround-replace)

"--------------------------------------------------------------------------------
"--- memolist.vim

let g:memolist_memo_suffix = "md"
let g:memolist_memo_date = "%Y-%m-%d %H:%M"
let g:memolist_ex_cmd = 'NERDTree'

"--------------------------------------------------------------------------------
"--- incsearch.vim

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)


"--------------------------------------------------------------------------------
"--- open-browser.vim

let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)


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

"--------------------------------------------------------------------------------
"--- 表示

" 強調表示
syntax on
" 256色モードで起動
set t_Co=256
" 背景文字色
colorscheme hybrid
set background=dark
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
set listchars=tab:\¦\ ,trail:_,extends:>,precedes:<
" 印字不可能文字を16進数で表示
set display=uhex
" メニュー非表示
set guioptions-=m
" エラー時の画面フラッシュをOFF
set novisualbell
" ヤンクした内容をクリップボードにコピー
set clipboard+=autoselect
set clipboard+=unnamed
" タブを常に表示
set showtabline=2
" 100 桁以上はハイライトしない
" 既定値では 3000
set synmaxcol=200

" 全角スペースをハイライト
"if has("syntax")
"    syntax on
"    function! ActivateInvisibleIndicator()
"    syntax match InvisibleJISX0208Space "　" display containedin=ALL
"    highlight InvisibleJISX0208Space term=underline ctermbg=Cyan guibg=Cyan
"endf
"    augroup invisible
"    autocmd! invisible
"    autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
"    augroup END
"endif

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

autocmd! FileType ruby setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd! FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd! FileType eruby setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd! FileType yaml setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd! FileType yml setlocal shiftwidth=2 tabstop=2 softtabstop=2

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

autocmd! FileType markdown hi! def link markdownItalic Normal
au BufRead,BufNewFile *.md         set filetype=markdown
au BufNewFile,BufRead *.psgi       set filetype=perl
au BufNewFile,BufRead *.t          set filetype=perl
au BufNewFile,BufRead cpanfile     set filetype=perl
autocmd Filetype json setl conceallevel=0
autocmd Filetype markdown setl conceallevel=0

"--------------------------------------------------------------------------------
"--- キーバインド関係

" 行単位で移動(1行が長い場合に便利)
nnoremap <Space>. :<C-u>edit $MYVIMRC<CR>
nnoremap <Space>, :<C-u>source $MYVIMRC<CR>

" カーソル配下の単語を置換
nnoremap g/ :<C-u>%s/<C-R><C-w>//gc<Left><Left><Left>

" ハイライトを削除
noremap <Esc><Esc> :nohlsearch<CR><Esc>

" 行末までコピー
nnoremap Y y$

" バッファ
nmap <silent> <S-l> :bnext<CR>
nmap <silent> <S-h> :bprevious<CR>

" タブ
nmap <silent> <C-n> :tabe<CR>
nmap <silent> <C-l> :tabn<CR>
nmap <silent> <C-h> :tabN<CR>

" 検索などで飛んだらそこを真ん中に
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz
nmap G Gzz

imap <c-j> <c-[>

let g:terraform_fmt_on_save = 1

