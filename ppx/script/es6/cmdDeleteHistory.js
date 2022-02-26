//!*script
/**
 * 対象ヒストリを初期化
 * ・引数を付けると、X_save%\@history_?_back.txtが保存される
 *
 * PPx.Arguments(
 *  0: 1=履歴をバックアップ | 0=バックアップしない
 * )
 */

'use strict';

// バックアップのフラグ
const g_hasBackup = !!(PPx.Arguments.length && PPx.Arguments(0)|0);

const g_whistory = PPx.Extract('%*editprop(whistory)').toLowerCase();
const g_whValue = {
  g: '汎用', p: 'PPc履歴', v: 'PPv履歴', n: '数値', m: 'マスク', s: '検索', h: 'コマンド',
  d: 'ディレクトリ', c: 'ファイル名', f: 'フルパス', u: 'ユーザ1', x: 'ユーザ2'
}[g_whistory];

if (g_whValue === undefined) {
  PPx.Execute('%"履歴の削除"%I"該当する履歴がありません');
  PPx.Quit(1);
} else {
  !PPx.Execute(`%"履歴の削除"%Q"${g_whValue}ヒストリを全削除します"`) || PPx.Quit(1);
}

if (g_hasBackup) {
  PPx.Execute(
    '*run -min -wait:later' +
      ` ppcustw HD %*getcust(X_save)%\\@history_${g_whistory}_back.txt -format:2 -mask:${g_whistory} %:` +
      ' *wait -run'
  );
}

let loop = 'true';
while (loop !== '') {
  loop = PPx.Extract(`%h${g_whistory}0`);
  PPx.Execute(`*deletehistory ${g_whistory},0`);
}

PPx.SetPopLineMessage(`delete ${g_whistory}`);

