//!*script
/**
 * gitmode初期化
 *
 * PPx.Arguments(
 * 0: gitのログをまとめておくディレクトリパス
 * )
 */

'use strict';

PPx.Result = (() => {
  const listDir = PPx.Arguments(0);

  // headのパス
  let pathHead = null;

  // branch名
  let branch = '';

  // gitリポジトリのルートパスを取得
  const rootGit = (() => {
    const noRepo = () => {
      PPx.Execute(
        '*linecust JsGitSet%n,' +
          'KC_main:LOADEVENT,*string i,gitRoot= %%: *linecust JsGitSet%n,KC_main:LOADEVENT,'
      );
      return '@norepo@';
    };

    const fso = PPx.CreateObject('Scripting.FileSystemObject');

    // ディレクトリがなければ作る
    if (!fso.FolderExists(listDir)) {
      PPx.Execute(`*makedir ${listDir}`);
    }

    let upDir = PPx.Extract('%*name(DCK,"%FD")').replace(
      // /aux:(\\\\)?S_[^\\]*\\(.*)(?!$)(.*)/, (match, p1, p2) => {
      /aux:(\\\\)?S_[^\\]*\\(.*)?/,
      (_, p1, p2) => {
        if (p1 === '\\\\') {
          return '';
        }

        return p2;
      }
    );

    if (upDir === '') {
      return noRepo();
    }

    const isEmpty = PPx.Extract('%*getcust(Mes0411:NOEL)');
    if (~upDir.indexOf(isEmpty)) {
      const reg = new RegExp(isEmpty);
      upDir = upDir.replace(reg, '');
    }

    // PPx.Execute('*logwindow "@@@' + upDir + '"');
    upDir = fso.GetFolder(upDir);

    // リポジトリのルートを取得
    do {
      const hasGit = fso.BuildPath(upDir, '.git');
      if (fso.FolderExists(hasGit)) {
        const head = fso.BuildPath(hasGit, 'head');
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
    const st = PPx.CreateObject('ADODB.stream');
    st.Open;
    st.Type = 2;
    st.Charset = 'UTF-8';
    st.LoadFromFile(pathHead);
    const cntsHead = st.ReadText(-1);
    st.close;

    branch = ~cntsHead.indexOf('ref:')
      ? cntsHead.replace(/^ref:\srefs\/heads\/(.*)\n/, '$1')
      : cntsHead.slice(0, 6);
  }

  if (rootGit !== '@norepo@') {
    PPx.Execute(
      `*string u,g_mode%n=1 %: *string i,uBranch=${branch} %: *color back`
    );
    PPx.Execute(
      '*linecust JsGitSet%n,' +
        'KC_main:LOADEVENT,%(*string o,flag=%%su"g_mode%n" %: *ifmatch 0%sgo"flag",01%si"RootPath" %:' +
        ' *string i,diffpatch= %: *string i,gitRoot= %: *string i,uBranch= %:' +
        ' *deletecust _User:g_mode%n %:' +
        ' *mapkey delete,K_gitmapC %:' +
        ' *linecust JsGitSet%n,KC_main:LOADEVENT,%)'
    );
  }

  PPx.Execute(`*string i,gitRoot=${rootGit}`);
  PPx.Execute('%K"@LOADCUST"');

  return rootGit;
})();
