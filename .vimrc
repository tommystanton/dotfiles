set exrc " XXX For Vroom::Vroom (see perldoc)

set timeoutlen=250      " If a command is entered that partially-matches
                        " another command, don't wait too long
set nofoldenable        " Turn off folding initially (can close all
                        " folds, if  desired, via zM)
set background=dark     " My terminals have black backgrounds
set nocompatible        " Set this first
set modeline            " Allows vim commmands to be placed at top/bottom the file
set hidden              " Allow change of buffer when multiple files loaded and modified
set scrolloff=2         " Always keep some lines below/above the cursor visible
set laststatus=2        " Always show the status line
set wildmenu            " Enhanced command line completion
set wildmode=list:longest,full " Show list of completions
                               " and complete as much as possible,
                               " then iterate full completions

set history=500         " I want more history
set report=0            " Always report line changes for : commands
set showmode            " Shows which mode you're in
set showcmd             " Show command I'm typing
set showmatch           " Shows matching brace/paren, whatever when pair is completed
set listchars=eol:$,tab:>-,extends:>,precedes:<

" edit settings
set expandtab           " See also tabstops, shiftwidth below
set backspace=indent,eol,start  " Enable full backspacing in insert mode

" swap file settings
set updatecount=90      " Update swap file after this many keystrokes
set directory^=~/.vim_swp

"" TODO This is less burdensome if /var/tmp/tstanton/ exists
"" backup file settings
"set backup              " Keep a backup of edited files (filename~)
"set backupcopy=auto     " yes=rename-old+create-new, no=overwrite, auto=yes-if-safe
"" Put the backup into ./.backup subdirectory if there is one (usually not)
"" Else put the backup into the users own temp directory, else . else /tmp
"set backupdir=./.backup,/var/tmp/$LOGNAME,/tmp,.
"" Skip all the above backup cleverness when editing files matching these:
"set backupskip+=/var/tmp/*

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.ind,.idx,.out,.toc,.class

" enable viminfo, but ensure each user has a separate file
set viminfo='50,\"1000,%

" include argv status, filetype, and char-under-cursor in status line
set statusline=%<%f\ %h%m%r%a%=%y\ 0x%B\ %l,%c%V\ %P

set nomore      " don't page long listings (as we have scroll bars)
set title       " put filename etc in window title
set titleold=   " restore to empty string if can't restore old title


" XXX There can't be comments trailing these commands, and the trailing
" control character  (via CTRL-V CTRL-M) is necessary.
" Find the next markup, ie. '# TODO', '//XXX', or '" FIXME'
map ,ma /[#/"]\s*[A-Z]\{3,4\}\>
" Find the version control merge conflict lines (ie. "<<<<<<< HEAD")
" (Hmm, the backslashes before pipes needed to be escaped here...)
map ,me /^\(<\\|=\\|>\)\{3,\}

" On a line, wrap barewords in single quotes
map ,q' :s/\S\+/'\0',/g
" ...in double quotes
map ,q" :s/\S\+/"\0",/g

" Set inv<option> inverts an option.
" Toggle between paste and nopaste and print the status
map ,p :set invpaste paste?
" Toggle wrapping
map ,w :set invwrap wrap?
" Toggle EOL markers
map ,l :set invlist list?
" Toggle line numbers
map ,n :set invnu nu?
" Toggle spell check
map ,s :set invspell spell?

" Insert a Perl debugger breakpoint above the current line,
" left-justified
map ,b O$DB::single = 1;:leftj

" Insert an empty Data::Dumper::Dumper(), leaving the user in INSERT
" mode ready to type in the variable(s) for manual Perl debugging
map ,d Ouse Data::Dumper qw(Dumper);warn Dumper();:.-,.leftk$/Dumper(\zs\ze)i
" ...or start using Data::Dumper in a one-line style, for Apache logs
map ,da Ouse Data::Dumper qw(Dumper); local $Data::Dumper::Indent = 0;warn Dumper();:.-,.leftk$/Dumper(\zs\ze)i
" Do the same thing as above, but with Test::More's diag()
map ,t Ouse Data::Dumper qw(Dumper);diag Dumper();:.-,.leftk$/Dumper(\zs\ze)i

" Just insert an additional warn Dumper()
map ,dw Owarn Dumper();:leftk$/Dumper(\zs\ze)i
" Just insert an additional diag Dumper()
map ,td Odiag Dumper();:leftk$/Dumper(\zs\ze)i

" Yank from cursor to the end of line
map Y y$

" Turn off search highlighting by default
set nohlsearch
" Toggle search highlighting when desired
map <C-H> :set invhlsearch hlsearch?

" syntax highlight settings
if has("syntax")
    let g:bash_is_sh = 1  " Get syntax right for our .sh files
    syntax enable
endif
" F7: toggle syntax highlighting (with users preferred colors)
map <F7> :if exists("syntax_on") <BAR> syntax off <BAR> else <BAR> syntax enable <BAR> endif<CR>

" GVim options
" White text on a black background
highlight Normal guibg=black guifg=white
" Use a larger font by default
set guifont=Monospace\ 14

" search settings
set ignorecase
set smartcase
set incsearch " While typing a search command, show where the pattern,
              " as it was typed so far, matches

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else                            " if no autocmd support then:
  set autoindent                " set autoindenting on
endif " has("autocmd")

"===== general key mappings =====
"
" use Q for formatting (not ex mode), ie Q} reformats the paragraph
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Indent/outdent current block...
" ... not including surrounding braces
map ,b> $>i}``
map ,b< $<i}``
" ... including surrounding braces
map ,B> $>a}``
map ,B< $<a}``

