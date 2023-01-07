//!*script
/**
 * utf8-lfで保存ファイルに追記
 */

PPx.Execute('*editmode -lf -codepage:65001 %: *replace %*edittext');
var text = PPx.Extract('%*edittext');
var filename = PPx.Extract('%se"filename"');

var st = PPx.CreateObject('ADODB.stream');
st.Open;
st.Type = 2;
st.Charset = 'UTF-8';
st.LoadFromFile(filename);

var textline = st.ReadText(-1).split('\u000A');
var omitByte = -1;
for (var i = textline.length; i-- ;) {
  if (textline[i] !== '') {
    if (textline.length - 1 === i) {
      omitByte = 0;
      text = '\u000A' + text;
    }

    break;
  }

  omitByte = omitByte + 1;
}

// 結果を書き出してメニューを上書き
st.Position = st.Size - omitByte;
st.SetEOS;
st.WriteText(text, 1);
st.SaveToFile(filename, 2);
st.Close;

