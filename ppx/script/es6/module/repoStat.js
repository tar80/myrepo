//!*script
/**
 * return git repository root & current branch name
 *
 * PPx.Arguments(
 * 0: return string "repository root path,branch name"
 * 1: add valiables %si'repoRoot', %si'gitBranch'
 * 2: delete valiables
 * )
 *
 * ・引数なし・または'0'のときは、別のスクリプトから呼び出す用途
 *    const [repoRoot, gitBranch] = PPx.Extract("%*script(repoStat.js)").split(',');
 * ・引数'1'のときは、'*string i'を設定する。'2'は設定した変数の削除
 *    *script repoStat.js,1
 * ・%si'repoRoot', %si'gitBranch'は、ディレクトリ移動時に
 *    KC_main:LOADEVENTによって初期化されるが、%si'RootPath'が、
 *    "aux?S_git-*"にマッチする限り維持される
 */

'use strict';

// カレントディレクトリがリポジトリではなかったときに%si'repoRoot'に代入される文字
const NO_REPO = '@norepo@';

const g_arg = PPx.Arguments.Length && PPx.Arguments(0) | 0;

if (g_arg === 2) {
  PPx.Execute(
    `*string i,repoRoot=
     *string i,gitBranch=
     *linecust JsRepoStat%n,KC_main:LOADEVENT,
     *linecust JsRepoStat%n,KC_main:FIRSTEVENT,`
  );
  PPx.Quit(1);
}

// .git\headのパス
let pathHead = null;

// branch名
let branchName = '';

// repository rootを取得
const repoRootDir = (() => {
  let upperDir = PPx.Extract('%*name(DCK,%1)');

  if (upperDir.indexOf('aux:') === 0) {
    upperDir = upperDir.replace(/aux:(\\\\)?S_[^\\]*\\(.*)?/, (_, p1, p2) => {
      return p1 === '\\\\' ? '' : p2;
    });
  }

  if (upperDir !== '') {
    const fso = PPx.CreateObject('Scripting.FileSystemObject');
    upperDir = fso.GetFolder(upperDir);

    do {
      const hasGit = fso.BuildPath(upperDir, '.git');
      if (fso.FolderExists(hasGit)) {
        const head = fso.BuildPath(hasGit, 'head');
        if (fso.FileExists(head)) {
          pathHead = head;
        }

        return String(upperDir);
      }

      upperDir = upperDir.ParentFolder;

      if (upperDir === null || upperDir.IsRootFolder) {
        break;
      }
    } while (!upperDir.IsRootFolder);
  }

  return NO_REPO;
})();

if (pathHead !== null) {
  // .git\headの内容からブランチ名を取得
  const st = PPx.CreateObject('ADODB.stream');
  st.Open;
  st.Type = 2;
  st.Charset = 'UTF-8';
  st.LoadFromFile(pathHead);
  const cntsHead = st.ReadText(-1);
  st.close;

  branchName = ~cntsHead.indexOf('ref:')
    ? cntsHead.replace(/^ref:\srefs\/heads\/(.*)\n/, '$1')
    : cntsHead.slice(0, 6);
}

({
  0: () => (PPx.Result = `${repoRootDir},${branchName}`),
  1: () => {
    if (repoRootDir === NO_REPO) {
      PPx.Execute(
        '*linecust JsRepoStat%n,' +
          'KC_main:LOADEVENT,*string i,repoRoot= %%: *string i,gitBranch=' +
          '%%: *linecust JsRepoStat%n,KC_main:LOADEVENT,'
      );
    } else {
      PPx.Execute(
        '*linecust JsRepoStat%n,' +
          'KC_main:LOADEVENT,*ifmatch %n,%%n %%: *ifmatch !aux?S_git-*,%%si"RootPath"' +
          '%%: *string i,repoRoot= %%: *string i,gitBranch=' +
          '%%: *linecust JsRepoStat%n,KC_main:LOADEVENT,' +
          '%%: *linecust JsRepoStat%n,KC_main:FIRSTEVENT,'
      );
      PPx.Execute(
        '*linecust JsRepoStat%n,' +
          'KC_main:FIRSTEVENT,*ifmatch %n,%%n' +
          `%%: *string i,repoRoot=${repoRootDir} %%: *string i,gitBranch=${branchName} %%: *color back`
      );
    }

    PPx.Execute(
      `*string i,repoRoot=${repoRootDir} %: *string i,gitBranch=${branchName} %: *color back`
    );
    PPx.Execute('%K"@LOADCUST"');
  }
}[g_arg]());
