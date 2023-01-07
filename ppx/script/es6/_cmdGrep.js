//!*script
/**
 * grep結果を出力
 *
 * PPx.Arguments(
 *  0: 出力ファイル
 *  1: grep | jvgrep | rg | gitgrep ;初期選択grepコマンド
 *  2: LF | PPv | vim               ;初期選択出力先
 *  3: 1=オプション再登録 | 2=M_grepを削除して終了
 * )
 */

'use strict';

/////////* 初期設定 *////////////

// マークなしの時の選択対象
// 0=カーソルエントリ, 1=親ディレクトリ
const NO_MARK_TARGET = 1;

/**
 * USE:   使用するコマンド(Boolean)
 * CMD:   grepコマンド
 * OP:    アウトプット(LF|PPv)
 * LOCK:  オプション固定値
 * ADD:   オプション可変値
 * COMPLIST: オプション補完候補リスト
 * ※ADDの記述はマイナス(-)で始まる場合スペースを１つ入れる
 */
let g_listGrep = {
  grepLF: {
    USE: false,
    CMD: 'grep',
    OP: 'LF',
    LOCK: '-nH',
    ADD: 'irEC1 --color=never',
    COMPLIST: 'GREPOPTION.TXT'
  },
  grepPPv: {
    USE: false,
    CMD: 'grep',
    OP: 'PPv',
    LOCK: '-nH',
    ADD: 'irEC1 --color=never',
    COMPLIST: 'GREPOPTION.TXT'
  },
  rgLF: {
    USE: true,
    CMD: 'rg',
    OP: 'LF',
    LOCK: '-nH --no-heading',
    ADD: ' --color never -C1 -Li',
    COMPLIST: 'RGOPTION.TXT'
  },
  rgPPv: {
    USE: false,
    CMD: 'rg',
    OP: 'PPv',
    LOCK: '-nH --no-heading',
    ADD: ' --color always -C1 -Li',
    COMPLIST: 'RGOPTION.TXT'
  },
  jvgrepLF: {
    USE: false,
    CMD: 'jvgrep',
    OP: 'LF',
    LOCK: '-nr',
    ADD: ' --color=never -GI -B1 -i',
    COMPLIST: 'JVGREPOPTION.TXT'
  },
  jvgrepPPv: {
    USE: true,
    CMD: 'jvgrep',
    OP: 'PPv',
    LOCK: '-nr',
    ADD: ' --color=always -GI -B1 -i',
    COMPLIST: 'JVGREPOPTION.TXT'
  },
  gitgrepLF: {
    USE: true,
    CMD: 'git grep',
    OP: 'LF',
    LOCK: '-nH',
    ADD: 'irEC1 --color=never',
    COMPLIST: 'GITGREPOPTION.TXT'
  },
  gitgrepPPv: {
    USE: false,
    CMD: 'git grep',
    OP: 'PPv',
    LOCK: '-nH',
    ADD: 'irEC1 --color=always',
    COMPLIST: 'GITGREPOPTION.TXT'
  },
  grepvim: {
    USE: false,
    CMD: 'grep',
    OP: 'vim',
    LOCK: '-nH',
    ADD: 'irE --color=never',
    COMPLIST: 'GREPOPTION.TXT'
  },
  rgvim: {
    USE: true,
    CMD: 'rg',
    OP: 'vim',
    LOCK: '--vimgrep -i',
    ADD: '',
    COMPLIST: 'RGOPTION.TXT'
  }
};

/////////////////////////////////

const g_args = (() => {
  const len = PPx.Arguments.length;
  const arg4 = len === 4 && PPx.Arguments(3);
  if (len < 3) {
    PPx.Echo('引数が足りません');
    PPx.Quit(-1);
  }

  if (arg4 === '2') {
    PPx.Execute('*deletecust "M_grep"');
    PPx.SetPopLineMessage('Delete > M_grep');
    PPx.Quit(-1);
  }

  return {
    length: len,
    listfile: PPx.Arguments(0),
    cmd: PPx.Arguments(1),
    output: PPx.Arguments(2),
    isReload: !!arg4
  };
})();

