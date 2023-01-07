//!*script
/**
 * PPxにカラーテーマを適用する
 *  1.色設定が上書きされるのでバックアップを取っておく
 *  2.https://windowsterminalthemes.dev/ で気に入った色テーマを"Get theme"する
 *  3.クリップボードに設定がコピーされるのでそのままこのスクリプトを実行
 */

'use strict';

const g_clipedTheme = PPx.Clipboard.toLowerCase().replace(/#([a-f0-9]{2})([a-f0-9]{2})([a-f0-9]{2})/g,'H$3$2$1');
{
  // クリップボード一行目からテーマを判別
  const checkChr = g_clipedTheme.charCodeAt(0) + g_clipedTheme.charCodeAt(1) + g_clipedTheme.charCodeAt(2);
  if (checkChr !== 146 && checkChr !== 165 && checkChr !== 168) {
    PPx.Echo('クリップボードから色情報を取得できませんでした');
    PPx.Quit(-1);
  }

  const colors = JSON.parse(g_clipedTheme);
  const c = {};
  for (const [key, value] of Object.entries(colors)) {
    c[key] = value.replace('bright', 'b').toUpperCase();
  }

  PPx.Execute(`*setcust CB_pals=${c.background},${c.blue},${c.green},${c.cyan},${c.red},${c.purple},${c.yellow},${c.white},${c.brightblack},${c.brightblue},${c.brightgreen},${c.brightcyan},${c.brightred},${c.brightpurple},${c.brightyellow},${c.brightwhite}`);
}

