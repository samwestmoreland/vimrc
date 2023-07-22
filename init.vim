call plug#begin()
" Plug 'mileszs/ack.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'preservim/nerdtree'
Plug 'github/copilot.vim'
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'
Plug 'nvim-lualine/lualine.nvim'
" If you want to have icons in your statusline choose one of these
Plug 'kyazdani42/nvim-web-devicons'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'ntpeters/vim-better-whitespace'
Plug 'airblade/vim-gitgutter'
" Plug 'wellle/context.vim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-lua/plenary.nvim'
Plug 'mfussenegger/nvim-dap'
Plug 'marcuscaisey/please.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'stevearc/dressing.nvim'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'rcarriga/nvim-dap-ui'
Plug 'sharkdp/fd'
call plug#end()

set expandtab
set shiftwidth=4
set tabstop=4
set smarttab
set ignorecase smartcase

set number relativenumber

hi Search cterm=bold ctermfg=white ctermbg=red

set updatetime=100

let mapleader = ','

nnoremap <C-LeftMouse> :echom 'Follow hyperlink'<CR>

inoremap kj <ESC>
nnoremap <leader>w :w<CR>
" call quit and source the vimrc
nnoremap <leader>q :call Quit()<CR> :source $MYVIMRC<CR>
nnoremap <leader>x :x<CR>

" please commands
lua << EOF
vim.keymap.set('n', '<leader>pj', require('please').jump_to_target)
vim.keymap.set('n', '<leader>pb', require('please').build)
vim.keymap.set('n', '<leader>pt', require('please').test)
vim.keymap.set('n', '<leader>pct', function()
require('please').test({ under_cursor = true })
end)
vim.keymap.set('n', '<leader>plt', function()
require('please').test({ list = true })
end)
vim.keymap.set('n', '<leader>pft', function()
require('please').test({ failed = true })
end)
vim.keymap.set('n', '<leader>pr', require('please').run)
vim.keymap.set('n', '<leader>py', require('please').yank)
vim.keymap.set('n', '<leader>pd', require('please').debug)
vim.keymap.set('n', '<leader>pa', require('please').action_history)
vim.keymap.set('n', '<leader>pp', require('please.runners.popup').restore)
EOF

nnoremap <leader>v :vsp<CR>
nnoremap <leader>V :sp<CR>
nnoremap <leader>o :only<CR>

nnoremap <leader>n :cn<CR>
nnoremap <leader>N :cp<CR>

nnoremap <leader>cc :GoCallers<CR>
nnoremap <leader>cr :GoReferrers<CR>

nnoremap <leader>ev :e ~/.config/nvim/init.vim <CR>
nnoremap <leader>sv :so ~/.config/nvim/init.vim <CR>

nnoremap <leader>d :call QueryRevDeps()<CR>

nnoremap <leader>ce :Copilot enable<CR> :redraw<CR>
nnoremap <leader>cd :Copilot disable<CR> :redraw<CR>

nnoremap <leader>a :Silent arc lint %<CR>

nnoremap <leader>hd :GitGutterPreviewHunk<CR>

" Also set the colours for the preview window here
highlight link diffAdded black
highlight link diffRemoved black
highlight link diffChanged black

" This is an fzf.vim command to search open buffers
nnoremap <leader>b :Buffers<CR>

" Build the target under the cursor
nnoremap B :call PleaseAction('build', '')<CR>

" Run the target under the cursor
nnoremap R :call PleaseAction('run', '')<CR>

" Test the target under the cursor
nnoremap R :call PleaseAction('test', '')<CR>

" Query print the target under the cursor
nnoremap Q :call PleaseAction('query print', '')<CR>

" Go to build file
nnoremap gb :call GoToBuildFile('')<CR>

" Get build label under cursor
nnoremap gl :call GetBuildLabelUnderCursor()<CR>

nnoremap <leader>g :Git<space>
nnoremap <leader>do :GitGutterDiffOrig<CR>

" Copy the name of the current file to the clipboard
nnoremap <C-g> :call GetFilename()<CR>

function! GetFilename()
    let l:filename = expand('%')
    " if path ends in BUILD, strip BUILD from path
    if l:filename =~ 'BUILD$'
        let l:filename = substitute(l:filename, '/BUILD$', '', '')
    endif
    let @" = l:filename
    return l:filename
