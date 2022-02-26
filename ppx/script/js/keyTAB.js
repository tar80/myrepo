//!*script
/**
 * TABキーで窓移動
 */

var g_ppx = (function () {
  var winId = PPx.WindowIDName;
  var winId_ = winId.split('_');
  return {
    winid: winId,
    sync: (winId_[0] === 'C' ? 'V' : 'C'),
    idname: winId_[1]
  };
})();

(function () {
  var sync = PPx.Extract('%*extract(C' + g_ppx.idname + ',"%%*js(PPx.Result=PPx.SyncView;)")')|0;

  // syncviewがonならPPc/PPv間でフォーカスをトグル
  if (sync !== 0) {
    PPx.Execute('*focus ' + g_ppx.sync + '_' + g_ppx.idname);
    PPx.Quit(1);
  }
})();

// PPb,PPcustを省いた起動リストを取得
var g_ppxlist = (function () {
  var c = PPx.Extract('%*ppxlist(-C)');
  var v = PPx.Extract('%*ppxlist(-V)');
  return (c + v).slice(0, -1).split(',');
})();

// 一枚表示なら反対窓起動
if (g_ppxlist.length < 4 && PPx.Pane.Count === 1) {
  PPx.Execute('%K"@F6');
  PPx.Quit(1);
}

var getID = (function () {
  g_ppxlist.sort(function (a, b) { return (a < b) ? -1 : 1; });
  var id;
  for (var i = g_ppxlist.length; i--;) {
    if (g_ppxlist[i] === g_ppx.winid) {
      id = g_ppxlist[i + 1];
      break;
    }
  }

  // リストの端なら最初に戻る
  return id || g_ppxlist[0];
})();

PPx.Execute('*focus ' + getID);

