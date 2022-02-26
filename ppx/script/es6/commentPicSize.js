//!*script
/**
 * リストの画像サイズをコメントに記載
 */

'use strict';

const fso = PPx.CreateObject('Scripting.FileSystemObject');
const g_pathIndex = PPx.Extract('%1%\\00_INDEX.txt');
const writeFile = fso.OpenTextFile(g_pathIndex, 2, true);

const g_sizes = [];
{
  const reg = /[\s\S]*大きさ\s*:‪(\d*\sx\s\d*)‬[\s\S]*/g;

  // 画像情報取得
  for (let [i, l] = [0, PPx.EntryDisplayCount]; i < l; i++) {
    const thisEntry = PPx.Entry(i);
    if (thisEntry.Name.match(/.(bmp|jpg|jpeg|png|gif)$/i)) {
      g_sizes.push(
        `${thisEntry.name}\u0009${thisEntry.Information.replace(reg, '$1')}`
      );
    }
  }
}

writeFile.WriteLine(g_sizes.join('\u000D\u000A'));
writeFile.Close();

