//!*script
/**
 * タグリストからメニューを生成
 *
 * PPx.Arguments(
 * 0: tag-list filepath
 * )
 */

/////////* 初期設定 *////////////

// 項目数のカウントごとにメニューに縦区切りを入れる
var sep_count = 12;

// タグシステムメニュー項目名
var MENU_TITLE = 'M_UecoSub';

// タグシステム用キーバインド
var KEY_BIND = 'K_tagSysMap';

// 標準のタグリスト
var TAG_LIST = "%'list'%\\tag\\_default.txt";

// タグリストから生成されるタグシステムメニュー
var MENU_CFG = "%'cfg'%\\zzUecoTagSys.cfg";

/////////////////////////////////

var listPath = (function () {
  var fso = PPx.CreateObject('Scripting.FileSystemObject');
  var path;
  if (PPx.Arguments.length !== 0) {
    path = PPx.Extract('%*name(DC,' + PPx.Arguments(0) + ')');
  }

  return fso.FileExists(path) ? path : TAG_LIST;
})();

// タグリスト読み込み
var st = PPx.CreateObject('ADODB.stream');
st.Open;
st.Type = 2;
st.Charset = 'UTF-8';
st.LoadFromFile(PPx.Extract(listPath));
var tags = st.ReadText(-1).split('\u000A');
st.Close;

// タグメニュー作成
var compTag = function (title) {
  return '%*script(%\'scr\'%\\compCode.js,"i","""%%","' + title * '","*string e,filename=%%%%su""taglist"" %%%%: *completelist -file:' + listPath + ' -detail:""user1"" %%%%: *mapkey use,' + KEY_BIND + '")';
};

var g_Xwin = PPx.Extract('%*getcust(X_win:v)');
var g_header = [
  '-|' + MENU_TITLE + ' =',
  MENU_TITLE + ' = {',
  '&T:add = *script %\'scr\'%\\tagOperate.js,push,"' + compTag('add Tag..') + '"',
  '&R:remove = *script %\'scr\'%\\tagOperate.js,remove,"' + compTag('remove Tag..') + '"',
  '&E:edit taglist = *edit -lf -utf8bom %su"taglist" %: *script %\'scr\'%\\tagMakeMenu.js,%su"taglist"',
  // この要素はPPvの表示設定。好みに合わせて変更。
  '&V:tag view = *if 0%NVT %: *linecust tagView,KC_main:SELECTEVENT, %: *closeppx VT %: *setcust X_win:v=' + g_Xwin + ' %: *stop\u000A' +
    '\u0009*string p,vState=1\u000A' +
    '\u0009*setcust X_win:v=B100100100\u000A' +
    '\u0009%Oi *ppv -r -bootid:t -k %(*execute C,*fitwindow %%N-R,%%NVT,0 %%: *topmostwindow %%NVT,1 %%: *wait 100,2 %%: *focus%)\u000A' +
    '\u0009*linecust tagView,KC_main:SELECTEVENT,%(%Oa *ppv -r -bootid:t %*script(%\'scr\'%\\tagColorize.js) -k *focus%)\u000A' +
    '\u0009%K"@LOADCUST',
  '-- ='
];
var g_footer = '}';
var g_items = (function () {
  var items = [];
  for (var i = 0, l = tags.length; i < l; i++) {
    var tag = tags[i];
    if (tag === '') {
      continue;
    }

    var tag_ = tag.split(';');
    if (tag_[1] === undefined || !/[a-zA-Z]/.test(tag_[1])) {
      continue;
    }

    var item = {
      key: tag_[1].substring(0, 1).toUpperCase(),
      name: tag_[0].replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, '')
    };

    items.push(
      '&' + item.key + ': ' + item.name + ' = *script %\'scr\'%\\tagOperate.js,push,"' + item.name + '"\u000A' +
        '&' + item.key + ': -' + item.name + ' = *script %\'scr\'%\\tagOperate.js,remove,"' + item.name + '"'
    );
  }

  items.sort();

  return g_header.concat(items);
})();

// 縦区切り挿入
while (g_items.length > sep_count) {
  g_items.splice(sep_count, 0, '|| =');
  sep_count = sep_count * 2;
}

// 結果を書き出してメニューを上書き
st.open;
st.Position = 0;
st.WriteText(g_items.concat(g_footer).join('\u000A'));
st.SaveToFile(PPx.Extract(MENU_CFG), 2);
st.Close;

// メニューをPPxに反映
PPx.Execute(
  '*setcust _User:taglist=' + listPath + ' %:' +
    '*setcust @' + MENU_CFG
);
