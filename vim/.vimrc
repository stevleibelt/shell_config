set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set number
set hlsearch
set ignorecase
set ruler
set wildmenu
set spelllang=en_us
map <F2> :retab <CR> :wq! <CR>
syntax enable
set showcmd
set showmode
set t_Co=256
colorscheme zenburn
autocmd FileType php setlocal makeprg=zca\ %<.php
autocmd FileType php setlocal errorformat=%f(line\ %l):\ %m
