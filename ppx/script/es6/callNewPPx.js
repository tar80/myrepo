//!*script
/**
 * 新規独立窓呼び出し
 *
 * PPx.Arguments(
 *  0: V=PPv呼び出し | 無=呼び出し元と同じ
 * )
 */

'use strict';

// 呼び出すPPx(C,V,B)を設定
const g_ppxId = PPx.Arguments.length ? 'V' : PPx.WindowIDName.slice(0, 1);

// 未起動PPxのIDを取得する関数
const nextId = key => key.find(chr => PPx.Extract(`%N${g_ppxId}${chr}`) == '');

// PPvで開くパスを取得
const cursorEntry = () => {
  if (PPx.Extract('%se"grep"') !== '') {
    // grepのリザルトからパスを抽出
    const text = PPx.extract('%*script(%\'scr\'%\\compCode.js,"s","""")');
    return text.replace(/^([^:].*):\d*:.*/, (match, p1) => `%*extract(C"%%FD")%\\${p1}`);
  }

  return '%R';
};

({
  'C': () => {
    const chrC = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return PPx.Execute(`*ppc -single -mps -bootid:${nextId([...chrC])} %FD -k %%J"%R"`);
  },

  'V': () => {
    const chrV = 'DEFGHIJKLMNOPQRSTUVW';
    return PPx.Execute(`*ppv -bootid:${nextId([...chrV])} ${cursorEntry()}`);
  }
})[g_ppxId]();

