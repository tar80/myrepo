//!*script
/**
 * リストファイルの読み書き
 *
 * PPx.Arguments(
 *  0: case
 *  1: listfile path
 * )
 */

if (PPx.Arguments.length < 2) {
  throw new Error('引数が足りません');
}

var g_info = {
  cmd: PPx.Arguments(0),
  listfile: PPx.Arguments(1),
  wd: PPx.Extract('%FDN%\\'),
  dirtype: PPx.DirectoryType,
  markCount: PPx.EntryMarkCount
};

// 該当エントリをリストに書き出す
var makeList = function (iomode, create, format) {
  var fso = PPx.CreateObject('Scripting.FileSystemObject');
  var writeFile = fso.OpenTextFile(g_info.listfile, iomode, create, format);
  var wd = (g_info.dirtype !== 4) ? g_info.wd : '';

  // マークがなければカーソルエントリを取得
  if (g_info.markCount === 0) {
    writeFile.WriteLine(wd + PPx.EntryName);
    writeFile.Close();
    return;
  }

  var thisEntry = PPx.Entry;
  thisEntry.FirstMark;

  do {
    writeFile.WriteLine(wd + thisEntry.Name);
    thisEntry.Mark = 0;
  } while (thisEntry.FirstMark);

  writeFile.Close();
};

switch (g_info.cmd) {
  // 新規ファイルリスト(非PPx形式)
  case 'new':
    makeList(2, true, -1);
    break;

  // 指定されたリストに追記
  case 'add':
    makeList(8, true, -1);
    break;

  // 新規リストファイル
  default:
    var hasMark = false;
    if (!PPx.EntryMarkCount) {
      hasMark = true;
      PPx.EntryMark = 1;
    }

    PPx.Execute('*makelistfile -normal -marked ' + g_info.listfile);
    if (hasMark) {
      PPx.EntryMark = 0;
    }

    break;
}

