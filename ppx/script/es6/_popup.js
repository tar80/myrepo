//!*script
/** ポップアップを返す
 *
 * PPx.Arguments(
 * 0: getcust | var
 * )
 */

'use strict';

const g_order = PPx.Arguments(0);
const popup = {};
popup['var'] = () =>
  PPx.Execute(`%OC %"変数一覧"%I"%%W\u0009 ${PPx.Extract('%W')}
%%n\u0009${PPx.Extract('%n')}
%%n#\u0009${PPx.Extract('%n#')}
%%N\u0009${PPx.Extract('%N')}
%%N.\u0009${PPx.Extract('%N.')}
%%FD\u0009${PPx.Extract('%FD')}
%%FDV\u0009${PPx.Extract('%FDV')}
%%FDS\u0009${PPx.Extract('%FDS')}
%%*ppxlist()\u0009${PPx.Extract('%*ppxlist()')}
%%linkedpath(%FDC)\u0009${PPx.Extract('%*linkedpath(%FDC)')}
%%*mousepos(x)\u0009${PPx.Extract('%*mousepos(x)')}
%%*mousepos(y)\u0009${PPx.Extract('%*mousepos(y)')}
%%*cursorpos(x)\u0009${PPx.Extract('%*cursorpos(x)')}
%%*cursorpos(y)\u0009${PPx.Extract('%*cursorpos(y)')}
%%*RESULT(DirectoryType)\u0009${PPx.DirectoryType}
%%*RESULT(exists,%FDC)\u0009${PPx.Extract('%*RESULT(exists,%FDC)')}
%%*clippedtext()\u0009${PPx.Extract('%*clippedtext()')}"`);

try {
  popup[g_order]();
} catch (err) {
  throw Error(err);
}
