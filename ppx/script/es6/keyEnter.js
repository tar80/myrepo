//!*script
/**
 * PPV呼び出し
 *
 * PPx.Arguments(
 *  0: doc | image | movie | 無し
 * )
 */

'use strict';

// サムネ画像専用全画面PPcID ※不要なら空('')にする
const FULL_SCREEN_ID = 'C_X';

const pwd = PPx.Extract('%*script(%*getcust(S_ppm#global:lib)\\getcwd.js)');
const cursor_entry = PPx.Extract('%*name(C,"%FC")');
const file_type = PPx.Extract('.%t').toLowerCase();

// ファイルの種類と含まれる拡張子
const ITEMS = {
  doc: ['.txt', '.ini', '.js', '.log', '.cfg', '.html', '.md', '.vbs', '.json', '.vim'],
  image: ['.jpg', '.jpeg', '.bmp', '.png', '.gif', '.vch', '.edg', '.webp'],
  movie: ['.3gp', '.avi', '.mp4', '.mpg', '.qt', '.ebml', '.webm']
};

const g_maskType = (() => {
  // 引数でITEMSを指定した時
  if (PPx.Arguments.length !== 0) {
    return PPx.Arguments(0);
  }

  // 拡張子がITEMSに該当した時
  for (const [key, value] of Object.entries(ITEMS)) {
    if (~value.indexOf(file_type)) {
      return key;
    }
  }

  // 拡張子がITEMSに該当しなかった時
  return (() => {
    PPx.Execute(`%K"@^i"%:*wait 0,1%:*focus エントリ情報%:%k"^q v"`);
    PPx.Quit(1);
  })();
})();

// 種別の処理
const run = () => {
  switch (g_maskType) {
    case 'image':
      PPx.Execute('*setcust XV_imgD:VZ=-2,4');
      break;

    case 'movie':
      PPx.Execute(
        '%On *ppb -c mpv.exe %FDC' +
          ' --framedrop=vo --geometry=%*windowrect(%N.,w)x%*windowrect(%N.,h)+%*windowrect(%N.,l)+%*windowrect(%N.,t)' +
          ' --loop=no %FDC'
      );
      PPx.Execute('*linecust JsKeyEnter,KV_main:CLOSEEVENT,');
      PPx.Quit(1);
      break;

    case 'doc':
      if (PPx.DirectoryType >= 63 && !!PPx.Execute('%"書庫内ファイル"%Q"PPvで開きますか？"')) {
        PPx.Quit(1);
      }
      break;
  }
};

if (PPx.WindowIDName === FULL_SCREEN_ID) {
  // タイトルバーなし
  PPx.Execute('%Ox *setcust X_win:V=B100000000');
  PPx.Execute(
    '*linecust JsKeyEnter,KV_main:CLOSEEVENT,*setcust X_vpos=%*getcust(X_vpos) %%:' +
      ' *execute C,*linecust JsKeyEnter,KV_main:CLOSEEVENT,'
  );
  //PPx.Execute('*topmostwindow %NVA,1');
} else {
  // タイトルバーあり
  PPx.Execute('*setcust X_win:V=B000000000');
  PPx.Execute(
    '*linecust JsKeyEnter,KV_main:CLOSEEVENT,*setcust X_vpos=%*getcust(X_vpos) %%:' +
      ' *execute C,*maskentry %%%%: *jumppath -update -entry:%%%%R %%:' +
      ' *linecust JsKeyEnter,KV_main:CLOSEEVENT,'
  );
  run();
}

// PPcに被せて表示
PPx.Execute('*setcust X_vpos=3');

// PPv[z]を呼び出し元PPcと連動
PPx.Execute(`*cd ${pwd}%:*ppv -bootid:z ${cursor_entry}`)
// PPx.Execute('*ppvoption id z %K"@N');

// maskを設定
PPx.Execute(`*maskentry path:,${ITEMS[g_maskType]}`);
PPx.Execute(`*jumppath -update -entry:${cursor_entry}`);
