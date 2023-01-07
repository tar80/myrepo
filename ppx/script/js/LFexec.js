//!*script
/**
 * リストファイルから取得した情報をコマンドに渡す
 * ・実行するコマンドは、 .\LFexec_cmd.jsに記述する
 *
 * PPx.Arguments(
 *  0: 実行するコマンド名
 *  1: 1=重複パスの実行
 * )
 */

var quit = function (msg) {
  PPx.Echo(msg);
  PPx.Quit(-1);
};

var g_args = (function () {
  var len = PPx.Arguments.length;
  if (len === 0) {
    quit('引数が足りません');
  }

  return {
    length: len,
    cmd: PPx.Arguments(0),
    allowDup: len !== 2 ? 0 : PPx.Arguments(1) | 0
  };
})();

// ヘッダ情報から検索語を取得
var g_searchWord = (function () {
  var keyItem = 'result => ';
  for (var i = 0, l = PPx.EntryDisplayCount; i < l; i++) {
    var thisComment = PPx.Entry(i).Comment;
    if (~thisComment.indexOf(keyItem)) {
      return thisComment.split(keyItem)[1];
    }
  }
})();

if (/^[0-9a-zA-Z]{7}@@@/.test(g_searchWord)) {
  g_args.cmd = g_args.cmd + '_commit';
}

// コマンドを読み込む
var initRun = (function () {
  var getCmd = PPx.Extract("%*script(%'scr'%\\LFexec_cmd.js," + g_args.cmd + ')');
  if (getCmd === '') {
    quit('指定されたコマンドはありません');
  }

  return Function(
    'path',
    'shortname',
    'number',
    'duplicate',
    'search_word',
    'return ' + getCmd + '()'
  );
})();

// コマンド実行初回
var run = initRun();

// 二回目以降
(function () {
  var entries = PPx.Extract('%#;FDC').split(';');
  var markCount = PPx.EntryMarkCount;

  // マークの有無でループの初期値を設定
  var hasMark = !markCount ? 0 : 1;

  // ShortNameチェック用
  var reg = /^[0-9]*/;

  // 重複エントリチェック用
  var exists = {};
  var thisEntry = PPx.Entry;
  thisEntry.FirstMark;

  var fso = PPx.CreateObject('Scripting.FileSystemObject');

  for (var i = hasMark; i <= markCount; i++) {
    // 空白行の判定
    if (fso.FileExists(thisEntry.Name)) {
      // フルパスの取得
      var path = entries[i - hasMark];

      //  ShortNameの取得
      var sn = thisEntry.ShortName;

      // ShortNameを数値と見なして取得
      var num = reg.test(sn) ? sn | 0 : 1;

      // 重複エントリの判別
      var dup = (function () {
        var isDup = exists[path] || false;
        exists[path] = true;
        return isDup;
      })();

      // 同一パスを判別してコマンドに渡す
      if (g_args.allowDup === 1 || !dup) {
        run(path, sn, num, dup, g_searchWord);
      }
    }

    thisEntry.NextMark;
  }
})();
