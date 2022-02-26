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

'use strict';

const quit = (msg) => {
  PPx.Echo(msg);
  PPx.Quit(-1);
};

const g_args = (() => {
  const len = PPx.Arguments.length;
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
const g_searchWord = (() => {
  const keyItem = 'result => ';
  for (let [i, l] = [0, PPx.EntryDisplayCount]; i < l; i++) {
    const thisComment = PPx.Entry(i).Comment;
    if (~thisComment.indexOf(keyItem)) {
      return thisComment.split(keyItem)[1];
    }
  }
})();

if (/^[0-9a-zA-Z]{7}@@@/.test(g_searchWord)) {
  g_args.cmd = g_args.cmd + '_commit';
}

// コマンドを読み込む
const initRun = (() => {
  const getCmd = PPx.Extract(`%*script(%'scr'%\\LFexec_cmd.js,${g_args.cmd})`);
  if (getCmd === '') {
    quit('指定されたコマンドはありません');
  }

  return Function('path', 'shortname', 'number', 'duplicate', 'search_word', `return ${getCmd}()`);
})();

// コマンド実行初回
const run = initRun();

{
  // 二回目以降
  const entries = PPx.Extract('%#;FDC').split(';');
  const markCount = PPx.EntryMarkCount;

  // マークの有無でループの初期値を設定
  const hasMark = !markCount ? 0 : 1;

  // ShortNameチェック用
  const reg = /^[0-9]*/;

  // 重複エントリチェック用
  let exists = {};

  const thisEntry = PPx.Entry;
  thisEntry.FirstMark;

  const fso = PPx.CreateObject('Scripting.FileSystemObject');

  for (let i = hasMark; i <= markCount; i++) {
    // 空白行の判定
    if (fso.FileExists(thisEntry.Name)) {
      // フルパスの取得
      const path = entries[i - hasMark];

      // ShortNameの取得
      const sn = thisEntry.ShortName;

      // ShortNameを数値と見なして取得
      const num = reg.test(sn) ? sn | 0 : 1;

      // 重複エントリの判別
      const dup = (() => {
        const isDup = exists[path] || false;
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
}
