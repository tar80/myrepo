""
" Lightline_theme: clover


" Author: tar80
" License: MIT
""

let s:p = {"normal": {}, "inactive": {}, "insert": {}, "replace": {}, "visual": {}, "command": {}, "tabline": {} }

let s:p.normal.left = [[["#14231e", 234], ["#6c806f", 243]], [["#fc89b4", 234], ["#4e5f50", 239]]]
let s:p.normal.middle = [[["#6c806f", 243], ["#344137", 237]]]
let s:p.normal.right = [[["#14231e", 234], ["#6c806f", 243]], [["#14231e", 234], ["#6c806f", 243]]]
let s:p.normal.error = [[["#2e1b19", 203], ["#fd5c70", 234]]]
let s:p.normal.warning = [[["#2e1b19", 204], ["#fc6f8d", 234]]]

let s:p.inactive.left = [[["#14231e", 234], ["#4e5f50", 239]], [["#14231e", 234], ["#4e5f50", 239]]]
let s:p.inactive.middle = [[["#6c806f", 243], ["#344137", 237]]]
let s:p.inactive.right = [[["#6c806f", 243], ["#344137", 237]], [["#6c806f", 243], ["#344137", 237]]]

let s:p.insert.left = [[["#092532", 235], ["#81b5c3", 109]], [["#fc89b4", 234], ["#4d7976", 243]]]
let s:p.insert.middle = [[["#81b5c3", 109], ["#3d5446", 238]]]
let s:p.insert.right = [[["#14231e", 234], ["#81b5c3", 109]], [["#14231e", 234], ["#81b5c3", 109]]]

let s:p.replace.left = [[["#2f2518", 235], ["#daba6f", 179]], [["#2e1b19", 234], ["#a69460", 137]]]
let s:p.replace.middle = [[["#daba6f", 179], ["#5d6049", 59]]]
let s:p.replace.right = [[["#14231e", 234], ["#daba6f", 179]], [["#14231e", 234], ["#daba6f", 179]]]

let s:p.visual.left = [[["#141921", 234], ["#a980d1", 140]], [["#fc89b4", 234], ["#77679f", 97]]]
let s:p.visual.middle = [[["#a980d1", 140], ["#464b52", 239]]]
let s:p.visual.right = [[["#14231e", 234], ["#a980d1", 140]], [["#14231e", 234], ["#a980d1", 140]]]

let s:p.command.left = [[["#192c27", 235], ["#9ece6e", 114]], [["#2e1b19", 204], ["#759759", 7]]]
let s:p.command.middle = [[["#9ece6e", 114], ["#4c6244", 65]]]
let s:p.command.right = [[["#192c27", 235], ["#9ece6e", 114]], [["#192c27", 235], ["#9ece6e", 114]]]

let s:p.tabline.left = [[["#4e5f50", 239], ["#0b1611", 233]]]
let s:p.tabline.tabsel = [[["#839a87", 102], ["#192c27", 235]]]
let s:p.tabline.middle = [[["#6c806f", 243], ["#0b1611", 233]]]
let s:p.tabline.right = [[["#6c806f", 243], ["#192c27", 235]]]

let g:lightline#colorscheme#clover#palette = lightline#colorscheme#flatten(s:p)
