//!*script
/**
 * 状況に応じて連動ビューを設定
 * ・%si"vSize"  :capturewindowに取り込む前のPPvのサイズ
 * ・%sp"vState" :値が"1"のとき、movingPPv.jsを止める
 */

'use strict';

const g_paneCount = PPx.Pane.Count;
const g_idName = PPx.WindowIDName.slice(2);

// 呼出元の状態に合わせて連動ビューを起動
const stateSync = (xWin) => {
  const postcmd = `*ppvoption sync ${g_idName}`;
  PPx.Execute(`*setcust X_win:V=${xWin}`);

  if (g_paneCount === 2) {
    PPx.Execute(`%Oin *ppv -r -bootid:${g_idName}`);

    // capturewindowに取り込む前のサイズを記憶する
    PPx.Execute(`*string i,vSize=%*getcust(_WinPos:V${g_idName})`);

    // movingPPv off
    PPx.Execute('*string p,vState=1');
    PPx.Execute(`*capturewindow V${g_idName} -pane:~ -selectnoactive%:${postcmd}`);
  } else {
    PPx.Execute('*setcust X_vpos=0');
    PPx.Execute(`*ppv -r -bootid:${g_idName} -k *topmostwindow %%NV${g_idName},1%%:*execute C,${postcmd}`);
  }

};

if (!PPx.SyncView) {
  g_paneCount === 2
    ? stateSync('B100000000') // タイトルバー無し
    : stateSync('B000000000'); // タイトルバー有り
} else {
  // 連動ビューがあれば解除して終了
  PPx.SyncView = 0;
  PPx.Execute('*setcust X_win:V=B000000000');

  // movingPPv on
  PPx.Execute('*string p,vState=');
  if (PPx.Extract('%si"vSize') !== '') {
    // ppvをcapturewindowに取り込む前のサイズに戻す
    PPx.Execute(`*setcust _WinPos:V${g_idName}=%si"vSize"`);
    PPx.Execute('*string i,vSize=');
  }
}
