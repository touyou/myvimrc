" =============================================================================
" 基本設定
" =============================================================================
" Vi互換モードを無効化
if &compatible
    set nocompatible
endif
scriptencoding utf-8
set fileformats=unix,mac,dos

" =============================================================================
" ランタイムパス
" =============================================================================
" vimディレクトリの設定
if isdirectory($HOME . '/.vim')
    let $MY_VIMRUNTIME = $HOME.'/.vim'
elseif isdirectory($HOME . '\vimfiles')
    let $MY_VIMRUNTIME = $HOME.'\vimfiles'
elseif isdirectory($VIM.'\vimfiles')
    let $MY_VIMRUNTIME = $VIM.'\vimfiles'
endif

" 設定用autocmdグループ
augroup MyAutoCmd
    autocmd! *
augroup END

" =============================================================================
" dpp.vim プラグインマネージャー
" =============================================================================
" DenoパスをPATHから自動検出
let g:denops#deno = exepath('deno')
let $BASE_DIR = expand('$MY_VIMRUNTIME/rc')

" dppのパス設定
const s:dpp_base = '~/.cache/dpp/'
const s:dpp_src = '~/.cache/dpp/repos/github.com/Shougo/dpp.vim'
const s:denops_src = '~/.cache/dpp/repos/github.com/vim-denops/denops.vim'
const s:ext_toml = '~/.cache/dpp/repos/github.com/Shougo/dpp-ext-toml'
const s:ext_lazy = '~/.cache/dpp/repos/github.com/Shougo/dpp-ext-lazy'
const s:ext_installer = '~/.cache/dpp/repos/github.com/Shougo/dpp-ext-installer'
const s:protocol_git = '~/.cache/dpp/repos/github.com/Shougo/dpp-protocol-git'

" runtimepathに追加
execute 'set runtimepath^=' .. s:dpp_src
execute 'set runtimepath^=' .. s:ext_toml
execute 'set runtimepath^=' .. s:ext_lazy
execute 'set runtimepath^=' .. s:ext_installer
execute 'set runtimepath^=' .. s:protocol_git

" dpp-ext-lazyのVim用変数を初期化 (Neovim用コードブロック外で必要)
if !exists('g:dpp#ext#_called_vim')
    let g:dpp#ext#_called_vim = {}
endif

" 状態をロード、失敗時は再構築
if s:dpp_base->dpp#min#load_state()
    execute 'set runtimepath^=' .. s:denops_src
    autocmd User DenopsReady
        \ : echohl WarningMsg
        \ | echomsg 'dpp: 状態を再構築中...'
        \ | echohl NONE
        \ | call dpp#make_state(s:dpp_base, expand('$MY_VIMRUNTIME/rc/dpp.ts'))
endif

" 状態構築完了通知
autocmd User Dpp:makeStatePost
    \ : echohl WarningMsg
    \ | echomsg 'dpp: 状態構築完了!'
    \ | echohl NONE

filetype plugin indent on
syntax enable
set secure

" =============================================================================
" 検索
" =============================================================================
set ignorecase      " 大文字小文字を区別しない
set smartcase       " 大文字が含まれる場合は区別する
set incsearch       " インクリメンタル検索
set hlsearch        " 検索結果をハイライト
set wrapscan        " 末尾から先頭に戻る

" =============================================================================
" 編集
" =============================================================================
" インデント
set shiftround autoindent smartindent cindent
set cinoptions+=:0

" タブ設定 (4スペース)
set ts=4 sw=4 sts=4 expandtab smarttab

" ファイルタイプ別インデント
augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.rb,*.html,*.erb,*.js,*.css,*.ts,*.tsx setlocal ts=2 sw=2 sts=2
    autocmd BufNewFile,BufRead *.ml,*.mli,*.mly,*.mll setlocal ts=2 sw=2 sts=2
augroup END

" バッファ操作
set hidden                          " 保存せずにバッファ切り替え可能
set switchbuf=useopen               " 既存ウィンドウを再利用
set backspace=indent,eol,start      " BSで何でも削除可能

" 括弧マッチ
set showmatch matchtime=3
set matchpairs& matchpairs+=<:>

" カーソル移動
set virtualedit=block
set guicursor=

