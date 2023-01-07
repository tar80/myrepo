﻿//!*script
/**
 * PPxにカラーテーマを適用する
 *  1.色設定が上書きされるのでバックアップを取っておく
 *  2.https://windowsterminalthemes.dev/ で気に入った色テーマを"Get theme"する
 *  3.クリップボードに設定がコピーされるのでそのままこのスクリプトを実行
 */

var g_clipedTheme = PPx.Clipboard.toLowerCase().replace(/#([a-f0-9]{2})([a-f0-9]{2})([a-f0-9]{2})/g,'H$3$2$1');

// クリップボード一行目からテーマを判別
(function (v) {
  var checkChr = v.charCodeAt(0) + v.charCodeAt(1) + v.charCodeAt(2);
  if (checkChr !== 146 && checkChr !== 165 && checkChr !== 168) {
    PPx.Echo('クリップボードから色情報を取得できませんでした');
    PPx.Quit(-1);
  }
})(g_clipedTheme);

var arrColor = g_clipedTheme.split('\u000A');
var c = {};
for (var i = 1, l = arrColor.length - 2; i < l; i++) {
  var m = arrColor[i].match(/^[\s]*(.*):\s(.*)/);
  m[1] = m[1].replace(/"/g, '');
  m[2] = m[2].replace(/"/g, '').slice(0,-1);
  c[m[1].toLowerCase()] = m[2].replace('bright', 'b').toUpperCase();
}

PPx.Execute('*setcust CB_pals=' + c.background + ',' + c.blue + ',' + c.green + ',' + c.cyan + ',' + c.red + ',' + c.purple + ',' + c.yellow + ',' + c.white + ',' + c.brightblack + ',' + c.brightblue + ',' + c.brightgreen + ',' + c.brightcyan + ',' + c.brightred + ',' + c.brightpurple + ',' + c.brightyellow + ',' + c.brightwhite);
