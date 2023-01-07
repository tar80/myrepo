//!*script
/**
 * PPxにカラーテーマを適用する
 *  1.色設定が上書きされるのでバックアップを取っておく
 *  2.https://windowsterminalthemes.dev/ で気に入った色テーマを"Get theme"する
 *  3.クリップボードに設定がコピーされるのでそのままこのスクリプトを実行
 */

/////////* 初期設定 *////////////

// 設定ファイルを作成する場所
var THEME_DIR_PATH = '%\'cfg\'%\\theme';

// 色設定を適用するPPxアプリケーション
var APPLY_PPC = false;
var APPLY_PPV = false;
var APPLY_PPB = false;

/**
 * 色設定
 * 使用できる色は以下20色
 * 暗い色:    BLACK, RED, GREEN, YELLOW, BLUE, PURPLE, CYAN, WHITE
 * 明るい色: BBLACK,BRED,BGREEN,BYELLOW,BBLUE,BPURPLE,BCYAN,BWHITE
 * 背景: BG, 通常色: FG, 選択項目背景: SEL_BG, カーソル: CUR
 */

// PPc
var BACKGROUND = 'C_back = BG';
var FOREGROUND = 'C_mes = CYAN';
var TREE  = '; CC_tree = FG,BG';
var TIP   = 'C_tip = BLUE,I_BG';
var LOG   = 'CC_log = GREEN,BG';
//                      message,".","..",label,dir,system,hidden,readonly,normal,archive,link,virtual,enc,special
var ENTRY = 'C_entry = BGREEN,_AUTO,_AUTO,RED,CYAN,BRED,BBLACK,BGREEN,BWHITE,BBLUE,BPURPLE,BBLACK,RED,PURPLE';
var EINFO = 'C_eInfo = GREEN,RED,_AUTO,_AUTO,BLUE,BBLUE,SEL_BG,CUR,CUR,SEL_BG,_AUTO,BBLACK,_AUTO,BBLUE,BGREEN,BYELLOW,BCYAN,BPURPLE,BRED,BWHITE,_AUTO';

// PPv
var EDGELINE  = 'CV_boun = _AUTO';
var LINECUR   = 'CV_lcsr = CUR';
var LINENUM   = 'CV_lnum = CYAN,PURPLE';
var SPECIAL   = 'CV_lbak = _AUTO,_AUTO,BPURPLE';
var CTRL      = 'CV_ctrl = YELLOW';
var LINEFMT   = 'CV_lf   = YELLOW';
var TAB       = 'CV_tab  = YELLOW';
var SPACE     = 'CV_spc  = PURPLE';
var LINK      = 'CV_link = BLUE';
var SYMBOL    = 'CV_syn  = BPURPLE,BYELLOW';
var HIGHLIGHT = '; CV_hili = BBLUE,BYELLOW,BGREEN,BCYAN,CUR,BPURPLE,BRED,CYAN,RED';
var VCOLOR    = 'CV_char = BBLACK,BRED,BGREEN,BBLUE,BYELLOW,BCYAN,BPURPLE,BWHITE,_AUTO,RED,GREEN,BLUE,YELLOW,CYAN,PURPLE,WHITE';

// PPb
var BCOLOR = 'CB_pals = BG,BLUE,GREEN,CYAN,RED,PURPLE,YELLOW,WHITE,BBLACK,BRED,BGREEN,BBLUE,BYELLOW,BCYAN,BPURPLE,BWHITE';

//////////////////// ////////////

var g_cliedTheme = PPx.Clipboard.toLowerCase().replace(/#([a-f0-9]{2})([a-f0-9]{2})([a-f0-9]{2})/g,'H$3$2$1');

// クリップボードの改行コードを取得
var g_returnCode = function (v) {
  var checkChr = v.charCodeAt(0) + v.charCodeAt(1) + v.charCodeAt(2);
  var code = {
    146: '\u000D\u000A',
    165: '\u000A',
    168: '\u000D'
  }[checkChr];

  if (typeof code === 'undefined') {
    PPx.Echo('クリップボードから色情報を取得できませんでした');
    PPx.Quit(-1);
  }

  return code;
}(g_cliedTheme);

// クリップボードの内容を整形して色リストを取得
var g_setCfg = (function() {
  var title;
  var list = ['A_color = {'];
  var colors = g_cliedTheme.split(g_returnCode);
  var colorItem = {
    'name': function (v) { return title = v.replace(' ', '-'); },
    'background': function (v) { return list.push('BG = ' + v.toUpperCase()); },
    'foreground': function (v) { return list.push('FG = ' + v.toUpperCase()); },
    'selectionbackground': function (v) { return list.push('SEL_BG = ' + v.toUpperCase()); },
    'cursorcolor': function (v) { return list.push('CUR = ' + v.toUpperCase()); }
  };

  for (var i = 1, l = colors.length - 1; i < l; i++) {
    var m = colors[i].match(/^[\s]*"(.*)":\s"(.*)"/);
    if (typeof colorItem[m[1]] !== 'undefined') {
      colorItem[m[1]](m[2]);
      continue;
    }

    list.push((m[1] + ' = ' + m[2]).replace('bright', 'b').toUpperCase());
  }

  list.push('}');
  return {title: title, ele: list};
})();

// 確認ダイアログ。中止で終了
!PPx.Execute('%"テーマの生成"%Q"' + g_setCfg.title + ' を生成します"') || PPx.Quit(1);

// themeディレクトリがなければ作る
if (PPx.Extract('%*result(exists,' + THEME_DIR_PATH + ')') === '0') {
  PPx.Execute('*makedir ' + THEME_DIR_PATH);
}

// メニューに設定を追加
PPx.Execute('*setcust M_themeSub:' + g_setCfg.title + '=*setcust @' + THEME_DIR_PATH + '%\\' + g_setCfg.title + '.cfg');

var g_appC =APPLY_PPC ? '' : '; ';
g_setCfg.ele.push(g_appC + BACKGROUND);
g_setCfg.ele.push(g_appC + FOREGROUND);
g_setCfg.ele.push(g_appC + TREE);
g_setCfg.ele.push(g_appC + TIP);
g_setCfg.ele.push(g_appC + LOG);
g_setCfg.ele.push(g_appC + ENTRY);
g_setCfg.ele.push(g_appC + EINFO);

var g_appV = APPLY_PPV ? '' : '; ';
g_setCfg.ele.push(g_appV + EDGELINE);
g_setCfg.ele.push(g_appV + LINECUR);
g_setCfg.ele.push(g_appV + LINENUM);
g_setCfg.ele.push(g_appV + SPECIAL);
g_setCfg.ele.push(g_appV + CTRL);
g_setCfg.ele.push(g_appV + LINEFMT);
g_setCfg.ele.push(g_appV + TAB);
g_setCfg.ele.push(g_appV + SPACE);
g_setCfg.ele.push(g_appV + LINK);
g_setCfg.ele.push(g_appV + SYMBOL);
g_setCfg.ele.push(g_appV + HIGHLIGHT);
g_setCfg.ele.push(g_appV + VCOLOR);

var g_appB = APPLY_PPB ? '' : '; ';
g_setCfg.ele.push(g_appB + BCOLOR);

var g_cfgColor = g_setCfg.ele.join('\u000D\u000A');
var st = PPx.CreateObject('ADODB.stream');
st.Open;
st.Type = 2;
st.Charset = 'UTF-8';
st.WriteText(g_cfgColor);
st.SaveToFile(PPx.Extract(THEME_DIR_PATH + '%\\') + g_setCfg.title + '.cfg', 2);
st.Close;

