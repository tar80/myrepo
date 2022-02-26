//!*script
/**
 * TABキーで窓移動
 */

'use strict';

const g_ppx = (() => {
  const winId = PPx.WindowIDName;
  const winId_ = winId.split('_');
  return {
    winid: winId,
    sync: (winId_[0] === 'C' ? 'V' : 'C'),
    idname: winId_[1]
  };
})();

{
  const sync = PPx.Extract(`%*extract(C${g_ppx.idname}"%%*js(PPx.Result=PPx.SyncView;)")`)|0;

  // syncviewがonならPPc/PPv間でフォーカスをトグル
  if (sync !== 0) {
    PPx.Execute(`*focus ${g_ppx.sync}_${g_ppx.idname}`);
    PPx.Quit(1);
  }
}

// PPb,PPcustを省いた起動リストを取得
const g_ppxlist = (() => {
  const c = PPx.Extract('%*ppxlist(-C)');
  const v = PPx.Extract('%*ppxlist(-V)');
  return (c + v).slice(0, -1).split(',');
})();

// 一枚表示なら反対窓起動
if (g_ppxlist.length < 4 && PPx.Pane.Count === 1) {
  PPx.Execute('%K"@F6');
  PPx.Quit(1);
}

const getId = (() => {
  g_ppxlist.sort((a, b) => (a < b) ? -1 : 1);
  let id = g_ppxlist[g_ppxlist.indexOf(g_ppx.winid) + 1];

  // リストの端なら最初に戻る
  return id || g_ppxlist[0];
})();

PPx.Execute(`*focus ${getId}`);

