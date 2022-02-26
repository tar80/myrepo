//!*script
/**
 * PPxにカラーテーマを適用する
 *  1.色設定が上書きされるのでバックアップを取っておく
 *  2.https://windowsterminalthemes.dev/ で気に入った色テーマを"Get theme"する
 *  3.クリップボードに設定がコピーされるのでそのままこのスクリプトを実行
 */

'use strict';

/////////* 初期設定 *////////////

// 設定ファイルを作成する場所
const THEME_DIR_PATH = '%\'cfg\'%\\theme';

// 色設定を適用するPPxアプリケーション
const APPLY_PPC = false;
const APPLY_PPV = true;
const APPLY_PPB = false;

/**
 * 色設定
 * 使用できる色は以下20色
 * 暗い色:    BLACK, RED, GREEN, YELLOW, BLUE, PURPLE, CYAN, WHITE
 * 明るい色: BBLACK,BRED,BGREEN,BYELLOW,BBLUE,BPURPLE,BCYAN,BWHITE
 * 背景: BG, 通常色: FG, 選択項目背景: SEL_BG, カーソル: CUR
 */

// PPc
const BACKGROUND = 'C_back = BG';
const FOREGROUND = 'C_mes = CYAN';
const TREE  = '; CC_tree = FG,BG';
const TIP   = 'C_tip = BLUE,I_BG';
const LOG   = 'CC_log = GREEN,BG';
//                      message,".","..",label,dir,system,hidden,readonly,normal,archive,link,virtual,enc,special
const ENTRY = 'C_entry = BGREEN,_AUTO,_AUTO,RED,CYAN,BRED,BBLACK,BGREEN,BWHITE,BBLUE,BPURPLE,BBLACK,RED,PURPLE';
const EINFO = 'C_eInfo = GREEN,RED,_AUTO,_AUTO,BLUE,BBLUE,SEL_BG,CUR,CUR,SEL_BG,_AUTO,BBLACK,_AUTO,BBLUE,BGREEN,BYELLOW,BCYAN,BPURPLE,BRED,BWHITE,_AUTO';

// PPv
const EDGELINE  = 'CV_boun = _AUTO';
const LINECUR   = 'CV_lcsr = CUR';
const LINENUM   = 'CV_lnum = CYAN,PURPLE';
const SPECIAL   = 'CV_lbak = _AUTO,_AUTO,BPURPLE';
const CTRL      = 'CV_ctrl = YELLOW';
const LINEFMT   = 'CV_lf   = YELLOW';
const TAB       = 'CV_tab  = YELLOW';
const SPACE     = 'CV_spc  = PURPLE';
const LINK      = 'CV_link = BLUE';
const SYMBOL    = 'CV_syn  = BPURPLE,BYELLOW';
const HIGHLIGHT = '; CV_hili = BBLUE,BYELLOW,BGREEN,BCYAN,CUR,BPURPLE,BRED,CYAN,RED';
const VCOLOR    = 'CV_char = BBLACK,BRED,BGREEN,BBLUE,BYELLOW,BCYAN,BPURPLE,BWHITE,_AUTO,RED,GREEN,BLUE,YELLOW,CYAN,PURPLE,WHITE';

// PPb
const BCOLOR = 'CB_pals = BG,BLUE,GREEN,CYAN,RED,PURPLE,YELLOW,WHITE,BBLACK,BRED,BGREEN,BBLUE,BYELLOW,BCYAN,BPURPLE,BWHITE';

//////////////////// ////////////

const g_clipedTheme = PPx.Clipboard.toLowerCase().replace(/#([a-f0-9]{2})([a-f0-9]{2})([a-f0-9]{2})/g,'H$3$2$1');
{
  // クリップボード一行目からテーマを判別
  const checkChr = g_clipedTheme.charCodeAt(0) + g_clipedTheme.charCodeAt(1) + g_clipedTheme.charCodeAt(2);
  if (checkChr !== 146 && checkChr !== 165 && checkChr !== 168) {
    PPx.Echo('クリップボードから色情報を取得できませんでした');
    PPx.Quit(-1);
  }
}

// クリップボードの内容を整形して色リストを取得
const g_setCfg = (() => {
  let title;
  const colors = JSON.parse(g_clipedTheme);
  const list = ['A_color = {'];
  const colorItem = {
    'name': v => title = v.replace(' ', '-'),
    'background': v => list.push('BG = ' + v.toUpperCase()),
    'foreground': v => list.push('FG = ' + v.toUpperCase()),
    'selectionbackground': v => list.push('SEL_BG = ' + v.toUpperCase()),
    'cursorcolor': v => list.push('CUR = ' + v.toUpperCase())
  };

  for (const [key, value] of Object.entries(colors)) {
    if (colorItem[key] !== undefined) {
      colorItem[key](value);
      continue;
    }

    list.push(`${key} = ${value}`.replace('bright', 'b').toUpperCase());
  }

  list.push('}');
  return {title: title, ele: list};
})();

// 確認ダイアログ。中止で終了
!PPx.Execute(`%"テーマの生成"%Q"${g_setCfg.title} を生成します"`) || PPx.Quit(1);

// themeディレクトリがなければ作る
if (PPx.Extract(`%*result(exists,${THEME_DIR_PATH})`) === '0') {
  PPx.Execute(`*makedir ${THEME_DIR_PATH}`);
}

// メニューに設定を追加
PPx.Execute(`*setcust M_themeSub:${g_setCfg.title}=*setcust @${THEME_DIR_PATH}%\\${g_setCfg.title}.cfg`);

const g_appC = APPLY_PPC ? '' : '; ';
g_setCfg.ele.push(g_appC + BACKGROUND);
g_setCfg.ele.push(g_appC + FOREGROUND);
g_setCfg.ele.push(g_appC + TREE);
g_setCfg.ele.push(g_appC + TIP);
g_setCfg.ele.push(g_appC + LOG);
g_setCfg.ele.push(g_appC + ENTRY);
g_setCfg.ele.push(g_appC + EINFO);

const g_appV = APPLY_PPV ? '' : '; ';
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

const g_appB = APPLY_PPB ? '' : '; ';
g_setCfg.ele.push(g_appB + BCOLOR);

const g_cfgColor = g_setCfg.ele.join('\u000D\u000A');
const st = PPx.CreateObject('ADODB.stream');
st.Open;
st.Type = 2;
st.Charset = 'UTF-8';
st.WriteText(g_cfgColor);
st.SaveToFile(`${PPx.Extract(THEME_DIR_PATH)}\\${g_setCfg.title}.cfg`, 2);
st.Close;