// 実行するgrep処理を取得
const g_grep = g_listGrep[g_args.cmd + g_args.output];
{
  // grepメニュー内容を取得
  const infoMenu = PPx.Extract('%*getcust(M_grep)').split('\u000D\u000A');

  // PPxへのgrepメニュー登録
  if (infoMenu.length === 3 || g_args.isReload) {
    for (const [key, value] of Object.entries(g_listGrep)) {
      const thisGrep = value;
      if (thisGrep.USE) {
        PPx.Execute(
          `%OC *setcust M_grep:${key}=*string i,cmd=${thisGrep.CMD}
            *string i,gopt=${thisGrep.LOCK}${thisGrep.ADD}
            *string e,lock=${thisGrep.LOCK}
            *string e,add=${thisGrep.ADD}
            *string e,list=${thisGrep.COMPLIST}
            *string e,flen=${thisGrep.LOCK.length}
            *string e,blen=${thisGrep.LOCK.length + thisGrep.ADD.length}
            *string i,output=${thisGrep.OP}`
        );
      } else {
        PPx.Execute(`*deletecust "M_grep:${key}"`);
      }
    }
  }
}

g_listGrep = null;

const st = PPx.CreateObject('ADODB.stream');

// 親ディレクトリの取得
const g_infoPath = ((nmt = NO_MARK_TARGET) => {
  const dirType = PPx.DirectoryType;
  const vwd = PPx.Extract('%FDV');
  let wd = PPx.Extract('%FD');
  let path = PPx.Extract(nmt === 1 ? '' : '%R');
  let isFlag = 0;

  if (~vwd.indexOf('aux:')) {
    isFlag = 2;

    if (g_args.cmd === 'gitgrep') {
      wd =
        PPx.Extract('%si"repoRoot"') ||
        PPx.Extract("%*script(%'scr'%\\module\\repoStat.js)").split(',')[0];
    } else {
      // カレントがaux:時
      wd = wd.replace(/^aux:(\/\/)?S_[^\\/]*[\\/](.*)/, (_match, p1, p2) => {
        if (/\/\//.test(p1)) {
          // ローカルでなければ終了
          PPx.Echo('非対応ディレクトリ');
          PPx.Quit(-1);
        }

        return p2;
      });
    }
  } else if (dirType === 4) {
    isFlag = 1;

    // カレントがリストファイル時
    st.Open;
    st.Type = 2;
    st.Charset = 'UTF-16LE';
    st.LoadFromFile(vwd);
    st.LineSeparator = -1;
    st.SkipLine = 1;
    wd = st.ReadText(-2);
    st.Close;

    // Baseパスの取得
    wd = ~wd.indexOf(';Base=')
      ? wd.replace(/^;Base=(.*)\|\d*/, '$1')
      : PPx.Extract('%*name(D,"%FDC")');
  }

  // grep対象の決定
  if (PPx.EntryMarkCount) {
    path = '%#FCB';
    if (isFlag === 2) {
      let hash;
      if (~vwd.indexOf('S_git-log')) {
        hash = '%*name(C,%#FC)';
        path = '';
      } else {
        hash = '%si"commithash"';
      }

      PPx.Execute(`*string i,git_string=${hash}`);
    }
  } else if (isFlag !== 0) {
    !PPx.Execute('%"確認"%Q"' + wd + 'を対象にgrepを実行します"') || PPx.Quit(-1);
  }

  return {
    wd: wd,
    entry: path,
    type: dirType
  };
})();

// optionボタンの設定
PPx.Execute(
  '*string i,Edit_OptionCmd=*string i,gopt=%%*input("%%se"lock"%%se"add""' +
    ' -title:"Option  ※%%se"lock"は外さないこと※" -mode:e -select:%%se"flen",%%se"blen"' +
    ' -k *completelist -set -detail:"user 2user1" -file:"%%\'list\'\\%%se"list"") %%:' +
    ' *setcaption [%%si"output"] %%si"cmd" %%si"gopt"  ※\\=\\\\\\\\'
);

const deleteSi = () => {
  PPx.Execute(
    '*execute %n,*string i,cmd= %%: *string i,gopt= %%: *string i,Edit_OptionCmd= %%: *string i,git_string='
  );
};

// 検索文字の入力とエスケープ処理
const g_searchKey = (() => {
  const quit = () => {
    deleteSi();
    PPx.Quit(-1);
  };

  return (
    PPx.Extract(
      // compCode.js, 補完対象, 補完文字, 一行編集タイトル, 起動時実行
      "%*script(%'scr'%\\compCode.js," +
        '"iOs",' +
        '"""%%",' +
        `"[${g_args.output}] ${g_args.cmd} ${g_grep.LOCK}${g_grep.ADD} ※\\=\\\\\\\\",` +
        `"*mapkey use,K_cmdGrepMap %%%%: *linemessage %si'git_string' %%%%: *execute %%%%%%%%M_grep,!${g_args.cmd}${g_args.output}")`
    ) || quit(-1)
  );
})();

