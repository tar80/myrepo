//!*script
// deno-lint-ignore-file no-var
/**
 * 一行編集上で編集中の文字の選択状態を操作する
 * ・引数は正規表現で指定
 *    prev:選択範囲の前の文字列を指定
 *    select:選択する文字列を指定
 * ・PPXMES.DLLが必要
 * ・参照元:https://egg.5ch.net/test/read.cgi/software/1476708638/405-411
 *
 * PPx.Arguments(
 *  0: "(prev)(select)"
 * )
 */

var text = PPx.Extract('%*edittext()').replace(/"/, '""');
var reg = new RegExp(PPx.Arguments(0));
var match = text.match(reg);
if (match === null) {
  PPx.SetPopLineMessage('[ setSel.js: no match. ]');
  PPx.Quit(1);
}

var lparam = match[1].length + match[2].length;
var wparam = (match[2] !== '') ? text.lastIndexOf(match[2]) : match[1].length;
PPx.Execute('*sendmessage %N,177,' + wparam + ',' + lparam);

