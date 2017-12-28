" 文件编码
set fileencodings=utf-8

" 显示行号
set number

" 语法高亮
syntax on

" 不要备份配置
set nobackup

" 鼠标可用
set mouse=a

" 智能（弱智）制表
set smarttab


" ========== Indentation ==========
" 定义一个 tab 对应多少个 space
set shiftwidth=4

" 没看懂，必须保证与上面一样
set tabstop=4

" 用于 C 中出现 { 时被激活自动对齐上一行
set smartindent

" 自动对齐上一行
set autoindent

" 超过一行后保持 Indentation, 参见 :help breakindent
set breakindent

" 断词 Indentation，参见 https://stackoverflow.com/questions/2828174/word-wrap-in-vim-preserving-indentation
:set formatoptions=l
:set lbr

" ============================


" ========== 配色方案 ==========
colorscheme solarized
let g:solarized_termcolors=256
" light or dark
set background=dark


" 行列定位光标，参见 https://www.jianshu.com/p/b8763c23ea64
set cursorcolumn
set cursorline
" 配置定位行列颜色
" highlight CursorLine   cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE
" highlight CursorColumn cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE
" ============================


" 文件自动检测外部更改
set autoread

" 右下角显示光标位置
set ruler
" 不要闪烁
set novisualbell


" ========== Vim-Plug (不是 Vundle) ==========
call plug#begin('~/.vim/plugged')

Plug 'Raimondi/delimitMate'
Plug 'Shougo/neocomplete.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/goyo.vim'
" Plug 'vim-latex/vim-latex'
" Plug 'xuhdev/vim-latex-live-preview'
" Plug 'lervag/vimtex'

Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons' 		" 必要图标
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'


Plug 'vim-airline/vim-airline'		" require `powerline`，由 yaourt 安装
Plug 'vim-airline/vim-airline-themes'


" Snip-Mate require `vim-addon-mw-utils` and `tlib_vim`
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
" 下载安装并修改别人维护的 Snippet 规则 (内含，如 C, python, tex 的各种 snippet)
Plug 'honza/vim-snippets'

call plug#end()

" ============================



" ========== 插件配置 ==================
" vim-latex-live-preview
" let g:livepreview_engine = 'xelatex'
" let g:livepreview_previewer = 'evince'
" let g:vimtex_enable = 1


" 开启 vim 自动打开 Nerdtree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Nerdtree 快捷键
map <C-n> :NERDTreeToggle<CR>
map <F3> :NERDTreeToggle<CR>
" 当 window 仅余 nerdtree 时关闭 vim
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Arrow Style
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'


" Airline
" require "powerfont"
let g:airline_theme='ctrlspace'
let g:airline_powerline_fonts = 1
" check buffer
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
set encoding=utf8
set guifont=DroidSansMono\ Nerd\ Font\ 11



" enable folder highlight
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name


" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }




" Limelight
let g:limelight_conceal_ctermfg = 'grey'
let g:limelight_conceal_ctermfg = '240'




" ====================================
" ========== 一键编译 ==================
" ====================================
" 参见 http://blog.chinaunix.net/uid-21202106-id-2406761.html


" Always change the working directory to the dir of file, cf. http://vim.wikia.com/wiki/Get_the_name_of_the_current_file
" %:p is the full path+filename
" %:p:h is the full path
" exec "cd %:p:h"

" ========== 自动工作路径切换 ==========
" Automatically change the current directoryEdit.
" Sometimes it is helpful if your working directory is always the same as the file you are editing. To achieve this, put the following in your vimrc:(cf. http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file)

autocmd BufEnter * silent! lcd %:p:h
" ==================================


" gcc
func! CompileGcc()
    exec "w"
    let compilecmd="!gcc "
    let compileflag="-o %< "
    if search("mpi\.h") != 0
        let compilecmd = "!mpicc "
    endif
    if search("glut\.h") != 0
        let compileflag .= " -lglut -lGLU -lGL "
    endif
    if search("cv\.h") != 0
        let compileflag .= " -lcv -lhighgui -lcvaux "
    endif
    if search("omp\.h") != 0
        let compileflag .= " -fopenmp "
    endif
    if search("math\.h") != 0
        let compileflag .= " -lm "
    endif
    exec compilecmd." % ".compileflag
endfunc

" python
func! RunPython()
        exec "!python %"
endfunc


" LaTeX
func! CompileLaTeX()
	" 编译四次 xelatex, 一次 bib，一次 metapost (用于 Feynman 图)
        exec "!xelatex -synctex=1 -interaction=nonstopmode '%'; !bibtex *.bib; !mpost *.mp; !xelatex -synctex=1 -interaction=nonstopmode '%'; !xelatex -synctex=1 -interaction=nonstopmode '%'"
endfunc


func! CompileCode()
        exec "w"
        if &filetype == "c"
                exec "call CompileGcc()"
        elseif &filetype == "python"
                exec "call RunPython()"
        elseif &filetype == "tex"
                exec "call CompileLaTeX()"
        endif
endfunc


map <F5> :call CompileCode()<CR>
imap <F5> <ESC>:call CompileCode()<CR>
vmap <F5> <ESC>:call CompileCode()<CR>