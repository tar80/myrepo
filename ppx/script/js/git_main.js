//!*script
/**
 * gitメインスクリプト
 *
 * PPx.Arguments(
 *  0: quit | menu | dir | status | log
 *  1: commit hash
 * )
 */

/////////* 初期設定 *////////////

var LOG_MAX = 100;      // git logの取得数
var DIFF_UNIFIED = 1;   // git diffの該当行前後に残す行数

// メインリポジトリ
var MY_REPO = PPx.Extract('%*name(DC,"%\'myrepo\'")');

// gitのリストをまとめておくディレクトリ
var LIST_DIR = "%'list'%\\git";

/////////////////////////////////

// カレントが(aux以外の)仮想パスなら終了
if (PPx.DirectoryType === 4 && PPx.Extract('%*name(T,%FDV)')) {
  PPx.Quit(1);
}

var g_args = {
  'order': PPx.Arguments(0),
  'hash': (PPx.Arguments.length === 2) ? PPx.Arguments(1) : 'head',
  'preset': function() { return (this.hash === 'head') ? this.order : 'commit'; },
  'path': PPx.Extract('%FD')
};

// gitリポジトリならrootパスを返す。非リポジトリなら@norepo@を返す。
var g_root = PPx.Extract('%si"gitRoot') || PPx.Extract('%*script(%\'scr\'%\\module\\mod_gitset.js,' + LIST_DIR + ')');
var checkRoot = function () {
  if (g_root === '@norepo@') {
    PPx.SetPopLineMessage('!"not a repository.');
    PPx.Quit(1);
  }
};

// listfile親パス+プレフィクス
var g_wdPf = (function (path) {
  // prefixを設定
  var myrepo = g_args['path'].indexOf(path);
  var pf = ~myrepo ? '_' : '';
  return PPx.Extract(LIST_DIR + '%\\' + pf);
})(MY_REPO);

// auxパスの設定と取得
var g_listfile;
var getLog = function (preset) {
  checkRoot();

  PPx.Execute(
    '*setcust S_git-' + preset + ':lf=' + g_listfile
  );
  PPx.Execute(
    '*job start %: *script %\'scr\'%\\module\\mod_gitlog.js,' +
    preset + ',' + g_root + ',' + g_listfile + ',' + g_args.hash + ',' + LOG_MAX + ',' + DIFF_UNIFIED +
     ' %: *job end %: *jumppath aux:S_git-' + preset + '\\' + g_root
  );
};

var getDiff = function (preset) {
  PPx.Execute(
    '*script %\'scr\'%\\module\\mod_gitlog.js,' +
    preset + ',' + g_root + ',' + g_listfile + ',' + g_args.hash + ',' + LOG_MAX + ',' + DIFF_UNIFIED
  );
};

({
  'quit': function () {
    var path = PPx.Extract('%FD').replace(/^aux:S[^\\]*\\(.*)/,'$1');
    PPx.Execute('*jumppath ' + path + ' -savelocate');
  },
  'menu': function () {
    var subMenu = (g_root !== '@norepo@') ? 'M_gitSub' : 'M';
    (PPx.Extract('%si"RootPath') !== '') ?
      PPx.Execute('*setcust M_gitAUX:ex=??' + subMenu + ' %: %M_gitAUX,G') :
      PPx.Execute('*setcust M_git:ex=??' + subMenu + ' %: %M_git,G');
  },
  'dir': function () {
    checkRoot();
    var path = PPx.Extract('%si"RootPath"').replace(/^(.*S_git-)[^\\]*(.*)/, '$1dir$2');
    PPx.Execute('*jumppath ' + path + ' -savelocate');
  },
  'status': function () {
    g_listfile = g_wdPf + 'gitstatus.xgit';
    getLog('status');
    g_listfile = g_wdPf + 'gitdiff.patch';
    PPx.Execute('*string i,diffpatch=' + g_listfile);
    getDiff('diff');
    return;
  },
  'log': function () {
    g_listfile = g_wdPf + 'gitlog.xgit';
    getLog('log');
    return;
  },
  'commit': function () {
    g_listfile = g_wdPf + 'gitcommit.xgit';
    getLog('commit');
    g_listfile = g_wdPf + 'gitdiff_commit.patch';
    PPx.Execute('*string i,diffpatch=' + g_listfile);
    getDiff('diff_commit');
    return;
  }
})[g_args.preset()]();

