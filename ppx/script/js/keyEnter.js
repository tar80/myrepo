//!*script
/**
 * PPV呼び出し
 *
 * PPx.Arguments(
 *  0: doc | image | movie | 無し
 * )
 */

// サムネ画像専用全画面PPcID ※不要なら空('')にする
var FULL_SCREEN_ID = 'C_X';

var g_cursorEntry = PPx.Extract('%R');
var g_fileType = PPx.Extract('.%t').toLowerCase();

// ファイルの種類と含まれる拡張子
var ITEMS = {
  doc:   '.txt,.ini,.js,.log,.cfg,.html,.ahk,.md,.vbs,.json,.vim',
  image: '.jpg,.jpeg,.bmp,.png,.gif,.vch,.edg',
  movie: '.3gp,.avi,.flv,.mp4,.mpg,.qt,.ebml,.webm'
};

var g_maskType = (function () {
  // 引数でITEMSを指定した時
  if (PPx.Arguments.length !== 0) {
    return PPx.Arguments(0);
  }

  var _objHOP = Object.prototype.hasOwnProperty;
  // 拡張子がITEMSに該当した時
  for (var item in ITEMS) {
    if (_objHOP.call(ITEMS, item)) {
      if (~ITEMS[item].indexOf(g_fileType)) {
        return item;
      }
    }
  }

  // 拡張子がITEMSに該当しなかった時
  return (function () {
    PPx.Execute(
      '%K"@^i %:' +
        ' *focus エントリ情報 %:' +
        ' *wait 0 %:' +
        ' %k"^q v"'
    );
    PPx.Quit(1);
  })();
})();

// 種別の処理
var run = function () {
  switch (g_maskType) {
    case 'image':
      PPx.Execute(
        '*setcust XV_imgD:VZ=-2,4'
      );
      break;

    case 'movie':
      PPx.Execute(
        '%On *ppb -c %0..\\mplayer\\mplayer.exe' +
        ' -framedrop -geometry %*windowrect(%N.,l):%*windowrect(%N.,t)' +
        ' -vf dsize=%*windowrect(%N.,w):%*windowrect(%N.,h):0 %FDC -loop 0'
      );
      PPx.Execute(
        '*linecust JsKeyEnter,KV_main:CLOSEEVENT,'
      );
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
  PPx.Execute(
    '%Ox *setcust X_win:V=B100000000'
  );
  PPx.Execute(
    '*linecust JsKeyEnter,KV_main:CLOSEEVENT,*setcust X_vpos=%*getcust(X_vpos) %%:' +
    ' *execute C,*string p,vState= %%: *linecust JsKeyEnter,KV_main:CLOSEEVENT,'
  );
  //PPx.Execute('*topmostwindow %NVA,1');
} else {
  // タイトルバーあり
  PPx.Execute(
    '*setcust X_win:V=B000000000'
  );
  PPx.Execute(
    '*linecust JsKeyEnter,KV_main:CLOSEEVENT,*setcust X_vpos=%*getcust(X_vpos) %%:' +
      ' *execute C,*string p,vState= %%%%: *maskentry %%%%: *jumppath -update -entry:%%%%R %%:' +
      ' *linecust JsKeyEnter,KV_main:CLOSEEVENT,'
  );
  run();
}

// Moving_PPv停止 ※movingPPv.jsを導入していなければ不要
PPx.Execute('*string p,vState=1');

// PPcに被せて表示
PPx.Execute('*setcust X_vpos=3');

// PPv[z]を呼び出し元PPcと連動
PPx.Execute('*ppvoption id z %K"@N');

// maskを設定
PPx.Execute('*maskentry path:,' + ITEMS[g_maskType]);
PPx.Execute('*jumppath -update -entry:' + g_cursorEntry);

