//!*script
/**
 * カーソル位置を考慮してPPvの位置を移動する
 */

// 画面サイズ
var DISP_WIDE = 1024;

(function () {
  // %sp"vState"=1(除外対象)、PPvが2枚以上で中止
  var vState = PPx.Extract('0%*extract(C,%%sp"vState")')|0;
  var countV = PPx.Extract('%*ppxlist(+V)');

  if (vState !== 0 || countV > 1) {
    PPx.Quit(1);
  }
})();

var g_ppvId = PPx.WindowIDName;
var g_wide = (function () {
  var disp_wide2 = (DISP_WIDE / 2);
  var ppv_wide = PPx.Extract('%*windowrect(' + g_ppvId + ',w)')|0;
  var mouseX = PPx.Extract('%*extract(C,"%%*cursorpos(x)")')|0;

  // left
  if (mouseX <= (disp_wide2 - 100)) {
    return (ppv_wide < disp_wide2) ? disp_wide2 : (DISP_WIDE - ppv_wide);
  }

  // right
  return (ppv_wide < disp_wide2) ? (disp_wide2 - ppv_wide) : 0;
})();

var g_height = (function () {
  var ppv_height = PPx.Extract('%*windowrect(' + g_ppvId + ',t)')|0;
  return (ppv_height < 80) ? ppv_height : 80;
})();

PPx.Execute('*windowposition ' + g_ppvId + ',' + g_wide + ',' + g_height);

