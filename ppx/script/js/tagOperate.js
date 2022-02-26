//!*script
/**
 * コメントにタグを付けたり外したり
 *
 * PPx.Arguments(
 *  0: push | remove
 *  1: tags
 * )
 */

var g_args = (function () {
  if (PPx.Arguments.length === 0) {
    PPx.Echo('引数が足りません');
    PPx.Quit(-1);
  }

  return {
    order: PPx.Arguments(0),
    tags: PPx.Arguments(1).split(' ')
  };
})();

var cmd = {};
cmd['push'] = function (cmnts) {
  var cmnts1 = (cmnts.length === 0) ? g_args.tags : cmnts.split(' ').concat(g_args.tags);
  var exist = {};
  var newCmnts = [];
  for (var i = 0, l = cmnts1.length; i < l; i++) {
    var thisComment = cmnts1[i];
    if (!exist[thisComment]) {
      exist[thisComment] = true;
      newCmnts.push(thisComment);
    }
  }

  return newCmnts.sort(function (a, b) {
    return (a.toLowerCase() < b.toLowerCase()) ? -1 : 1;
  });
};

cmd['remove'] = function (cmnts) {
  var cmnts2 = cmnts.split(' ');
  var i, l;

  // 編集結果(削除するタグ)の重複チェック
  // var exist = {};
  // var rmTags = [];
  // for (i = 0, l = g_args.tags.length; i < l; i++) {
  //   var thisComment = g_args.tags[i];
  //   if (!exist[thisComment]) {
  //     exist[thisComment] = true;
  //     rmTags.push(thisComment);
  //   }
  // };

  for (i = 0, l = g_args.tags.length; i < l;i++) {
    var tag = g_args.tags[i];
    for (var j = 0, k = cmnts2.length; j < k; j++) {
      if (cmnts2[j] === tag) {
        cmnts2.splice(j, 1);
      }
    }
  }

  return cmnts2;
};

var thisEntry = PPx.Entry;
thisEntry.FirstMark;
do {
  var thisComment = (function () { return cmd[g_args.order](thisEntry.comment); })();

  thisEntry.comment = thisComment.join(' ');
} while (thisEntry.NextMark);

PPx.Execute('*color back');

