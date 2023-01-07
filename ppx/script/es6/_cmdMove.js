//!*script
/**
 * 状況に応じたファイル移動の設定
 * ・スクリプトから*ppcfileを実行するとPPcから
 *   フォーカスが外れる。-compcmdでフォーカス制御
 *
 * PPx.Arguments(
 *  0: 0=detail | 1=quick
 * )
 */

'use strict';

const g_moveAction = PPx.Arguments.length && PPx.Arguments(0)|0;

// 反対窓親パス情報
const g_dirOp = (() => {
  const path = PPx.Extract('%2');
  const fileInfo = PPx.GetFileInformation(path);
  const reg = /^aux:.*/;
  const type = fileInfo || (reg.test(path) ? ':AUX' : 'no');
  return {
    path: path,
    ext: type
  };
})();

/**
 * 送り先振り分け
 * array[
  '0=detail|1=quick',
  '送り先',
  '追加のoption',
  'compcmdの値'
  ]
 */
const g_infoCmd = {
  // 反対窓あり
  ':DIR': [
    g_moveAction,
    g_dirOp.path,
    ' -qstart -nocount -preventsleep -same:0 -sameall -undolog',
    '-compcmd *focus'
  ],

  // リストファイル
  ':XLF': [
    g_moveAction,
    g_dirOp.path,
    '-qstart -nocount -preventsleep -same:0 -sameall -undolog ',
    ''
  ],

  // AUX:パス
  ':AUX': [
    g_moveAction,
    g_dirOp.path,
    '-qstart -nocount -skiperror -preventsleep -same:0 -sameall -undolog ',
    '-compcmd *execute ~,%%K"@F5"'
  ],

  // 該当なし
  'no': [
    0,
    "%'work'%\\",
    ' -qstart -nocount -preventsleep -same:0 -sameall -undolog',
    '-compcmd *ppc -pane:~ %%hd0 -k *jumppath -entry:%%R'
  ]
}[g_dirOp.ext];

if (g_infoCmd === undefined) {
  PPx.Echo(`非対応ディレクトリ(${g_dirOp.ext})`);
  PPx.Quit(-1);
}

// *ppcfileに送る値を設定
const cmd = ((action, dest, append, comp)  => {
  const {act, opt} = (action === 0) ?
    {act: 'move', opt: '-renamedest'} :
    {act: '!move', opt: '-min'};
  return {
    act: act,
    dest: dest,
    opt: `${opt} ${append}`,
    comp: comp
  };
})(...g_infoCmd);

// 移動実行
if (PPx.DirectoryType >= 62) {
  // 書庫
  if (g_dirOp.ext === ':XLF') {
    PPx.Echo('非対応:書庫内ファイル -> リストファイル');
  } else {
    PPx.Execute(`%u7-zip64.dll,x -aos -hide "%1" -o%"解凍先 ※重複>スキップ"%{${cmd.dest}%} %@`);
  }
} else {
  // 通常コピー
  PPx.Execute(`*ppcfile ${cmd.act}, ${cmd.dest}, ${cmd.opt} ${cmd.comp}`);
}

