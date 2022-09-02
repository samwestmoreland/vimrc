call plug#begin()
Plug 'mileszs/ack.vim'
Plug 'fatih/vim-go', { 'tag': 'v1.26', 'do': ':GoUpdateBinaries' }
Plug 'preservim/nerdtree'
Plug 'github/copilot.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'nvim-lualine/lualine.nvim'
" If you want to have icons in your statusline choose one of these
" Plug 'kyazdani42/nvim-web-devicons'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'ntpeters/vim-better-whitespace'
Plug 'airblade/vim-gitgutter'
call plug#end()

set expandtab
set shiftwidth=4
set tabstop=4
set smarttab

set updatetime=100

let mapleader = ','

inoremap kj <ESC>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" Split navigation
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>

nnoremap <leader>v :vsp<CR>
nnoremap <leader>V :sp<CR>
nnoremap <leader>o :only<CR>

nnoremap <leader>n :cn<CR>
nnoremap <leader>N :cp<CR>

nnoremap <leader>cc :GoCallers<CR>
nnoremap <leader>cr :GoReferrers<CR>

nnoremap <leader>ev :e ~/.config/nvim/init.vim <CR>
nnoremap <leader>sv :so ~/.config/nvim/init.vim <CR>

nnoremap <leader>g :Git 

" Redo
nnoremap U :redo<CR>

" Nerdtree mappings
nnoremap <C-n> :NERDTreeFind<CR>

" CtrlP
nnoremap <C-p> :FZF<CR>

au BufRead,BufNewFile *.build_defs set filetype=python
au BufRead,BufNewFile *.BUILD set filetype=python
au BufRead,BufNewFile *.BUILD_FILE set filetype=python

" Open vim terminal
nnoremap <leader>t :terminal<CR>

" Toggle off highlighting
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

set norelativenumber
set number
set scrolloff=30

let g:ackprg = 'ag --nogroup --nocolor --column'
nnoremap <leader><leader> :Ack!<Space>

" Exit terminal mode
tnoremap <leader><leader> <C-\><C-n>

" Terminal mode navigation
tnoremap <C-w>h <C-\><C-N><C-w>h
tnoremap <C-w>j <C-\><C-N><C-w>j
tnoremap <C-w>k <C-\><C-N><C-w>k
tnoremap <C-w>l <C-\><C-N><C-w>l
tnoremap <C-w><C-h> <C-\><C-N><C-w>h
tnoremap <C-w><C-j> <C-\><C-N><C-w>j
tnoremap <C-w><C-k> <C-\><C-N><C-w>k
tnoremap <C-w><C-l> <C-\><C-N><C-w>l

" vim-go options
let g:go_bin_path = ''
let g:go_fmt_autosave = 1
let g:go_fmt_command = 'gofmt'
let g:go_fmt_options = '-s'
let g:go_imports_autosave = 0
let g:go_mod_fmt_autosave = 0
let g:go_auto_type_info = 1
let g:go_gopls_enabled = 1
let g:go_null_module_warning = 0
let g:go_search_bin_path_first = 0

augroup transparent_signs
  au!
  autocmd ColorScheme * highlight SignColumn guibg=NONE
augroup END

highlight! link SignColumn LineNr
autocmd ColorScheme * highlight! link SignColumn LineNr

function! s:go_guru_scope_from_git_root()
  let gitroot = system("git rev-parse --show-toplevel | tr -d '\n'")
  let pattern = escape(go#util#gopath() . '/src/', '\ /')
  return substitute(gitroot, pattern, '', '') . '/... -vendor/'
endfunction

au FileType go silent exe "GoGuruScope " . s:go_guru_scope_from_git_root()

autocmd FileType .vim, .py, .go, .build_defs EnableStripWhitespaceOnSave
