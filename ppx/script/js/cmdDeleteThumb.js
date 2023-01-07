//!*script
/**
 * サムネイルのキャッシュ削除
 */

for (var i = PPx.EntryDisplayCount; i--;) {
  var thisEntry = PPx.Entry(i);
  if (thisEntry.Size) {
    PPx.Execute('*delete "' + thisEntry.Name + ':thumbnail.jpg"');
  }
}

