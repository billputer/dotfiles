" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

filetype off

set rtp+=~/.vim/bundle/vundle
call vundle#begin()

Bundle 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
Bundle 'scrooloose/nerdtree'

call vundle#end()


set modelines=0

set encoding=utf-8
set scrolloff=3
set showmode
set hidden
set wildmenu
set visualbell
set cursorline
set ttyfast
set showmatch

" wrapping options
set wrap
set formatoptions=qn1
" todo: enclose this in in a guard
" set colorcolumn=85


let mapleader = ","

nnoremap / /\v
vnoremap / /\v

" map ,<space> to clear command line
nnoremap <leader><space> :noh<cr>

" guard this
" sets tab to go to parens
"nnoremap <tab> %
"vnoremap <tab> %

" show whitespace characters
set list
set listchars=tab:▸\ ,eol:¬

" set j & k to move by screen line
nnoremap j gj
nnoremap k gk

nnoremap ; :


" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup
set nowritebackup
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on
  set smartindent

endif " has("autocmd")

if has("folding")
  set foldenable
  set foldmethod=syntax
  set foldlevel=1
  set foldnestmax=2
  set foldtext=strpart(getline(v:foldstart),0,50).'\ ...\ '.substitute(getline(v:foldend),'^[\ #]*','','g').'\ '

  " automatically open folds at the starting cursor position
  " autocmd BufReadPost .foldo!
endif

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set softtabstop=4
set expandtab

" Always display the status line
set laststatus=2

" Visual mode: D
vmap D y'>p

" Local config
if filereadable(".vimrc.local")
  source .vimrc.local
endif

" Use Ack instead of Grep when available
if executable("ack")
  set grepprg=ack\ -H\ --nogroup\ --nocolor
endif

" Color scheme
set background=dark
colorscheme solarized
highlight NonText guibg=#060606
highlight Folded  guibg=#0A0A0A guifg=#9090D0

" Airline
let g:airline_powerline_fonts=1
let g:airline#extensions#branch#enabled=1

" Numbers
set number
set numberwidth=5

" Tab completion options
" (only complete to the longest unambiguous match, and show a menu)
set completeopt=longest,menu
set wildmode=list:longest,list:full

" case only matters with mixed case expressions
set ignorecase
set smartcase

" PHP hacks
" highlights interpolated variables in sql strings and does sql-syntax highlighting. yay
autocmd FileType php let php_sql_query=1
" does exactly that. highlights html inside of php strings
autocmd FileType php let php_htmlInStrings=1
" discourages use oh short tags. c'mon its deprecated remember
autocmd FileType php let php_noShortTags=1
" automagically folds functions & methods. this is getting IDE-like isn't
autocmd FileType php let php_folding=1

if has("autocmd")
    " Drupal *.module, *.inc and *.install files.
    augroup module
        autocmd BufRead,BufNewFile *.module set filetype=php
        autocmd BufRead,BufNewFile *.inc set filetype=php
        autocmd BufRead,BufNewFile *.install set filetype=php
    augroup END
endif

""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom commands
""""""""""""""""""""""""""""""""""""""""""""""""""

" W strips trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" U converts file to unix style endings and saves
nnoremap <leader>U :set ff=unix<cr>:wq<cr>

" S sorts CSS properties alphabetically
nnoremap <leader>S ?{<CR>jV/^\v\s*\}?$<CR>k:sort<CR>:noh<CR>

" V relects text that was just pasted in
nnoremap <leader>v V`]

" jj exits insert mode
inoremap jj <ESC>

" w opens a new vertical window and switches to it
nnoremap <leader>w <C-w>v<C-w>l

" mappings for moving between tabs easily
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Ctrl+n toggles NERDTree
map <C-n> :NERDTreeToggle<cr>

" F3 disables autoindenting and autocommenting
nnoremap <F3> :setl noai nocin nosi formatoptions-=c formatoptions-=r formatoptions-=o inde=<CR>
