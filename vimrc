set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

"syntax enable

set encoding=utf-8
set fileencoding=utf-8
set history=4096

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" color schemes
Bundle 'tomasr/molokai'
Bundle 'altercation/vim-colors-solarized'
Bundle 'nanotech/jellybeans.vim'
Bundle 'junegunn/seoul256.vim'

" Syntax
Bundle 'tpope/vim-haml'
Bundle 'StanAngeloff/php.vim'
Bundle 'othree/html5.vim'
"Bundle 'sheerun/vim-polyglot'

" Other plugins
Bundle 'godlygeek/tabular'
Bundle 'Valloric/YouCompleteMe'
Bundle 'marijnh/tern_for_vim'
Bundle 'tpope/vim-surround'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Townk/vim-autoclose'
Bundle 'bling/vim-airline'
Bundle 'kien/ctrlp.vim'
Bundle 'vim-scripts/toggle_words.vim'
Bundle 'SirVer/ultisnips'

filetype plugin indent on   " required (vundle)

" Airline config
let g:airline_powerline_fonts=1
let g:airline_theme='laederon'
set laststatus=2

" UltiSnips config
let g:UltiSnipsExpandTrigger="<c-j>"

" toggle_words config
nmap <LEADER>t :ToggleWord<CR>

" colorscheme molokai
" colorscheme jellybeans
let g:seoul256_background=234
colorscheme seoul256

set background=dark

" Color scheme config
if has('gui_running')
  set guioptions-=T   " remove toolbar
endif

" Font config
if has('gui_macvim')
  set guifont=Sauce\ Code\ Powerline:h15
  set transparency=2
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
" Tab completion
set wildmenu
set wildmode=list:longest,full
"set relativenumber
set number        " line numbers
set ignorecase
set incsearch     " Incremental searching
set hlsearch      " Highlight search results
set nohidden      " Remove buffer when closing tab
set cul           " highlight current line
set scrolloff=4   " keep 4 lines above and below cursor
set nowrap        " no soft wrap long lines

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

" --- FILETYPE SPECIFIC SETTINGS
" enable column highlight on white space indented languages
autocmd FileType python,haml setlocal cursorcolumn 
" autocmd FileType php setlocal noautoindent nosmartindent nocindent indent=<CR>
autocmd FileType php setlocal smartindent autoindent cindent indentexpr=<CR>

" --- Functions
au BufWritePost *.haml call HamlMake()
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
au BufWritePost *.scss call ScssMake()
function! ScssMake()
  if filereadable(expand('%:p:h')."/.autoscss")
    let scssinput = expand('%:p')
    let cssoutput = substitute(scssinput, ".scss", ".css", "")
    execute 'silent !scss --compass % '.cssoutput
  endif
endfunction