endfunction

" GoTo code navigation.
nmap <silent> gd :call GoToDefinition()<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! GetPleaseRepoRoot()
    " walk up file tree from current directory until we find a .plzconfig
    " file. If we don't find one, return empty string.
    let l:dir = getcwd()
    while l:dir != '/'
        if filereadable(l:dir . '/.plzconfig')
            return l:dir
        endif
        let l:dir = fnamemodify(l:dir, ':h')
    endwhile
    return ''
endfunction

function! GoToDefinition()
    if expand('%:t') == 'BUILD' || expand('%:e') == 'build_defs' || expand('%:e') == 'build_def'
        let l:cmd = 'rg -n "def ' . expand('<cword>') . '\(" -g "*\.build*"'
        let l:output = system(l:cmd)
        " if we found something
        if len(l:output) > 0
            if len(l:output) > 1
                echo "Found more than one definition, using the first one"
            endif
            " split the output into lines
            let l:lines = split(l:output, '\n')
            let l:line = l:lines[0]
            let l:parts = split(l:line, ':')
            let l:file = l:parts[0]
            let l:line = l:parts[1]
            execute 'e ' . l:file
            execute l:line
        else
            call CocAction('jumpDefinition')
        endif
    else
        " otherwise, execute coc go to definition
        echo "we're not in a BUILD or build_def file"
        call CocAction('jumpDefinition')
    endif
endfunction

function! GetBuildLabelUnderCursor()
    " Search backwards from the cursor col + 1 for the double slash that marks the
    " beginning of the build label.
    let l:line = getline('.')
    let l:startcol = col('.') + 2
    let l:slashpos = searchpos('//', 'b', l:line[0:l:startcol])
    echo l:slashpos
    if l:slashpos[1] == 0
        echo 'No build label found'
        return ''
    endif

    " We need to match the following:
    " "//path/to:target"
    " "//path/to:target#rule"
    " "//path/to/to:target#rule"
    " "//path/to/to:_target#rule"
    "
    " But not:
    " "//common/go/fbender/utils/tests/proto:all failed:"
    " "//build/defs/third_party:all)"
    " i.e. make sure we don't match spaces or brackets

    let l:pattern = '\v//[^ ]+:[^ )]+'
    let l:match = matchstr(l:line, l:pattern, l:slashpos[1]-1)
    if l:match == ''
        echo 'No build label found'
        return ''
    endif

    " strip any trailing colons
    let l:match = substitute(l:match, ':$', '', '')
    echo 'Found build label: ' . l:match
    let @" = l:match
    return l:match
endfunction

function! PleaseAction(action, label)
    let l:root = GetPleaseRepoRoot()
    if l:root == ''
        echo 'Not in a Please repo'
        return
    endif
    let l:label = a:label
    if l:label == ''
        let l:label = GetBuildLabelUnderCursor()
    endif
    if l:label == ''
        " execute a plz command here
        echo 'executing plz query whatinputs on this file'
        let l:cmd = 'plz query whatinputs ' . expand('%:p')
        let l:output = system(l:cmd)
        echo 'got result: ' . l:output
        if l:output != ''
            let l:label = l:output
        endif
    endif
    if l:label == ''
        return
    endif
    let l:cmd = 'plz ' . a:action . ' ' . l:label
    echo 'Executing: ' . l:cmd

    " switch to the terminal buffer
    call OpenTerminalInSplit('vertical')

    " go into insert mode
    call feedkeys("i", "n")

    " clear any existing text
    call feedkeys("\<C-u>", "n")

    " send the command to the terminal
    call feedkeys(l:cmd, "n")
endfunction

