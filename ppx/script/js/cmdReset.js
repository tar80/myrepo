//!*script
/**
 * 初期化後再設定
 */

var g_wd = PPx.Extract('%FD');
PPx.Execute('*deletecust _User:r_cback');
PPx.Execute('PPCUSTW CD %\'cfg\'%\\Px_info@.cfg -mask:"_User,A_color,CB_pals,M_theme,M_themeSub" %&');
PPx.Execute('PPCUSTW CINIT %&');
PPx.Execute('*closeppx C* %: *wait 100,2 %: *cd ' + g_wd + ' %: PPCUSTW CA %FDC');

