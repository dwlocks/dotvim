" use vimx or gvim -v
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()

set mouse=a

colorscheme fnaqevan
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
set showmatch
source $VIMRUNTIME/macros/matchit.vim

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>
"use jk for escape when inserting
:imap jk <Esc>
:noremap <Space> 10jzz
:noremap <Backspace> 10kzz
"Put in my name when I type mee, cmd or insert mode.
:map mee Dan Locks <dwlocks at zmanda dot com>
:imap mee Dan Locks <dwlocks at zmanda dot com>
:map Mee Dan Locks <dwlocks@zmanda.com>
:imap Mee Dan Locks <dwlocks@zmanda.com>
"Commit entry macro
:map <special> <F7> :0r!~/Scripts/commit_log.sh<CR>
:map! <special> <F7> <Esc> :0r!~/Scripts/commit_log.sh<CR>
"Spec %changelog entry
:map <special> <F8> O* <Esc>:r!date +\%a\ \%b\ \%d\ \%Y<CR>kJ$a mee 3.2.0alpha<CR>- 
:map! <special> <F8>* <Esc>:r!date +\%a\ \%b\ \%d\ \%Y<CR>kJ$a mee 3.2.0alpha<CR>- 
"ChangeLog entry. firstlines
:map <special> <F9> :0r!~/Scripts/change_log.sh<CR>
:map! <special> <F9> <Esc> :0r!~/Scripts/change_log.sh<CR>
"ChangeLog mode stuff:
let g:changelog_spacing_errors=1
let g:changelog_new_date_format = "%d  %u\n\t* %c\n\n"
let g:changelog_username = "Dan Locks <dwlocks@zmanda.com>"
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
