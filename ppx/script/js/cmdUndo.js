//!*script
/**
 * undo,redo
 *
 * PPx.Arguments(
 *  0: 無=undo | redo
 * )
 */

var g_order = (PPx.Arguments.length && PPx.Arguments(0)) || 'undo';
var g_pathUndolog = (function () {
  var xsave = PPx.Extract('%*getcust(X_save)');
  return (!~xsave.indexOf(':')) ?
    PPx.Extract('%0%\\' + xsave + '%\\ppxundo.log') :
    PPx.Extract(xsave + '%\\ppxundo.log');
})();

var fso = PPx.CreateObject('Scripting.FileSystemObject');
var run = {};
run['undo'] = function () {
  var readFile = fso.OpenTextFile(g_pathUndolog, 1, false, -1);
  var compCmd1 = '';

  // 中止・エラー終了時の処理
  var quitMsg = function (msg) {
    readFile.Close();
    PPx.SetPopLineMessage(msg);
    PPx.Quit(1);
  };

  // ログが空なら終了
  if (readFile.AtEndOfLine) {
    quitMsg('!"empty undolog');
  }

  // ログを一行づつ読み出して整形
  do {
    var arr1 = readFile.ReadLine().split('\u0009');
    var proc1 = arr1[0];
    var lineU1 = arr1[1];

    // Skipなら次の行へ
    if (proc1 === 'Skip') {
      continue;
    }

    var lineU2 = readFile.ReadLine().split('\u0009')[1];
    switch (proc1) {
      case 'Move':
      case 'MoveDir':
        compCmd1 = '-compcmd *script %\'scr\'%\\cmdUndo.js,redo';
        break;

      case 'Backup':
        for (var i = 0, l = PPx.EntryDisplayCount; i < l; i++) {
          if (!fso.FileExists(lineU2) && !fso.FolderExists(lineU2)) {
            quitMsg('NotExist ' + lineU2);
          }
        }

        readFile.SkipLine();
        break;

      default:
        quitMsg('UnknownProcess ' + proc1);
        break;
    }

    PPx.SetPopLineMessage(
      '!Undo\u000D\u000A' +
        'Send ' + lineU2 + '\u000D\u000A' +
        'Dest -> ' + lineU1 + '\u000D\u000A'
    );
  } while (!readFile.AtEndOfStream);

  readFile.Close();
  PPx.Execute('*file !Undo -min -nocount' + compCmd1);
};

// ReDo(Move,RenameのUnDoを処理)
run['redo'] = function () {
  var writeFile = fso.OpenTextFile(g_pathUndolog, 1, false, -1);
  var result2 = '';

  // ログを一行づつ読み出して整形
  while (!writeFile.AtEndOfStream) {
    var arr2 = writeFile.ReadLine().split('\u0009');
    var proc2 = arr2[0];
    var lineR1 = arr2[1];

    // Skipなら次の行へ
    if (proc2 === 'Skip') {
      continue;
    }

    var lineR2 = writeFile.ReadLine().split('\u0009')[1];
    result2 += 'Move\u0009' + lineR2 + '\u000D\u000A' +
        ' ->\u0009' + lineR1 + '\u000D\u000A';
  }

  // 置換結果を書き出してutf16leで上書きする
  writeFile = fso.OpenTextFile(g_pathUndolog, 2, true, -1);
  writeFile.Write(result2);
  writeFile.Close();
};

run[g_order]();

