//!*script
/**
 * 引数で指定された情報を返す
 * ・PPx.Resultには文字数制限がある
 * ・返り値はString型で、空文字('')の場合CASE_EMPTYを返す
 * ・Boolean型は'true'/'false'が返るので、数値('1'/'0')で返したいときは
 *   一度Number型に変換するNumber(true/false)
 *
 * PPx.Arguments(
 *  0: filetype | exists | getpath | myrepo | shapecode | LDC | lfnames
 *  1: パスを指定したい場合など必要に応じて指定
 */

var CASE_EMPTY = 'NoMatch';

var result = function () {
  var order = PPx.Arguments(0);
  var arg1 = (PPx.Arguments.length === 2) ? PPx.Arguments(1) : '';
  var res = '';
  try {
    res = cmd[order](arg1);
  } catch (err) {
    res = PPx.Extract('%*js(PPx.Result = PPx.' + order + ';)');
  } finally {
    PPx.Result = String(res) || CASE_EMPTY;
  }
};

var cmd = {};

// ファイルタイプ判別
cmd['filetype'] = function () {
  var getExt = PPx.GetFileInformation(PPx.Extract('%R')).slice(1);
  return (getExt === '') ? '---' : getExt;
};

// 存在確認 第2引数指定可(指定なし=%R)
// %FDCなど複数回パスを送りたいときは引数で指定する
cmd['exists'] = function (path) {
  path = path || PPx.Extract('%R');
  var fso = PPx.CreateObject('Scripting.FileSystemObject');
  return Number(fso.FileExists(path) || fso.FolderExists(path));
};

// 反対窓の有無でパスを変える
cmd['getpath'] = function () {
  var targetPath = (PPx.Pane.Count === 2) ? '%2%\\' : "%'work'%\\";
  return PPx.Extract(targetPath);
};

// メインリポジトリ
cmd['myrepo'] = function () {
  return PPx.Extract('%1').indexOf(PPx.Extract("%'myrepo'"));
};

// 改行を含むPPxコマンドマクロを整形
cmd['shapecode'] = function () {
  var crlf = (function () {
    var rc = PPx.Extract('%*editprop(returncode)');
    var rep = /(CR|LF)(LF)?/g;
    return rc.replace(rep, function (match, p1, p2) {
      p1 = (p1 === 'CR') ? '\u000D' : '\u000A';
      p2 = (p2 === 'LF') ? '\u000A' : '';
      return p1 + p2;
    });
  })();

  return PPx.Extract('%OC %*edittext').split(crlf).join(crlf + '\u0009');
};

// リンクならリンク先を、実体があればそのままのパスを返す
// ※返すパスはスペース区切りの複数のパス
cmd['LDC'] = function () {
  var entries = PPx.Extract('%#;FDC').split(';');
  var arrLdc = [];
  for (var i = 0, l = entries.length; i < l; i++) {
    var entry = entries[i];
    arrLdc.push(function () {
      return PPx.Extract('%*linkedpath(' + entry + ')') || entry;
    }());
  }

  return arrLdc.join(' ');
};

// listfileのエントリ情報を返す
// 第2引数指定可 (指定なし=Name)
// ※返すパスはスペース区切りの複数のパス
cmd['lfnames'] = function (prop) {
  var prop_ = prop || 'Name';

  // マークがない時
  if (!PPx.EntryMarkCount) {
    return PPx.Entry[prop_];
  }

  var infoList = [];
  var thisEntry = PPx.Entry;
  thisEntry.FirstMark;
  do {
    infoList.push(thisEntry[prop_]);
  } while (thisEntry.NextMark);

  return infoList.join(' ');
};

result();

