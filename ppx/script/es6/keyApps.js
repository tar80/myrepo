//!*script
/**
 * 右クリックメニュー拡張子判別
 *
 * PPx.Arguments(
 *  0: M_Ccr | M_FileMOVE | M_FileCOPY
 * )
 */

'use strict';

/////////* 初期設定 *////////////

// 拡張子判別
const ITEMS = {
  dir: ['DIR'],
  arc: ['7Z', 'CAB', 'LZH', 'MSI', 'RAR', 'ZIP'],
  img: ['BMP', 'EDG', 'GIF', 'JPEG', 'JPG', 'PNG', 'VCH'],
  doc: ['AHK', 'INI', 'CFG', 'JS', 'JSON', 'LOG', 'MD', 'TXT', 'VIM']
};

// 選択キー
const KEYS = {
  dir: 'W',
  arc: 'W',
  img: 'L',
  doc: 'R',
  list: 'J',
  arch: 'O',
  none: 'R'
};

////////////////////////////////

if (!PPx.Arguments.length) {
  PPx.Echo('引数が足りません');
  PPx.Quit(-1);
}

const g_menuOrder = PPx.Arguments(0);

// 拡張子を大文字で取得する
const g_fileType = (PPx.GetFileInformation(PPx.Extract('%R')) === ':DIR') ?
  'DIR' :
  PPx.Extract('%t').toUpperCase();

// メニュー毎の初期選択キー
const g_menu = (() => {
  for (const [item, value] of Object.entries(ITEMS)) {
    if (~value.indexOf(g_fileType)) {
      return {type: item, key: KEYS[item]};
    }
  }

  return {type: 'none', key: KEYS['none']};
})();

// カレントディレクトリの属性に応じて処理を分岐
const getMenu = (list, arch) => {
  let dirType = PPx.DirectoryType;
  if (dirType === 4 && PPx.Extract('%si"RootPath') !== '') {
    dirType = 'AUX';
  }

  switch (dirType) {
    case 'AUX':
      PPx.Execute('%M_Caux,C');
      break;

    case 4:
      PPx.Execute(`*setcust M_Clist:Ext=??M_U${g_menu.type} %: %M_Clist,${list}`);
      break;

    case 80:
      PPx.Execute('%M_Chttp');
      break;

    case 62:
    case 64:
    case 96:
      PPx.Execute(`%M_Carc,${arch}`);
      break;


    default:
      PPx.Execute(`*setcust M_Ccr:Ext=??M_U${g_menu.type} %: %${g_menuOrder},${g_menu.key}`);
      break;
  }
};

if (g_menuOrder === 'M_Ccr') {
  // 標準メニュー
  getMenu(KEYS['list'], KEYS['arch']);
} else {
  // ファイル移動メニュー
  g_menu.key = (g_menuOrder === 'M_FileMOVE') ? 'M' : 'C';
  getMenu(g_menu.key, g_menu.key);
}

