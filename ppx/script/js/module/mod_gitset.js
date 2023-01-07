﻿//!*script
/**
 * gitmode初期化
 * ・gitモードフラグ(_user:g_mode%n)、リポジトリrootパス(%si"gitRoot")、ブランチ名(%si"uBranch")を取得
 * ・取得した変数削除用のLOADEVENTを設置、gitモード用標準キーバインドも同時に削除(K_gitmapC)
 *
 * PPx.Arguments(
 * 0: gitのログをまとめておくディレクトリパス
 * )
 */

PPx.Result = (function () {
  var listDir = PPx.Arguments(0);

  // headのパス
  var pathHead = null;

  // branch名
  var branch = '';

  // gitリポジトリのルートパスを取得
  var rootGit = (function () {
    var noRepo = function () {
      PPx.Execute(
        '*linecust JsGitSet%n,' +
          'KC_main:LOADEVENT,*string i,gitRoot= %%: *linecust JsGitSet%n,KC_main:LOADEVENT,'
      );
      return '@norepo@';
    };

    var fso = PPx.CreateObject('Scripting.FileSystemObject');

    // ディレクトリがなければ作る
    if (!fso.FolderExists(listDir)) {
      PPx.Execute('*makedir ' + listDir + '');
    }

    var upDir = PPx.Extract('%*name(DCK,"%FD")') .replace(
      /aux:(\\\\)?S_[^\\]*\\(.*)?/, function (match, p1, p2) {
        if (p1 === '\\\\') {
          return '';
        }

        return p2;
      }
    );

    if (upDir === '') {
      return noRepo();
    }

    var isEmpty = PPx.Extract('%*getcust(Mes0411:NOEL)');
    if (~upDir.indexOf(isEmpty)) {
      var reg = new RegExp(isEmpty);
      upDir = upDir.replace(reg, '');
    }

    // PPx.Execute('*logwindow "@@@' + upDir + '"');
    upDir = fso.GetFolder(upDir);

    // リポジトリのルートを取得
    do {
      var hasGit = fso.BuildPath(upDir, '.git');
      if (fso.FolderExists(hasGit)) {
        var head = fso.BuildPath(hasGit, 'head');
        if (fso.FileExists(head)) {
          pathHead = head;
        }
        return String(upDir);
      }

      upDir = upDir.ParentFolder;

      if (upDir === null || upDir.IsRootFolder) {
        return noRepo();
      }

    } while (!upDir.IsRootFolder);
  })();

  if (pathHead !== null) {
      var st = PPx.CreateObject('ADODB.stream');
      st.Open;
      st.Type = 2;
      st.Charset = 'UTF-8';
      st.LoadFromFile(pathHead);
      var cntsHead = st.ReadText(-1);

      branch = (~cntsHead.indexOf('ref:')) ?
        cntsHead.replace(/^ref:\srefs\/heads\/(.*)\n/, '$1') :
        cntsHead.slice(0, 6);
  }

  if (rootGit !== '@norepo@') {
    PPx.Execute(
      '*setcust _User:g_mode%n=1 %: *string i,uBranch=' + branch + ' %: *color back'
    );
    PPx.Execute(
      '*linecust JsGitSet%n,' +
        'KC_main:LOADEVENT,*ifmatch 0%%su"g_mode%n",01%%si"RootPath" %%:' +
        ' *string i,diffpatch= %%: *string i,gitRoot= %%: *string i,uBranch= %%:' +
        ' *deletecust _User:g_mode%%n %%:' +
        ' *mapkey delete,K_gitmapC %%:' +
        ' *linecust JsGitSet%n,KC_main:LOADEVENT,'
    );
  }

  PPx.Execute('*string i,gitRoot=' + rootGit);
  PPx.Execute('%K"@LOADCUST"');

  return rootGit;
})();

