""
" Lightline_theme: stagnant


" Author: tar80
" License: MIT
""

let s:p = {"normal": {}, "inactive": {}, "insert": {}, "replace": {}, "visual": {}, "tabline": {} }

let s:p.normal.left = [[["#002222", 234], ["#4F6B75", 242]], [["#72D69E", 79], ["#3A5258", 239]]]
let s:p.normal.middle = [[["#708A90", 66], ["#3A5258", 239]]]
let s:p.normal.right = [[["#708A90", 66], ["#3A5258", 239]], [["#708A90", 66], ["#3A5258", 239]]]
let s:p.normal.error = [[["#252A2C", 235], ["#926161", 95]]]
let s:p.normal.warning = [[["#252A2C", 235], ["#926161", 95]]]

let s:p.inactive.left = [[["#4F6B75", 242], ["#344B4E", 239]], [["#4F6B75", 242], ["#344B4E", 239]]]
let s:p.inactive.middle = [[["#4F6B75", 242], ["#344B4E", 239]]]
let s:p.inactive.right = [[["#4F6B75", 242], ["#344B4E", 239]], [["#4F6B75", 242], ["#344B4E", 239]]]

let s:p.insert.left = [[["#002222", 234], ["#59FEF9", 87]], [["#72D69E", 79], ["#3A5258", 239]]]
let s:p.insert.middle = [[["#708A90", 66], ["#3A5258", 239]]]
let s:p.insert.right = [[["#708A90", 66], ["#3A5258", 239]], [["#708A90", 66], ["#3A5258", 239]]]

let s:p.replace.left = [[["#002222", 234], ["#FE817C", 210]], [["#72D69E", 79], ["#3A5258", 239]]]
let s:p.replace.middle = [[["#708A90", 66], ["#3A5258", 239]]]
let s:p.replace.right = [[["#708A90", 66], ["#3A5258", 239]], [["#708A90", 66], ["#3A5258", 239]]]

let s:p.visual.left = [[["#002222", 234], ["#C188F6", 141]], [["#72D69E", 79], ["#3A5258", 239]]]
let s:p.visual.middle = [[["#708A90", 66], ["#3A5258", 239]]]
let s:p.visual.right = [[["#708A90", 66], ["#3A5258", 239]], [["#708A90", 66], ["#3A5258", 239]]]

let s:p.tabline.left = [[["#4F6B75", 242], ["#344B4E", 239]]]
let s:p.tabline.tabsel = [[["#599D9D", 73], ["#002222", 234]]]
let s:p.tabline.middle = [[["#4F6B75", 242], ["#344B4E", 239]]]
let s:p.tabline.right = [[["#708A90", 66], ["#344B4E", 239]]]

let g:lightline#colorscheme#stagnant#palette = lightline#colorscheme#flatten(s:p)
