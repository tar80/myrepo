set autochdir
set diffopt+=iwhite
set browsedir=buffer
"@ keep a backup after overwriting a file
set nobackup
"@ use a swap file for this buffer
set noswapfile
"@ automatically save and restore undo history
set noundofile
"@ list of directories for undo files
set undodir=$HOME/.cache/undolog
"@ how many command lines are remembered
set history=100
"@ width of ambiguous width characters
set ambiwidth=single
"@ show match for partly typed search command
set incsearch
"@ highlight all matches for the last used search pattern
set hlsearch
"@ use the 'g' flag for ":substitute"
set gdefault
"@ ignore case when using a search pattern
set ignorecase
"@ override 'ignorecase' when pattern has upper case characters
" set smartcase
"@ list of flags that tell how automatic formatting works
set formatoptions=mMjql
"@ list of flags specifying which commands wrap to another line
set whichwrap=<,>,[,],h,l
"@ search commands wrap around the end of the buffer
set nowrapscan
"@ number of screen lines to show around the cursor
set scrolloff=1
"@ wrap long lines at a character in breakat
set linebreak
"@ preserve indentation in wrapped text
set breakindent
"@ string to put before wrapped screen lines
set showbreak=>>
"@ minimal number of columns to scroll horizontally
set sidescroll=6
"@ minimal number of columns to keep left and right of the cursor
set sidescrolloff=3
"@ don't redraw while executing macros
set lazyredraw
"@ ring the bell for error messages
set noerrorbells
"@ use a visual bell instead of beeping
set visualbell t_vb=
"@ do not ring the bell for these reasons
" set belloff=all
"@ show <Tab> as ^I and end-of-line as $
set list
"@ start a dialog when a command fails
set confirm
"@ include lastline to show the last line even if it doesn't fit
set display=lastline
"@ display the current mode in the status line
set noshowmode
"@ when to use a tab pages line
set showtabline=2
"@ when to use a status line for the last window
set laststatus=2
"@ number of lines used for the command-line
set cmdheight=2
"@ show the line number for each line
set number
"@ number of columns to use for the line number
set numberwidth=4
"@ show the relative line number for each line
set relativenumber
"@ show cursor position below each window
set ruler
"@ specifies what <BS>, CTRL-W, etc. can do in Insert mode
set backspace=indent,eol,start
"@ specifies how Insert mode completion works for CTRL-N and CTRL-P
set complete=.,w
"@ whether to use a popup menu for Insert mode completion
set completeopt=menuone,noselect
"@ maximum height of the popup menu
set pumheight=10
"@ when inserting a bracket, briefly jump to its match
set showmatch
"@ tenth of a second to show a match for 'showmatch'
set matchtime=2
"@ list of pairs that match for the "%" command
set matchpairs+=【:】,[:],<:>
"@  number formats recognized for CTRL-A and CTRL-X commands
set nrformats-=octal
"@ number of spaces a <Tab> in the text stands for
set tabstop<
"@ number of spaces used for each step of (auto)indent
set shiftwidth=2
"@ a <Tab> in an indent inserts 'shiftwidth' spaces
set smarttab
"@ if non-zero, number of spaces to insert for a <Tab>
set softtabstop=2
"@ round to 'shiftwidth' for "<<" and ">>"
set shiftround
"@ expand <Tab> to spaces in Insert mode
set expandtab
"@ automatically set the indent of a new line
set autoindent
"@ wildmode      specifies how command line completion works
set wildmode=longest:full,full
"@ command-line completion shows a list of matches
set wildmenu
"@ Display all the information of the tag by the supplement of the Insert mode.
set showfulltag
"@ when to use virtual editing: "block", "insert", "all" and/or "onemore"
set virtualedit=block
"@ list of strings used for list mode
set listchars=tab:\|\ ,extends:<,precedes:>,trail:_,
"@ list of accepted languages
set spelllang+=cjk
"@ list of flags to make messages shorter
set shortmess=filnrxtToOcs
"@ list of preferred languages for finding help
set helplang=ja

"$$ important {{{1

