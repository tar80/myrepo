//!*script
/**
 * undo,redo
 *
 * PPx.Arguments(
 *  0: 無=undo | redo
 * )
 */

'use strict';

const g_order = (PPx.Arguments.length && PPx.Arguments(0)) || 'undo';
const g_pathUndolog = (() => {
  const xsave = PPx.Extract('%*getcust(X_save)');
  return (!~xsave.indexOf(':')) ?
    PPx.Extract(`%0${xsave}%\\ppxundo.log`) :
    PPx.Extract(`${xsave}%\\ppxundo.log`);
})();

const fso = PPx.CreateObject('Scripting.FileSystemObject');
const run = {};
run['undo'] = () => {
  const readFile = fso.OpenTextFile(g_pathUndolog, 1, false, -1);
  let compCmd1 = '';

  // 中止・エラー終了時の処理
  const quitMsg = function (msg) {
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
    const [proc1, lineU1] = readFile.ReadLine().split('\u0009');

    // Skipなら次の行へ
    if (proc1 === 'Skip') {
      continue;
    }

    const lineU2 = readFile.ReadLine().split('\u0009')[1];
    switch (proc1) {
      case 'Move':
      case 'MoveDir':
        compCmd1 = '-compcmd *script %\'scr\'%\\cmdUndo.js,redo';
        break;

      case 'Backup':
        {
          for (let [i, l] = [0, PPx.EntryDisplayCount]; i < l; i++) {
            if (!fso.FileExists(lineU2) && !fso.FolderExists(lineU2)) {
              quitMsg(`NotExist ${lineU2}`);
            }
          }

          readFile.SkipLine();
        }

        break;

      default:
        quitMsg(`UnknownProcess ${proc1}`);
        break;
    }

    PPx.SetPopLineMessage(
      '!Undo\u000D\u000A' +
        `Send ${lineU2}\u000D\u000A` +
        `Dest -> ${lineU1}\u000D\u000A`
    );
  } while (!readFile.AtEndOfStream);

  readFile.Close();
  PPx.Execute(`*file !Undo -min -nocount ${compCmd1}`);
};

// ReDo(Move,RenameのUnDoを処理)
run['redo'] = () => {
  let writeFile = fso.OpenTextFile(g_pathUndolog, 1, false, -1);
  let result2 = '';

  // ログを一行づつ読み出して整形
  while (!writeFile.AtEndOfStream) {
    const [proc2, lineR1] = writeFile.ReadLine().split('\u0009');

    // Skipなら次の行へ
    if (proc2 === 'Skip') {
      continue;
    }

    const lineR2 = writeFile.ReadLine().split('\u0009')[1];
    result2 += `Move\u0009${lineR2}\u000D\u000A` +
                  ` ->\u0009${lineR1}\u000D\u000A`;
  }

  // 置換結果を書き出してutf16leで上書きする
  writeFile = fso.OpenTextFile(g_pathUndolog, 2, true, -1);
  writeFile.Write(result2);
  writeFile.Close();
};

run[g_order]();

