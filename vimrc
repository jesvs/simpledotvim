set nocompatible
filetype off  " required by Vundle

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

set encoding=utf-8
set fileencoding=utf-8
set history=4096

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" color schemes
"Bundle 'tomasr/molokai'
"Bundle 'altercation/vim-colors-solarized'
Bundle 'nanotech/jellybeans.vim'
Bundle 'junegunn/seoul256.vim'
"Bundle 'Lokaltog/vim-distinguished'

" Syntax
Bundle 'tpope/vim-haml'
Bundle 'StanAngeloff/php.vim'
Bundle 'othree/html5.vim'
Bundle 'slim-template/vim-slim'
Bundle 'pangloss/vim-javascript'

" Other plugins
Bundle 'godlygeek/tabular'
Bundle 'Valloric/YouCompleteMe'
" Causing issues (with YCM ?)
"Bundle 'marijnh/tern_for_vim' 
Bundle 'tpope/vim-surround'
Bundle 'Lokaltog/vim-easymotion'
" delimitMate: suggested by YCM author instead of vim-autoclose
Bundle 'Raimondi/delimitMate' 
Bundle 'bling/vim-airline'
Bundle 'kien/ctrlp.vim'
Bundle 'vim-scripts/toggle_words.vim'
Bundle 'SirVer/ultisnips'

filetype plugin indent on " required (vundle)

" Airline config
let g:airline_powerline_fonts=1
let g:airline_theme='laederon'
set laststatus=2

" UltiSnips config
let g:UltiSnipsExpandTrigger="<c-j>"

" toggle_words config
nmap <LEADER>t :ToggleWord<CR>

" colorscheme molokai
colorscheme jellybeans
"let g:seoul256_background=234
"colorscheme seoul256
"colorscheme distinguished

set background=dark

" Color scheme config
if has('gui_running')
  set guioptions-=T   " remove toolbar
endif

" Font config
if has('gui_macvim')
  set guifont=Sauce\ Code\ Powerline:h13
  set transparency=1
endif

if has('gui_gtk')
  set guifont=Source\ Code\ Pro\ Semi-Bold\ 12
endif

set noswapfile
set nobackup
set showcmd       " shows what you are typing as a command
set autoindent
set smartindent
set expandtab     " Expand tab to spaces
set smarttab
set shiftwidth=2
set softtabstop=2
set wildmenu
set wildmode=list:longest,full
set number        " line numbers
set ignorecase
set incsearch     " Incremental searching
set hlsearch      " Highlight search results
set nohidden      " Remove buffer when closing tab
set cul           " highlight current line
set scrolloff=4   " keep 4 lines above and below cursor
set nowrap        " no soft wrap long lines
set synmaxcol=100
set ttyfast
set ttyscroll=3
set lazyredraw

let mapleader=',' " change leader to ,

" --- MAPS
" Edit vimrc \ev
nnoremap <silent> <Leader>ev :tabnew<CR>:e ~/.vimrc<CR>
" Enter to write file
nnoremap <CR> :w<CR>
" Map semicolon to colo
map ; :
" clear highlight
nnoremap <silent> <Leader>/ :nohlsearch<CR>
" exit insert mode by typing jj
imap jj <Esc>

" remove ALL autocommands to prevent duplication when sourcing .vimrc
autocmd! 

" --- FILETYPE SPECIFIC SETTINGS
" enable column highlight on white space indented languages
autocmd FileType python,haml setlocal cursorcolumn 
" autocmd FileType php setlocal noautoindent nosmartindent nocindent indent=<CR>
autocmd FileType php setlocal smartindent autoindent cindent indentexpr=<CR>
autocmd BufNewFile,BufRead *.slim set filetype=slim
autocmd BufNewFile,BufRead .bash_profile set filetype=sh

" --- Functions
autocmd BufWritePost *.haml call HamlMake()
" Inspired by Mark Hansen's python dependent function
" http://markhansen.co.nz/autocompiling-haml/
" Create an empty .autohaml to auto compile your haml files on save
function! HamlMake()
  if filereadable(expand('%:p:h')."/.autohaml")
    let hamlinput = expand('%:p')
    let htmloutput = substitute(hamlinput, ".haml", ".html", "")
    execute 'silent !haml % '.htmloutput
  endif
endfunction

" Create an empty .autoscss to auto compile your scss files on save
autocmd BufWritePost *.scss call ScssMake()
function! ScssMake()
  if filereadable(expand('%:p:h')."/.autoscss")
    let scssinput = expand('%:p')
    let cssoutput = substitute(scssinput, ".scss", ".css", "")
    silent execute '!scss -q --compass % '.cssoutput
  endif
endfunction

" Enable syntax highlighting when buffers are displayed in a window through
" :argdo and :bufdo, which disable the Syntax autocmd event to speed up
" processing.
augroup EnableSyntaxHighlighting
  " Filetype processing does happen, so we can detect a buffer initially
  " loaded during :argdo / :bufdo through a set filetype, but missing
  " b:current_syntax. Also don't do this when the user explicitly turned off
  " syntax highlighting via :syntax off.
  " The following autocmd is triggered twice:
  " 1. During the :...do iteration, where it is inactive, because
  " 'eventignore' includes "Syntax". This speeds up the iteration itself.
  " 2. After the iteration, when the user re-enters a buffer / window that was
  " loaded during the iteration. Here is becomes active and enables syntax
  " highlighting. Since that is done buffer after buffer, the delay doesn't
  " matter so much.
  " Note: When the :...do command itself edits the window (e.g. :argdo
  " tabedit), the BufWinEnter event won't fire and enable the syntax when the
  " window is re-visited. We need to hook into WinEnter, too. Note that for
  " :argdo split, each window only gets syntax highlighting as it is entered.
  " Alternatively, we could directly activate the normally effectless :syntax
  " enable through :set eventignore-=Syntax, but that would also cause the
  " slowdown during the iteration Vim wants to avoid.
  " Note: Must allow nesting of autocmds so that the :syntax enable triggers
  " the ColorScheme event. Otherwise, some highlighting groups may not be
  " restored properly.
  autocmd! BufWinEnter,WinEnter * nested if exists('syntax_on') && ! exists('b:current_syntax') && ! empty(&l:filetype) && index(split(&eventignore, ','), 'Syntax') == -1 | syntax enable | endif

  " The above does not handle reloading via :bufdo edit!, because the
  " b:current_syntax variable is not cleared by that. During the :bufdo,
  " 'eventignore' contains "Syntax", so this can be used to detect this
  " situation when the file is re-read into the buffer. Due to the
  " 'eventignore', an immediate :syntax enable is ignored, but by clearing
  " b:current_syntax, the above handler will do this when the reloaded buffer
  " is displayed in a window again.
  autocmd! BufRead * if exists('syntax_on') && exists('b:current_syntax') && ! empty(&l:filetype) && index(split(&eventignore, ','), 'Syntax') != -1 | unlet! b:current_syntax | endif
augroup END
