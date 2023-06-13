//!*script
/**
 * サムネイルのキャッシュ削除
 */

'use strict';

for (let i = PPx.EntryDisplayCount; i--;) {
  const thisEntry = PPx.Entry(i);
  if (thisEntry.Size) {
    PPx.Execute(`*delete "${thisEntry.Name}:thumbnail.jpg"`);
  }
}

