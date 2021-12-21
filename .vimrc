let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'airblade/vim-gitgutter'
" Plug 'tpope/vim-fugitive'

" if has('nvim') || has('patch-8.0.902')
"   Plug 'mhinz/vim-signify'
" else
"   Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
" endif

call plug#end()

set expandtab
set incsearch

set splitbelow
set splitright

set scrolloff=999

let mapleader = ","

inoremap kj <ESC>
nnoremap <leader>w :w<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>q :q<CR>

" Edit vimrc
nnoremap <leader>sv :so ~/.vimrc <CR>
nnoremap <leader>ev :e ~/vimrc/.vimrc <CR>

" Jump to previous buffer
nnoremap <leader>b :b#<CR>

" Leave only this buffer visible
nnoremap <leader>o :only<CR>

" Split
nnoremap <leader>v :vsp<CR>
nnoremap <leader>V :sp<CR>

" Move between splits
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Fuzzy finder
nmap <C-P> :FZF<CR>

" Open nerdtree
nnoremap <C-n> :NERDTree<CR>

" Open terminal
nnoremap <leader>t :ter<CR>

" Set syntax highlighting in build files
au BufReadPost *.build_defs set syntax=python
au BufReadPost *BUILD set syntax=python

" Configure ack
let g:ackprg = 'ag --nogroup --nocolor --column --ignore-dir ChangeLog --ignore-dir docs'
nnoremap <leader><leader> :Ack!<Space>

" For gitgutter
highlight clear SignColumn
autocmd ColorScheme * highlight! link SignColumn LineNr

" vim-go keybindings
nnoremap <leader>cc :GoCallers<CR>
