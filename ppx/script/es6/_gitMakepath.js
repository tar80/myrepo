//!*script
/**
 * GitRepositoryのルートパスをリスト化
 */

/////////* 初期設定 *////////////

// 検索するパス
const GIT_REPOSITORY = [
  'C:\\bin\\HOME',
  'C:\\bin\\repository;C:\\bin\\Scoop'
].join(';');
const FILE_NAME = 'GITREPOSITORIES.TXT';
const LIST_PATH = PPx.Extract(`%'list'%\\${FILE_NAME}`);

/////////////////////////////////

PPx.Execute(
  `*whereis -mask:a:dh,".git" -path:"${GIT_REPOSITORY}" -dir -name -listfile:"${LIST_PATH}" %&`
);

{
  const fso = PPx.CreateObject('Scripting.FileSystemObject');
  let readFile = fso.OpenTextFile(LIST_PATH, 1, false, -1);
  const newList = [];

  while (!readFile.AtEndOfStream) {
    newList.push(readFile.ReadLine().replace('\\.git\\', ''));
  }

  readFile = fso.OpenTextFile(LIST_PATH, 2, true, -1);
  readFile.Write(newList.reduce((p, c) => `${p}\u000D\u000A${c}`));
  readFile.Close();
}

PPx.Execute(`*linemessage Update  ${FILE_NAME}`);
PPx.Execute(`*completelist -file: ${LIST_PATH}`);


