set nocompatible                    " We are vim, not vi

let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)
let s:homedir = expand('<sfile>:p:h')
"let &runtimepath = printf('%s,%s,%s/after', s:vimdir, &runtimepath, s:vimdir)
let &runtimepath = printf('%s/.vim,%s', s:homedir, &runtimepath)

set backspace=indent,eol,start      " More powerful backspacing
"set textwidth=80                    " No auto-linebreaking
" Autowrapping is ok for text
autocmd FileType text setlocal textwidth=78
autocmd FileType text,markdown,rst,gitcommit setlocal spell
set nobackup                        " Hate backups
set viminfo='20,\"100               " 100 lines of registers
set history=100                     " And 100 lines of history
set ruler                           " Show the cursor position all the time
set number                          " Line numbering is good
set mouse=                          " Use mouse if available
set showcmd                         " Show not-yet-completely-typed commands
set laststatus=2                    " Always show a status line
set linebreak                       " Wrap long lines properly

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.pyc,.pyo

" Enable file type detection
filetype plugin indent on

" Make Vim jump to the last position when reopening a file
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

syntax on

" Searching
set nohlsearch                      " Don't do annoying highlights
set incsearch                       " Search-as-you-type
set ignorecase                      " Case insensitive is ok
set smartcase                       " Case sensitive if you type capitals
set wrapscan                        " Wrap around

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Tab annoyances
set tabstop=4                       " Tabs are 4 spaces wide in my world
set shiftwidth=4                    " Even as spaces
set expandtab                       " I hate tabs anyway
set autoindent                      " Always set autoindenting on
set smartindent                     " Be smart
" One-keystroke reformatting
"nnoremap q gq}
"nnoremap Q gq{

set makeprg=make

"set bg=dark
set wildmode=longest,list
set autoread
set scrolloff=5
" Make Y behave like C or D
map Y y$
let mapleader = ","
let maplocalleader = "\\"
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>nm :set mouse=
" Reindent
nnoremap <leader>i gg=G
autocmd BufReadPost COMMIT_EDITMSG exe "normal! gg"
set statusline=%.50F\ %{fugitive#statusline()}\ %([%M%R%H]%)%=[%l,%v/%L]

noremap <leader>y "*y
noremap <leader>p "*p

call pathogen#infect() 

:vnoremap . :normal .<CR>

au BufNewFile,BufRead *.git/worktrees/*/COMMIT_EDITMSG  setf gitcommit
au BufNewFile,BufRead *.git/worktrees/*/MERGE_MSG       setf gitcommit

if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
    " Need to find a good 256 color scheme
    execute "set t_Co=8"
endif
