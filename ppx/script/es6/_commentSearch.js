//!*script
/**
 * コメントの検索
 * ・要compCode.js
 * ・文字列filter・数字以外・引数なしの場合'filter'が代入される
 * ・ABB_SEARCHをfalseに設定すると、&-検索自動補正を行わない
 * ・210414 引数に'filter'を指定した場合、絞り込み検索が行われる
 * ・211226 検索語には正規表現が使える他、空白を含むと&検索に、
 *          空白を含み単語末尾に"-"があると除外検索に自動補正する
 *          ・例) &: abc 123, -: abc 123-, or: abc|123(空白を含むと誤爆する)
 * ・211229 補完リストに%su"taglist"を読み込むようにした
 *          -検索の正規表現を強化したつもり
 *
 * PPx.Arguments(
 *  0: 'filter'=絞り込み | number=ハイライト番号
 * )
 */

'use strict';

const ABB_SEARCH = true;

const g_order = (PPx.Arguments.length && PPx.Arguments(0)) || 'filter';
const g_regSearchKey = (() => {
  const msg = ABB_SEARCH
    ? '※空白あり(&検索), 空白と単語末尾-(-検索), 空白なし|(or検索)'
    : '※正規表現';
  const compPath =
    PPx.Extract('%su"taglist"') &&
    ' %%%%: *completelist -set -file:%%su""taglist"" -detail:""user1""';
  let minus = '';
  let input = PPx.Extract(
    `%*script(%'scr'%\\compCode.js,"is","""%%","Search Comment.. ${msg}","*editmode e${compPath}")`
  );
  input === '' && PPx.Quit(-1);

  if (ABB_SEARCH) {
    input = (() => {
      if (~input.indexOf('|') || !~input.indexOf(' ')) {
        return input;
      }

      return input.replace(/([^\s-]*)(.)/g, (match, p1, p2) => {
        const fmt = {
          ' ': `(?=.*${p1})`,
          '-': `(?!.*${p1})`
        };

        if (p2 === '-') {
          minus = `^(?!${p1})`;
        }

        return fmt[p2] || fmt[' '];
      });
    })();
  }

  return new RegExp(minus + input, 'i');
})();

let i = PPx.EntryDisplayCount;
if (g_order === 'filter') {
  for (; i--; ) {
    const thisEntry1 = PPx.Entry(i);
    if (!g_regSearchKey.test(thisEntry1.Comment)) {
      thisEntry1.Hide;
    }
  }

  PPx.Execute('*color back');
  PPx.Quit(1);
}

const g_hlNum = ((n) => (isNaN(n) ? 1 : n))(Number(g_order));

// ハイライトを初期化
PPx.Execute('*markentry -highlight:0');
for (; i--; ) {
  const thisEntry2 = PPx.Entry(i);
  if (g_regSearchKey.test(thisEntry2.Comment)) {
    thisEntry2.Highlight = g_hlNum;
  }
}
