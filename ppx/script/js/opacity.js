//!*script
/**
 * 背景透過用
 *
 * PPx.Arguments(
 *  0: 0-100 ; 不透過度
 */

var TP_SOFT = 80;    // 透過弱
var TP_HARD = 60;    // 透過強

var g_ppxId = PPx.Extract('%n#') || PPx.Extract('%n');

if (PPx.Arguments.length) {
  PPx.Execute('*customize X_bg:O_%' + g_ppxId + '=' + PPx.Arguments(0));
} else {
  PPx.Execute('*RotateCustomize X_bg:O_%%' + g_ppxId + ', 100, ' + TP_SOFT + ', ' + TP_HARD);
}

