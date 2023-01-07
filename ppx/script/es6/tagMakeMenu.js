//!*script
/**
 * タグリストからメニューを生成
 *
 * PPx.Arguments(
 * 0: tag-list filepath
 * )
 */

'use strict';

/////////* 初期設定 *////////////

// 項目数のカウントごとにメニューに縦区切りを入れる
let sep_count = 12;

// タグシステムメニュー項目名
const MENU_TITLE = 'M_UecoSub';

// タグシステム用キーバインド
const KEY_BIND = 'K_tagSysMap';

// 標準のタグリスト
const TAG_LIST = "%'list'%\\tag\\_default.txt";

// タグリストから生成されるタグシステムメニュー
const MENU_CFG = "%'cfg'%\\zzUecoTagSys.cfg";

/////////////////////////////////

const listPath = (function () {
  const fso = PPx.CreateObject('Scripting.FileSystemObject');
  let path;
  if (PPx.Arguments.length !== 0) {
    path = PPx.Extract(`%*name(DC,${PPx.Arguments(0)})`);
  }

  return fso.FileExists(path) ? path : TAG_LIST;
})();

// タグリスト読み込み
const st = PPx.CreateObject('ADODB.stream');
st.Open;
st.Type = 2;
st.Charset = 'UTF-8';
st.LoadFromFile(PPx.Extract(listPath));
const tags = st.ReadText(-1).split('\u000A');
st.Close;

// タグメニュー作成
const compTag = title => (
  `%*script(%'scr'%\\compCode.js,"i","""%%","${title}","*string e,filename=%%%%su""taglist"" %%%%: *completelist -file:${listPath} -detail:""user1"" %%%%: *mapkey use,${KEY_BIND}")`
);
const g_Xwin = PPx.Extract('%*getcust(X_win:v)') || 'B000000000' ;
const g_header = [
  `-|${MENU_TITLE} =`,
  `${MENU_TITLE} = {`,
  `&T:add = *script %'scr'%\\tagOperate.js,push,"${compTag('add Tag..')}"`,
  `&R:remove = *script %'scr'%\\tagOperate.js,remove,"${compTag('remove Tag..')}"`,
  '&E:edit taglist = *edit -lf -utf8bom %su"taglist" %: *script %\'scr\'%\\tagMakeMenu.js,%su"taglist"',
  // この要素はPPvの表示設定。好みに合わせて変更。
  `&V:tag view = *if 0%NVT %: *linecust tagView,KC_main:SELECTEVENT, %: *closeppx VT %: *setcust X_win:v=${g_Xwin} %: *stop
	*string p,vState=1
	*setcust X_win:v=B100100100
	%Oi *ppv -r -bootid:t -k %(*execute C,*fitwindow %%N-R,%%NVT,0 %%: *topmostwindow %%NVT,1 %%: *focus%)
	*linecust tagView,KC_main:SELECTEVENT,%(%Oa *ppv -r -bootid:t %*script(%'scr'%\\tagColorize.js)%)
	%K"@LOADCUST`,
  '-- ='
];
const g_footer = '}';
const g_items = (() => {
  let items = [];
  for (const tag of tags) {
    if (tag === '') {
      continue;
    }

    const tag_ = tag.split(';');
    if (tag_[1] === undefined || !/[a-zA-Z]/.test(tag_[1])) {
      continue;
    }

    const item = {
      key: tag_[1].substring(0, 1).toUpperCase(),
      name: tag_[0].trim()
    };

    items.push(
      `&${item.key}: ${item.name} = *script %'scr'%\\tagOperate.js,push,"${item.name}"\u000A` +
        `&${item.key}: -${item.name} = *script %'scr'%\\tagOperate.js,remove,"${item.name}"`
    );
  }

  items.sort();

  return [...g_header, ...items];
})();

// 縦区切り挿入
while (g_items.length > sep_count) {
  g_items.splice(sep_count, 0, '|| =');
  sep_count = sep_count * 2;
}

// 結果を書き出してメニューを上書き
st.open;
st.Position = 0;
st.WriteText([...g_items, ...g_footer].join('\u000A'));
st.SaveToFile(PPx.Extract(MENU_CFG), 2);
st.Close;

// メニューをPPxに反映
PPx.Execute(
  `*string u,taglist=${listPath} %:` +
    `*setcust @${MENU_CFG}`
);
