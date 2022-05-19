"--------------------------------------------------------------------------------
"--- plugins

call plug#begin('~/.vim/plugged')

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
"Plug 'mattn/vim-lsp-settings'

Plug 'glidenote/memolist.vim'

" 表示
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'Yggdroot/indentLine'

" Tree explorer(fern)
Plug 'lambdalisue/fern.vim'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/glyph-palette.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

" 検索
Plug 'ctrlpvim/ctrlp.vim'

" 操作
Plug 'gcmt/wildfire.vim'
Plug 'tpope/vim-endwise'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'thinca/vim-quickrun'

" Programming
Plug 'hashivim/vim-terraform'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'chr4/nginx.vim'
Plug 'itkq/fluentd-vim'
Plug 'elzr/vim-json'
Plug 'google/vim-jsonnet'

call plug#end()

"--------------------------------------------------------------------------------
"--- fern.vim

let g:cursorhold_updatetime = 100
let g:fern#renderer = "nerdfont"

"autocmd VimEnter * ++nested Fern . -drawer -stay -keep -toggle -reveal=%
nnoremap <C-e> :<c-u>Fern . -drawer -keep -toggle -reveal=%<cr>

augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END

"--------------------------------------------------------------------------------
"--- vim-lsp

let g:lsp_diagnostics_enabled = 0

if executable('solargraph')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'solargraph',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
        \ 'initialization_options': {"diagnostics": "false"},
        \ 'whitelist': ['ruby'],
        \ })
endif

if executable('terraform-ls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'terraform-ls',
        \ 'cmd': {server_info->['terraform-ls', 'serve']},
        \ 'whitelist': ['terraform'],
        \ })
endif

"--------------------------------------------------------------------------------
"--- asyncomplete.vim
"

let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt=1

" 補完表示時のEnterで改行をしない
inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"

call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'allowlist': ['*'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'config': {
    \    'max_buffer_size': 5000000,
    \  },
    \ }))

"--------------------------------------------------------------------------------
"--- lightline

let g:lightline = {
      \ 'colorscheme': 'onedark',
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
"--- ctrlp

" ファイル名検索をデフォルトにする
let g:ctrlp_by_filename = 1
" 終了時にキャッシュをクリアしない
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_by_filename = 0

"--------------------------------------------------------------------------------
"--- vim-quickrun

let g:quickrun_config = {
\   "_" : {
\       "runner" : "vimproc",
\       "runner/vimproc/updatetime" : 10,
\   },
\}

"--------------------------------------------------------------------------------
"--- etc

" 保存時にterraform fmtを実行する
let g:terraform_fmt_on_save = 1

" ダブルクォートを表示する
let g:vim_json_syntax_conceal = 0

"--------------------------------------------------------------------------------
"--- 基本

" スクロール時の余白確保
set scrolloff=5
" 自動で折り返しをしない
set textwidth=0
" バックアップを取らない
set nobackup
" スワップファイルを作成しない
set noswapfile
" 編集中でも他のファイルを開けるようにする
set hidden
" ビープをならさない
set vb t_vb=
" Exploreの初期ディレクトリ
set browsedir=buffer
" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,] 

"--------------------------------------------------------------------------------
"--- 表示

" 背景文字色
colorscheme onedark
" コマンドをステータス行に表示
set showcmd
" 括弧の対応をハイライト
set showmatch
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
set clipboard=unnamed
" タブを常に表示
set showtabline=2
" 100 桁以上はハイライトしない
" 既定値では 3000
set synmaxcol=300

" 全角スペースをハイライト
if has("syntax")
    syntax on
    function! ActivateInvisibleIndicator()
    syntax match InvisibleJISX0208Space "　" display containedin=ALL
    highlight InvisibleJISX0208Space term=underline ctermbg=Cyan guibg=Cyan
endf
    augroup invisible
    autocmd! invisible
    autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
    augroup END
endif

"--------------------------------------------------------------------------------
"--- インデント

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
autocmd! FileType typescript setlocal shiftwidth=2 tabstop=2 softtabstop=2

"--------------------------------------------------------------------------------
"--- 補完・履歴

" リスト表示，最長マッチ
"set wildmode=list:longest
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

"--------------------------------------------------------------------------------
"--- ファイル種別

au BufRead,BufNewFile *.md         set filetype=markdown
au BufNewFile,BufRead *.psgi       set filetype=perl
au BufNewFile,BufRead *.t          set filetype=perl
au BufNewFile,BufRead cpanfile     set filetype=perl
autocmd! FileType markdown hi! def link markdownItalic Normal
autocmd Filetype json setl conceallevel=0
autocmd Filetype markdown setl conceallevel=0
autocmd BufNewFile,BufRead *.dig set filetype=yaml
autocmd Syntax yaml setl indentkeys-=<:> indentkeys-=0#

"--------------------------------------------------------------------------------
"--- キーバインド関係

" 設定ファイルを編集
nnoremap <Space>. :<C-u>edit $MYVIMRC<CR>
" 設定ファイルを再読込
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
" exit insert mode
imap <c-j> <c-[>
