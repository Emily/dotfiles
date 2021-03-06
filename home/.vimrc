"" Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
" let g:tsuquyomi_disable_default_mappings = 1
" Leader
let mapleader = ","

set nocompatible  " Use Vim settings, rather then Vi settings
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set hlsearch
set incsearch     " do incremental searching
set ignorecase
set smartcase
set laststatus=2  " Always display the status line
set encoding=utf-8
set scrolloff=3
set hidden " allow switching from unsaved file without saving
set autowrite

if &diff
  set diffopt+=iwhite
endif

" set t_Co=256
set background=dark
colorscheme Tomorrow-Night
set colorcolumn=80
:hi ColorColumn ctermbg=red guibg=red
set cursorline

" Whitespace
set nowrap

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Cucumber navigation commands
  autocmd User Rails Rnavcommand step features/step_definitions -glob=**/* -suffix=_steps.rb
  autocmd User Rails Rnavcommand config config -glob=**/* -suffix=.rb -default=routes

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd BufRead,BufNewFile *.md setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80
augroup END

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab
set backspace=indent,eol,start

" Display extra whitespace
"set list listchars=tab:»·,trail:·
"
" Pressing return clears highlighted search
nnoremap <CR> :nohlsearch<CR>/<BS>

" Numbers
set number
set numberwidth=5

" Snippets are activated by Shift+Tab
let g:snippetsEmu_key = "<S-Tab>"

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
set complete=.,w,t
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>

" Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" Index ctags from any project, including those outside Rails
map <Leader>ct :!ctags -R .<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" vim-rspec mappings
nnoremap <Leader>S :call RunCurrentSpecFile()<CR>
nnoremap <Leader>s :call RunNearestSpec()<CR>
nnoremap <Leader>z :call RunFastSpec()<CR>
nnoremap <Leader>Z :call RunAllSpecs()<CR>

nnoremap <Leader>x :unlet g:tslime<CR>

if filereadable("script/spec")
  let g:rspec_command = "!time bundle exec spec {spec}"
else
  let g:rspec_command = "!time bin/**/rspec {spec}"
end

function! RunFastSpec()
  let g:old_rspec_command = g:rspec_command
  let g:rspec_command = "!time rspec {spec}"
  call RunNearestSpec()
  let g:rspec_command = g:old_rspec_command
endfunction

let g:rspec_command = "call Send_to_Tmux(\"bundle exec rspec {spec}\n\")"

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1

let g:tsuquyomi_disable_quickfix = 1

"" CtrlP
map <leader>t :CtrlP<cr>
map <leader>b :CtrlPBuffer<cr>
let g:ctrlp_working_path_mode=2
set wildignore+=*/*.swp
let g:ctrlp_custom_ignore = '\v[\/]((\.(git|hg|svn))|(vendor/bundle)|(bin/stubs))$'

"" Cleanup ruby files on save
function! GitStripSpace()
  let l:save_cursor = getpos(".")
  silent! %!git stripspace
  call setpos('.', l:save_cursor)
endfunction! GitStripSpace()

autocmd Filetype ruby autocmd BufWritePre * call GitStripSpace()

" Spliting
map <leader>\| :vsp<cr>
map <leader>- :sp<cr>
map <leader>_ :23sp<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Paste current line in github in the buffer
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>o :r! echo `git url`/blob/`git rev-parse --abbrev-ref HEAD`/%\#L<C-R>=line('.')<CR><CR>

" make ctrl+c match esc (visual block mode doesn't like ctrl+c)
map <c-c> <esc>

" enable builtin matchit.vim
runtime macros/matchit.vim

" run current file via ruby
map <leader>, :!ruby %<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Silver Searcher for faster grep and ctrl-p
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" if executable('ag')
"   " Use ag over grep
"   set grepprg=ag\ --nogroup\ --nocolor

"   " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
"   let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

"   " ag is fast enough that CtrlP doesn't need to cache
"   let g:ctrlp_use_caching = 0
"   " bind K to grep word under cursor
"   nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

"   " bind \ (backward slash) to grep shortcut
"   command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
"   nnoremap \ :Ag<SPACE>
" endif
if executable('rg')
  set grepprg=rg\ --color=never\ --no-heading\ --smart-case\ --vimgrep
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob=""'
  let g:ctrlp_use_caching = 0
  command -nargs=+ -complete=file -bar Rg execute ":AsyncRun rg --color=never --no-heading --smart-case --vimgrep \<args>"
  map <leader>\ :AsyncStop<SPACE><CR>
  nnoremap \ :Rg<SPACE>
endif

let g:asyncrun_open = 8

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" KEEP THIS AT THE BOTTOM OF THE FILE
" Local config
"
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif

map <Space><C-]> <Plug>(TsuquyomiReferences)
