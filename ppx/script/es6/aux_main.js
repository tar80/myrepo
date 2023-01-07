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

'use strict';

if (PPx.Arguments.length < 5) {
  PPx.Echo('Error Invalid Arguments');
  PPx.Quit(-1);
}

/////////* 初期設定 *////////////

const g_ls2lf = {
  PATH: 'c:\\bin\\ppx\\auxcmd\\ls2lf.exe',

  // オプション指定(--show:結果表示, --append:追記, --lfdir:階層表示)
  OPT: ''
};

/////////////////////////////////

PPx.Execute('*string p,runJsAuxMain=1');

const g_args = {
  cmd: PPx.Arguments(0),
  listfile: PPx.Arguments(1),
  path1: PPx.Arguments(2),
  path2: PPx.Arguments(3),
  ppcID: PPx.Arguments(4)
};

// const msgLog = msg => `*execute ${g_args.ppcID},*linemessage !"${msg}`;

({
  'rclone': () => {
    // PPx.Execute(
    //   msgLog(`getting ${g_args.path1}`)
    // );
    PPx.Execute(
      ` *execute b,*job start %%:*set RCLONE_CONFIG_PASS=test %%: ${g_ls2lf.PATH} -j "A:Attr,S:Size,M:ModeTime,F:Name" ${g_ls2lf.OPT} ${g_args.listfile} ${g_args.cmd} lsjson ${g_args.path1} %%& *job end %%:` +
      ` *execute ${g_args.ppcID},*string p,runJsAuxMain= %%%%: *jumppath aux://S_auxRCLONE/${g_args.path1}`
    );
    // PPx.Execute(
    //   '*run -min %0%\\ppbw.exe -c' +
    //     ` ${g_ls2lf.PATH} -j "A:Attr,S:Size,M:ModeTime,F:Name" ${g_ls2lf.OPT} ${g_args.listfile} ${g_args.cmd} lsjson ${g_args.path1} %%&` +
    //     ` *execute ${g_args.ppcID},*string p,runJsAuxMain= %%%%: *jumppath aux://S_auxRCLONE/${g_args.path1} %%%%:` +
    //     ` ${msgLog('completed')}`
    // );
  },

  'git': () => { }

})[g_args.cmd]();

