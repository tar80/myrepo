//!*script
/**
 * utf8-lfで保存ファイルに追記
 */

'use strict';

PPx.Execute('*editmode -lf -codepage:65001 %: *replace %*edittext');
let text = PPx.Extract('%*edittext');
const filename = PPx.Extract('%se"filename"');

const st = PPx.CreateObject('ADODB.stream');
st.Open;
st.Type = 2;
st.Charset = 'UTF-8';
st.LoadFromFile(filename);

const textline = st.ReadText(-1).split('\u000A');
let omitByte = -1;
for (let i = textline.length; i-- ;) {
  if (textline[i] !== '') {
    if (textline.length - 1 === i) {
      omitByte = 0;
      text = `\u000A${text}`;
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

