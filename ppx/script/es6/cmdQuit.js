//!*script
/**
 * IDを考慮してPPx終了
 */

'use strict';

const ppx_id = ((id = PPx.WindowIDName) => {
  if (id === 'C_A') {
    let idLists = PPx.Extract('%*ppxlist(-)').split(',');
    idLists.sort((a, b) => (a < b ? 1 : -1));
    return idLists[0];
  }

  return id;
})();
const sync_hwnd = PPx.Extract('%*extract(C,"%%*js(PPx.Result=PPx.SyncView;)")');

if (sync_hwnd !== '0' && sync_hwnd !== '') {
  PPx.Execute('*execute C,*ppvoption sync off');
  PPx.Quit(1);
} else if (ppx_id === 'C_X') {
  PPx.Execute('*customize XC_celD=%su"c_celD"');
}

PPx.Execute(`*closeppx ${ppx_id}`);
