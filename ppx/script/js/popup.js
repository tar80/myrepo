//!*script
/** ポップアップを返す
 *
 * PPx.Arguments(
 * 0: getcust | var
 * )
 */

var g_order = PPx.Arguments(0);
var popup = {};
popup['getcust'] = function () {
  return PPx.Echo(PPx.Extract('%*getcust(%*selecttext)'))
};

popup['var'] = function () {
  return PPx.Echo(
    '%W\u0009' + PPx.Extract('%W') + '\n' +
      '%n\u0009' + PPx.Extract('%n') + '\n' +
      '%n#\u0009' + PPx.Extract('%n#') + '\n' +
      '%N\u0009' + PPx.Extract('%N') + '\n' +
      '%N.\u0009' + PPx.Extract('%N.') + '\n' +
      '%FD\u0009' + PPx.Extract('%FD') + '\n' +
      '%FDV\u0009' + PPx.Extract('%FDV') + '\n' +
      '%FDS\u0009' + PPx.Extract('%FDS') + '\n' +
      '%linkedpath(%FDC)\u0009' + PPx.Extract('%*linkedpath(%FDC)') + '\n' +
      '%*mousepos(x)\u0009' + PPx.Extract('%*mousepos(x)') + '\n' +
      '%*mousepos(y)\u0009' + PPx.Extract('%*mousepos(y)') + '\n' +
      '%*cursorpos(x)\u0009' + PPx.Extract('%*cursorpos(x)') + '\n' +
      '%*cursorpos(y)\u0009' + PPx.Extract('%*cursorpos(y)') + '\n' +
      '%*ppxlist()\u0009\u0009' + PPx.Extract('%*ppxlist()') + '\n' +
      'DirectoryType\u0009' + PPx.DirectoryType + '\n' +
      'Exists, %FDC\u0009' + PPx.Extract('%*RESULT(exists,%FDC)') + '\n' +
      '%*clippedtext()\u0009' + PPx.Extract('%*clippedtext()')
  )
};

try {
  popup[g_order]();
} catch (err) {
  throw new Error(err);
}

