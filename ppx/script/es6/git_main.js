//!*script
/**
 * gitメインスクリプト
 *
 * PPx.Arguments(
 *  0: quit | menu | dir | status | log
 *  1: commit hash
 * )
 */

'use strict';

/////////* 初期設定 *////////////

const LOG_MAX      = 100;  // git logの取得数
const DIFF_UNIFIED = 1;    // git diffの該当行前後に残す行数

// メインリポジトリ
const MY_REPO = PPx.Extract('%*name(DC,"%\'myrepo\'")');

// gitのリストをまとめておくディレクトリ
const LIST_DIR = "%'list'%\\git";

/////////////////////////////////

// カレントが(aux以外の)仮想パスなら終了
if (PPx.DirectoryType === 4 && PPx.Extract('%*name(T,%FDV)')) {
  PPx.Quit(1);
}

const g_args = {
  'order': PPx.Arguments(0),
  'hash': (PPx.Arguments.length === 2) ? PPx.Arguments(1) : 'head',
  'preset': function() { return (this.hash === 'head') ? this.order : 'commit'; },
  'path': PPx.Extract('%FD')
};

// gitリポジトリならrootを返す
const g_root = PPx.Extract('%si"gitRoot') || PPx.Extract(`%*script(%'scr'%\\module\\mod_gitset.js,${LIST_DIR})`);
const checkRoot = () => {
  if (g_root === '@norepo@') {
    PPx.SetPopLineMessage('!"not a repository.');
    PPx.Quit(1);
  }
};

// auxパスの設定と実行
const getLog = (preset, sf) => {
  checkRoot();

  PPx.Execute('*PPBWT');

  const pf = ~g_args['path'].indexOf(MY_REPO) ? '_' : '';
  const pathLf = `${LIST_DIR}\\${pf}`;
  PPx.Execute(
    `*setcust S_git-${preset}:lf=${pathLf}git${g_args.order}${sf}.xgit`
  );
  PPx.Execute(
    `*string i,diffpatch=${pathLf}gitdiff${sf}.patch`
  );
  PPx.Execute(
    `*job start %: %Osa *run -d:${g_root} node` +
      ` ${MY_REPO}\\nodejs\\ppx\\main_git.js` +
      ` ${preset} ${g_root} ${pathLf} ${g_args.hash} ${LOG_MAX} ${DIFF_UNIFIED}` +
      ` %: *job end %: *jumppath aux:S_git-${preset}\\${g_root}`
  );
  const id_suffix = PPx.ComboIDName ? '#' : '';
  PPx.Execute(
    `%KC${id_suffix}"@WTOP"`
  );
};

({
  'quit': () => {
    const path = PPx.Extract('%FD').replace(/^aux:S[^\\]*\\(.*)/,'$1');
    PPx.Execute(`*jumppath ${path} -savelocate`);
  },
  'menu': () => {
    const subMenu = (g_root !== '@norepo@') ? 'M_gitSub2' : 'M';
    (PPx.Extract('%si"RootPath') !== '') ?
      PPx.Execute(`*setcust M_gitAUX:ex2=??${subMenu} %: %M_gitAUX,G`) :
      PPx.Execute(`*setcust M_git:ex2=??${subMenu} %: %M_git,G`);
  },
  'dir': () => {
    checkRoot();
    const path = PPx.Extract('%si"gitRoot"').replace(/^aux:S_git-[^\\]*\\(.*)/, '$1');
    PPx.Execute(`*jumppath aux:S_git-dir\\${path} -savelocate`);
  },
  'status': () => getLog('status', ''),
  'log': () => getLog('log', ''),
  'commit': () => {
    PPx.Execute(`*string i,commithash=${g_args.hash}`);
    getLog('commit', '_commit');
  }
})[g_args.preset()]();

