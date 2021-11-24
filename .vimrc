let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fugitive'
Plug 'mileszs/ack.vim'
call plug#end()

set expandtab
set incsearch

let mapleader = ","

inoremap kj <ESC>
nnoremap <leader>w :w<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>q :q<CR>

" Edit this file
nnoremap <leader>sv :so ~/.vimrc <CR>
nnoremap <leader>ev :e ~/vimrc/.vimrc <CR>

" Split
nnoremap <leader>v :vsp<CR>
nnoremap <leader>V :sp<CR>

" Move between splits
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

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
