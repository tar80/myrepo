//!*script
/**
 * マークしたファイルの状態を操作
 *
 * PPx.Arguments(
 *  0: 0=unstage | 1=stage | 2=untrack | 3=partofstage
 *  1: 0=メッセージ | 1=削除 | 2=通常 | 3=不明 | 4=更新 | 5=追加
 * )
 */

'use strict';

if (PPx.Arguments.length < 2) {
  PPx.Echo('引数が足りません');
  PPx.Quit(-1);
}

const g_statMark = (() => {
  const m = {
    3: 'MM',
    2: '??',
    1: '@ ',
    0: ' @'
  };

  return {
    mark: m[PPx.Arguments(0)],
    number: PPx.Arguments(1)|0
  };
})();

const g_entry = PPx.Entry;
g_entry.FirstMark;

do {
  if (~g_statMark.mark.indexOf('@')) {
    const chr = g_entry.Comment.replace(' ','');
    g_entry.Comment = (chr === '??') ? 'A ' : g_statMark.mark.replace('@', chr);
  } else {
    g_entry.Comment = g_statMark.mark;
  }

  g_entry.State = g_statMark.number;
  g_entry.Mark = 0;
  g_entry.NextMark;
} while (g_entry.FirstMark);

