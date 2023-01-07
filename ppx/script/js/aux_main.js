//!*script
/**
 * aux:パスリストの作成
 * ・スクリプトの重複実行回避のため実行中は%sp"runJsAuxMain"に"1"が代入される
 *   リスト生成後、aux:パスを開く前に削除すること
 *
 * PPx.Arguments(
 *  0: 実行する外部コマンド
 *  1: リストファイルのパス
 *  2: パス1
 *  3: パス2
 *  4: 実行するPPcのID
 * )
 */

if (PPx.Arguments.length < 5) {
  PPx.Echo('Error Invalid Arguments');
  PPx.Quit(-1);
}

/////////* 初期設定 *////////////

var g_ls2lf = {
  PATH: '%0%\\auxcmd\\ls2lf.exe',

  // オプション指定(--show:結果表示, --append:追記, --lfdir:階層表示)
  OPT: ''
};

/////////////////////////////////

PPx.Execute('*string p,runJsAuxMain=1');

var g_args = {
  cmd: PPx.Arguments(0),
  listfile: PPx.Arguments(1),
  path1: PPx.Arguments(2),
  path2: PPx.Arguments(3),
  ppcID: PPx.Arguments(4)
};

({
  'rclone': function () {
    PPx.Execute(
        '*job start %: %On ' + g_ls2lf.PATH + ' -j "A:Attr,S:Size,M:ModeTime,F:Name" ' + g_ls2lf.OPT + ' ' + g_args.listfile + ' ' + g_args.cmd + ' lsjson ' + g_args.path1 + ' %& +job end %:' +
        ' *execute ' + g_args.ppcID + ',*string p,runJsAuxMain= %%: *jumppath aux://S_auxRCLONE/' + g_args.path1
    );
  },

  'git': function () {}

})[g_args.cmd]();

