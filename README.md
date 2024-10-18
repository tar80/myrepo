# myrepo

alacritty/

- `%appdata%/alactirry`にsymlink
- `~/.config/alacritty/`に`alacritty-theme`をclone

bash/

gitbashはgitコマンドの補完とステータス類の取得関数を読み込んでいるが
重くなるだけで大して使えないので読み込まないようにする

- `~/`に`bash_profile`, `.bashrc`をsymlink
- `~/.config/git/`に`git-prompt.sh`をsymlink

everything/

- `%scoop%/persist/everything`にsymlink
- .gitignoreでeverything.dbを除外

images/

keypirinha/

- 対象ファイルにsymlink

migemo/

- 対象ディレクトリにsymlink

mpv/

- `%appdata%/mpv`にsymlink

nodejs/

- 削除予定

nvim/

- `~/.config/nvim/`に`after`, `lua`, `init.lua`をsymlink

nyagos/

- `~/.config/.nyagos`にsymlink

obsidian/

- `vault/`に`.obsidian.vimrc`をsymlink
- `vault/obsidian/`に各アイテムをsymlink

ppx/

- `ppx/`に`ifextend.cfg`をsymlink
- 他は削除予定

pwsh/

- `defender.ps1`はリアルテイム保護とかwindowsアップデートの自動起動抑止スクリプト
- 多分使わないけど保守

qutebrowser/

- `%appdata%/qutebrowser/config`にsymlink

vim/

- 使っていない
- gvimは使わざるを得ない場合があるのでgvim用軽量プロファイルを作成予定

wezterm/

- `~/.config/wezterm`にsymlink

wt/

- 多分使わないけど保守
