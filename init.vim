call plug#begin()
Plug 'mileszs/ack.vim'
Plug 'fatih/vim-go', { 'tag': 'v1.26', 'do': ':GoUpdateBinaries' }
Plug 'preservim/nerdtree'
Plug 'github/copilot.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'nvim-lualine/lualine.nvim'
" If you want to have icons in your statusline choose one of these
Plug 'kyazdani42/nvim-web-devicons'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'ntpeters/vim-better-whitespace'
Plug 'airblade/vim-gitgutter'
Plug 'wellle/context.vim'
call plug#end()

set expandtab
set shiftwidth=4
set tabstop=4
set smarttab

set updatetime=100

let mapleader = ','

inoremap kj <ESC>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :call Quit()<CR>
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

" This is an fzf.vim command to search open buffers
nnoremap <leader>b :Buffers<CR>

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

" Open terminal
nnoremap <leader>t :call OpenTerminalInSplit()<CR>

" If terminal exists, open it in a new split
function! OpenTerminalInSplit()
    if TerminalExists()
        execute "botright vsplit | b term"
    else
        execute "botright vsplit | terminal"
    endif
endfunction

" Check if there is an open terminal buffer
function! TerminalExists()
    let l:term = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") ==# "terminal"')
    return !empty(l:term)
endfunction

" Toggle off highlighting
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

set norelativenumber
set number
set scrolloff=30

let g:ackprg = 'ag --nogroup --nocolor --column'
nnoremap <leader><leader> :Rg<space>

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

" lualine configuration
lua << EOF
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', {'diff', colored = true}},
    lualine_c = {{'filename', file_status = true, path = 1, shorting_target = 40, symbols = {modified = '', readonly = ''}}},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {{'filename', file_status = true, path = 1, shorting_target = 40, symbols = {modified = '', readonly = ''}}},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
EOF

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

function! Quit()
    " if buffer is vimrc, wipe buffer
    if expand('%') == '~/.config/nvim/init.vim'
        execute 'bwipeout'
    else
        execute 'quit'
    endif
endfunction
