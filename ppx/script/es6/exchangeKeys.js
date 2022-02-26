//!*script
/**
 * キーバインドの一時保存・設定と復元
 *
 * PPx.Arguments(
 *  0: 1=キー保存 | 0=キー復元
 *  1: 対象とするキー設定ファイルのパス
 * )
 *  登録ex) exchangeKeys.js,1,path\customkeys.cfg
 *  解除ex) exchangeKeys.js,0,path\customkeys.cfg
 *  ※PPx内部に【M_設定ファイル名】のメニュー項目が一時保存されます
 *
 * ・キー設定ファイル作成時の注意点
 *    1.UTF-8で保存してください。他の文字コードは読めません
 *    2.対象にできる項目は変数keybinds内で示された項目のみです。また、
 *    【 項目名  スペース  =  スペース  { 】 の形式でないと失敗します。コメントは付けてもOK
 *       ex) KC_main = {
 *           KV_main = { ;comment
 *    3.キーバインドのExShiftキー、Altキー、Ctrlキー、Shiftキーは~&^\の順番で書く必要があります
 *       ex) ○: ~&^\A, &^\A, &^A, ^\A
 *           ×: \^&~A, ^\&A, ^&A, \^A
 *    4.CTRL+0やCTRL+Jなど特定のキーはPPx内部で^V_Hxxの型に変換されて記憶されているようです
 *      CTRL+0の場合、^V_H30としないと復元に失敗します
 *    5.'"'キーと'%'キーはエラーが出るのでいまのところ対象外です
 */

'use strict';

const quitMsg = (cmd, msg) => {
  PPx[cmd](msg);
  PPx.Quit(-1);
};

if (PPx.Arguments.length < 2) {
  quitMsg('Echo', '引数が足りません');
}

const g_order = PPx.Arguments(0)|0;
const g_pathCustomKeys = PPx.Arguments(1);

// ファイル名からメニュー名を決定
const g_menuTitle = PPx.Extract(`%*name(X,${g_pathCustomKeys})`);

// メニューが登録されているか否かの確認用
const g_menuLength = PPx.Extract(`%*getcust(M_${g_menuTitle})`).split('\u000A').length;

// スクリプトの実行を許可する項目名
const g_allowKeybinds = [
  'KC_main', 'KC_incs', 'K_edit', 'K_ppe', 'K_lied', 'K_tree',
  'KB_edit', 'KV_main', 'KV_page', 'KV_crt', 'KV_img'
];

const g_customKeys = (() => {
  const st = PPx.CreateObject('ADODB.stream');
  st.Open;
  st.Type = 2;
  st.Charset = 'UTF-8';
  st.LoadFromFile(g_pathCustomKeys);
  const items = st.ReadText(-1).split('\u000A');
  st.Close;

  let header;
  const keys = [];
  const regKey = /^\S*\s=\s{.*/;
  const regItem = /^\S*\s*[=,].*/;
  const regValue = /^(\S*)\s.*/;

  for (const value of items) {
    if (regKey.test(value)) {
      // 項目名の判別
      header = value.split(' ')[0];
      if (!~g_allowKeybinds.indexOf(header)) {
        quitMsg('Echo', `${header}のキー登録は許可されていません`);
      }
    } else if (regItem.test(value)) {
      // キーをリストに追加
      keys.push({
        key: header,
        cmd: value.replace(regValue, (match, p1) => p1.replace(/\\'/g, '\\\''))
      });
    }
  }

  return keys;
})();

if (g_customKeys[0].key === undefined) {
  quitMsg('Echo', '項目名が設定されていません');
}

({
  1: () => {
    if (g_menuLength > 3) {
      quitMsg('SetPopLineMessage', `${g_menuTitle}は適用済みです`);
    }

    // 復元用のキーバインドを登録
    for (const item of g_customKeys) {
      const orgKey = PPx.Extract(
        `%OC %*getcust(${item.key}:${item.cmd})`
      );
      if (orgKey === '') {
        // 元のキーが未設定の時
        PPx.Execute(
          `*setcust M_${g_menuTitle}:${item.key}:${item.cmd}=%%mNotExist %%K"@${item.cmd}`
        );
      } else if (orgKey.slice(0,1) === '@' || /^[a-zA-Z]*$/.test(orgKey)) {
        // 元のキーの区切りが"="だった時
        PPx.Execute(
          `*setcust M_${g_menuTitle}:${item.key}:${item.cmd}=%%mSepEQ %%K"${orgKey}`
        );
      } else {
        const orgKey_ = orgKey.replace(/%/g, '%%');
        PPx.Execute(
          `%OC *setcust M_${g_menuTitle}:${item.key}:${item.cmd}=${orgKey_}`
        );
      }
    }

    PPx.Execute(
      `*setcust @${g_pathCustomKeys}`
    );
  },

  0: () => {
    if (g_menuLength <= 3) {
      quitMsg('SetPopLineMessage', `${g_menuTitle}は登録されていません`);
    }

    const emptyKeys = [];
    for (const item of g_customKeys) {
      const restoreKey = PPx.Extract(
        `%OC %*getcust(M_${g_menuTitle}:${item.key}:${item.cmd})`
      );
      if (restoreKey === '') {
        emptyKeys.push(item);
      } else if (~restoreKey.indexOf('mNotExist')) {
        PPx.execute(
          `*deletecust ${item.key}:${item.cmd}`
        );
      } else if (~restoreKey.indexOf('mSepEQ')) {
        // 元のキーの区切りが"="だった時
        PPx.Execute(
          `*setcust ${item.key}:${item.cmd}=${restoreKey.replace('%K"', '')}`
        );
      } else {
        const restoreKey_ = restoreKey.replace(/%/g, '%%');
        PPx.Execute(
          `%OC *setcust ${item.key}:${item.cmd},${restoreKey_}`
        );
      }
    }

    if (emptyKeys.length !== 0) {
      PPx.SetPopLineMessage('未登録キー: ', ...emptyKeys);
    }

    PPx.Execute(`*deletecust "M_${g_menuTitle}"`);
    PPx.Execute('%K"@LOADCUST');
  }
})[g_order]();

