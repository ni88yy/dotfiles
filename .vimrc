if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin()
Plug 'Shougo/neocomplcache.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'baskerville/bubblegum'
Plug 'bling/vim-airline'
Plug 'derekwyatt/vim-scala'
Plug 'kien/ctrlp.vim'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'edkolev/tmuxline.vim'
call plug#end()

" #####################################################################
" set behaviours of vim
" #####################################################################
let mapleader=','
let maplocalleader=',,'
set cursorline     " highlights the current line
set number         " always show line numbers
set relativenumber
set nowrap         " turn off the line wrapping
set noswf          " turn off swap files for now, it gets annoying when continuous compilation compiles swap files
set hls            " turn on search highlighting
set statusline=%f%=%{fugitive#statusline()}\ %l/%L "set the status line
set background=light
set title         " change the terminal's title
set wildmenu      " turn on enhanced auto complete
set hidden        " put modified buffers in background
set noswf         " turn off swap files for now, it gets annoying when continuous compilation compiles swap files

" Dealing with tabs
set tabstop=4     " Number of spaces that a <Tab> in the file counts for.
set shiftwidth=4  " Number of spaces to use for each step of (auto)indent.  Used for |'cindent'|, |>>|, |<<|, etc
set softtabstop=4 " Number of spaces that a <Tab> counts for while performing editing operations, like inserting a <Tab> or using <BS>.
set expandtab     " tabs are spaces
set autoindent    " new lines are indented the same as the previous line

set isk-=.        " add . as word boundary

" #####################################################################
" simple maps
" #####################################################################
"
" toggle hls
nnoremap <leader>h :nohlsearch<CR>

" toggle list hidden chars
nnoremap <leader>l :set list!<CR>:set list?<cr>

" toggle paste
nnoremap <leader>p :set paste!<CR>:set paste?<CR>

" toggle paste
nnoremap <leader>w :set wrap!<CR>:set wrap?<CR>

" add better pane navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" add better command mode navigation
cnoremap <c-h> <left>
cnoremap <c-j> <down>
cnoremap <c-k> <up>
cnoremap <c-l> <right>
cnoremap ^     <home>
cnoremap $     <end>

" close current window
nnoremap <leader>k :close<CR>

" split
noremap <leader>vs :vsp<cr><c-^><c-w>p
noremap <leader>sp :rightbelow vsplit #<cr>

" set up a line text object
vnoremap il :<c-u>silent! normal! ^v$g_<cr>

" Quickly edit/source the vimrc file
nnoremap <leader>ec :e $MYVIMRC<CR>
nnoremap <silent> <leader>so :w<CR>:so ~/.vimrc<CR>:echom ".vimrc saved and sourced"<CR>

" Maps Alt-[h,j,k,l] to resizing a window split
if bufwinnr(1)
  nnoremap ∆ <C-W>-
  nnoremap ˚ <C-W>+
  nnoremap ¬ <C-W><
  nnoremap ˙ <C-W>>
endif

" search current highlight
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR> 
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch()
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g') 
    let @s = temp
endfunction

" toggle number
nnoremap <leader>n :call <SID>SetNumber()<CR>
vnoremap <leader>n :<c-u>call <SID>SetNumber()<CR>

function! s:SetNumber()
    if !&number && !&relativenumber
        let &number = 1
        let &relativenumber = 1
        echo "relativenumber number"
    elseif &number && &relativenumber
        let &number = 1
        let &relativenumber = 0
        echo "number"
    else
        let &number = 0
        let &relativenumber = 0
        echo "nonumber"
    endif
endfunction

" ctag locations
set tags=./.tags,.tags,./tags,tags

" #####################################################################
" Turn on colors
" #####################################################################
syntax on

colorscheme solarized

" toggle bacground between dark and light
nnoremap <leader>b :call ToggleBackground()<cr>

function! ToggleBackground()
    if(&background==#"dark")
        set background=light
    else
        set background=dark
    endif
endfunction


" #####################################################################
" NERDTree
" #####################################################################
autocmd vimenter * NERDTree

let NERDTreeWinPos="left"
let NERDTreeWinSize=36
let NERDTreeIgnore=['target[[dir]]']
let NERDTreeShowHidden=0

" set up some nerd tree bindings
nnoremap <leader>tt :NERDTreeToggle<cr>
nnoremap <leader>to :NERDTree<cr>
nnoremap <leader>tc :NERDTreeClose<cr>
nnoremap <leader>tf :NERDTreeFind<cr>

" close nerdtree and vim on close file
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" #####################################################################
" airline (powerline)
" #####################################################################
let g:airline_theme='bubblegum'


" #####################################################################
" make better cursor shapes
" #####################################################################
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif


" #####################################################################
" Neocomplcache
" #####################################################################
let g:neocomplcache_enable_at_startup = 1

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"


" #####################################################################
" ctrl-p
" #####################################################################
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/](\.git|\.hg|\.svn|target|www)$',
            \ 'file' : '\v\.(class)$',
            \}

let g:ctrlp_working_path_mode = 'rc'


" #####################################################################
" tmuxline
" #####################################################################
let g:tmuxline_separators = {
    \ 'left' : '',
    \ 'left_alt': '>',
    \ 'right' : '',
    \ 'right_alt' : '<',
    \ 'space' : ' '}

