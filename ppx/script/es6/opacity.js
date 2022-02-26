//!*script
/**
 * 背景透過用
 *
 * PPx.Arguments(
 *  0: 0-100 ; 不透過度
 */

'use strict';

const TP_SOFT = 80;  // 透過弱
const TP_HARD = 60;  // 透過強

const g_ppxId = PPx.Extract('%n#') || PPx.Extract('%n');

if (PPx.Arguments.length !== 0) {
  PPx.Execute(`*customize X_bg:O_%${g_ppxId} = ${PPx.Arguments(0)}`);
} else {
  PPx.Execute(`*RotateCustomize X_bg:O_%%${g_ppxId}, 100, ${TP_SOFT} ,${TP_HARD}`);
}