" =============================================================================
" クリップボード・マウス
" =============================================================================
if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus,unnamed
else
    set clipboard& clipboard+=unnamed
endif
if has('mouse')
    set mouse=a
endif

" =============================================================================
" ファイル管理
" =============================================================================
set nobackup nowritebackup swapfile
set autoread                        " 外部で変更されたファイルを自動再読み込み

" 外部変更の自動検知 (フォーカス時・バッファ切替時)
augroup auto_checktime
    autocmd!
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * silent! checktime
augroup END

" スワップファイルディレクトリ
let s:swapdir = expand($MY_VIMRUNTIME . '/tmp')
if !isdirectory(s:swapdir)
    call mkdir(s:swapdir, 'p', 0700)
endif
execute 'set directory=' . fnameescape(s:swapdir) . '//,.'

" =============================================================================
" 表示
" =============================================================================
" 不可視文字の表示
set list listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲

" 行番号・カーソル行
set number cursorline

" 折り返し・カラム
set wrap textwidth=0 colorcolumn=80

" ステータス表示
set title ruler cmdheight=2 laststatus=2 showcmd showmode

" ベル無効化
set t_vb= novisualbell

" その他
set nrformats-=octal                " 007を8進数として扱わない
set timeoutlen=3500 history=50
set formatoptions+=mM               " 日本語の折り返し対応
set whichwrap=b,s,h,l,[,],<,>
set ambiwidth=double                " 曖昧幅文字を全角扱い
set wildmode=list,full wildmenu

" =============================================================================
" タブライン
" =============================================================================
function! s:SID_PREFIX()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

function! s:my_tabline()
    let s = ''
    for i in range(1, tabpagenr('$'))
        let bufnr = tabpagebuflist(i)[tabpagewinnr(i) - 1]
        let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
        let title = '[' . fnamemodify(bufname(bufnr), ':t') . ']'
        let s .= '%' . i . 'T'
        let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
        let s .= i . ':' . title . mod . '%#TabLineFill# '
    endfor
    return s . '%#TabLineFill#%T%=%#TabLine#'
endfunction

let &tabline = '%!' . s:SID_PREFIX() . 'my_tabline()'
set showtabline=2

" =============================================================================
" カラースキーム
" =============================================================================
if has("termguicolors")
    set termguicolors
endif
silent! colorscheme dogrun

" =============================================================================
" キーマッピング - ファンクションキー
" =============================================================================
" F1: vimrcを開く
nnoremap <silent> <F1> :<C-u>e ~/.vimrc<CR>

" F10: 現在のファイルを再読み込み
function! s:source_script(path) abort
    let path = expand(a:path)
    if filereadable(path)
        execute 'source' fnameescape(path)
        echomsg printf('"%s" を読み込みました (%s)', fnamemodify(path, ':~:.'), strftime('%c'))
    endif
endfunction
nnoremap <silent> <F10> :<C-u>call <SID>source_script('%')<CR>

" =============================================================================
" キーマッピング - タブ操作
" =============================================================================
nnoremap <silent> to :tablast <bar> tabnew<CR>
nnoremap <silent> tx :tabclose<CR>
nnoremap <silent> tn :tabnext<CR>
nnoremap <silent> tp :tabprevious<CR>
nnoremap <silent> t1 :tabnext 1<CR>
nnoremap <silent> t2 :tabnext 2<CR>
nnoremap <silent> t3 :tabnext 3<CR>
nnoremap <silent> t4 :tabnext 4<CR>
nnoremap <silent> t5 :tabnext 5<CR>
nnoremap <silent> t6 :tabnext 6<CR>
nnoremap <silent> t7 :tabnext 7<CR>
nnoremap <silent> t8 :tabnext 8<CR>
nnoremap <silent> t9 :tabnext 9<CR>

" =============================================================================
" キーマッピング - ウィンドウ操作
" =============================================================================
nnoremap ss :split<CR><C-w>w
nnoremap sv :vsplit<CR><C-w>w
nnoremap <Space> <C-w>w

" ウィンドウ間移動
nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap s<Left> <C-w>h
nnoremap s<Down> <C-w>j
nnoremap s<Up> <C-w>k
nnoremap s<Right> <C-w>l

