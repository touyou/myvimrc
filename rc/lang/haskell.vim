" =============================================================================
" Haskell 設定
" =============================================================================
" ghcupのバイナリをPATHに追加
let $PATH = expand('~/.ghcup/bin') . ':' . $PATH

" HLSのパスを明示的に設定 (ghcup経由)
let g:lsp_settings = get(g:, 'lsp_settings', {})
let g:lsp_settings['haskell-language-server'] = {
    \ 'cmd': ['haskell-language-server-wrapper', '--lsp'],
    \ 'allowlist': ['haskell', 'lhaskell'],
    \ }

" Haskellファイルの設定
augroup haskell_settings
    autocmd!
    " インデント設定
    autocmd FileType haskell setlocal ts=2 sw=2 sts=2 expandtab
    " KでLSPホバーを使う (manではなく)
    autocmd FileType haskell nnoremap <buffer> K :LspHover<CR>
    " 保存時にフォーマット (HLS経由)
    autocmd BufWritePre *.hs silent! LspDocumentFormatSync
augroup END

" haskell-vim の設定
let g:haskell_enable_quantification = 1   " forall のハイライト
let g:haskell_enable_recursivedo = 1      " mdo, rec のハイライト
let g:haskell_enable_arrowsyntax = 1      " proc のハイライト
let g:haskell_enable_pattern_synonyms = 1 " pattern のハイライト
let g:haskell_enable_typeroles = 1        " type role のハイライト
let g:haskell_enable_static_pointers = 1  " static のハイライト
let g:haskell_indent_disable = 0          " 自動インデント有効
