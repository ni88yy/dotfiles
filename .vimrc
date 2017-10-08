if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin()

" required
Plug 'xolox/vim-misc'
Plug 'xolox/vim-easytags'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'

" presentation stuff
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'baskerville/bubblegum'
Plug 'altercation/vim-colors-solarized'
Plug 'edkolev/tmuxline.vim'

" more stuff
Plug 'Valloric/YouCompleteMe' " http://tilvim.com/2013/08/21/js-autocomplete.html
Plug 'nvie/vim-flake8'
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
set list
set listchars=tab:>-,trail:-

" Dealing with tabs
set tabstop=2     " Number of spaces that a <Tab> in the file counts for.
set shiftwidth=2  " Number of spaces to use for each step of (auto)indent.  Used for |'cindent'|, |>>|, |<<|, etc
set softtabstop=2 " Number of spaces that a <Tab> counts for while performing editing operations, like inserting a <Tab> or using <BS>.
set expandtab     " tabs are spaces
set autoindent    " new lines are indented the same as the previous line
set isk-=.        " add . as word boundary

" #####################################################################
" set behaviours of python
" #####################################################################
" autocmd BufNewFile,BufRead *.py
"     \ setlocal tabstop=4
"     \ setlocal softtabstop=4
"     \ setlocal shiftwidth=4
"     \ setlocal textwidth=80
"     \ setlocal smarttab
"     \ setlocal expandtab

" #####################################################################
" simple maps
" #####################################################################

nnoremap n nzz
nnoremap N Nzz

" toggle hls
nnoremap <leader>h :nohlsearch<CR>

" toggle list hidden chars
nnoremap <leader>l :set list!<CR>:set list?<cr>

" toggle paste
nnoremap <leader>p :set paste!<CR>:set paste?<CR>

" " toggle paste
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
" cnoremap ^     <home>
" cnoremap $     <end>

" " close current window
" nnoremap <leader>k :close<CR>

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

" " ctag locations
" set tags=./.tags,.tags,./tags,tags

nnoremap <leader>q :call QuickfixToggle()<cr>

let g:quickfix_is_open = 0

function! QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
    else
        copen
        let g:quickfix_is_open = 1
    endif
endfunction

" #####################################################################
" Turn on colors
" #####################################################################
let python_hightlight_all=1

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
" hidden characters
" #####################################################################
" highlight ExtraWhitespace ctermbg=gray guibg=gray
" match ExtraWhitespace /\s\+$\|\t/


" #####################################################################
" NERDTree
" #####################################################################
" autocmd vimenter * NERDTree

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
" ctrl-p
" #####################################################################
" let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPBuffer'
" let g:ctrlp_custom_ignore = {
"             \ 'dir':  '\v[\/](\.git|\.hg|\.svn|target|www)$',
"             \ 'file' : '\v\.(class)$',
"             \}

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


" " #####################################################################
" " YouCompleteMe
" " #####################################################################
" " make YCM compatible with UltiSnips (using supertab)
" let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:ycm_autoclose_preview_window_after_completion=1



" #####################################################################
" flake8
" #####################################################################
" autocmd FileType python map <buffer> <F3> :call Flake8()<CR>
autocmd BufWritePost *.py call Flake8()
" autocmd BufNewFile,BufRead *.py call Flake8()
let g:flake8_show_in_gutter=0  " show
let g:flake8_show_in_file=0  " show

" flake8_error_marker='EE'     " set error marker to 'EE'
" flake8_warning_marker='WW'   " set warning marker to 'WW'
" flake8_pyflake_marker=''     " disable PyFlakes warnings
" flake8_complexity_marker=''  " disable McCabe complexity warnings
" flake8_naming_marker=''      " disable naming warnings

highlight link Flake8_Error      Error
highlight link Flake8_Warning    WarningMsg
highlight link Flake8_Complexity WarningMsg
highlight link Flake8_Naming     WarningMsg
highlight link Flake8_PyFlake    WarningMsg
