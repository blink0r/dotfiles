"__     ___           ____   ____
"\ \   / (_)_ __ ___ |  _ \ / ___|
" \ \ / /| | '_ ` _ \| |_) | |
"  \ V / | | | | | | |  _ <| |___
"   \_/  |_|_| |_| |_|_| \_\\____|
"

inoremap <F1> <Esc>:w<Enter>
nnoremap <F5> :call <SID>compile_and_run()<CR>
nnoremap <F6> :call asyncrun#quickfix_toggle(8)<cr>
autocmd FileType python nnoremap <F7> :0,$!yapf<CR>
nnoremap <F1> :set im<Enter>
inoremap <C-k> <C-o>gk
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-j> <C-o>gj
nnoremap Q <nop>

" Make basic movements work better with wrapped lines
nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k

"Make backspace delete in normal
nnoremap <BS>    <BS>x
xnoremap <BS> x

syntax on
set nocompatible              " required
filetype off                  " required
set number
set wildmode=longest,list,full
set splitbelow splitright
set encoding=utf-8
set fileencoding=utf-8
set backspace=2
set ruler
set noerrorbells
set ignorecase
set smartcase
set showmode
set hlsearch

" Deletes all trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Run xrdb when Xresources is updated
autocmd BufWritePost ~/.Xresources !xrdb %

" Run i3-msg reload when i3 config is updated
autocmd BufWritePost ~/.config/i3/config !i3-msg reload

" Automagically resize splits when the host is resized
autocmd VimResized * wincmd =

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugins
Plugin 'gmarik/Vundle.vim'
Plugin 'w0rp/ale'
Plugin 'skywind3000/asyncrun.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'ajh17/VimCompletesMe'
Plugin 'junegunn/goyo.vim'
"Plugin 'junegunn/limelight.vim'
"Plugin 'davidhalter/jedi-vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Quick run via <F5>
function! s:compile_and_run()
    exec 'w'
    if &filetype == 'c'
        exec "AsyncRun! gcc % -o %<; time ./%<"
    elseif &filetype == 'cpp'
       exec "AsyncRun! g++ -std=c++11 % -o %<; time ./%<"
    elseif &filetype == 'java'
       exec "AsyncRun! javac %; time java %<"
    elseif &filetype == 'sh'
       exec "AsyncRun! time bash %"
    elseif &filetype == 'python'
       exec "AsyncRun! time python %"
    endif
endfunction

" asyncrun now has an option for opening quickfix automatically
let g:asyncrun_open = 15

" Change Linecolor
highlight LineNr ctermfg=166 guifg=#d75f00