"@ cpoptions     list of flags to specify Vi compatibility
" set cpo=aABceFs_
"@ insertmode    use Insert mode as the default mode
" set noinsermode
"@ paste paste mode, insert typed text literally
" set nopaste
"@ pastetoggle   key sequence to toggle paste mode
" set pastetoggle=
"@ startofline   many jump commands move the cursor to the first non-blank
" set startofline
"@ paragraphs    nroff macro names that separate paragraphs
" set paragraphs=IPLPPPQPP\ TPHPLIPpLpItpplpipbp
"@ sections      nroff macro names that separate sections
" set sections=SHNHH\ HUnhsh
"@ path  list of directory names used for file searching
" set path=.,,
"@ cdpath        list of directory names used for :cd
" set cdpath=,,
"@ magic change the way backslashes are used in search patterns
        " set magic     nomagic
"@ regexpengine  select the default regexp engine used
        " set re=-1
"@ casemap       what method to use for changing case of letters
        " set cmp=internal,keepascii
"@ maxmempattern maximum amount of memory in Kbyte used for pattern matching
        " set mmp=999
"@ define        pattern for a macro definition line
        " (global or local to buffer)
        " set def=^\\s*#\\s*define
"@ include       pattern for an include-file line
        " (local to buffer)
        " set inc=^\\s*#\\s*include
"@ includeexpr   expression used to transform an include line to a file name
        " (local to buffer)
        " set inex=

"$$ tags {{{1

"@ tagbsearch    use binary searching in tags files
        " set tbs       notbs
"@ taglength     number of significant characters in a tag name or zero
        " set tl=-1
"@ tags  list of file names to search for tags
        " (global or local to buffer)
        " set tag=./tags;,tags
"@ tagcase       how to handle case when searching in tags files:
        " "followic" to follow 'ignorecase', "ignore" or "match"
        " (global or local to buffer)
        " set tc=followic
"@ tagrelative   file names in a tags file are relative to the tags file
        " set tr        notr
"@ tagstack      a :tag command will use the tagstack
        " set tgst      notgst
"@ showfulltag   when completing tags in Insert mode show more info
        " set nosft     sft
"@ tagfunc       a function to be used to perform tag searches
        " (local to buffer)
        " set tfu=
"@ cscopeprg     command for executing cscope
        " set csprg=cscope
"@ cscopetag     use cscope for tag commands
        " set nocst     cst
"@ cscopetagorder        -1 or 1; the order in which ":cstag" performs a search
        " set csto=-1
"@ cscopeverbose give messages when adding a cscope database
        " set csverb    nocsverb
"@ cscopepathcomp        how many components of the path to show
        " set cspc=-1
"@ cscopequickfix        when to open a quickfix window for cscope
        " set csqf=
"@ cscoperelative        file names in a cscope file are relative to that file
        " set nocsre    csre

"$$ displaying text {{{1

"@ scroll        number of lines to scroll for CTRL-U and CTRL-D
        " (local to window)
        " set scr=7
"@ wrap  long lines wrap
        " (local to window)
        " set wrap      nowrap
"@ wrap long lines at a character in 'breakat'
        " (local to window)
"@ breakindentopt        adjust breakindent behaviour
        " (local to window)
        " set briopt=
"@ breakat       which characters might cause a line break
        " set brk=\ \   !@*-+;:,./?
"@ conceallevel  controls whether concealable text is hidden
        " (local to window)
        " set cole=-1
"@ concealcursor modes in which text in the cursor line can be concealed
        " (local to window)
        " set cocu=

"$$ syntax, highlighting and spelling {{{1

"@ synmaxcol     maximum column to look for syntax items
        " (local to buffer)
        " set smc=2999
"@ fillchars     characters to use for the status line, folds and filler lines
        " set fcs=
"@ cursorcolumn  highlight the screen column of the cursor
        " (local to window)
        " set nocuc     cuc
"@ cursorline    highlight the screen line of the cursor
        " (local to window)
        " set nocul     cul
"@ cursorlineopt specifies which area 'cursorline' highlights
        " (local to window)
        " set culopt=both
"@ colorcolumn   columns to highlight
        " (local to window)
        " set cc=
