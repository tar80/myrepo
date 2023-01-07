//!*script
/**
 * メモの書き込み
 *
 * PPx.Arguments(
 *  0: memo filepath
 *  1: text color
 * )
 */

'use strict';

const g_info = (() => {
  const len = PPx.Arguments.length;
  if (!len) {
    PPx.Echo('引数が異常');
    PPx.Quit(-1);
  }

  const dirType = PPx.DirectoryType;
  const filePath = PPx.Arguments(0);
  return {
    dirType: dirType,
    pathMemo: (dirType === 4) ? PPx.Extract('%FVD').replace('::listfile', '') : filePath,
    color: (len === 2) ? PPx.Arguments(1) : '0'
  };
})();

// メモの書き込み
const g_memoText = (() => {
  try {
    // エスケープ処理済みの文字列を読み込む
    const res = PPx.Extract('"%*script(%\'scr\'%\\compCode.js,"i","%%","memo..")"');
    return res || PPx.Quit(-1);
  } catch (err) {
    throw `LFmemo.js: ${err}`;
  }
})();

// メモをListfileの形式に置き換える
const g_memoItem = PPx.Extract(`"%*now","",A:H${g_info.color},C:0.0,L:0.0,W:0.0,S:0.0,M:0,T:${g_memoText}`);

const fso = PPx.CreateObject('Scripting.FileSystemObject');
const writeFile = fso.OpenTextFile(g_info.pathMemo, 8, true, -1);
writeFile.WriteLine(g_memoItem);
writeFile.Close();

if (g_info.dirType === 4) {
  PPx.Execute('*wait 100,1 %: %K"@F5"');
}

