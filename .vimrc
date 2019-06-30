set fileencodings=utf-8					" 编码

set number								" 显示行号
syntax on								" 语法高亮
set nobackup							" 不要备份配置
set mouse=a								" 鼠标可用
set tabstop=4							" 缩进4格
set shiftwidth=4						" 偏移4格
set smarttab							" 智能（弱智）制表
set smartindent							" 智能（弱智）缩进

color ron								" 配色方案
set background=dark						" light or dark

set autoread							" 文件自动检测外部更改
set autoindent							" 自动对齐
set ruler								" 右下角显示光标位置


set novisualbell						" 不要闪烁



" vim-plug
call plug#begin('~/.vim/plugged')

Plug 'Raimondi/delimitMate'
Plug 'Shougo/neocomplete.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/goyo.vim'


call plug#end()

let g:limelight_conceal_ctermfg = 'grey'
let g:limelight_conceal_ctermfg = '240'
