//!*script
/**
 * 新規独立窓呼び出し
 *
 * PPx.Arguments(
 *  0: V=PPv呼び出し | 無=呼び出し元と同じ
 * )
 */

// 呼び出すPPx(C,V,B)を設定
var g_ppxId = PPx.Arguments.length ? 'V' : PPx.WindowIDName.slice(0, 1);

// 未起動PPxのIDを取得
var nextId = function (idName) {
  for (var i = 0, l = idName.length; i < l; i++) {
    if (!PPx.Extract('%N' + g_ppxId + idName[i])) {
      return idName[i];
    }
  }
};

// PPvで開くパスを取得
var cusorEntry = function () {
  if (PPx.Extract('%se"grep"') !== '') {
    // grepのリザルトからパスを抽出
    var text = PPx.extract('%*script(%\'scr\'%\\compCode.js,"s","""")');
    return text.replace(/^([^:].*):\d*:.*/, function (match, p1) {
      return '%*extract(C"%%FD")%\\' + p1;
    });
  }

  return '%R';
};

({
  'C': function () {
    var chrC = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    return PPx.Execute('*ppc -single -mps -bootid:' + nextId(chrC) + ' %FD -k %%J"%R"');
  },

  'V': function () {
    var chrV = 'DEFGHIJKLMNOPQRSTUVW'.split('');
    return PPx.Execute('*cd %FD %: *ppv -bootid:' + nextId(chrV) + ' ' + cusorEntry());
  }
})[g_ppxId]();

