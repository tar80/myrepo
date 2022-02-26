//!*script
/**
 * IDを考慮してPPx終了
 */

// フォーカスのある窓IDを取得
var g_ppxId = (function (id) {
  if (id === 'C_A') {
    // フォーカスがC_Aなら他の窓を選択
    var idLists = PPx.Extract('%*ppxlist(-)').split(',');
    idLists.sort(function (a, b) { return a < b ? 1 : -1; });
    return idLists[0];
  }

  return id;
})(PPx.WindowIDName);

var g_sync = PPx.Extract('%*extract(C,"%%*js(PPx.Result=PPx.SyncView;)")')|0;
if (g_sync !== 0) {
  PPx.Execute('*setcust X_win:V=B000000000');
  PPx.Execute('*execute C,*ppvoption sync off');

  // 連動ビューがcapturewindowなら元のサイズに戻す
  if (PPx.Extract('%si"vSize') !== '') {
    PPx.Execute('*setcust _WinPos:V' + g_ppxId.slice(2) + '=%si"vSize"');
    PPx.Execute('*string i,vSize=');
  }

  PPx.Quit(1);
} else if (g_ppxId === 'C_X') {
  PPx.Execute('*customize XC_celD=%*getcust(_User:c_celD)');
}

PPx.Execute('*closeppx ' + g_ppxId);

