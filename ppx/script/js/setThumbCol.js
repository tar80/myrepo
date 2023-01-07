//!*script
/**
 * 一括サムネイル設定
 *
 * PPx.Arguments(
 *  0: 表示形式(MC_celS)
 *  1: サムネイル候補画像リストパス
 * )
 */

if (PPx.Arguments.length !== 2) {
  PPx.Echo('引数が異常');
  PPx.Quit(1);
}

var g_args = {
  style: PPx.Arguments(0),
  pathList: PPx.Arguments(1)
};

var g_pathImage = PPx.Extract(
  '%*input(-title:"サムネイル画像の選択" -mode:e -k *completelist -file:"' + g_args.pathList + '")'
);

PPx.Execute(
  '%Oi *viewstyle -temp "' + g_args.style + '" %: *wait 100'
);

PPx.EntryFirstMark;
do {
  PPx.Execute(
    '*setentryimage ' + g_pathImage + ' -save'
  );
} while (PPx.EntryNextMark);

