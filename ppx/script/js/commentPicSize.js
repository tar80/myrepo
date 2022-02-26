//!*script
/**
 * リストの画像サイズをコメントに記載
 */

var fso = PPx.CreateObject('Scripting.FileSystemObject');
var g_pathIndex = PPx.Extract('%1%\\00_INDEX.txt');
var writeFile = fso.OpenTextFile(g_pathIndex, 2, true);

// アクティブな窓の表示状態を取得
var sXccelf = PPx.Extract('%*getcust(xc_celf:' + PPx.Extract('%n').slice(1) + ')');

// 情報取得のため一時的に表示を変更
PPx.Execute('*customize XC_celF:' + PPx.Extract('%n').slice(1) + '=U"大きさ",0');

// 画像情報取得
for (var i = 0, l = PPx.EntryDisplayCount; i < l; i++) {
  var thisEntry = PPx.Entry(i);
  if (thisEntry.Name.match(/.(bmp|jpg|jpeg|png|gif)$/i)) {
    var thisImageSize = thisEntry.Information.replace(/[\s\S]*\*Size:(\d*x\d*)[\s\S]*/g,'$1');
    var thisImageInfo = thisEntry.Name + '\t' + thisImageSize;
    writeFile.WriteLine(thisImageInfo);
  }
}

writeFile.Close();

// 表示を戻す
PPx.Execute('*customize XC_celF:' + PPx.Extract('%n').slice(1) + '=' + sXccelf);

