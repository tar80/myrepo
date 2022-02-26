//!*script
/**
 * discription
 *
 * PPx.Arguments(
 * 0: 拡張コメント番号
 * )
 */

'use strict';

const ITEMS = {
  no: { EXT: ['false'], ICON: '\uF128' },                   // 
  dir: { EXT: ['true'], ICON: '\uF07B' },                   // 
  image: { EXT: ['jpg', 'jpeg', 'bmp', 'png'], ICON: '\uF1C5' },    // 
  audio: { EXT: ['mp3', 'wav'], ICON: '\uF001' },           // 
  video: { EXT: ['mp4'], ICON: '\uF008' },                  // 
  arch: { EXT: ['zip', '7z', 'rar', 'cab'], ICON: '\uF1C6' }, // 
  web: { EXT: ['html', 'xml'], ICON: '\uF0AC' },            // 
  doc: { EXT: ['txt', 'ini'], ICON: '\uF15C' },             // 
  cfg: { EXT: ['cfg', 'yml'], ICON: '\uF993' },             // 煉
  db: { EXT: ['json'], ICON: '\uE706' },                    // 
  lib: { EXT: ['dll'], ICON: '\uF085' },                    // 
  app: { EXT: ['exe'], ICON: '\uFB13' },                    // ﬓ
  js: { EXT: ['js'], ICON: '\uE74E' },                      // 
  vim: { EXT: ['vim'], ICON: '\uE62B' },                    // 
  md: { EXT: ['md'], ICON: '\uE609' },                      // 
  lf: { EXT: ['xlf'], ICON: '\uF45E' },                     // 
  git: { EXT: ['git', 'gitignore', 'gitconfig'], ICON: '\uF1D3' },  // 
  ruby: { EXT: ['bundle'], ICON: '\uE739' },                // 
};

const g_arg = PPx.Arguments.length && PPx.Arguments(0) | 0;
const g_items = Object.keys(ITEMS);

const fso = PPx.CreateObject('Scripting.FileSystemObject');

for (let i = PPx.EntryDisplayCount; i--;) {
  const thisEntry = PPx.Entry(i);
  const thisExt = fso.GetExtensionName(thisEntry.Name).toLowerCase() || String(fso.FolderExists(thisEntry.Name));
  (() => {
    for (let j = g_items.length; j--;) {
      const thisType = ITEMS[g_items[j]];
      if (thisType.EXT.some(v => v === thisExt)) {
        thisEntry.SetComment(g_arg, thisType.ICON);
        return;
      }
    }
    thisEntry.SetComment(g_arg, ITEMS['no'].ICON);
  })();
}

PPx.Execute('%K"@SCROLL"');
