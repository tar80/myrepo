//!*script
/**
 * PPvに背景画像を設定
 */

var idnameV = PPx.Extract('%n');
PPx.Execute(
  '*RotateExecute v_rotate_PPvBG,' +
    '"*setcust X_bg:P_' + idnameV + '="" "" %%:' +
    ' *setcust X_bg:T_' + idnameV + '=0 %%:' +
    ' *sound C:\\Windows\\Media\\windows Information bar.wav",' +
      '"*setcust X_bg:P_' + idnameV + '=%FDCN %%:' +
      ' *setcust X_bg:T_' + idnameV + '=20 %%:' +
      ' *sound D:\\Misc\\music\\se\\utopiaex.wav"'
);

