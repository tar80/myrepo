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

var quitMsg = function (cmd, msg) {
  PPx[cmd](msg);
  PPx.Quit(-1);
};

if (PPx.Arguments.length < 2) {
  quitMsg('Echo', '引数が足りません');
}

var g_order = PPx.Arguments(0)|0;
var g_pathCustomKeys = PPx.Arguments(1);

// ファイル名からメニュー名を決定
var g_menuTitle = PPx.Extract('%*name(X,' + g_pathCustomKeys + ')');

// メニューが登録されているか否かの確認用
var g_menuLength = PPx.Extract('%*getcust(M_' + g_menuTitle + ')').split('\u000A').length;

// スクリプトの実行を許可する項目名
var g_allowKeybinds = 'KC_main, KC_incs, K_edit, K_ppe, K_lied, K_tree, KB_edit, KV_main, KV_page, KV_crt, KV_img';
var g_customKeys = (function () {
  var st = PPx.CreateObject('ADODB.stream');
  st.Open;
  st.Type = 2;
  st.Charset = 'UTF-8';
  st.LoadFromFile(g_pathCustomKeys);
  var items = st.ReadText(-1).split('\u000A');
  st.Close;

  var header;
  var keys = [];
  var regKey = /^\S*\s=\s{.*/;
  var regItem = /^\S*\s*[=,].*/;
  var regValue = /^(\S*)\s.*/;

  for (var i = 0, l = items.length; i < l; i++) {
    var value = items[i];
    if (regKey.test(value)) {
      // 項目名の判別
      header = value.split(' ')[0];
      if (!~g_allowKeybinds.indexOf(header)) {
        quitMsg('Echo', header + 'のキー登録は許可されていません');
      }

    } else if (regItem.test(value)) {
      // キーをリストに追加
      keys.push({
        key: header,
        cmd: value.replace(regValue, function (match, p1) {
          return p1.replace(/\\'/g, '\\\'');
        })
      });
    }
  }

  return keys;
})();

if (typeof g_customKeys[0].key === 'undefined') {
  quitMsg('Echo', '項目名が設定されていません');
}

({
  1: function () {
    if (g_menuLength > 3) {
      quitMsg('SetPopLineMessage', g_menuTitle + 'は適用済みです');
    }

    // 復元用のキーバインドを登録
    for (var i = 0, l = g_customKeys.length; i < l; i++) {
      var thisItem1 = g_customKeys[i];
      var orgKey = PPx.Extract(
        '%OC %*getcust(' + thisItem1.key + ':' + thisItem1.cmd +')'
      );
      if (orgKey === '') {
        // 元のキーが未設定の時
        PPx.Execute(
          '*setcust M_' + g_menuTitle + ':' + thisItem1.key + ':' + thisItem1.cmd + '=%%mNotExist %%K"@' + thisItem1.cmd
        );
      } else if (orgKey.slice(0,1) === '@' || /^[a-zA-Z]*$/.test(orgKey)) {
        // 元のキーの区切りが"="だった時
        PPx.Execute(
          '*setcust M_' + g_menuTitle + ':' + thisItem1.key + ':' + thisItem1.cmd + '=%%mSepEQ %%K"' + orgKey
        );
      } else {
        var orgKey_ = orgKey.replace(/%/g, '%%');
        PPx.Execute(
          '%OC *setcust M_' + g_menuTitle + ':' + thisItem1.key + ':' + thisItem1.cmd + '=' + orgKey_
        );
      }
    }

    PPx.Execute(
      '*setcust @' + g_pathCustomKeys
    );
  },

  0: function () {
    if (g_menuLength <= 3) {
      quitMsg('SetPopLineMessage', g_menuTitle + 'は登録されていません');
    }

    var emptyKeys = [];
    for (var i = 0, l = g_customKeys.length; i < l; i++) {
      var thisItem2 = g_customKeys[i];
      var restoreKey = PPx.Extract(
        '%OC %*getcust(M_' + g_menuTitle + ':' + thisItem2.key + ':' + thisItem2.cmd + ')'
      );
      if (restoreKey === '') {
        // キーが未登録だった時
        emptyKeys.push(thisItem2);
      } else if (~restoreKey.indexOf('mNotExist')) {
        // 元のキーが未設定の時
        PPx.execute(
          '*deletecust ' + thisItem2.key + ':' + thisItem2.cmd
        );
      } else if (~restoreKey.indexOf('mSepEQ')) {
        // 元のキーの区切りが"="だった時
        PPx.Execute(
          '*setcust ' + thisItem2.key + ':' + thisItem2.cmd + '=' + restoreKey.replace('%K"', '')
        );
      } else {
        var restoreKey_ = restoreKey.replace(/%/g, '%%');
        PPx.Execute(
          '%OC *setcust ' + thisItem2.key + ':' + thisItem2.cmd + ',' + restoreKey_
        );
      }
    }

    if (emptyKeys.length !== 0) {
      PPx.SetPopLineMessage('未登録キー: ' + emptyKeys.join(','));
    }

    PPx.Execute('*deletecust "M_' + g_menuTitle + '"');
    PPx.Execute('%K"@LOADCUST');
  }
})[g_order]();

