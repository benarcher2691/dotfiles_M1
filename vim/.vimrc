" Basic settings
set nocompatible              " Use Vim defaults (not Vi)
set backspace=indent,eol,start " Allow backspacing over everything
set history=1000              " Keep 1000 lines of command history
set ruler                     " Show cursor position
set showcmd                   " Show incomplete commands
set incsearch                 " Incremental search
set hlsearch                  " Highlight search results
set ignorecase                " Case insensitive search
set smartcase                 " Case sensitive if uppercase is used
set autoindent                " Auto indent new lines
set smartindent               " Smart indentation
set number                    " Show line numbers
set relativenumber            " Show relative line numbers
set cursorline                " Highlight current line
set wildmenu                  " Command completion menu
set wildmode=longest:full,full " Command completion behavior
set laststatus=2              " Always show status line
set encoding=utf-8            " Use UTF-8 encoding
set scrolloff=5               " Keep 3 lines visible above/below cursor
set sidescrolloff=5           " Keep 5 columns visible left/right of cursor
" set clipboard=unnamedplus

" Indentation
set tabstop=2                 " Tab width
set shiftwidth=2              " Indent width
set softtabstop=2             " Soft tab width
set expandtab                 " Use spaces instead of tabs
set shiftround                " Round indent to multiple of shiftwidth

" Display
set wrap                      " Wrap long lines
set linebreak                 " Break lines at word boundaries
set showbreak=↪\              " Show line breaks
set list                      " Show invisible characters
set listchars=tab:→\ ,trail:·,extends:>,precedes:<,nbsp:+

" Files and backups
set autoread                  " Auto-reload changed files
set noswapfile                " Disable swap files
set nobackup                  " Disable backup files
set undofile                  " Enable persistent undo
set undodir=~/.vim/undodir    " Undo directory

" Performance
set lazyredraw                " Don't redraw during macros
set synmaxcol=300             " Syntax highlight only first 300 columns
set updatetime=300            " Faster completion

" Visual
syntax enable                 " Enable syntax highlighting
set background=dark           " Dark background
colorscheme desert            " Use desert colorscheme
set t_Co=256                  " 256 colors
set termguicolors             " True color support

" Key mappings
let mapleader = " "           " Set leader key to space

" Clear search highlighting
" nnoremap <leader>h :nohlsearch<CR>
nnoremap <Esc> :nohlsearch<CR>

" Quick save and quit
" nnoremap <leader>w :w<CR>
" nnoremap <leader>q :q<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move lines up/down (Option+j/k on macOS Swedish keyboard)
nnoremap √ :m .+1<CR>==
nnoremap ª :m .-2<CR>==
vnoremap √ :m '>+1<CR>gv=gv
vnoremap ª :m '<-2<CR>gv=gv

" Better indentation in visual mode
vnoremap < <gv
vnoremap > >gv

" Toggle paste mode
set pastetoggle=<F2>

" File type specific settings
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType javascript,html,css,json setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType go setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab

" Create undo directory if it doesn't exist
if !isdirectory($HOME."/.vim/undodir")
    call mkdir($HOME."/.vim/undodir", "p")
endif

" Auto-save when losing focus
" autocmd FocusLost * :wa

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

function! GitBranch()
  let l:branch = system('git rev-parse --abbrev-ref HEAD 2>/dev/null')
  return strlen(l:branch) ? substitute(l:branch, '\n', '', '') : ''
endfunction

" Status line
set statusline=%f       " File name
set statusline+=\ [%{GitBranch()}] "Git branch"
set statusline+=%m      " Modified flag
set statusline+=%r      " Read only flag
set statusline+=%h      " Help buffer flag
set statusline+=%w      " Preview window flag
set statusline+=%=      " Left/right separator
set statusline+=%c,     " Cursor column
set statusline+=%l/%L   " Cursor line/total lines
set statusline+=\ %P    " Percent through file

"augroup ForceClipboard
"  autocmd!
"  autocmd VimEnter * set clipboard=unnamedplus
"augroup END

