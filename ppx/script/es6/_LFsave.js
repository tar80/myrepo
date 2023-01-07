//!*script
/**
 * リストファイルの並び、コメント、マーク状態を保存
 * ・リストファイルの書式は、*makelistfile -basic に準ずる
 */

'use strict';

// 取得するヘッダ情報の最大行数
const RSV_HEADER = 5;

// 現在のエントリ状態をリスト化
const g_newItems = (() => {
  //【.】【..】を考慮
  const dotEntries = (() => {
    const [wd, pwd] = PPx.Extract('%*getcust(XC_tdir)').split(',');
    return Number(wd) + Number(pwd);
  })();

  const items1 = new Map();
  for (let [i, l] = [dotEntries, PPx.EntryDisplayCount]; i < l; i++) {
    let thisEntry1 = PPx.Entry(i);
    if (thisEntry1.state === 1) {
      continue;
    }

    if (thisEntry1.Name !== thisEntry1.ShortName) {
      items1.set(i, `"${thisEntry1.Name}","${thisEntry1.ShortName}"`);
      continue;
    }

    items1.set(i, `"${thisEntry1.Name}",""`);
  }

  return items1;
})();

const g_pathList = PPx.Extract('%FDV').replace('::listfile', '');
const fso = PPx.CreateObject('Scripting.FileSystemObject');

// ファイルに保存されているエントリ状態を取得
const g_oldItems = (() => {
  const items2 = [];
  const readFile = fso.OpenTextFile(g_pathList, 1, false, -1);

  while (!readFile.AtEndOfStream) {
    items2.push(readFile.ReadLine());
  }

  readFile.Close();
  return items2;
})();

// リスト上の並びをlistfileの形式で取得し直す
for (const [index, value] of g_newItems.entries()) {
  // ファイルからエントリと一致する行情報を取得
  const matchItem = g_oldItems.find(data => ~data.indexOf(value));
  const matchItem_ = matchItem.split(',');

  const thisEntry2 = PPx.Entry(index);
  const cmnt = thisEntry2.Comment.replace(/"/g,'""');
  const mark = thisEntry2.Mark;
  const hl = thisEntry2.Highlight;

  g_newItems.set(index, (matchItem_.length < 6) ?
    `${value},A:H0,C:0.0,L:0.0,W:0.0,S:0.0,H:${hl},M:${mark},T:"${cmnt}"` :
    `${matchItem_.splice(0, 7)},H:${hl},M:${mark},T:"${cmnt}"`
  );
}

// PPc側で保持されている更新内容をリセット
PPx.Execute('%K"@F5');

// 保存用の並び
const g_newList = ((item) => {
  const header = [];

  // ヘッダを取得
  for (let [i, l] = [0, Math.min(RSV_HEADER, item.length)]; i < l; i++) {
    if (item[i].indexOf(';') === 0) {
      header.push(item[i]);
    }
  }

  const reslut = [...header, ...g_newItems.values()];
  return reslut.reduce((p, c) => `${p}\u000D\u000A${c}`) + '\u000D\u000A';
})(g_oldItems);

// 置換結果を書き出してutf16leで上書き
const writeFile = fso.OpenTextFile(g_pathList, 2, true, -1);
writeFile.Write(g_newList);
writeFile.Close();

if (PPx.DirectoryType === 4) {
  PPx.Execute('*wait 100,1 %: %K"@F5"');
}

