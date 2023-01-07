//!*script
/**
 * PPvに背景画像を設定
 */

'use strict';

const ppv_id = PPx.Extract('%n');
const enable_bg = PPx.Extract('%*getcust(X_bg:T_%n)');

enable_bg !== '1'
  ? PPx.Execute(
      `*setcust X_bg:P_${ppv_id}=%FDCN` +
        `%:*setcust X_bg:T_${ppv_id}=1` +
        `%:*sound "C:\\Windows\\Media\\windows Information bar.wav"`
    )
  : PPx.Execute(
      `*setcust X_bg:P_${ppv_id}=" "` +
        `%:*setcust X_bg:T_${ppv_id}=0` +
        `%:*sound "C:\\Windows\\Media\\speech on.wav"`
    );
