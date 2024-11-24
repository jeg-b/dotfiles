filetype plugin on
syntax on
filetype indent on
set number
set relativenumber
set clipboard=unnamedplus
set smarttab
set autoindent
set smartindent
set incsearch
set hlsearch
set ttimeout
set ttimeoutlen=1
set listchars=tab:>-,trail:~,extends:>,precedes:<,space:.
set ttyfast
" ### change cursor in isert and normal mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
noremap <F3> :Autoformat<CR>
