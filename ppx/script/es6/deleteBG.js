//!*script
/**
* 背景画像の削除
* ・XC_dsetから該当するパスの設定を削除
*/

PPx.Echo('use deleteBG.js');
var g_bg = (function () {
  var upDir = PPx.Extract('%FD');
  var root = PPx.Extract('%*name(H,' + upDir + ')\\');
  do {
    var dset = PPx.Extract('%*getcust(XC_dset:' + upDir + '\\)');
    if (dset !== '') {
      return {
        path: upDir + '\\',
        img: dset.replace(/^.*X_bg:P_%n=(.*)\s%:.*/, '$1')
      };
    }

    upDir = PPx.Extract('%*name(D,' + upDir + ')');
    if (root === upDir) {
      PPx.SetPopLineMessage('!"該当なし');
      PPx.Quit(1);
    }

  } while (true);
})();

PPx.Execute(
  '%"*jumppath ' + g_bg.path + '"%Q"背景画像を解除します%bn' + g_bg.img + '" %:' +
    ' %k"enter" %: *jumppath ' + g_bg.path + ' %: *diroption -thisbranch cmd "" %: %K"@F5"'
);
