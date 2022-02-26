//!*script
/**
 * 引数で与えられたパスの階層を一つ上へ補完
 *
 * PPx.Arguments(
 *  0: 補完候補ファイルパス
 * )
 */

PPx.Result = (function () {
  // 補完候補ファイルのパスを決定
  var pathComplist = PPx.Arguments.length ?
    PPx.Arguments(0) :
    PPx.Extract('%\'temp\'%\\ppx_comppath.txt');

  /**
   * 編集中文字列からコマンドと基準パスを分離整形
   * ※補完パスがルートならコマンド側に分離する
   * divTexts = [
   *  0: 行頭がパス以外の文字であれば代入
   *  1: コマンドとパスの間に"があれば代入
   *  2: 文字列中の親ディレクトリに相当する部分を代入
   * ]
   */
  var divTexts = (function () {
    // 編集中文字列の",をエスケープ
    var text = PPx.Extract('%*edittext');
    var rep = /[",]/g;
    var fmt = {'"': '""', ',': '@#@'};
    var text_ = text.replace(rep, (function (chr) { return fmt[chr]; }));
    text_ = text_.replace(/^([^\\]*\s)?(.*\\)(?!$).*/, function (match, p1, p2) {
      return ~p2.indexOf('"') ?
        [p1, '"', p2.slice(1)] :
        [p1, '', p2];
    });

    return text_.split(',');
  })();

  if (typeof divTexts[2] === 'undefined') {
    // 半角スペースを含む文字列の処理
    // ? 半角スペース以降を削除 : 全削除;
    divTexts[0] = ~divTexts[0].indexOf(' ') ? divTexts[0].split(' ')[0] : '';

  } else if (PPx.Extract('%W').slice(0,10) === 'Jumppath..') {
    // 実行元がパス移動一行編集なら補完リストを生成して読み込む
    PPx.Execute(
      '*execute C,*whereis -path:"' + divTexts[2] + '" -listfile:' + pathComplist +
        ' -mask:"a:d" -dir:on -subdir:off -name'
    );
    PPx.Execute(
      '*completelist -file:' + pathComplist
    );
  }

  return '"' + divTexts.join('').replace('@#@', ',') + '"';
})();

