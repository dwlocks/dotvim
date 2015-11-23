" use vimx or gvim -v
set runtimepath+=/usr/share/vim/addons
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()

" Bundle settings
"
" Disable rope (from jedi-vim)
let g:pymode_rope = 0

set mouse=a

if has('gui_running')
    "
else
    set t_Co=16
    let g:solarized_termcolors=16
endif
set background=dark
colorscheme solarized
filetype plugin indent on
syntax on

" help for highly nested languages
autocmd Filetype xml,html,jss,css,xsd,yml set tabstop=2
autocmd Filetype xml,html,jss,css,xsd,yml set shiftwidth=2
autocmd FileType sh setlocal expandtab shiftwidth=4 softtabstop=4

let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax
set modeline
set autoindent
set shiftwidth=4
set softtabstop=4
set tabstop=8
set expandtab
set shiftround
set list
" Show tabs, trailing whitespace, and orphan whitespace
" tab chars: ^k->> ^k-1N (ascii 175, utf-16 8194), trail: ^k-.M (ascii 250)
set listchars=tab:» ,trail:·,nbsp:·
set fo+=tc

set showmode number
set mouse=n

" Statusline building. escape spaces
set laststatus=2
set statusline=%2n\ " buffer number
set statusline+=%.50F " Full path, max of 50chars
set statusline+=%= " other end
set statusline+=%c\  " column number
set statusline+=%m " modified or not.

set hlsearch " highlight search matches, use :noh to stop
set showmatch
source $VIMRUNTIME/macros/matchit.vim

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>
"use jk for escape when inserting
imap jk <Esc>
noremap <Space> 10jzz
noremap <Backspace> 10kzz

"copy
vmap <F7> "+ygv"zy`>
"paste (Shift-F7 to paste after normal cursor, Ctrl-F7 to paste over visual selection)
nmap <F7> "zgP
nmap <S-F7> "zgp
imap <F7> <C-r><C-o>z
vmap <C-F7> "zp`]
cmap <F7> <C-r><C-o>z

"ChangeLog mode stuff:
let g:changelog_spacing_errors=1
let g:changelog_new_date_format = "%d  %u\n\t* %c\n\n"
let g:changelog_username = "Dan Locks <danlocks@gmail.com>"
au BufRead,BufNewFile ChangeLog set noexpandtab

"f2 save and exit.
:map <special> <F2> ZZ
:map! <special> <F2> <Esc>ZZ
"meta movement moving focus of windows
map <Esc>h :wincmd h<CR>
map <Esc>j :wincmd j<CR>
map <Esc>k :wincmd k<CR>
map <Esc>l :wincmd l<CR>
"map <Esc>H :wincmd H<CR>
"map <Esc>J :wincmd J<CR>
"map <Esc>K :wincmd K<CR>
"map <Esc>L :wincmd L<CR>
autocmd BufNewFile,BufRead commit.txt set textwidth=70

"open a new window with the output of the command given
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'vertical botright new ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  echo 'Shell command ' . command . ' executed.'
endfunction
