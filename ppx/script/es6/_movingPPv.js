//!*script
/**
 * カーソル位置を考慮してPPvの位置を移動する
 */

'use strict';

// 画面サイズ
const DISP_WIDE = 1366;

{
  // %sp"vState" = 1;(除外対象)、PPvが2枚以上で中止
  const vState = PPx.Extract('0%*extract(C,%%sp"vState")')|0;
  const countV = PPx.Extract('%*ppxlist(+V)');

  if (vState !== 0 || countV > 1) {
    PPx.Quit(1);
  }
}

const g_ppvId = PPx.WindowIDName;
const g_wide = (() => {
  const disp_wide2 = (DISP_WIDE / 2 - 10);
  const ppv_wide = PPx.Extract(`%*windowrect(${g_ppvId},w)`)|0;
  const mouseX = PPx.Extract('%*extract(C,"%%*cursorpos(x)")')|0;

  // left
  if (mouseX <= (disp_wide2 - 100)) {
    return (ppv_wide < disp_wide2) ? disp_wide2 : (DISP_WIDE - ppv_wide);
  }

  // right
  return (ppv_wide < disp_wide2) ? (disp_wide2 - ppv_wide) : 0;
})();

const g_height = (() => {
  const ppv_height = PPx.Extract(`%*windowrect(${g_ppvId},t)`)|0;

  return (ppv_height < 80) ? ppv_height : 80;
})();

PPx.Execute(`*windowposition ${g_ppvId},${g_wide},${g_height}`);
