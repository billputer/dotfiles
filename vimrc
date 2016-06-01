" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

filetype off

set rtp+=~/.vim/bundle/vundle
call vundle#begin()

Plugin 'altercation/vim-colors-solarized'
Plugin 'bogado/file-line'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'ludovicchabant/vim-lawrencium'
Plugin 'pearofducks/ansible-vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-sensible'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

call vundle#end()


set modelines=0
set showmode
set hidden
set visualbell
set cursorline
set ttyfast
set showmatch
set hlsearch

" wrapping options
set wrap
set formatoptions=qn1

let mapleader = ","

nnoremap / /\v
vnoremap / /\v

" map ,<space> to clear command line
nnoremap <leader><space> :noh<cr>

" show whitespace characters
set list
set listchars=tab:▸\ ,eol:¬

" set j & k to move by screen line
nnoremap j gj
nnoremap k gk

nnoremap ; :


set nobackup
set nowritebackup
set showcmd		" display incomplete commands

" Don't use Ex mode, use Q for formatting
map Q gq

if has("folding")
  set foldenable
  set foldmethod=syntax
  set foldlevel=1
  set foldnestmax=2
  set foldtext=strpart(getline(v:foldstart),0,50).'\ ...\ '.substitute(getline(v:foldend),'^[\ #]*','','g').'\ '
endif

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set softtabstop=4
set expandtab

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
highlight NonText guibg=#060606
highlight Folded  guibg=#0A0A0A guifg=#9090D0
" enable solarized if it exists
silent! colorscheme solarized


" Airline
let g:airline_powerline_fonts=1
let g:airline#extensions#branch#enabled=1
let g:airline_theme = 'solarized'

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

if has("autocmd")
  " PHP hacks
  " highlights interpolated variables in sql strings and does sql-syntax highlighting. yay
  autocmd FileType php let php_sql_query=1
  " does exactly that. highlights html inside of php strings
  autocmd FileType php let php_htmlInStrings=1
  " discourages use oh short tags. c'mon its deprecated remember
  autocmd FileType php let php_noShortTags=1
  " automagically folds functions & methods. this is getting IDE-like isn't
  autocmd FileType php let php_folding=1

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

" L clears the highlighting of :set hlsearch
nnoremap <leader>l :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

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

" F4 toggles line numbers and visible whitespace
nnoremap <F4> :setlocal number! list!<CR>

" Lawrencium - Mercurial shortcuts
map <Leader>ha :Hgannotate<CR>
map <Leader>hc :Hgcommit<CR>
map <Leader>hd :Hgvdiff<CR>
map <Leader>hl :Hglogthis<CR>
map <Leader>hs :Hgstatus<CR>