"@ spell highlight spelling mistakes
        " (local to window)
        " set nospell   spell
"@ spellfile     file that "zg" adds good words to
        " (local to buffer)
        " set spf=
"@ spellcapcheck pattern to locate the end of a sentence
        " (local to buffer)
        " set spc=[.?!]\\_[\\])'\"\     \ ]\\+
"@ spelloptions  flags to change how spell checking works
        " (local to buffer)
        " set spo=
"@ spellsuggest  methods used to suggest corrections
        " set sps=best
"@ mkspellmem    amount of memory used by :mkspell before compressing
        " set msm=459999,2000,500

"$$ multiple windows {{{1

"@ equalalways   make all windows the same size when adding/removing windows
        " set ea        noea
"@ eadirection   in which direction 'equalalways' works: "ver", "hor" or "both"
        " set ead=both
"@ winheight     minimal number of lines used for the current window
        " set wh=0
"@ winminheight  minimal number of lines used for any window
        " set wmh=0
"@ winfixheight  keep the height of the window
        " (local to window)
        " set nowfh     wfh
"@ winfixwidth   keep the width of the window
        " (local to window)
        " set nowfw     wfw
"@ winwidth      minimal number of columns used for the current window
        " set wiw=19
"@ winminwidth   minimal number of columns used for any window
        " set wmw=0
"@ helpheight    initial height of the help window
        " set hh=19
"@ previewheight default height for the preview window
        " set pvh=11
"@ hidden        don't unload a buffer when no longer shown in a window
        " set hid       nohid
"@ switchbuf     "useopen" and/or "split"; which window to use when jumping
        " to a buffer
        " set swb=uselast
"@ splitbelow    a new window is put below the current one
        " set nosb      sb
"@ splitright    a new window is put right of the current one
        " set nospr     spr
"@ scrollopt     "ver", "hor" and/or "jump"; list of options for 'scrollbind'
        " set sbo=ver,jump

"$$ multiple tab pages {{{1

"@ tabpagemax    maximum number of tab pages to open for -p and "tab all"
        " set tpm=49

"$$ terminal {{{1

"@ scrolljump    minimal number of lines to scroll at a time
        " set sj=0
"@ guicursor     specifies what the cursor looks like in different modes
        " set gcr=n-v-c-sm:block,i-ci-ve:ver24,r-cr-o:hor20
"@ title show info in the window title
        " set notitle   title
"@ titlelen      percentage of 'columns' used for the window title
        " set titlelen=84
"@ titlestring   when not empty, string to be used for the window title
        " set titlestring=
"@ titleold      string to restore the title to when exiting Vim
        " set titleold=
"@ icon  set the text of the icon for this window
        " set noicon    icon
"@ iconstring    when not empty, text for the icon of this window
        " set iconstring=

"$$ mouse {{{1

"@ mouse list of flags for using the mouse
        " set mouse=
"@ mousemodel    "extend", "popup" or "popup_setpos"; what the right
        " mouse button is used for
        " set mousem=extend
"@ mousetime     maximum time in msec to recognize a double-click
        " set mouset=499

"$$ printing {{{1

"@ printoptions  list of items that control the format of :hardcopy output
        " set popt=
"@ printdevice   name of the printer to be used for :hardcopy
        " set pdev=
"@ printexpr     expression used to print the PostScript file for :hardcopy
        " set pexpr=
"@ printfont     name of the font to be used for :hardcopy
        " set pfn=courier
"@ printheader   format of the header used for :hardcopy
        " set pheader=%<%f%h%m%=Page\ %N
"@ printencoding encoding used to print the PostScript file for :hardcopy
        " set penc=
"@ printmbcharset        the CJK character set to be used for CJK output from :hardcopy
        " set pmbcs=
"@ printmbfont   list of font names to be used for CJK output from :hardcopy
        " set pmbfn=

"$$ messages and info {{{1

"@ terse add 's' flag in 'shortmess' (don't show search message)
        " set noterse   terse
"@ showcmd       show (partial) command keys in the status line
        " set sc        nosc
