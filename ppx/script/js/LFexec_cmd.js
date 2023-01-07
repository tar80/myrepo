//!*script
/**
 * LFexecを実行するコマンドリスト
 *
 * PPx.Arguments(
 *  0: 実行するコマンド名
 * )
 *
 * ・コマンド毎にオブジェクトcmd[]内に記述する
 *  ・returnより前の部分は初回のみ実行される
 *  ・return以降に以下の引数が使用できる
 *     path        = ファイルパス(リストファイル上のエントリ)
 *     shortname   = ショートネーム(リストファイル上のエントリ)
 *     number      = 行数(shotrnameに設定された数値※cmdGrep.js用)
 *     duplicate   = 真偽値(重複パス実行)
 *     search_word = 検索語
 * ・git grepの検索結果にはコマンド名に'_commit'を付加したコマンドが適用される
 *    例えばgit grepに対してcmd['editor']を実行すると、実際にはcmd['editor_commit']の内容が実行される
 */

if (!PPx.Arguments.length) {
  PPx.Quit(-1);
}

var cmd = {};
var result = function () {
  PPx.Result = cmd[PPx.Arguments(0)];
};

cmd['gvim'] = function () {
  PPx.Execute('%Oix *focus #%*findwindowclass("vim"),%g\'gvim\'');
  return function (path, shortname, number, duplicate, search_word) {
    PPx.Execute(
      '%Obd gvim --remote-send "<Cmd>tabe ' + path + '|' + number + '-1 /' + search_word + '/<CR>"'
    );
  };
};

// git grepに対して適用される
// git grepの'search_word'は'commit_hash@@@search_word'として出力される(commit_hashは7桁)ので
// search_word.split('@@@')のように分割して利用できる
cmd['gvim_commit'] = function () {
  PPx.Execute('%Oix *focus #%*findwindowclass("vim"),%\'gvim\'');
  var root =
    PPx.Extract('%si"repoRoot"') ||
    PPx.Extract("%*script(%'scr'%\\module\\repoStat.js)").split(',')[0];
  return function (path, shortname, number, duplicate, search_word) {
    PPx.Execute('%Obd gvim --remote-send "<Cmd>tabe ' + path + '|' + number + '-1 /' + search_word + '/<CR>"');
  };
};

// git grepに対して適用される
// git grepの'search_word'は'commit_hash@@@search_word'として出力される(commit_hashは7桁)ので
// search_word.split('@@@')のように分割して利用できる
cmd['gvim_commit'] = function () {
  PPx.Execute('%Oi *focus #%*findwindowclass("vim"),%\'gvim\'');
  var root = PPx.Extract('%si"repoRoot"') || PPx.Extract("%*script(%'scr'%\\module\\repoStat.js)").split(',')[0];
  return function (path, shortname, number, duplicate, search_word) {
    PPx.Execute('*wait 100,1');
    var path = path.slice(root.length + 1).replace(/\\/g, '/');
    var split_word = search_word.split('@@@');
    PPx.Execute(
      '%Obd gvim --remote-send "<Cmd>tabnew ' + split_word[0] + ':' + PPx.Extract('%*name(C,' + path + ')') + "|set bt=nofile|execute 'silent! r! git cat-file -p " + split_word[0] + ':' + path + "'|0d_|" + number + '-1 /' + split_word[1] + '/<CR>"'
    );
  };
};

cmd['ppv'] = function () {
  return function (path, shortname, number, duplicate, search_word) {
    if (!duplicate) {
      PPx.Execute('%Oi *ppv ' + path + ' -k *find ' + search_word + ' %%: *jumpline L' + number);
      PPx.Execute('*wait 100,1');
    }
  };
};

cmd['sed'] = function () {
  var rep = PPx.Extract(
    '"s#%*script(%\'scr\'%\\compCode.js,"is","""%%","[検索文字#置換文字] ※\\=\\\\\\\\")#g"'
  );
  return function (path, shortname, number, duplicate) {
    if (!duplicate) {
      PPx.Execute('%Oi copy ' + path + ' ' + path + '_back %&');
    }

    PPx.Execute('%Oi sed -i -r ' + number + rep + ' ' + path);
  };
};

result();
