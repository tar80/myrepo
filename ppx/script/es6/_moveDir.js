//!*script
/**
 * 同階層の隣合うディレクトリに移動
 * 同階層の隣合う同じ拡張子の仮想ディレクトリに移動
 * ・第二引数にパスが指定されていなければ、%'temp'\ppxcomp.tempが代入される。
 * ・参照元:
 *  http://anago.5ch.net/test/read.cgi/software/1264624581/219
 *  http://hoehoetukasa.blogspot.com/2014/01/ppx_29.html
 *
 * PPx.Arguments(
 *  0: 0=preview | 1=next
 *  1: パスを書き出す一時ファイルのパス
 * )
 */

'use strict';

const g_argLen = PPx.Arguments.length;
if (g_argLen < 1) {
  PPx.Echo('引数が足りません');
  PPx.Quit(-1);
}

const quitMsg = msg => {
  PPx.SetPopLineMessage(`!"${msg}`);
  PPx.Quit(1);
};

const g_args = {
  action: PPx.Arguments(0)|0,
  compfile: (g_argLen === 2) ? PPx.Arguments(1) : PPx.Extract('%\'temp\'\\ppxcomp.temp')
};

const g_wd = (() => {
  let wd = {};
  PPx.Extract('%FDVN').replace(/^(.*)\\((.*\.)?(?!$)(.*))/, (match, p1, p2, p3, p4) => {
    wd = {
      path: `${match}\\`,
      pwd:  p1,
      name: p2,
      ext:  `.${p4.toLowerCase()}`,
      dirType: PPx.DirectoryType
    };
    return;
  });

  (wd.pwd === undefined) && quitMsg('<<Root>>');
  return wd;
})();

switch (g_wd.dirType) {
  case 0:
    quitMsg('DirectoryType: 0, unknown');
    break;

  case 1:
    // 属性を考慮してリスト作成
    PPx.Execute(
      `*whereis -path:"${g_wd.pwd}%\\" -mask:"a:d+s-" -dir:on -subdir:off -listfile:${g_args.compfile} -name`
    );
    break;

  case 4:
  case 63:
  case 64:
  case 96:
    // 拡張子を考慮してリスト作成
    PPx.Execute(
      `*whereis -path:"${g_wd.pwd}%\\" -mask:${g_wd.ext} -subdir:off -listfile:${g_args.compfile} -name`
    );
    g_wd.path = g_wd.path.slice(0, -1);
    break;

  default:
    quitMsg(`DirectoryType : ${g_wd.dirType}, Not supported`);
    break;
}

// パス移動を実行する関数
const movePath = (valA, valB, termMessage) => {
  const fso = PPx.CreateObject('Scripting.FileSystemObject');
  const readFile = fso.OpenTextFile(g_args.compfile, 1, false, -1);
  readFile.AtEndOfLine && quitMsg('Empty');

  // パスリストからパスを取得
  const pathList = [];
  while (!readFile.AtEndOfStream) {
    pathList.push(readFile.ReadLine());
  }

  readFile.Close();

  if (pathList.length === 1) {
    quitMsg('Not found');
  }

  // リストを名前順でソート
  pathList.sort((a, b) => (a.toLowerCase() < b.toLowerCase()) ? valA : valB);

  // 対象エントリ名を取得
  const i = pathList.indexOf(g_wd.path);
  const nextPath = pathList[Math.max(i - 1, 0)];

  // 端ならメッセージを表示
  if (pathList[i - 2] === undefined) {
    PPx.SetPopLineMessage(`!"<${termMessage}>`);
  }

  if (pathList[i - 1] !== undefined) {
    PPx.Execute(`*jumppath "${nextPath}"`);
  }
};

(g_args.action === 0) ?
  movePath(-1, 1, 'Top') :
  movePath(1, -1, 'Bottom');