"=====[ Utility commands ]===============================

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                  \ | wincmd p | diffthis
endif


"=====[ Add or subtract comments ]===============================

function! ToggleComment ()
    let currline = getline(".")
    " FIXME Doesn't consider tabs
    if currline =~ '^\s*#'
        s/#//
    " TODO Nothing should be done on an empty line
    " TODO Somehow ignore toggling existing comments?
    else
        s/\(\s*\)\(.*\)/\1#\2/
    endif
endfunction

map <silent> # :call ToggleComment()<CR>j0


"===== visual mode settings =====

" Square up visual selections
set virtualedit=block

" Make BS/DEL work as expected in visual modes
vmap <BS> x


"===== set file types =====
"
" Teach vim that .t files are perl files (ie tests)
au BufRead,BufNewFile *.t   set filetype=perl
au BufRead,BufNewFile *.plx set filetype=perl
au BufRead,BufNewFile *.json set filetype=javascript


set autoindent

"set cindent
"" Tim Bunce--
"" smartindent is off by default and, I believe, isn't needed because the
"" 'filetype plugin indent on' line in vimrc enables per-filetype indent
"" behaviour.
"set smartindent
""Make smartindent also indent lines starting with #
"inoremap # X#

set tabstop=8
set softtabstop=4 "4 spaces for a tab
set shiftwidth=4 " How much to indent/outdent by
set shiftround " Indent/outdent (via <,>) to nearest shiftwidth
set secure
set textwidth=72 " Use the traditional textwidth
set number " Show line numbers
set list " Draw little $'s to show where lines end...now I can see EVERYTHING!
set wrap! " Turn off word wrap
set lbr " Have the word-wrapping NOT split up sequential characters
set ruler " Show the line and column number of the cursor position
syntax enable
syn on
let perl_fold=1
let ruby_fold=1
"nmap <C-j> :bnext<CR>:redraw<CR>:ls<CR>
"nmap <C-k> :bprevious<CR>:redraw<CR>:ls<CR>

set fo=tcql "format options - kept the defaults but got rid of 't', 'o' and 'r' were for automatic comment leaders
"set tw=70 "set so that comments automatically break after 60 horizonital

" == Abbreviations ==
" Create a :tabv, for viewing (not editing) in a new tab
" (from http://vim.wikia.com/wiki/Using_tab_pages)
cabbrev tabv tab sview +setlocal\ nomodifiable

" == Git ==
" Diff the current file
map ,gd :!git diff %
" View commits associated with the current file
map ,gl :!git log -p %
" Commit the current file (all changes!)
map ,gc :!git commit %

" == Subversion ==
" Diff the current file (and view it in another instance of Vim)
map ,sd :!svn diff % \| vim -R -c 'set syntax=diff' -
" Revert the current file
map ,sr :!svn revert %
" Commit the current file
map ,sc :!svn commit %

" == Perforce ==
" Diff the current file
map ,pd :!p4 diff -du % \| vim -R -c 'set syntax=diff' -
" Open the current file for edit
map ,pe :!p4 edit %
" Revert the current file
map ,pr :!p4 revert %
" Submit the current file
map ,ps :!p4 submit %

" perl(1): check the syntax of the current file
map ,pc :!perl -Ilib -c %
" podchecker(1): check the syntax of the current file
map ,pp :!podchecker %
" perldoc(1): view POD of the current file
map ,pdf :!perldoc -F %

" perltidy selected lines (or entire buffer)
nnoremap <silent> ,pt :%!perltidy -q<Enter>
vnoremap <silent> ,pt :!perltidy -q<Enter>

" Like perltidy, but for JSON (only tidies entire buffer)
nnoremap <silent> ,jt :%!perl -MJSON::PP -e 'local $/; binmode STDIN; $_ = <STDIN>; syswrite STDOUT, JSON::PP->new->pretty(1)->indent_length(2)->encode(JSON::PP->new->decode($_));'<Enter>
