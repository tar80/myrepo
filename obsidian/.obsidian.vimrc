" commands
exmap focus_top obcommand editor:focus-top
exmap focus_left obcommand editor:focus-left
exmap focus_right obcommand editor:focus-right
exmap focus_bottom obcommand editor:focus-bottom
exmap back obcommand app:go-back
exmap forward obcommand app:go-forward
exmap next_tab obcommand workspace:next-tab
exmap prev_tab obcommand workspace:previous-tab
exmap q obcommand workspace:close
exmap sp obcommand workspace:split-horizontal
exmap vs obcommand workspace:split-vertical
exmap fold_toggle obcommand editor:toggle-fold
exmap fold_all obcommand editor:fold-all
exmap unfold_all obcommand editor:unfold-all
exmap surround_wiki surround [[ ]]
exmap surround_double_quotes surround " "
exmap surround_single_quotes surround ' '
exmap surround_backticks surround ` `
exmap surround_brackets surround ( )
exmap surround_square_brackets surround [ ]
exmap surround_curly_brackets surround { }
exmap light obcommand theme:use-light
exmap dark obcommand theme:use-dark
" keymaps
unmap <Space>
nmap <Space>h :focus_left
nmap <Space>j :focus_bottom
nmap <Space>k :focus_top
nmap <Space>l :focus_right
nmap <Space>q :q
nmap <Tab> <Nop>
nmap <C-o> :back
nmap <C-i> :forward
nmap gt :next_tab
nmap gT :prev_tab
nmap za :fold_toggle
nmap zM :fold_all
nmap zR :unfold_all
nmap Y y$
nnoremap <C-[> :nohl
nnoremap > >>
nnoremap < <<
imap <C-d> <Del>
imap <C-h> <BS>
imap <C-b> <Left>
imap <C-f> <Right>
vmap ;" :surround_double_quotes
vmap ;' :surround_single_quotes
vmap ;` :surround_backticks
vmap ;( :surround_brackets
vmap ;[ :surround_single_quotes
vmap ;{ : surround_curly_brackets

