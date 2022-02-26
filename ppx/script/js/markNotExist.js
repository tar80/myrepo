//!*script
/**
 * リストファイル上の存在しないファイルをマーク
 */

var fso = PPx.CreateObject('Scripting.FileSystemObject');

for (var i = 0, l = PPx.EntryDisplayCount; i < l; i++) {
  var thisEntry = PPx.Entry(i);
  if (!fso.FileExists(thisEntry.Name) && !fso.FolderExists(thisEntry.Name)) {
    thisEntry.Mark = 1;
  }
}

