//!*script
/**
 * 同階層の隣合うディレクトリに移動
 * 同階層の隣合う同じ拡張子の仮想ディレクトリに移動
 * ・参照元:
 *  http://anago.5ch.net/test/read.cgi/software/1264624581/219
 *  http://hoehoetukasa.blogspot.com/2014/01/ppx_29.html
 *
 * PPx.Arguments(
 *  0: 0=preview | 1=next
 * )
 */

var quitMsg = function (msg) {
  PPx.SetPopLineMessage('!"' + msg);
  PPx.Quit(1);
};

var g_order = PPx.Arguments.length && PPx.Arguments(0)|0;
var g_wd = (function () {
  var wd = {};
  PPx.Extract('%FDVN').replace(/^(.*)\\((.*\.)?(?!$)(.*))/, function (match, p1, p2, p3, p4) {
    wd = {
      path: match + '\\',
      pwd:  p1,
      name: p2,
      ext:  p4.toLowerCase(),
      dirType: PPx.DirectoryType
    };
    return;
  });

  (typeof wd.pwd === 'undefined') && quitMsg('<<Root>>');

  return wd;
})();

var fso = PPx.CreateObject('Scripting.FileSystemObject');
var enumDir;        // enumerator
var g_subDir = [];  // subdirectory_list
var g_pwd;          // parent_directory
var movePath;
var makeList = function (callback) {
  return function (value1, value2, termMsg) {
    // 親ディレクトリからリストを取得
    for (enumDir.moveFirst(); !enumDir.atEnd(); enumDir.moveNext()) {
      callback();
    }

    // リストを名前順でソート
    g_subDir.sort(function (a, b) {
      return (a.toLowerCase() < b.toLowerCase()) ? value1 : value2;
    });

    for (var i = g_subDir.length; i--;) {
      if (g_subDir[i] === g_wd.name) {
        break;
      }
    }

    // 対象エントリ名を取得
    var dirName = g_subDir[Math.max(i - 1, 0)];
    if (typeof g_subDir[i - 1] !== 'undefined') {
      PPx.Execute('*jumppath "' + fso.BuildPath(g_pwd.Path, dirName) + '"');

      // 端ならメッセージを表示
      if (typeof g_subDir[i - 2] === 'undefined') {
        quitMsg('<' + termMsg + '>');
      }
    }
  };
};

switch (g_wd.dirType) {
  case 0:
    quitMsg('DirectoryType: 0, unknown');
    break;

  case 1:
    g_pwd = fso.GetFolder(g_wd.path).ParentFolder;
    enumDir = new Enumerator(g_pwd.SubFolders);

    // 属性を考慮してリストに追加
    movePath = makeList(function () {
      var thisFile = fso.GetFolder(fso.BuildPath(g_pwd.Path, enumDir.item().Name));
      if (thisFile.Attributes <= 17) {
        g_subDir.push(enumDir.item().Name);
      }
    });
    break;

  case 4:
  case 63:
  case 64:
  case 96:
    g_pwd = fso.GetFolder(g_wd.pwd);
    enumDir = new Enumerator(g_pwd.Files);

    /* 拡張子を考慮してリストに追加 */
    movePath = makeList(function () {
      var thisExt = fso.GetExtensionName(fso.BuildPath(g_pwd.Path, enumDir.item().Name)).toLowerCase();
      if (thisExt === g_wd.ext) {
        g_subDir.push(enumDir.item().Name);
      }
    });
    break;

  default:
    quitMsg('DirectoryType : ' + g_wd.dirType + ', Not supported');
    break;
}

(g_order === 0) ?
  movePath(-1, 1, 'Top') :
  movePath(1, -1, 'Bottom');

