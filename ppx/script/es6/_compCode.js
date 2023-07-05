//!*script
/**
 * 編集文字列の補完。コマンド使用時、"%が消費される問題の対策
 *
 * PPx.Arguments(
 *  0: 'i'=%*input() | 's'=%*selecttext()  | 'e'=%*edittext()
 *    ・二文字目以降があればeditmodeに設定する。
 *    ※二文字目がREOSの場合、三文字目が必要になる。
 *      例) "iOh" => *input(-mode:Oh)
 *  1: 補完対象文字
 *    ・【"%\】は二文字以上の偶数個で指定する。
 *    ・【"】は記述した半分の数が戻る。【%\】は記述したそのままの数が戻る。
 *    ・アルファベットと数字を引数にした場合、単純に数が倍になる。カンマは使えない。
 *        例)引数,"abcABC122333""%%%%\\\\\\"と記述したとき、abcABC123"%\ -> aabbccAABBCC112222333333"%%%%\\\\\\
 *    ・補完対象文字の重複カウント数最大値(COUNT_MAX)は4回。
 *  2: inputバーのタイトル
 *    ・引数が空なら"compCode.."が代入される
 *  3: %*input()のオプション-k以降に実行するコマンド
 * )
 */

'use strict';

const NL_CHAR = '\r\n';
// 補完対象文字の重複カウント最大値
const COUNT_MAX = 4;

PPx.Result = (() => {
  const argLength = PPx.Arguments.length;
  if (argLength < 2) {
    PPx.Echo('引数が足りません');
    PPx.Quit(-1);
  }

  const infoEdit = (() => {
    const id = PPx.Arguments(0);
    const keys = 'gpvnmshdcfuxUXREOS';
    const reg = /PP[BCV]\[/;
    let whistory;

    // 呼び出し元が編集状態なら保存ヒストリ種類を参照
    if (!reg.test(PPx.Extract('%W'))) {
      whistory = PPx.Extract('%*editprop(whistory)');
    }

    // 編集モードを設定
    const editmode = whistory || 'g';

    return {
      chr: PPx.Arguments(1),
      title: (argLength > 2) && PPx.Arguments(2) || 'compCode..',
      precmd: (argLength > 3) ? PPx.Arguments(3) : '',
      type: id.charAt(0),
      mode: (keys.indexOf(id.charAt(1)) > 0) ? id.substring(1) : editmode
    };
  })();

  const input = PPx.Extract(function () {
    try {
      return {
        i: () => `%OP %*input("%*selecttext" -title:"${infoEdit.title}" -mode:${infoEdit.mode} -k ${infoEdit.precmd})`,
        s: () => '%*selecttext',
        e: () => '%*edittext'
      }[infoEdit.type]();

    } catch (err) {
      PPx.Echo('compCode.js: 第一引数が範囲外です');
      PPx.Quit(-1);
    }
  }()) || PPx.Quit(-1);

  // 重複した文字をまとめる
  const chrs = Array.from(new Set(infoEdit.chr));

  // String内のseqと同じ文字数をカウント。最大max回
  String.prototype.counter = function (seq, max) {
    const i = this.split(seq).length - 1;
    return Math.min(i, max);
  };

  // 補完対象文字の置換リストを作成
  const fmt = chrs.reduce((chr, value) => {
    // 文字の重複回数を取得
    chr[value] = value.repeat(function (ele) {
      // 同じ文字数のカウント
      const count = infoEdit['chr'].counter(value, COUNT_MAX);
      // 例外処理
      if (ele === '\\') {
        return count;
      }

      return count * 2;
    }(value));

    return chr;
  }, {});

  const compChr = `[${chrs.join('')}]`.replace(/\\/, '\\\\');
  const reg = new RegExp(compChr, 'g');

  return input.replace(reg, c => fmt[c]);
})();

