//!*script
/**
 * リストファイルの並び、コメント、マーク状態を保存
 * ・リストファイルの書式は、*makelistfile -basic に準ずる
 */

// 取得するヘッダ情報の最大行数
var RSV_HEADER = 5;

// 現在のエントリ状態をリスト化
var g_newItems = (function () {
  //【.】【..】を考慮
  var dotEntries = (function () {
    var tdir = PPx.Extract('%*getcust(XC_tdir)').split(',');
    return Number(tdir[0]) + Number(tdir[1]);
  })();

  var items1 = [];
  for (var i = dotEntries, l = PPx.EntryDisplayCount; i < l; i++) {
    var thisEntry1 = PPx.Entry(i);
    if (thisEntry1.state === 1) {
      continue;
    }

    if (thisEntry1.Name !== thisEntry1.ShortName) {
      items1.push({index: i, value: '"' + thisEntry1.Name + '","' + thisEntry1.ShortName + '"'});
      continue;
    }

    items1.push({index: i, value: '"' + thisEntry1.Name + '",""'});
  }

  return items1;
})();

var g_pathList = PPx.Extract('%FDV').replace('::listfile', '');
var fso = PPx.CreateObject('Scripting.FileSystemObject');

// ファイルに保存されているエントリ状態を取得
var g_oldItems = (function () {
  var items2 = [];
  var readFile = fso.OpenTextFile(g_pathList, 1, false, -1);

  while (!readFile.AtEndOfStream) {
    items2.push(readFile.ReadLine());
  }

  readFile.Close();
  return items2;
})();

// 保存用の並び
var g_newList = (function (items) {
  var header = [];

  // ヘッダを取得
  for (var i = 0, l = Math.min(RSV_HEADER, items.length); i < l; i++) {
    if (items[i].indexOf(';') === 0) {
      header.push(items[i]);
    }
  }

  return header;
})(g_oldItems);

// リスト上の並びをlistfileの形式で取得し直す
for (var i = 0, l = g_newItems.length; i < l; i++) {
  var newItem = g_newItems[i];
  var matchItem = '';

  // ファイルからエントリと一致する行情報を取得
  for (var j = 0, k = g_oldItems.length; j < k; j++) {
    var oldItem = g_oldItems[j];
    if (~oldItem.indexOf(newItem.value)) {
      matchItem = oldItem.split(',');
    }
  }

  var thisEntry2 = PPx.Entry(newItem.index);
  var cmnt = thisEntry2.Comment.replace(/"/g, '""');
  var mark = thisEntry2.Mark;
  var hl = thisEntry2.Highlight;

  g_newList.push(
    matchItem.length < 6
      ? newItem + ',A:H0,C:0.0,L:0.0,W:0.0,S:0.0,H:' + hl + ',M:' + mark + ',T:"' + cmnt + '"'
      : matchItem.splice(0, 7) + ',H:' + hl + ',M:' + mark + ',T:"' + cmnt + '"'
  );
}

// PPc側で保持されている更新内容をリセット
PPx.Execute('%K"@F5');

// 置換結果を書き出してutf16leで上書き
var writeFile = fso.OpenTextFile(g_pathList, 2, true, -1);
writeFile.Write(g_newList.join('\u000D\u000A') + '\u000D\u000A');
writeFile.Close();

if (PPx.DirectoryType === 4) {
  PPx.Execute('*wait 200,1 %: %K"@F5"');
}