" If the cursor is over a build target in a BUILD file,
" return the target fields in a dictionary. Otherwise,
" return 0.
function! GetBuildTarget()
    " Check we're in a build file
    if expand('%:t') != 'BUILD'
        return {}
    endif

    let l:start = '^[a-zA-Z0-9_\-]*($'
    let l:end = '^)$'
    let l:field = '^ *[a-zA-Z_]* = .*,$'

    " Dictionary to store the build target attributes
    let l:build_target_fields = {}

    " search up from current line for a line that matches start regex

    " the line number we're starting our search on
    let l:startingline = line('.')

    let l:line = l:startingline
    while l:line > 0
        let l:line_text = getline(l:line)

        if l:line_text =~ '^ *$'
            return {}
        endif

        if l:line_text =~ l:start
            let l:build_target_fields['type'] = substitute(l:line_text, '(', '', '')
            break
        elseif l:line_text =~ l:end && l:line != l:startingline
            return {}
        elseif l:line_text =~ l:field
            let l:parts = split(l:line_text, '=')
            if len(l:parts) == 2
                let l:parts[0] = substitute(l:parts[0], ' ', '', 'g')
                let l:parts[1] = substitute(l:parts[1], ' ', '', 'g')
                let l:build_target_fields[l:parts[0]] = l:parts[1]
            endif
        endif

        let l:line = l:line - 1

        if l:line == 0
            return {}
        endif
    endwhile

    " search down from current line for a line that matches end regex
    let l:line = l:startingline
    while l:line < line('$') + 1
        let l:line_text = getline(l:line)

        if l:line_text =~ '^ *$'
            return {}
        endif

        if l:line_text =~ l:end
            " Construct the build label and add it to the dictionary
            echo "got the current filename as " . GetFilename()
            let l:label = GetFilename() . ':' . l:build_target_fields['name']
            let l:build_target_fields['label'] = l:label
            return l:build_target_fields
        elseif l:line_text =~ l:start
            return {}
        elseif l:line_text =~ l:field
            let l:parts = split(l:line_text, '=')
            if len(l:parts) == 2
                let l:parts[0] = substitute(l:parts[0], ' ', '', 'g')
                let l:parts[1] = substitute(l:parts[1], ' ', '', 'g')
                let l:build_target_fields[l:parts[0]] = l:parts[1]
            endif
        endif

        let l:line = l:line + 1

        if l:line > line('$')
            return {}
        endif
    endwhile

    return {}
endfunction

" For debugging
function! PrintResult()
    let l:build_target_fields = GetBuildTarget()
    echo l:build_target_fields
endfunction

function! QueryRevDeps()
    echo 'Querying reverse dependencies...'
    if expand('%:t') != 'BUILD'
        echo 'Not in a BUILD file'
        return
    endif

    let l:build_target_fields = GetBuildTarget()
    if l:build_target_fields == {}
        echo 'Not on a build target'
        return
    endif

    " get the string between the quotes
    let l:target = substitute(l:build_target_fields['name'], '"', '', 'g')
    let l:target = substitute(l:target, ',$', '', '')

    if l:target == ''
        echo 'No target name found'
        return
    endif

    " construct build label from target
    " get path from repo root to current file
    let l:path = expand('%:p:h')
    let l:repo_root = GetPleaseRepoRoot()
    let l:label = substitute(l:path, l:repo_root, '', '')
    let l:label = '/' . l:label . ':' . l:target

    " query for reverse dependencies
    let l:cmd = 'plz query revdeps ' . l:label
    let l:output = system(l:cmd)

    " print output if it is not empty
    if len(l:output) > 0
        echo l:output
    else
        echo "No reverse dependencies found"
    endif
endfunction

" Redo
nnoremap U :redo<CR>

" Nerdtree mappings
nnoremap <C-n> :call NerdTreeOpen()<CR>

function! NerdTreeOpen()
    " if there is a file open in the current buffer
    if expand('%') != ''
        " open the file in the current buffer in the nerdtree
        execute 'NERDTreeFind'
    else
        " otherwise, open the current directory in the nerdtree
        execute 'NERDTree'
    endif
endfunction

" CtrlP
nnoremap <C-p> :FZF<CR>

au BufRead,BufNewFile *.build_defs set filetype=python
au BufRead,BufNewFile *.build_def set filetype=python
au BufRead,BufNewFile *.BUILD set filetype=python
au BufRead,BufNewFile *.BUILD_FILE set filetype=python

" Open terminal
nnoremap <leader>t :call OpenTerminalInSplit('vertical')<CR>
nnoremap <leader>T :call OpenTerminalInSplit('horizontal')<CR>

