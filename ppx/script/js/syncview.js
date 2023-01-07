//!*script
/**
 * 状況に応じて連動ビューを設定
 * ・%si"vSize"  :capturewindowに取り込む前のPPvのサイズ
 * ・%sp"vState" :値が"1"のとき、movingPPv.jsを止める
 */

var g_paneCount = PPx.Pane.Count;
var g_idName = PPx.WindowIDName.slice(2);

// 呼出元の状態に合わせて連動ビューを起動
var startSync = function (xWin) {
  PPx.Execute('*setcust X_win:V=' + xWin);
  if (g_paneCount === 2) {
    PPx.Execute('%Oin *ppv -r -bootid:' + g_idName);

    // capturewindowに取り込む前のサイズを記憶する
    PPx.Execute('*string i,vSize=%*getcust(_WinPos:V' + g_idName + ')');

    // movingPPv off
    PPx.Execute('*string p,vState=1');
    PPx.Execute('%Oi *capturewindow V' + g_idName + ' -pane:~ -selectnoactive');
  } else {
    PPx.Execute('%Oi *ppv -r -bootid:' + g_idName);
    PPx.Execute('*setcust X_vpos=0');
    PPx.Execute('*topmostwindow %NV' + g_idName + ',1');
  }

  PPx.Execute('*execute C,*ppvoption sync ' + g_idName);
};

if (!PPx.SyncView) {
  startSync('B000000000');
  // (iPaneCount === 2) ?
  //   // タイトルバー無し
  //   startSync('B100000000') :
  //   // タイトルバー有り
  //   startSync('B000000000');
} else {
  // 連動ビューがあれば解除して終了
  PPx.SyncView = 0;
  PPx.Execute('*setcust X_win:V=B000000000');

  // movingPPv on
  PPx.Execute('*string p,vState=');
  if (PPx.Extract('%si"vSize') !== '') {
    // ppvをcapturewindowに取り込む前のサイズに戻す
    PPx.Execute('*setcust _WinPos:V' + g_idName + '=%si"vSize"');
    PPx.Execute('*string i,vSize=');
  }
}

