//!*script
/**
 * リストビューの表示切り替え
 */

var g_dirType = PPx.DirectoryType|0;
var g_listView = (PPx.WindowIDName === 'C_X') ? -1 : g_dirType;
// var imgSize = new Array(2);
// var str;
// PPx.Entry.Information.replace(/[\s\S]*\*Size:(\d*)x(\d*)[\s\S]*/g, function (match, p1, p2) {
//   imgSize = [p1, p2];
//   str = (imgSize[0] - imgSize[1] < 0)
//   ? "縦(&H)"
//   : "(&W)";
// });

if (!PPx.Extract('%si"rotate_view"')) {
  PPx.Execute(
    '*string i,rotate_view=1'
  );
  PPx.Execute(
    '*linecust JsRotateViewstyle,' +
    'KC_main:LOADEVENT,*string i,rotate_view= %%:' +
      ' *deletecust _User:c_rotate_styleA %%:' +
      ' *deletecust _User:c_rotate_styleB %%:' +
      ' *deletecust _User:c_rotate_styleC %%:' +
      ' *linecust JsRotateViewstyle,KC_main:LOADEVENT,'
  );
}

switch (g_listView) {
  case -1:
    if (g_dirType >= 62) {
      PPx.Execute(
        '*RotateExecute c_rotate_styleC,' +
          '"*viewstyle ""画像中縦(&H)""",' +
          '"*viewstyle ""画像特縦(&H)"""'
      );
    } else {
      PPx.Execute(
        '%Osn *ppb -c file %R | xargs %0ppcw -r -bootid:X -noactive -k *string i,str='
      );
      var image = (function () {
        var size = PPx.Extract('%si"str"').replace(/.*,\s([0-9]{1,6})\s?x\s?([0-9]{1,6}),\s.*$/, '$1,$2').split(',');
        return {
          w: size[0],
          y: size[1]
        };
      })();

      var wxh = (image.w - image.y < 0) ? '縦(&H)' : '(&W)';
      PPx.Execute(
        '*RotateExecute c_rotate_styleB,' +
        '"*viewstyle ""画像小(&W)""",' +
        '"*viewstyle ""画像中' + wxh + '""",' +
        '"*viewstyle ""画像大' + wxh + '"""'
      );
    }
    break;

  case 4:
    PPx.Execute(
      '*RotateExecute c_rotate_styleA,' +
      '*viewstyle -temp &LISTFILE,' +
      '*viewstyle -temp 一覧(c&Omment)'
    );
    break;

    // case '96':
    //   PPx.Execute('*RotateExecute c_rotate_styleA, *maskpath off , *maskpath on');
    //   break;

  default:
    if (g_dirType >= 62) {
      var image = 'jpg ,jpeg ,bmp ,png ,gif ,vch ,edg';
      if (~image.indexOf(PPx.Extract('%t'))) {
        PPx.Execute(
          '*RotateExecute c_rotate_styleA,' +
            '*viewstyle -temp "サムネ小(&J)",' +
            '*viewstyle -temp "サムネ中(&J)",' +
            '*viewstyle -temp "書庫(&A)"'
        );
        PPx.Quit(1);
      }
      PPx.Execute(
        '*RotateExecute c_rotate_styleA,' +
          '*viewstyle -temp "汎用(&;)",' +
          '*viewstyle -temp "書庫(&A)"'
      );
    } else {
      PPx.Execute(
        '*RotateExecute c_rotate_styleA,' +
          '*viewstyle -temp "サムネ小(&J)" %%:*sortentry &R:標準,' +
          '*viewstyle -temp "サムネ中(&J)" %%:*sortentry &R:標準,' +
          '*viewstyle -temp "サムネ欄(&J)" %%:*sortentry &R:標準,' +
          '*viewstyle -temp "汎用(&;)"'
      );
    }

    break;
}