" If terminal exists, open it in a new split
function! OpenTerminalInSplit(orientation)
    if TerminalExists()
        " if terminal buffer is already open in a window, move the cursor to that window
        if TerminalBufferIsOpen()
            " get the window number of the terminal buffer
            let l:terminal_window = GetTerminalWindow()
            " move the cursor to the terminal window
            execute l:terminal_window . 'wincmd w'
            execute "normal! a"
        elseif a:orientation == 'vertical'
            execute "botright vsplit | b term"
            set nonumber
            execute "normal! a"
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
            :ToggleWhitespace
            :ToggleWhitespace
            execute "normal! a"
        elseif a:orientation == 'horizontal'
            execute "botright split | term"
            set nonumber
        else
            echo "Invalid orientation"
        endif
    endif
endfunction

function! GetTerminalWindow()
    " get the window number of the terminal buffer
    let l:terminal_window = bufwinnr('term')
    return l:terminal_window
endfunction

function! TerminalBufferIsOpen()
    let l:terminal_buffer_number = bufnr('^term://')
    " check if that buffer number is currently open in a window
    if bufwinnr(l:terminal_buffer_number) != -1
        return 1
    else
        return 0
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
vnoremap <leader><leader> :<C-U>execute "Rg" GetVisualSelectionAndEscape()<CR>

function! GetVisualSelectionAndEscape()
    normal gv"xy
    let l:text = getreg('x')
    let l:text = substitute(l:text, '(', '\\(', '')
    let l:text = substitute(l:text, ')', '\\)', '')
    let l:text = substitute(l:text, '[', '\\[', '')
    let l:text = substitute(l:text, ']', '\\]', '')
    let l:text = substitute(l:text, '{', '\\{', '')
    let l:text = substitute(l:text, '}', '\\}', '')
    let l:text = substitute(l:text, '?', '\\?', '')
    " let l:text = substitute(l:text, '$', '\\\\$', '')
    return l:text
endfunction

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
tnoremap <C-w>= <C-\><C-N><C-w>=a

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
    let l:home = expand('$HOME')

    if expand('%') == l:home . '/.config/nvim/init.vim'
        " get buffer number of current buffer
        let l:buf = bufnr('%')
        " replace buffer with alternate buffer
        execute "b#"
        " wipe buffer with number l:buf
        execute "bwipeout " . l:buf
        echo 'Wiped vimrc buffer'
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
    let l:match = matchlist(l:line, '\/\/[A-z0-9\/_-]\+:[A-z0-9_#-]\+')
    if len(l:match) > 0
        let l:build_file = substitute(l:match[0], '//', '', '')
        " get the target name
        let l:target = substitute(l:build_file, '.*:', '', '')
        let l:target = StripTagFromInternalTarget(l:target)
        let l:build_file = substitute(l:build_file, ':.*', '/BUILD', '')
        " find line number of target in build file
        let l:line_number = system('grep -n name.\*"' . l:target . '\"" ' . l:build_file . ' | cut -d: -f1 | head -n1')
        execute 'edit ' . l:build_file
        " if line number is not empty, go to line number
        if len(l:line_number) > 0
            " strip newline from line number
            let l:line_number = substitute(l:line_number, '\n', '', '')
            execute 'normal ' . l:line_number . 'G'
        else
            echo 'Could not find target in build file'
        endif
    else
        " check for build labels of the form //foo/bar
        let l:match = matchlist(l:line, '\/\/[A-z0-9\/_-]\+')
        if len(l:match) > 0
            " get the last part of the build label
            let l:target = substitute(l:match[0], '.*\/', '', '')
            return GoToBuildFile(l:match[0] . ':' . l:target)
        echo 'No build label found'
        else
            let l:match = matchlist(l:line, ':[A-z0-9\/_-]\+')
            if len(l:match) > 0
                let l:path = expand('%:p:h')
                let l:reporoot = GetPleaseRepoRoot()
                let l:path = substitute(l:path, l:reporoot, '', '')
                let l:target = '/' . l:path . l:match[0]
                return GoToBuildFile(l:target)
            else
                echo 'No build label found'
            endif
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

command! -nargs=1 Silent execute ':silent !'.<q-args> | redraw!
