//!*script
/**
 * リストビューの表示切り替え
 */

'use strict';

const g_dirType = PPx.DirectoryType|0;
const g_listView = (PPx.WindowIDName === 'C_X') ? -1 : g_dirType;

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
    {
      if (g_dirType >= 62) {
        PPx.Execute(
          '*RotateExecute c_rotate_styleC,' +
            '"*viewstyle ""画像大(&I)""",' +
            '"*viewstyle ""画像特(&I)"""'
        );
      } else {
        PPx.Execute(
          '*RotateExecute c_rotate_styleB,' +
            '"*viewstyle ""画像中(&I)""",' +
            '"*viewstyle ""画像大(&I)""",' +
            '"*viewstyle ""画像特(&I)"""'
        );
        // PPx.Execute(
        // const imgSize = PPx.Entry.Information.replace(/[\s\S]*大きさ\s:\D*(\d*)\sx\s(\d*)[\s\S]*/g, '$1,$2').split(',');
        // const str = (imgSize[0] - imgSize[1] < 0) ? '縦(&H)' : '(&W)';
        // 
        // PPx.Execute(
        //   '*RotateExecute c_rotate_styleB,' +
        //   '"*viewstyle ""画像:小(&W)""",' +
        //   `"*viewstyle ""画像:中${str}""",` +
        //   `"*viewstyle ""画像:大${str}"""`
        // );
      }
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
    {
      if (g_dirType >= 62) {
        const image = ['jpg', 'jpeg', 'bmp', 'png', 'gif', 'vch', 'edg'];
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
    }

    break;
}

