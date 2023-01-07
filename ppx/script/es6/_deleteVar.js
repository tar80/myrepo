//!*script
/**
 * 引数に指定された特殊環境変数siを削除
 * ・一行編集がキャンセルされたときにアクティブイベントを実行し
 *   不要になった特殊環境変数i(主にEdit_OptionCmd)を削除
 *
 * PPx.Arguments(
 *  0: si1,
 *  1: si2,
 *  2: si3...
 * )
 */

'use strict';

const g_argLength = PPx.Arguments.length;
!g_argLength && PPx.Quit(1);

const g_delCmds = [];
for (let i = g_argLength; i--;) {
  g_delCmds.push(`*string i,${PPx.Arguments(i)}=%%:`);
}

PPx.Execute(
  '*linecust JsDeleteVar,' +
    `KC_main:ACTIVEEVENT, ${g_delCmds.join('')} *linecust JsDeleteVar,KC_main:ACTIVEEVENT,`
);
PPx.Execute(
  '%K"@LOADCUST"'
);

