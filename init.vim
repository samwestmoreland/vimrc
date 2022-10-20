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

" Go to build file
nnoremap gb :call GoToBuildFile('')<CR>

nnoremap <leader>g :Git 
nnoremap <leader>gp :Git pull<CR>
nnoremap <leader>gr :Git rebase master<CR>
nnoremap <leader>gc :Git checkout 
nnoremap <leader>gm :Git checkout master<CR>

" GoTo code navigation.
nmap <silent> gd :call GoToDefinition()<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

function! GoToDefinition()
    if expand('%:t') == 'BUILD'
        let l:cmd = 'rg -n "def ' . expand('<cword>') . '"'
        let l:output = system(l:cmd)
        " if we found something
        if len(l:output) > 0
            " split the output into lines
            let l:lines = split(l:output, '\n')
            let l:line = l:lines[0]
            let l:parts = split(l:line, ':')
            let l:file = l:parts[0]
            let l:line = l:parts[1]
            execute 'e ' . l:file
            execute l:line
        else
            echo 'No definition found'
        endif
    else
        " otherwise, execute coc go to definition
        call CocAction('jumpDefinition')
    endif
endfunction

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
nnoremap <leader>t :call OpenTerminalInSplit('vertical')<CR>
nnoremap <leader>T :call OpenTerminalInSplit('horizontal')<CR>

" If terminal exists, open it in a new split
function! OpenTerminalInSplit(orientation)
    if TerminalExists()
        if a:orientation == 'vertical'
            execute "botright vsplit | b term"
            set nonumber
        elseif a:orientation == 'horizontal'
            execute "botright split | b term"
            set nonumber
        else
            echo "Invalid orientation"
        endif
    else
        if a:orientation == 'vertical'
            execute "botright vsplit | term"
            set nonumber
        elseif a:orientation == 'horizontal'
            execute "botright split | term"
            set nonumber
        else
            echo "Invalid orientation"
        endif
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

function! GoToBuildFile(build_label)
    let l:line = ''
    if a:build_label is ''
        let l:line = getline('.')
    else
        let l:line = a:build_label
    endif
    " match regex on current line
    let l:match = matchlist(l:line, '\/\/[A-z0-9\/_]\+:[A-z0-9_#]\+')
    if len(l:match) > 0
        let l:build_file = substitute(l:match[0], '//', '', '')
        " get the target name
        let l:target = substitute(l:build_file, '.*:', '', '')
        let l:target = StripTagFromInternalTarget(l:target)
        let l:build_file = substitute(l:build_file, ':.*', '/BUILD', '')
        " find line number of target in build file
        let l:line_number = system('grep -n name.\*' . l:target . ' ' . l:build_file . ' | cut -d: -f1 | head -n1')
        execute 'edit ' . l:build_file
        " if line number is not empty, go to line number
        if len(l:line_number) > 0
            echo 'found target on line ' . l:line_number
            " strip newline from line number
            let l:line_number = substitute(l:line_number, '\n', '', '')
            execute 'normal ' . l:line_number . 'G'
        else
            echo 'Could not find target in build file'
        endif
    else
        " check for build labels of the form //foo/bar
        let l:match = matchlist(l:line, '\/\/[A-z0-9\/_]\+')
        if len(l:match) > 0
            " get the last part of the build label
            let l:target = substitute(l:match[0], '.*\/', '', '')
            return GoToBuildFile(l:match[0] . ':' . l:target)
        echo 'No build label found'
        endif
    endif
endfunction

" Check if build label is internal target
function! IsInternalTarget(target)
    " If target begins with underscore and contains a hash
    if match(a:target, '^_.*#') > -1
        return 1
    endif
    return 0
endfunction

" Strip tag from internal target
function! StripTagFromInternalTarget(target)
    " If target begins with underscore and contains a hash
    if IsInternalTarget(a:target)
        " Strip tag from target
        let l:target = substitute(a:target, '_', '', '')
        let l:target = substitute(l:target, '#.*', '', '')
        return l:target
    endif
    return a:target
endfunction
