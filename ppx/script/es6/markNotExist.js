//!*script
/**
 * リストファイル上の存在しないファイルをマーク
 */

'use strict';

const fso = PPx.CreateObject('Scripting.FileSystemObject');

for (let [i, l] = [0, PPx.EntryDisplayCount]; i < l; i++) {
  const thisEntry = PPx.Entry(i);
  if (!fso.FileExists(thisEntry.Name) && !fso.FolderExists(thisEntry.Name)) {
    thisEntry.Mark = 1;
  }
}