// 検索語内の正規表現エスケープ文字を文字に変換
const g_keyWord = ((str) => {
  const fmt = {
    '\\^': '^',
    '\\(': '(',
    '\\)': ')',
    '\\[': '[',
    '\\]': ']',
    '\\s': ' ',
    '\\+': '+',
    '\\?': '?',
    '\\.': '.',
    '\\t': '\u0009'
  };

  const str_ = str.replace(/\^?([^$]*)\$?/, '$1');
  return str_.replace(/(\\)(.)/g, (match, p1, p2) => fmt[match] || fmt[p1] + p2);
})(g_searchKey);

const run = {};
run['vim'] = () => {
  const listfilePath = `${g_args.listfile}vim`;
  PPx.Execute(
    `%Od *run -noppb -d:"${g_infoPath.wd}"` +
      ` %si"cmd" %si"gopt" "${g_searchKey}" %si"git_string" ${g_infoPath.entry}` +
      ` > ${listfilePath} %& *string i,git_string=`
  );
  // %Oxオプションでは最大化できなかったため、winposとlines columnsで窓を調整
  PPx.Execute(
    `%Obd gvim "+winpos 0 0|set lines=40 columns=130|cfile ${listfilePath}|copen|set nowrap|/${g_searchKey}/`
  );
};

run['PPv'] = () => {
  // 一時的にキャレットモードに変更
  PPx.Execute(
    '*linecust tmod,KV_main:CLOSEEVENT,*setcust XV_tmod=%*getcust(XV_tmod) %%:' +
      ' *linecust tmod,KV_main:CLOSEEVENT,'
  );
  PPx.Execute('*setcust XV_tmod=1');

  // grepの結果をPPvの標準入力で受け取る
  PPx.Execute(
    `%Od *run -noppb -d:"${g_infoPath.wd}"` +
      ` %si"cmd" %si"gopt" "${g_searchKey}" %si"git_string" ${g_infoPath.entry}` +
      ` | %0ppvw -bootid:w -esc -document -utf8 -k *string p,grep=1 %%: *find "${g_keyWord}"`
  );
};

run['LF'] = () => {
  const commithash = PPx.Extract('%si"git_string');
  const hasCommit = !!commithash;
  const commithash_ = hasCommit ? `${commithash}@@@` : '';
  // リストのヘッダー
  const newList = [
    ';ListFile',
    `;Base=${g_infoPath.wd}|${g_infoPath.type}`,
    `"file","line",A:H5,C:0.0,L:0.0,W:0.0,S:0.0,H:0,M:0,T:"result => ${commithash_}${g_keyWord}"`
  ];

  // grepの結果を出力
  PPx.Execute(
    `%Od *run -noppb -d:"${g_infoPath.wd}"` +
      ` %si"cmd" %si"gopt" "${g_searchKey}" ${commithash} ${g_infoPath.entry}` +
      ` > ${g_args.listfile} %&`
  );

  st.Open;
  st.Type = 2;
  st.Charset = 'UTF-8';
  st.LoadFromFile(g_args.listfile);

  // grepの結果を読み出して整形
  const grepResults = st.ReadText(-1).split('\u000A');
  const replacer = {
    'false': (value) => {
      value.replace(/^([^.]*[^-:]*)[-:](\d*)([-:])\s*(.*)/, (_match, p1, p2, p3, p4) => {
        p1 = p1 === '' ? p3 : p1;
        p3 = ~p3.indexOf(':') ? 0 : 3;
        p4 = p4.replace(/"/g, '""');
        newList.push(`"${p1}","${p2}",A:H${p3},C:0.0,L:0.0,W:0.0,S:0.0,H:0,M:0,T:"${p4}"`);
      });
    },
    'true': (value) => {
      value.replace(
        /^([0-9a-zA-Z]{7}):([^.]*[^-:]*)[-:](\d*)([-:])\s*(.*)/,
        (_match, p1, p2, p3, p4, p5) => {
          p2 = p1 === '' ? p4 : p2;
          p4 = ~p4.indexOf(':') ? 0 : 3;
          p5 = p5.replace(/"/g, '""');
          newList.push(`"${p2}","${p3}",A:H${p4},C:0.0,L:0.0,W:0.0,S:0.0,H:0,M:0,T:"${p5}"`);
        }
      );
    }
  }[hasCommit];

  for (const line of grepResults) {
    replacer(line);
  }

  // 結果を書き出して上書き
  st.Position = 0;
  st.WriteText(newList.reduce((p, c) => `${p}\u000D\u000A${c}`));
  st.SaveToFile(g_args.listfile, 2);
  st.Close;
};

run[PPx.Extract('%si"output"')]();
deleteSi();
