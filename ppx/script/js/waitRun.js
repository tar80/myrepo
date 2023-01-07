//!*script
/**
 * プログラムが起動するまで待機
 *
 * PPx.Arguments(
 * 0: 待機時間(ミリ秒)
 * 1: 対象とするクラス名
 * )
 */

var args = {
  ms: PPx.Arguments(0),
  cname: PPx.Arguments(1)
};

var i = 50;
var pid = 0;
while (pid === 0) {
  PPx.Execute(`*wait ${args.ms}`);
  pid = PPx.Extract(`%*findwindowclass("${args.cname}")`)|0;

  i--;
  if (i === 0) {
    PPx.Echo('time over');
    PPx.Quit(-1);
  }
}

