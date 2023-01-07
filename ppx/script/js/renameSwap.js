//!*script
/**
 * 選択された2ファイル間でファイル名を交換する
 * ・マーク数が二つなら2ファイル間で名前交換
 * ・〃        二つ以下なら反対窓のカーソル位置ファイルと交換
 * ・同名ファイルなら拡張子を交換
 * ・ファイルとディレクトリ間の名前交換は非対応
 */

var g_markCount = PPx.EntryMarkCount;
var fso = PPx.CreateObject('Scripting.FileSystemObject');

var quitMsg = function (msg) {
  PPx.Echo(msg);
  PPx.Quit(-1);
};

// 例外の確認
var checkExcp = function (en1, en2, ren1, ren2) {
  // 同名ファイル
  var dupName = (function () {
    for (var i = arguments.length; i--;) {
      if (fso.FileExists(arguments[i])) {
        return arguments[i];
      }
    }
  })(ren1, ren2);

  if (typeof dupName !== 'undefined' && dupName !== en1 && dupName !== en2) {
    quitMsg('同名ファイルが存在します\n\n' + dupName);
  }

  // ファイル属性
  var en1isDir = fso.FolderExists(en1);
  var en2isDir = fso.FolderExists(en2);
  var en1isFile = fso.FileExists(en1);
  var en2isFile = fso.FileExists(en2);
  if (en1isDir + en1isFile === 0 || en2isDir + en2isFile === 0) {
    quitMsg('エントリを取得できません');
  }

  if (en1isDir !== en2isDir) {
    quitMsg('ファイルとディレクトリの名前交換はできません');
  }
};

var entry1, entry2, rename1, rename2;
if (g_markCount === 2) {
  var thisEntry = PPx.Entry;

  // エントリファイル情報を取得
  var entryClass = function () {
    var name = PPx.Extract('%*name(X,"' + thisEntry.name + '")');
    var ext = PPx.Extract('%*name(T,"' + thisEntry.name + '")');
    ext = ext && '.' + ext;
    return {
      name: name,
      ext: ext,
      filename: name + ext
    };
  };

  thisEntry.FirstMark;
  entry1 = entryClass();
  thisEntry.NextMark;
  entry2 = entryClass();

  // 一時的にFirstMarkに付加する接尾語を設定
  var tempName = entry1.name + '_ren';
  while (fso.FileExists(tempName)|0 || fso.FolderExists(tempName)|0) {
    tempName = tempName.replace('_', '__');
  }

  if (entry1.name === entry2.name) {
    // 同名ファイルなら拡張子を交換
    rename1 = entry1.name + entry2.ext;
    rename2 = entry2.name + entry1.ext;
  } else {
    // ファイル名を交換
    rename1 =  entry2.name + entry1.ext;
    rename2 =  entry1.name + entry2.ext;
  }

  checkExcp(entry1.filename, entry2.filename, rename1, rename2);

  PPx.Execute(
    '%Q%"rename""マークしたエントリ名を入れ替えます" %:' +
      ' *rename ' + entry1.filename + ',' + tempName + '%:' +
      ' *rename ' + entry2.filename + ',' + rename2 + '%:' +
      ' *rename ' + tempName + ',' + rename1
  ) && PPx.Quit(-1);
} else if (PPx.Pane.Count === 2 && g_markCount <= 2) {
  entry1 = '%FDCN';
  entry2 = '%~FDCN';
  rename1 = (PPx.Extract('%T') === '') ? '%~FXN' : '%~FXN.%T';
  rename2 = (PPx.Extract('%~T') === '') ? '%~FD\\%FXN' : '%~FD\\%FXN.%~T';

  checkExcp(PPx.Extract(entry1), PPx.Extract(entry2), PPx.Extract(rename1), PPx.Extract(rename2));

  PPx.Execute(
    '%"rename"%Q"反対窓エントリとファイル名を入れ替えます" %:' +
      ' *rename ' + entry1 + ',' + rename1 + ' %:' +
      ' *rename ' + entry2 + ',' + rename2
  ) && PPx.Quit(-1);
} else {
  quitMsg(
    'mark < 2 :反対窓カーソル位置とファイル名交換\n' +
      'mark = 2 :マークしたエントリのファイル名交換'
  );
}

PPx.Execute('*unmarkentry');

