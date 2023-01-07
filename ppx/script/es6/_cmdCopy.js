//!*script
/**
 * 状況に応じたファイルコピーの設定
 * ・%'work'=workspace
 * ・スクリプトから*ppcfileを実行するとPPcから
 *   フォーカスが外れる。-compcmdでフォーカス制御
 *
 * PPx.Arguments(
 *  0: 0=detail | 1=quick | 2>=link
 *  1: 0<完了後ハイライト番号
 * )
 */

'use strict';

const g_args = (() => {
  const len = PPx.Arguments.length;
  return {
    copyAct: len ? PPx.Arguments(0) | 0 : 0,
    hlNum: len >= 2 ? PPx.Arguments(1) | 0 : 0
  };
})();

// 完了後ハイライト
const compHighlight = ((num) => {
  return num === 0 ? '' : `%%: *markentry -highlight:${num} %%#;FC %%: *unmarkentry`;
})(g_args.hlNum);

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

// マークしたエントリ情報
const g_entries = (() => {
  const arrName = PPx.Extract('%#;FCN').replace(/ /g, '_').split(';');
  return {
    path: PPx.Extract('%#;FDCSN').split(';'),
    name: arrName,
    count: arrName.length
  };
})();

// 送り先振り分け
// array['0=detail|1=quick', '送り先', '追加のoption', 'compcmdの値']
const g_infoCmd = {
  // 反対窓あり
  ':DIR': [
    g_args.copyAct,
    g_dirOp.path,
    '-qstart -nocount -preventsleep -same:0 -sameall -undolog ',
    `-compcmd *focus ${compHighlight}`
  ],

  // リストファイル
  ':XLF': [
    g_args.copyAct,
    g_dirOp.path,
    '-qstart -nocount -preventsleep -same:0 -sameall -undolog ',
    ''
  ],

  // AUX:パス
  ':AUX': [
    g_args.copyAct,
    g_dirOp.path,
    '-qstart -nocount -skiperror -preventsleep -same:0 -sameall -undolog ',
    '-compcmd *execute ~,%%K"@F5"'
  ],

  // 該当なし
  'no': [
    0,
    "%'work'%\\",
    '-qstart -nocount -preventsleep -same:0 -sameall -undolog ',
    `-compcmd *ppc -pane:~ %%hd0 -k *jumppath -entry:${g_entries.name[0]}`
  ]
}[g_dirOp.ext];

if (g_infoCmd === undefined) {
  PPx.Echo(`非対応ディレクトリ(${g_dirOp.ext})`);
  PPx.Quit(-1);
}

// *ppcfileに送る値を設定
const cmd = ((action, dest, append, comp) => {
  const {act, opt} = action === 0 ? {act: 'copy', opt: '-renamedest'} : {act: '!copy', opt: '-min'};
  return {
    act: act,
    dest: dest,
    opt: `${opt} ${append}`,
    comp: comp
  };
})(...g_infoCmd);

// コピー実行
if (g_args.copyAct >= 2) {
  // シンボリックリンク
  cmd.dest = PPx.Extract(`%*input("${cmd.dest}" -title:"リンク先" -mode:d)%\\`) || PPx.Quit(1);

  const commands = [];
  for (var i = 0, l = g_entries.count; i < l; i++) {
    // 対象がディレクトリなら/Dオプション付加
    const optD = PPx.GetFileInformation(g_entries.path[i]) === ':DIR' ? '/D ' : '';
    commands.push(`"${optD}${cmd.dest}${g_entries.name[i]} ${g_entries.path[i]}"`);
  }

  // ファイル名内の空白は下線(_)に置き換えられる
  // PPx.Execute('%Obn *run -d:%0 ppbw.exe -c schtasks /run /tn suPPbDW');
  // PPx.Execute('*wait 1000,2');
  PPx.Execute(`FOR %%i IN (${commands.join(',')}) DO mklink %%~i >nul`);
} else if (PPx.DirectoryType >= 62) {
  // 書庫
  if (g_dirOp.ext === ':XLF') {
    PPx.Echo('非対応:書庫内ファイル -> リストファイル');
  } else {
    PPx.Execute(
      `%u7-zip64.dll,e -aou -hide "%1" -o%"解凍先  ※重複>リネーム,DIR>展開"%{${cmd.dest}%} %@`
    );
  }
} else {
  // 通常コピー
  PPx.Execute(`*ppcfile ${cmd.act}, ${cmd.dest}, ${cmd.opt} ${cmd.comp}`);
}
