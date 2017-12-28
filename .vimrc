" ========== hxd VIM configuration ==========
" Last edit on Dec/28/2017
" ===========================================

set fileencodings=utf-8			" 文件编码
set number				" 显示行号
syntax on				" 语法高亮
set nobackup				" 不要备份配置
set mouse=a				" 鼠标可用
set smarttab				" 智能（弱智）制表


" ========== Indentation ==========
set shiftwidth=4			" 定义一个 tab 对应多少个 space
set tabstop=4				" 没看懂 help，必须保证与上面一样

set smartindent				" 用于 C 中出现 { 时被激活自动对齐上一行
set autoindent				" 自动对齐上一行
set breakindent				" 超过一行后保持 Indentation
					" 参见 :help breakindent
					
:set formatoptions=l			" 断词 Indentation
:set lbr				" 参见 https://stackoverflow.com/questions/2828174/word-wrap-in-vim-preserving-indentation
" ============================


" ========== 配色方案 ==========
colorscheme solarized
let g:solarized_termcolors=256
" light or dark
set background=dark

set cursorcolumn			" 行列光标定位
					" 参见 https://www.jianshu.com/p/b8763c23ea64
set cursorline				" 配置定位行列颜色
" highlight CursorLine   cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE
" highlight CursorColumn cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE
" ============================

set autoread				" 文件自动检测外部更改
set ruler				" 右下角显示光标位置
set novisualbell			" 不要闪烁


" ========== Vim-Plug (不是 Vundle) ==========
call plug#begin('~/.vim/plugged')

Plug 'Raimondi/delimitMate'		" 括号补全
Plug 'Shougo/neocomplete.vim'		" 主字典补全
Plug 'junegunn/limelight.vim'		" 专注模式（没屁用。。）
Plug 'junegunn/goyo.vim'

" 以下 LaTeX 插件没一个中意的。。。
" Plug 'vim-latex/vim-latex'
" Plug 'xuhdev/vim-latex-live-preview'
" Plug 'lervag/vimtex'

Plug 'scrooloose/nerdtree'		" 文件目录
Plug 'ryanoasis/vim-devicons' 		" 依据后缀加图标（并不够用，尤其 LaTeX 的）
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
					" 依后缀文件名高亮


Plug 'vim-airline/vim-airline'		" require `powerline`，由 yaourt 安装
Plug 'vim-airline/vim-airline-themes'	" 状态栏，好看亦堪用


" Snip-Mate require `vim-addon-mw-utils` and `tlib_vim`
Plug 'MarcWeber/vim-addon-mw-utils'	" snipmate 依赖
Plug 'tomtom/tlib_vim'			" snipmate 依赖
Plug 'garbas/vim-snipmate'		" snipmate
Plug 'honza/vim-snippets'		" 别人维护的 Snippet 规则（依个人修改）

call plug#end()
" ===========================================



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
" ============= 一键编译 ===============
" ====================================
" 参见 http://blog.chinaunix.net/uid-21202106-id-2406761.html



" ========== 自动工作路径切换 ==========

" Always change the working directory to the dir of file, cf. http://vim.wikia.com/wiki/Get_the_name_of_the_current_file
" %:p is the full path+filename
" %:p:h is the full path
" exec "cd %:p:h"

" --------- 以上无用 -------

" Automatically change the current directoryEdit.
" Sometimes it is helpful if your working directory is always the same as the file you are editing. To achieve this, put the following in your vimrc:
" 参见 http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file

autocmd BufEnter * silent! lcd %:p:h
" ===================================


" ========== 设置编译脚本（VimScript） ==========
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
        " exec "!xelatex -synctex=1 -interaction=nonstopmode '%'; !bibtex *.bib; !mpost *.mp; !xelatex -synctex=1 -interaction=nonstopmode '%'; !xelatex -synctex=1 -interaction=nonstopmode '%'"
	exec "!xelatex  -synctex=1 -interaction=nonstopmode '%'"
	exec "!bibtex *.bib"
	exec "!mpost *.mp"
	exec "!xelatex  -synctex=1 -interaction=nonstopmode '%'"
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