"@ rulerformat   alternate format to be used for the ruler
        " set ruf=
"@ report        threshold for reporting number of changed lines
        " set report=1
"@ verbose       the higher the more messages are given
        " set vbs=-1
"@ verbosefile   file to write messages in
        " set vfile=
"@ more  pause listings when the screen is full
        " set more      nomore

"$$ selecting text {{{1

"@ selection     "old", "inclusive" or "exclusive"; how selecting text behaves
        " set sel=inclusive
"@ selectmode    "mouse", "key" and/or "cmd"; when to start Select mode
        " instead of Visual mode
        " set slm=
"@ clipboard     "unnamed" to use the * register like unnamed register
        " "autoselect" to always put selected text on the clipboard
        " set cb=
"@ keymodel      "startsel" and/or "stopsel"; what special keys can do
        " set km=

"$$ editing text {{{1

"@ undolevels    maximum number of changes that can be undone
        " (global or local to buffer)
        " set ul=999
"@ undoreload    maximum number lines to save for undo on a buffer reload
        " set ur=9999
"@ textwidth     line length above which to break a line
        " (local to buffer)
        " set tw=-1
"@ wrapmargin    margin from the right in which to break a line
        " (local to buffer)
        " set wm=-1
"@ comments      definition of what comment lines look like
        " (local to buffer)
        " set com=s0:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-
"@ formatlistpat pattern to recognize a numbered list
        " (local to buffer)
        " set flp=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
"@ formatexpr    expression used for "gq" to format lines
        " (local to buffer)
        " set fex=
"@ pumwidth      minimum width of the popup menu
        " set pw=14
"@ completefunc  user defined function for Insert mode completion
        " (local to buffer)
        " set cfu=
"@ omnifunc      function for filetype-specific Insert mode completion
        " (local to buffer)
        " set ofu=
"@ dictionary    list of dictionary files for keyword completion
        " (global or local to buffer)
        " set dict=
"@ thesaurus     list of thesaurus files for keyword completion
        " (global or local to buffer)
        " set tsr=
"@ infercase     adjust case of a keyword completion match
        " (local to buffer)
        " set noinf     inf
"@ digraph       enable entering digraphs with c0 <BS> c2
        " set nodg      dg
"@ tildeop       the "~" command behaves like an operator
        " set notop     top
"@ joinspaces    use two spaces after '.' when joining a line
        " set nojs      js

"$$ tabs and indenting {{{1

"@ vartabstop    list of number of spaces a tab counts for
        " (local to buffer)
        " set vts=
"@ varsofttabstop        list of number of spaces a soft tabsstop counts for
        " (local to buffer)
        " set vsts=
"@ smartindent   do clever autoindenting
        " (local to buffer)
        " set nosi      si
"@ cindent       enable specific indenting for C code
        " (local to buffer)
        " set nocin     cin
"@ cinoptions    options for C-indenting
        " (local to buffer)
        " set cino=
"@ cinkeys       keys that trigger C-indenting in Insert mode
        " (local to buffer)
        " set cink=-1{,0},0),0],:,0#,!^F,o,O,e
"@ cinwords      list of words that cause more C-indent
        " (local to buffer)
        " set cinw=if,else,while,do,for,switch
"@ indentexpr    expression used to obtain the indent of a line
        " (local to buffer)
        " set inde=
"@ indentkeys    keys that trigger indenting with 'indentexpr' in Insert mode
        " (local to buffer)
        " set indk=-1{,0},0),0],:,0#,!^F,o,O,e
"@ copyindent    copy whitespace for indenting from previous line
        " (local to buffer)
        " set noci      ci
"@ preserveindent        preserve kind of whitespace when changing indent
        " (local to buffer)
        " set nopi      pi
"@ lisp  enable lisp mode
        " (local to buffer)
        " set nolisp    lisp
"@ lispwords     words that change how lisp indenting works

"$$ folding {{{1

"@ foldenable    unset to display all folds open
        " (local to window)
        " set fen       nofen
"@ foldlevel     folds with a level higher than this number will be closed
        " (local to window)
        " set fdl=-1
