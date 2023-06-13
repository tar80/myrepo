//!*script
/**
 * IDを考慮してPPx終了
 */

'use strict';

// フォーカスのある窓IDを取得
const ppx_id = ((id) => {
  if (id === 'C_A') {
    // フォーカスがC_Aなら他の窓を選択
    let idLists = PPx.Extract('%*ppxlist(-)').split(',');
    idLists.sort((a, b) => (a < b ? 1 : -1));
    return idLists[0];
  }

  return id;
})(PPx.WindowIDName);

{
  if (PPx.Extract('%*extract(C,"%%*js(PPx.Result=PPx.SyncView;)")') !== '0') {
    PPx.Execute('*execute C,*ppvoption sync off');
    PPx.Quit(1);
  } else if (ppx_id === 'C_X') {
    PPx.Execute('*customize XC_celD=%su"c_celD"');
  }
}

PPx.Execute(`*closeppx ${ppx_id}`);
