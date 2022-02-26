//!*script
/**
 * GitRepositoryのルートパスをリスト化
 */

/////////* 初期設定 *////////////

// 検索するパス
var GIT_REPOSITORY = [
  'C:\\git\\tar80\\',
  'D:\\Apps\\vim\\vimfiles'
].join(';');
var FILE_NAME = 'GITREPOSITORIES.TXT';
var LIST_PATH = PPx.Extract("%'list'%\\" + FILE_NAME);

/////////////////////////////////

PPx.Execute(
  '*whereis -mask:a:dh,".git" -path:"' + GIT_REPOSITORY + '" -dir -name -listfile:"' + LIST_PATH + '" %&'
);

var fso = PPx.CreateObject('Scripting.FileSystemObject');
var readFile = fso.OpenTextFile(LIST_PATH, 1, false, -1);
var newList = [];

do {
  newList.push(readFile.ReadLine().replace('\\.git\\', ''));
} while (!readFile.AtEndOfStream);

readFile = fso.OpenTextFile(LIST_PATH, 2, true, -1);
readFile.Write(newList.join('\u000D\u000A'));
readFile.Close();

PPx.Execute('*linemessage Update  ' + FILE_NAME);
PPx.Execute('*completelist -file:' + LIST_PATH);