"@ foldlevelstart        value for 'foldlevel' when starting to edit a file
        " set fdls=-2
"@ foldcolumn    width of the column used to indicate folds
        " (local to window)
set foldcolumn=1
"@ foldtext      expression used to display the text of a closed fold
        " (local to window)
        " set fdt=foldtext()
"@ foldclose     set to "all" to close a fold when the cursor leaves it
        " set fcl=
"@ foldopen      specifies for which commands a fold will be opened
        " set fdo=block,hor,mark,percent,quickfix,search,tag,undo
"@ foldminlines  minimum number of screen lines for a fold to be closed
        " (local to window)
        " set fml=0
"@ commentstring template for comments; used to put the marker in
        " set cms=/*%s*/
"@ foldmethod    folding type: "manual", "indent", "expr", "marker",
        " "syntax" or "diff"
        " (local to window)
        " set fdm=manual
"@ foldexpr      expression used when 'foldmethod' is "expr"
        " (local to window)
        " set fde=-1
"@ foldignore    used to ignore lines when 'foldmethod' is "indent"
        " (local to window)
        " set fdi=#
"@ foldmarker    markers used when 'foldmethod' is "marker"
        " (local to window)
        " set fmr={{{,}}}
"@ foldnestmax   maximum fold depth for when 'foldmethod' is "indent" or "syntax"
        " (local to window)
        " set fdn=19

"$$ diff mode {{{1

"@ diffexpr      expression used to obtain a diff file
        " set dex=
"@ patchexpr     expression used to patch a file
        " set pex=

"$$ mapping {{{1

"@ maxmapdepth   maximum depth of mapping
        " set mmd=999
"$$ reading and writing files {{{1

"@ modeline      enable using settings from modelines when reading a file
        " (local to buffer)
        " set ml        noml
"@ modelineexpr  allow setting expression options from a modeline
        " set nomle     mle
"@ modelines     number of lines to check for modelines
        " set mls=4
"@ fixendofline  fixes missing end-of-line at end of text file
        " (local to buffer)
        " set fixeol    nofixeol
"@ bomb  prepend a Byte Order Mark to the file
        " (local to buffer)
        " set nobomb    bomb
"@ writebackup   write a backup file before overwriting a file
        " set wb        nowb
"@ backupskip    patterns that specify for which files a backup is not made
        " set bsk=$AppData\Local\Temp\*
"@ backupcopy    whether to make the backup as a copy or rename the existing file
        " (global or local to buffer)
        " set bkc=auto
"@ backupdir     list of directories to put backup files in
        " set bdir=.,$AppData\\Local\\nvim-data\\backup\\\\
"@ backupext     file name extension for the backup file
        " set bex=~
"@ autowrite     automatically write a file when leaving a modified buffer
        " set noaw      aw
"@ autowriteall  as 'autowrite', but works with more commands
        " set noawa     awa
"@ writeany      always write without asking for confirmation
        " set nowa      wa
"@ autoread      automatically read a file when it was modified outside of Vim
        " (global or local to buffer)
        " set ar        noar
"@ patchmode     keep oldest version of a file; specifies file name extension
        " set pm=
"@ fsync forcibly sync the file to disk after writing it
        " set nofs      fs

"$$ the swap file {{{1

"@ directory     list of directories for the swap file
        " set dir=C:\\Users\\murata\\AppData\\Local\\nvim-data\\swap\\\\

"$$ command line editing {{{1

"@ wildchar      key that triggers command-line expansion
        " set wc=8
"@ wildcharm     like 'wildchar' but can also be used in a mapping
        " set wcm=-1
"@ suffixes      list of file name extensions that have a lower priority
        " set su=.bak,~,.o,.h,.info,.swp,.obj
"@ suffixesadd   list of file name extensions added when searching for a file
        " (local to buffer)
        " set sua=
"@ wildignore    list of patterns to ignore files for file name completion
        " set wig=
"@ fileignorecase        ignore case when using file names
        " set fic       nofic
"@ wildignorecase        ignore case when completing file names
        " set nowic     wic
"@ cedit key used to open the command-line window
        " set cedit=
