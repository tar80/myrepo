-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

-- #Smartinput
-- @template: rule({ at = '', char = '', input = '', mode = '', filetype = '', syntax = '' })

-- #Triggers {{{2
local trigger = vim.fn['smartinput#map_to_trigger']

trigger('i', '<Plug>(smartinput_CR)', '<Enter>', '<Enter>')
trigger('i', '<Plug>(smartinput_C-h)', '<BS>', '<C-h>')
-- trigger("i", "<Plug>(smartinput_SPACE)", "<Space>", "<Space>")
trigger('i', '<Space>', '<Space>', '<C-g>U<Space>')
trigger('i', '<Tab>', '<Tab>', '<Tab>')
trigger('i', '<C-f>', '<C-f>', '<C-f>')
-- trigger("i", ";", ";", ";")
trigger('i', '=', '=', '=')
trigger('i', '.', '.', '.')
trigger('c', '<CR>', '<CR>', '<CR>')
trigger('c', '<Space>', '<Space>', '<Space>')

-- #Rules {{{2
local rule = vim.fn['smartinput#define_rule']

local multi_at = function(at, rulespec)
  for _, value in pairs(at) do
    rulespec['at'] = value
    rule(rulespec)
  end
end

-- Auto completion path
rule({ at = [[\w\+\\\%#$]], char = '<Tab>', input = '<C-g>u<C-x><C-f>' })

-- Replace indent of spaces to tab
rule({ at = '^\\s\\+\\%#$', char = '<Tab>', input = '<C-u><C-v><Tab>' })

-- Leave Tab
rule({ at = '\\%#', char = '<C-f>', input = '<Right>' })
multi_at({ '\\%#[\'`"])', '\\%#[\'`"]}' }, { char = '<C-f>', input = '<C-g>U<Right><Right>' })
-- Leave Semicolon
-- multi_at({ "\\%#['`\"])$", "\\%#['`\"]}$" }, { char = ";", input = "<C-g>U<Right><Right>;" })
-- rule({ at = "\\%#[)}]$", char = ";", input = "<C-g>U<Right>;" })
-- Leave Equal
rule({ at = '\\%#[\'`"]]$', char = '=', input = '<C-g>U<Right><Right><Space>=<Space>' })
rule({ at = '\\%#]$', char = '=', input = '<C-g>U<Right><Space>=<Space>' })

-- ##PPx {{{3
-- ppx -> . -> PPx.
rule({ at = '\\(^\\|\\s\\|(\\)ppx\\%#', char = '.', input = '<BS><BS><BS>PPx.', filetype = { 'lua', 'javascript' } })
-- ppa| -> . -> PPx.Arguments(|);
rule({ at = 'ppa\\%#', char = '.', input = '<C-w>PPx.Arguments', filetype = { 'javascript' } })
-- ppe| -> . -> PPx.Execute(|);
rule({ at = 'ppe\\%#', char = '.', input = '<C-w>PPx.Execute()<Left>', filetype = { 'javascript' } })
-- ppt| -> . -> PPx.Extract(|);
rule({ at = 'ppt\\%#', char = '.', input = '<C-w>PPx.Extract()<Left>', filetype = { 'javascript' } })
-- uue| -> . -> util.xecute(|);
rule({ at = 'uue\\%#', char = '.', input = '<C-w>util.execute()<Left>', filetype = { 'javascript' } })
-- uut| -> . -> util.xtract(|);
rule({ at = 'uut\\%#', char = '.', input = '<C-w>util.extract()<Left>', filetype = { 'javascript' } })
-- ppq| -> . -> PPx.Quit(|1);
rule({ at = 'ppq\\%#', char = '.', input = '<C-w>PPx.Quit(1);<Left><Left><Left>', filetype = { 'javascript' } })
-- ppw| -> . -> PPx.Echo(|);
rule({ at = 'ppw\\%#', char = '.', input = '<C-w>PPx.Echo();<Left><Left>', filetype = { 'javascript' } })

-- ##Lua {{{3
-- ^| @ -> <Space> -> ---@
rule({ at = '^\\s*@\\%#$', char = '<Space>', input = '<BS>---@', filetype = { 'lua' } })
rule({ at = '^\\s*--\\[\\%#\\]$', char = '[', input = '[<Del><CR>--<Space><CR>--]]<Home><Left>', filetype = { 'lua' } })
-- pp -> . -> vim.print(|)
rule({ at = 'pp\\%#', char = '.', input = '<BS><BS>vim.print()<Left>', filetype = { 'lua' } })
-- va -> . -> vim.api.nvim_|
rule({ at = 'va\\%#', char = '.', input = '<BS><BS>vim.api.nvim_', filetype = { 'lua' } })

-- ##Folding {{{3
rule({ at = '\\s"{{\\%#"', char = '{', input = '{2<Del>', mode = 'i', filetype = { 'vim', 'lua' } })
rule({ at = '\\S{{\\%#}}', char = '{', input = '<BS><BS><Space>{{{<Del><Del>', filetype = { 'vim', 'lua' } })
rule({ at = '\\s{{\\%#}}', char = '{', input = '{<Del><Del>', filetype = { 'vim', 'lua' } })

-- ##Bracket {{{3
local bracketList = { { '(', ')' }, { '{', '}' }, { '[', ']' } }

for _, v in ipairs(bracketList) do
  -- Behavior when there are letters behind
  rule({ at = '\\%#\\()\\|}\\|]\\|\\s\\|$\\)\\@!', char = v[1], input = v[1] })
  -- Input bracket without Leave-Block
  rule({ at = '\\%#\\n\\s*', char = v[2], input = v[2] })
end

-- Individualized responses
--  (|) -> <Space> -> ( | )
multi_at(
  { '(\\s*\\%#\\s*)', '{\\s*\\%#\\s*}', '\\[\\s*\\%#\\s*]' },
  { char = '<Space>', input = '<Space><Space><Left>' }
)
-- ( | ) -> <BS> -> (|)
multi_at({ '(\\s*\\%#\\s*)', '{\\s*\\%#\\s*}', '\\[\\s*\\%#\\s*]' }, { char = '<BS>', input = '<BS><Del>' })

-- ##Quote {{{3
local quoteList = { '"', '`', "'" }

for _, quote in ipairs(quoteList) do
  multi_at(
    { '\\s\\%#\\(\\s\\|$\\)', '(\\%#)', '{\\%#}', '\\[\\%#]' },
    { char = quote, input = quote .. quote .. '<left>' }
  )
  rule({ at = '\\%#', char = quote, input = quote })
end
--}}}2

-- ##Cmdline abbrev
-- Credit:https://scrapbox.io/vim-jp/lexima.vim%E3%81%A7Better_vim-altercmd%E3%82%92%E5%86%8D%E7%8F%BE%E3%81%99%E3%82%8B
vim.api.nvim_create_user_command('SmartinputAbbrev', function(param) -- {{{2
  local reply = vim.fn.split(param.args)
  local input_space = '<C-w>' .. reply[2] .. '<Space>'
  local input_cr = '<C-w>' .. reply[2] .. '<CR>'
  local exp = { mode = ':', at = "^\\(''<,''>\\)\\?" .. reply[1] .. '\\%#' }
  rule(vim.fn.extend(exp, { char = '<Space>', input = input_space }))
  rule(vim.fn.extend(exp, { char = '<CR>', input = input_cr }))
end, { nargs = 1 }) --}}}2

vim.cmd([[
SmartinputAbbrev eu8 e<Space>++enc=utf-8<CR>
SmartinputAbbrev eu16 e<Space>++enc=utf-16le<CR>
SmartinputAbbrev gs lua<Space>require('config.gits')<CR>
SmartinputAbbrev sc set<Space>scb<Space><Bar><Space>wincmd<Space>p<Space><Bar><Space>set<Space>scb<CR>
SmartinputAbbrev scn set<Space>noscb<CR>
SmartinputAbbrev del call<Space>delete(expand('%'))
SmartinputAbbrev cs execute<Space>'50vsplit'g:repo.'\\myrepo\\nvim\\.cheatsheet'<CR>
SmartinputAbbrev dd diffthis<Bar>wincmd<Space>p<Bar>diffthis<Bar>wincmd<Space>p<CR>
SmartinputAbbrev dof syntax<Space>enable<Bar>diffoff<CR>
SmartinputAbbrev dor vert<Space>bel<Space>new<Space>difforg<Bar>set<Space>bt=nofile<Bar>r<Space>++edit<Space>#<Bar>0d_<Bar>windo<Space>diffthis<Bar>wincmd<Space>p<CR>
SmartinputAbbrev ht so<Space>$VIMRUNTIME/syntax/hitest.vim
SmartinputAbbrev ct so<Space>$VIMRUNTIME/syntax/colortest.vim
SmartinputAbbrev hl lua<Space>print(require("module.util").hl_at_cursor())<CR>
]])
