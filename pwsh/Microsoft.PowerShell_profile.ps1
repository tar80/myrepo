#-----------------------------------------------------
# General
#-----------------------------------------------------

# PowerShell Core7でもConsoleのデフォルトエンコーディングはsjisなので必要
[System.Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
[System.Console]::InputEncoding  = [System.Text.Encoding]::GetEncoding("utf-8")

# git logなどのマルチバイト文字を表示させるため (絵文字含む)
$env:LESSCHARSET = "utf-8"

# For zoxide v0.8.0+
Invoke-Expression (& {
      $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
          (zoxide init --hook $hook powershell | Out-String)
})

# fzf
$env:FZF_DEFAULT_COMMAND='fd -HL -c never --exclude ".git" .'

function _fzf_compgen_path() {
  fd -HL -c never --exclude ".git" . "$1"
}
function _fzf_compgen_dir() {
  fd -HL -c never --type d --exclude ".git" . "$1"
}

$env:FZF_DEFAULT_OPTS = '--reverse --border --height 50% --inline-info
--color=fg:-1,bg:-1,hl:#ffcc00
--color=fg+:#4d84a8,bg+:-1,hl+:#00eaff
--color=info:#aa82fa,prompt:#2cdede,pointer:#6bff26
--color=marker:#c06eff,spinner:#a357ff,header:#a7d1d1'

#-----------------------------------------------------
# Variables
#-----------------------------------------------------

# repository
$myrepo = 'C:\bin\repository\tar80'

#-----------------------------------------------------
# Modules
#-----------------------------------------------------

Import-Module posh-git
Import-Module oh-my-posh

#-----------------------------------------------------
# Alias
#-----------------------------------------------------

Set-Alias nvim ${env:scoop}\apps\neovim\current\bin\nvim.exe

# ppc
# function ppc() { c:\bin\ppx\PPCW.EXE -r }

# scoop
# function s() {
# $t = type $env:home\lists\scoop.txt | fzf | cut -f1 -d' '
# scoop "$t"
# }

# ll
function ll() { lsd -l --group-dirs first --blocks permission --blocks size --blocks date --blocks name $args }

# tree
# function tree() { lsd -d --tree $args }

function cc() { fd -Ht d -c never -E .git -E node_modules | fzf | cd }

function re() { fd -Lt d -c never --full-path . $myrepo | fzf | cd }

function gre() {
    # $rps = rg --no-heading -Lin "$args" . | fzf -e -0 -q "$args " --preview "echo {} | gawk -F: '{ print `$2-2, `$2+2, substr(`$1, 2)}' | xargs sed"
    # $rps = rg --no-heading -Lin "$args" . | fzf -e -0 -q "$args " --preview "echo {} | xargs -I{} sed -r /^"(.*):(\d*):.*/\1 \2/ {}
    $res = rg --no-heading -Lin "$args" . | fzf -e -0 -q "$args " | gawk -F: '{ print $1, $2-1}'
    $arr_res = $res -split (' ')
    if ( $null -ne $arr_res[1] ) {
      if ( '' -ne $args ) {
        nvim $arr_res[0] -c $arr_res[1] -c /$args
      } else {
        nvim $arr_res[0]
      }
    }
}

# git

function ga() {
  $sel = git diff --name-status $args | sed 's/\t/  /' | fzf --preview "echo {} | sed -r 's/..\s*(.*)../\1/' | xargs git diff --color=always $args -- " --height 90%
  # if ( $null -ne $sel ) {
    #   if ( '' -ne $args ) {
    #     echo $sel
    #   }
    # }
}

#-----------------------------------------------------
# Powerline
#-----------------------------------------------------

Set-Theme Powerlevel10k-Lean

# Prompt
$ThemeSettings.Colors.DriveForegroundColor = "cyan"

# Git
$ThemeSettings.GitSymbols.LocalStagedStatusSymbol = " "
$ThemeSettings.GitSymbols.LocalWorkingStatusSymbol = " "
$ThemeSettings.GitSymbols.BeforeWorkingSymbol = [char]::ConvertFromUtf32(0xe708)+" "
$ThemeSettings.GitSymbols.DelimSymbol = [char]::ConvertFromUtf32(0xf040)+" "
$ThemeSettings.GitSymbols.BranchSymbol = [char]::ConvertFromUtf32(0xf126)+" "
$ThemeSettings.GitSymbols.BranchAheadStatusSymbol = [char]::ConvertFromUtf32(0xf0ee)+" "
$ThemeSettings.GitSymbols.BranchBehindStatusSymbol = [char]::ConvertFromUtf32(0xf0ed)+" "
$ThemeSettings.GitSymbols.BeforeIndexSymbol = [char]::ConvertFromUtf32(0xf6b7)+" "
$ThemeSettings.GitSymbols.BranchIdenticalStatusToSymbol = " "
$ThemeSettings.GitSymbols.BranchUntrackedSymbol = [char]::ConvertFromUtf32(0xf663)+" "

#-----------------------------------------------------
# PSReadLine
#-----------------------------------------------------

Set-PSReadlineOption -BellStyle None

Set-PSReadLineOption -EditMode Emacs

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

Set-PSReadLineKeyHandler -Key Ctrl+Insert -Function Copy

# 履歴から除外
Set-PSReadlineOption -AddToHistoryHandler {
  param ($command)
    switch -regex ($command) {
      "SKIPHISTORY" {return $false}
      "^[a-z]{1,3}$" {return $false}
      "exit" {return $false}
    }
  return $true
}

# 再読み込み
Set-PSReadLineKeyHandler -Key "F5" -BriefDescription "reloadPROFILE" -LongDescription "reloadPROFILE" -ScriptBlock {
  [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('<#SKIPHISTORY#> . $PROFILE')
      [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