"@ cmdwinheight  height of the command-line window
        " set cwh=6

"$$ executing external commands {{{1

"@ shellxescape  characters to escape when 'shellxquote' is (
        " set sxe=
"@ shelltemp     use a temp file for shell commands instead of using a pipe
        " set stmp      nostmp
"@ equalprg      program used for "=" command
        " (global or local to buffer)
        " set ep=
"@ formatprg     program used to format lines with "gq" command
        " set fp=
"@ keywordprg    program used for the "K" command
        " set kp=:Man
"@ warn  warn when using a shell command and a buffer has changes
        " set warn      nowarn

"$$ quickfix {{{1

"@ errorfile     name of the file that contains error messages
        " set ef=errors.err
"@ errorformat   list of formats for error messages
        " (global or local to buffer)
        " set efm=%f(%l)\ \\=:\ %t%*\\D%n:\ %m,%*[^\"]\"%f\"%*\\D%l:\ %m,%f(%l)\ \\=:\ %m,%*[^\ ]\ %f\ %l:\ %m,%f:%l:%c:%m,%f(%l):%m,%f:%l:%m,%f\|%l\|\ %m
"@ makeprg       program used for the ":make" command
        " (global or local to buffer)
        " set mp=make
"@ makeef        name of the errorfile for the 'makeprg' command
        " set mef=
"@ grepprg       program used for the ":grep" command
        " (global or local to buffer)
        " set gp=findstr\ /n\ $*\ nul
"@ grepformat    list of formats for output of 'grepprg'
        " set gfm=%f:%l:%m,%f:%l%m,%f\ \ %l%m
"@ makeencoding  encoding of the ":make" and ":grep" output
        " (global or local to buffer)
        " set menc=

"$$ language specific {{{1

"@ isfname       specifies the characters in a file name
        " set isf=@,47-57,/,\\,.,-,_,+,,,#,$,%,{,},[,],:,@-@,!,~,=
"@ isident       specifies the characters in an identifier
        " set isi=@,47-57,_,128-167,224-235
"@ iskeyword     specifies the characters in a keyword
        " (local to buffer)
        " set isk=@,47-57,_,192-255
"@ isprint       specifies printable characters
        " set isp=@,160-255
"@ quoteescape   specifies escape characters in a string
        " (local to buffer)
        " set qe=\\
"@ keymap        name of a keyboard mapping
        " set kmp=
"@ langmap       list of characters that are translated in Normal mode
        " set lmap=
"@ langremap     apply 'langmap' to mapped characters
        " set nolrm     lrm
"@ iminsert      in Insert mode: 0: use :lmap; 2: use IM; 0: neither
        " (local to window)
        " set imi=-1
"@ imsearch      entering a search pattern: 0: use :lmap; 2: use IM; 0: neither
        " (local to window)
        " set ims=-2

"$$ multi-byte characters {{{

"@ charconvert   expression used for character encoding conversion
        " set ccv=
"@ delcombine    delete combining (composing) characters on their own
        " set nodeco    deco
"@ maxcombine    maximum number of combining (composing) characters displayed
        " set mco=5
"@ emoji emoji characters are full width
        " set emo       noemo

"$$ various {{{1

"@ eventignore   list of autocommand events which are to be ignored
        " set ei=
"@ loadplugins   load plugin scripts when starting up
        " set lpl       nolpl
"@ exrc  enable reading .vimrc/.exrc/.gvimrc in the current directory
        " set noex      ex
"@ secure        safer working with script files in the current directory
        " set nosecure  secure
"@ maxfuncdepth  maximum depth of function calls
        " set mfd=99
"@ sessionoptions        list of words that specifies what to put in a session file
        " set ssop=blank,buffers,curdir,folds,help,tabpages,winsize
"@ viewoptions   list of words that specifies what to save for :mkview
        " set vop=folds,cursor,curdir
"@ viewdir       directory where to store files with :mkview
        " set vdir=C:\\Users\\murata\\AppData\\Local\\nvim-data\\view\\\\
"@ bufhidden     what happens with a buffer when it's no longer in a window
        " (local to buffer)
        " set bh=
