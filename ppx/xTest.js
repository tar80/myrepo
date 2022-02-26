//!*script

'use strict';

/* 画像サイズ取得 */
// const imgSize = PPx.Entry.Information.replace(/[\s\S]*大きさ\s:\D*(\d*)\sx\s(\d*)[\s\S]*/g, '$1,$2').split(',');
// const str = (imgSize[0] - imgSize[1] < 0)
//           ? '(&W)'
//           : '縦(&H)';
// const fso = PPx.CreateObject('Scripting.FileSystemObject');
// const st = PPx.CreateObject('ADODB.stream');
// const sh = PPx.CreateObject('WScript.Shell');
// String内の引数と同じ文字数をカウント
// String.prototype.counter = function (seq) { return this.split(seq).length - 1; };
/* objectの中身を参照 */
// PPx.Echo(JSON.stringify(value));
//======================================================================


var a = PPx.Extract('%*name(C,' + PPx.scriptname + ')');
PPx.Echo(a);

//======================================================================
// var test = (name, callback) => {
//   // for (var i = 0; i < cnt; i++) {
//   //   arr[i] = String(i);
//   // }
//
//   var start = Date.now();
//   callback();
//   var end = Date.now();
//   PPx.SetPopLineMessage( name + ' = ' + (end - start) + 'ミリ秒' );
// };
//
// var cnt = 2000;
// // var arr = new Array(cnt);
//
// const a = 'C:\\bin\\ppxdw64\\doc\\PPX.TXT';
// test('1', () => {
//   const fso = PPx.CreateObject('Scripting.FileSystemObject');
//   for (var i =0; i < cnt; i++) {
//     fso.openTextFile(a);
//     fso.Close;
//   }
// });
//
// test('2', () => {
//   const st = PPx.CreateObject('ADODB.stream');
//   for (var i =0; i < cnt; i++) {
//     st.Open;
//     // st.Type = 2;
//     // st.Charset = 'UTF-8';
//     st.LoadFromFile(a);
//     st.Close;
//   }
// });
// test('1', () => {
//   for (var i =0; i < cnt; i++) {
//     PPx.Execute('*wait 0 %: *wait 0');
//   }
// });
//
// test('2', () => {
//   for (var i =0; i < cnt; i++) {
//     PPx.Execute('*wait 0');
//     PPx.Execute('*wait 0');
//   }
// });
// // // test('for', () => {
// // //   for (var i=0; i<cnt; i++){
// // //     result = result[i] + arr[i];
// // //   }
// // // });
// //
// // test('forin', () => {
// //   var result = '';
// //   for (var i in arr) {
// //     result = result + ~i.indexOf('1');
// //   }
// // });
// //
// // test('forof', () => {
// //   var result = '';
// //   for (var i of arr) {
// //     result = result + ~i.indexOf('1');
// //   }
// // });
