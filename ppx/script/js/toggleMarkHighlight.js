//!*script
/**
 * マークとハイライトをトグル
 * ※非推奨。連続実行するとPPcがハングする場合あり
 * ・参照元:http://hoehoetukasa.blogspot.com/2015/08/blog-post.html
 *
 * PPx.Arguments(
 *  0: ハイライトの色番号。指定がなければ1を代入
 */

var g_hlNum = PPx.Arguments.length ? PPx.Arguments(0)|0 : 1;

// 今回変更するエントリの色情報
var g_saveHl = [];

// 前回変更したエントリの色情報
var changeHl = (function () {
  var obj = {};
  var m = [];
  var info = PPx.Extract('%*extract(%%si"enHl_%n")').split(',');
  for (var i = info.length; i--;) {
    if (info[i] !== '') {
      m = info[i].split(':');
      obj[m[0].slice(1, -1)] = m[1].slice(1, -1);
    }
  }
  return obj;
})();

var toggle = {
  1: function (num, entry) {
    entry.Mark = 0;
    var thisColor = (function () {
      if (typeof changeHl[num] === 'undefined') {
        // ハイライト番号の指定がなければ引数の番号を割り振る
        return {
          cmd: 'Highlight',
          num: g_hlNum
        };
      }

      // 変更する色情報を取得
      var colorState = changeHl[num].split('');

      // 前回のハイライト状態を復元
      return (colorState[0] === 'S') ?
        {cmd: 'State', num: colorState[1]} :
        {cmd: 'Highlight', num: colorState[0]};
    })();

    entry[thisColor.cmd] = thisColor.num;
  },

  0: function (num, entry) {
    var thisMark = (function () {
      if (entry.State > 3) {
        return 'S' + entry.State;
      }

      return  entry.Highlight || null;
    })();

    if (thisMark === null) {
      return;
    }

    g_saveHl += '"' + num + '":"' + thisMark +'",';
    entry.Mark = 1;
    entry.Highlight = 0;
  }
};

for (var i = 0, l = PPx.EntryDisplayCount; i < l; i++) {
  var thisEntry = PPx.Entry(i);
  toggle[thisEntry.Mark](i, thisEntry);
}

// 今回変更したハイライト状態を保存
PPx.Execute(
  '*string i,enHl_%n=' + g_saveHl.slice(0, -1)
);

// ディレクトリ移動時にハイライト情報を破棄
PPx.Execute(
  '*linecust JsToggleMH_%n,' +
    'KC_main:LOADEVENT,*ifmatch !0,0%%si"enHl_%n" %%: *string i,enHl_%n= %%: *linecust JsToggleMH_%n,KC_main:LOADEVENT,' +
    ' %: %K"@LOADCUST"'
);

