//!*script
/**
 * タグに色づけしてTEMP_FILEに出力
 */

var TEMP_FILE = PPx.Extract("%'temp'%\\ppxtags.tmp");

var st = PPx.CreateObject('ADODB.stream');
var g_tags = (function () {
  // タグリスト読み込み
  var tags = [];
  st.Open;
  st.Type = 2;
  st.Charset = 'UTF-8';
  st.LoadFromFile(PPx.Extract('%su"taglist"'));
  tags = st.ReadText(-2).split('\u000A');
  st.Close;

  return tags;
})();

var g_comments = PPx.Entry.comment.split(' ');

var result = [];
for (var i = 0, l = g_comments.length; i < l; i++) {
  var thisTag = g_comments[i];
  for (var j = g_tags.length; j--;) {
    var v = (function (data) {
      var data_ = data.split(' ;');
      return {
        tag: data_[0],
        color: data_[2]
      }
    })(g_tags[j]);

    if (~thisTag.indexOf(v.tag) && v.color !== undefined) {
      thisTag = '[' + v.color + 'm' + v.tag + '[0m';
    }
  }

  result.push(thisTag);
}

// 結果を書き出して上書き
st.Open;
st.Type = 2;
st.Charset = 'UTF-8';
st.Position = 0;
st.WriteText(result.join(' '));
st.SaveToFile(TEMP_FILE, 2);
st.Close;

PPx.Result = TEMP_FILE;

