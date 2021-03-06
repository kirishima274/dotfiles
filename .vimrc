scriptencoding utf-8
set encoding=utf-8
set nocompatible 
set number
set showmatch
set autoindent
set smartindent
set cursorline
" Ctrl+Vで貼付けても階段状にならないようにする
set pastetoggle=<C-E>
set clipboard+=unnamed
set laststatus=2
set t_Co=256
set guifont=MyFont\ for\ Powerline

syntax on

set background=light
colorscheme solarized

set backspace=indent,eol,start

" .md as markdown, instead of modula2
"autocmd MyAutoGroup BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown

"Vim-R-Plugin Setting
set nocompatible
syntax enable
filetype plugin on
filetype indent on

"Tab Setting
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

scriptencoding cp932

"auto closing parenthesis
imap { {}<LEFT>
imap [ []<LEFT>
imap ( ()<LEFT>

""""""""""""""""""""""""""""""
" Restore cursor to file position in previous editing session
""""""""""""""""""""""""""""""
if has("autocmd")
     autocmd BufReadPost *
     \ if line("'\"") > 0 && line ("'\"") <= line("$") |
     \   exe "normal! g'\"" |
     \ endif
endif
""""""""""""""""""""""""""""""

" Swap semicolon and colon. It dosen't work....
"vnoremap : ;
"vnoremap ; :


"--------------------------------------------------------------------------
"" Setting of lightline.vim

let g:lightline = {
        \ 'colorscheme': 'wombat',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
        \ },
        \ 'component_function': {
        \   'modified': 'MyModified',
        \   'readonly': 'MyReadonly',
        \   'fugitive': 'MyFugitive',
        \   'filename': 'MyFilename',
        \   'fileformat': 'MyFileformat',
        \   'filetype': 'MyFiletype',
        \   'fileencoding': 'MyFileencoding',
        \   'mode': 'MyMode'
        \ }
        \ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      return fugitive#head()
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

" Load local setting on proxy emviroment.
"if filereadable($HOME . '.vimrc.local')
"  source $HOME/.vimrc.local
"endif



function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=underline ctermfg=darkgrey gui=underline guifg=darkgrey
  endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        " ZenkakuSpaceをカラーファイルで設定するなら次の行は削除
        autocmd ColorScheme       * call ZenkakuSpace()
        " 全角スペースのハイライト指定
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif
"--------------------------------------------------------------------------
"" lightline.vim

"execute pathogen#infect()

"--------------------------------------------------------------------------
"" neobundle
set nocompatible               " Be iMproved
filetype off                   " Required!

if has('vim_starting')
      set runtimepath+=~/.vim/bundle/neobundle.vim/
  endif

  call neobundle#rc(expand('~/.vim/bundle/'))

  filetype plugin indent on     " Required!

  " Installation check.
  if neobundle#exists_not_installed_bundles()
    echomsg 'Not installed bundles : ' .
            \ string(neobundle#get_not_installed_bundle_names())
    echomsg 'Please execute ":NeoBundleInstall" command.'
    "finish
  endif

NeoBundleCheck

"Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/snipmate-snippets/snippets, ~/.vim/mysnippets'

"GitHubリポジトリにあるプラグインを利用する場合
NeoBundle 'tpope/vim-fugitive'

NeoBundle 'Shougo/neosnippet-snippets'

NeoBundle 'Shougo/neocomplcache.git'
NeoBundle 'Shougo/neosnippet.git'

NeoBundle 'plasticboy/vim-markdown'

NeoBundle 'itchyny/lightline.vim'
NeoBundle 'Shougo/vimproc.git' " proxy

"--------------------------------------------------------------------------
"" neocomplcache
let g:neocomplcache_enable_at_startup = 1

" Enable omni completion. Not required if they are already set elsewhere in.vimrc
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS


"--------------------------------------------------------------------------
"" neosnippet

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable() ?"\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
   set conceallevel=2 concealcursor=i
endif
