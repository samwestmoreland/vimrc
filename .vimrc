let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fugitive'
call plug#end()

set expandtab

let mapleader = ","

inoremap kj <ESC>
nnoremap <leader>w :w<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>q :q<CR>

" Edit this file
nnoremap <leader>sv :so ~/.vimrc <CR>
nnoremap <leader>ev :e ~/.vimrc <CR>

" Move between splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Open nerdtree
nnoremap <C-n> :NERDTree<CR>

" Open terminal
nnoremap <leader>t :ter<CR>