" ウィンドウリサイズ
nnoremap <C-w><Left> <C-w><
nnoremap <C-w><Right> <C-w>>
nnoremap <C-w><Up> <C-w>+
nnoremap <C-w><Down> <C-w>-

" =============================================================================
" キーマッピング - カーソル移動
" =============================================================================
nnoremap ZZ <Nop>
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
nnoremap h <Left>zv
nnoremap l <Right>zv
nnoremap <Esc><Esc> :<C-u>set nohlsearch!<CR>

" =============================================================================
" キーマッピング - クリップボード
" =============================================================================
noremap <C-A> ggVG
noremap <C-X> "+x
noremap <C-C> "+y
noremap <C-V> "+gP
noremap <C-S> :w<CR>

" 検索時の特殊文字エスケープ
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

" =============================================================================
" プラグイン設定 - NERDTree
" =============================================================================
let g:NERDTreeWinSize = 22
let g:NERDTreeDirArrowExpandable = '▶'
let g:NERDTreeDirArrowCollapsible = '▼'
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
nnoremap <silent> sf :NERDTreeToggle<CR>

" =============================================================================
" プラグイン設定 - DevIcons
" =============================================================================
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol = ''
let g:DevIconsDefaultFolderOpenSymbol = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {
    \ 'html': '', 'css': '', 'md': '', 'txt': ''
    \ }
set guifont=RictyDiscordForPowerline\ Nerd\ Font:h14

" =============================================================================
" プラグイン設定 - Vista (シンボルビューア)
" =============================================================================
let g:vista_default_executive = 'vim_lsp'
let g:vista_sidebar_width = 30
nnoremap <silent> <F2> :Vista!!<CR>

" =============================================================================
" プラグイン設定 - fzf
" =============================================================================
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <Leader>g :Rg<CR>
nnoremap <silent> <Leader>h :History<CR>

" =============================================================================
" プラグイン設定 - LSP
" =============================================================================
" LSPが有効になったバッファ用のキーマップ
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <buffer> <F3> <plug>(lsp-rename)
endfunction

" Tab/Shift+Tabで補完候補を選択
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() ? "\<C-y>" : "\<CR>"

augroup lsp_install
    autocmd!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" =============================================================================
" 言語別設定 (rc/lang/*.vim を自動読み込み)
" =============================================================================
for s:lang_file in glob($MY_VIMRUNTIME . '/rc/lang/*.vim', 1, 1)
    execute 'source' fnameescape(s:lang_file)
endfor

" =============================================================================
" ユーティリティコマンド
" =============================================================================
command! PluginList execute 'edit ' . expand('$MY_VIMRUNTIME/rc/PLUGINS.md')
command! PluginStatus echo '読込済: ' . len(dpp#get()) . ' プラグイン'

" =============================================================================
" プラグインインストーラー
" =============================================================================
" 未インストールのプラグインを取得
function! s:get_not_installed() abort
    let l:result = []
    for [l:name, l:plugin] in items(dpp#get())
        if !isdirectory(l:plugin.path)
            call add(l:result, l:name)
        endif
    endfor
    return l:result
endfunction

" プラグインをインストール (進捗表示付き)
function! s:dpp_install() abort
    let l:not_installed = s:get_not_installed()
    if empty(l:not_installed)
        echohl WarningMsg | echo '全プラグインがインストール済みです' | echohl None
        return
    endif
    echohl WarningMsg
    echo len(l:not_installed) . ' 個のプラグインをインストール中...'
    for l:plugin in l:not_installed
        echo '  - ' . l:plugin
    endfor
    echohl None
    call dpp#async_ext_action('installer', 'install')
endfunction

" プラグインを更新 (ターミナルで実行して進捗表示)
function! s:dpp_update() abort
    " ターミナルでスクリプトを実行
    execute 'terminal ++close ' . expand('$MY_VIMRUNTIME/bin/dpp-update')
endfunction

command! DppInstall call s:dpp_install()
command! DppUpdate call s:dpp_update()

" インストール完了通知
autocmd User Dpp:extActionDone:installer:install
    \ : echohl WarningMsg | echomsg 'dpp: インストール完了!' | echohl None
