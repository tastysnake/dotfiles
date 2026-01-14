" .vimrc

"####################
"####################
" General behaviour

" To edit faster
" (I'm annoyed by having to wait a few milliseconds as the hard drive spins up
" to change the swap file, so I change it to a dir inside the SSD. The directory
" MUST previously exist, and the double slashes at the end ensure that filenames
" for swapfiles are unique)
set directory=~/.vim/swapfiles//
" To write with Spanish keys
set encoding=utf-8 

" To highlight syntax of known languages
syntax on 

" To show line numbering
set number relativenumber 

" To spellcheck in English
set spelllang=en
" highlight badly spelled words
hi clear SpellBad
hi SpellBad cterm=inverse

" To enable FileType detection
filetype on

" To enable automatic indentation and plugins
filetype plugin indent on

" To use incremental search
set incsearch

" To use hidden buffers (no dialog on unwritten
" modified buffers, for example doing :n)
set hidden

" Smarter case sensitivity: if lowercase, ignore case; if uppercase, become
" case-sensitive.
set smartcase ignorecase

" <C-a> and <C-x> use decimal as a base, not octal
set nrformats=

" default line length; remove this cause its limiting
"set textwidth=80


"####################
" Included plugins
"
" matchit (enhanced parenthesis, etc. matching)
packadd! matchit

"####################
"####################
" path variable to use with :find
" add with path+=
set path+=.

"####################
"####################
" Tab-completion behaviour
" 
" First time pressing Tab, show a list of all possibilities
" and complete until longest common string. Then, just
" complete with full path.
"
set wildmode=list:longest,full
set nowildmenu
" Tabs as spaces, which also enables indentation with > and <
" 4 spaces, btw
set expandtab shiftwidth=4 softtabstop=4

"####################
"####################
" Shortcuts
"
" Set shortcuts lead key
let mapleader = " " 
" Enable/disable spelling highlighting
nnoremap <leader>s :set spell! 
" Toggle numbering
nnoremap <leader>n :set number! relativenumber! 
" Toggle search highlight
nnoremap <leader>h :set hls!
" Toggle NERDTree (file manager)
nnoremap <leader>d :NERDTreeToggle<CR>
" Text width
nnoremap <leader>t :setlocal textwidth=80

" instant word count of visually selected text
vnoremap <Leader>wc :w !wc -w



"####################
"####################
" MarkDown
"####################
"####################

" All .txt files as markdown
"autocmd BufNewFile,BufRead *.txt set filetype=markdown

" Highlight the line the cursor is on
"autocmd FileType markdown set cursorline

" Hide and format markdown elements like **bold**
autocmd FileType markdown set conceallevel=2

" Gives Vim access to a broader range of colours
set termguicolors

" working gx command
let g:netrw_browsex_viewer = "setsid xdg-open"


"####################
"####################
" vim-plug plugin manager setup
"
" Requires git for downloading plugins

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Directory for plugins
call plug#begin('~/.vim/myplugins')
" Add plugins

" file tree inside vim, NERDtree
Plug 'scrooloose/nerdtree'

" Better syntax highlighting and many more shits
" for markdown files
"Plug 'godlygeek/tabular'
"Plug 'plasticboy/vim-markdown'

" more focus when writing
"Plug 'junegunn/goyo.vim'


" Initialize plugin system
call plug#end()


"####################
"####################
" Command mode mappings
"
" %% to expand as %;h in command mode
" (active file directory)
"
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

"####################
"####################
" Insert mode mappings
"
" escape with jk from insert mode
inoremap jk <Esc>
inoremap JK <Esc>
" ;; to replace any conveniently-placed <++> chunk
inoremap <buffer> ;; <Esc>/<++><CR>4s
