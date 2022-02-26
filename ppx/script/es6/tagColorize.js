//!*script
/**
 * タグに色づけしてTEMP_FILEに出力
 */

'use strict';

const TEMP_FILE = PPx.Extract("%'temp'%\\ppxtags.tmp");

const st = PPx.CreateObject('ADODB.stream');
const g_tags = (() => {
  // タグリスト読み込み
  let tags = [];
  st.Open;
  st.Type = 2;
  st.Charset = 'UTF-8';
  st.LoadFromFile(PPx.Extract('%su"taglist"'));
  tags = st.ReadText(-2).split('\u000A');
  st.Close;

  return tags.map(v => v.split(' ;'));
})();

const g_comments = PPx.Entry.comment.split(' ');

let result = [];
for (let i = g_comments.length; i--;) {
  let thisTag = g_comments[i];
  for (let [tag, ,color] of g_tags.values()) {
    if (~thisTag.indexOf(tag) && color !== undefined) {
      thisTag = `[${color}m${tag}[0m`;
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

