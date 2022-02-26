//!*script
/**
 * PPx表示位置調節
 *
 * PPx.Arguments(
 *  0: b | c | e    ;スクリプト終了後のフォーカス
 *  1: b | c        ;ppb、ppcのどちらにppeを重ねるか
 *  2: top | bottom ;ppeの上下位置
 * )
 * ※ 'e'を指定した時は位置調整だけで左右の移動は行わない
 */

'use strict';

/////////* 初期設定 *////////////

// 画面の使用領域
const DISP_X = { 'START': 10, 'END': 1360 };   // 横軸[始点, 終点]
const DISP_Y = { 'START': 10, 'END': 720 };    // 縦軸[始点, 終点]

// PPb[A]がなかったときのPPcのローテーション。
// キー名は順番、3つでなくてもいい。値は*windowpositionの'X,Y'
const ROTATER = {
  1: '700,300',
  2: '320,100',
  3: '700,0'
};

/////////////////////////////////

const g_ppcId  = (() => {
  const id = PPx.Extract('%n#');
  return id ? `${id}#` : PPx.Extract('%n');
})();

const g_hwnd = ((id = g_ppcId) => ({
  b: PPx.Extract('%*extract(%%NBA)')|0,
  c: PPx.Extract(`%*Extract(%%N${id})`)|0,
  e: PPx.Extract('%*findwindowclass(PPeditW)')|0
}))();

// PPb[A]がなかった時
if (g_hwnd.b === 0) {
  let cpos = PPx.Extract('%su"c_pos"')|0;
  cpos = (cpos < Object.keys(ROTATER).length && cpos) + 1;

  PPx.Execute(`*windowposition %N${g_ppcId},${ROTATER[cpos]}`);
  PPx.Execute(`*string u,c_pos=${cpos}`);
  PPx.Quit(1);
}

if (PPx.Arguments.length < 3) {
  throw new Error('引数が足りません');
}

const g_args = ((a0, a1, a2) => {
  const error = (num) => {
    throw new Error(`第${num}引数が間違っています`);
  };

  if (a0 !== 'b' && a0 !== 'c' && a0 !== 'e') {
    error(1);
  }
  if (a1 !== 'b' && a1 !== 'c') {
    error(2);
  }
  if (a2 !== 'top' && a2 !== 'bottom') {
    error(3);
  }

  return {
    focus: a0,
    sync: a1,
    posE: a2
  };
})(PPx.Arguments(0), PPx.Arguments(1), PPx.Arguments(2));

// 窓の位置情報
class Cfield {
  constructor(zero, end, bWH, eWH, cW) {
    this.zero = zero;
    this.end = end;
    this.bWH = bWH|0;
    this.eWH = eWH|0;
    this.cW = cW|0;
    this.length = end - zero;
  }
  get hor() {
    return {b: this.zero + this.cW, c: this.zero + this.bWH};
  }
  get vert() {
    return {
      top: {x: this.zero + this.eWH, e: this.zero},
      bottom: {x: this.zero, e: this.length - g_height_e}
    }[g_args.posE];
  }
}

const g_height_e = (g_hwnd.e !== 0) ? PPx.Extract(`%*windowrect(${g_hwnd.e},h)`) : 0;
PPx.Execute(`*focus #${g_hwnd.b}`);
const g_rect_b = {
  wide: PPx.Extract(`%*windowrect(${g_hwnd.b},w)`),
  height: PPx.Extract(`%*windowrect(${g_hwnd.b},h)`)
};

const run = (() => {
  const focus = g_args.focus;
  const flag = PPx.Extract('%sp"togglepos"')|0;
  const hwnd = {
    'b': g_hwnd.b,
    'c': g_hwnd.c,
    'e': g_hwnd.e
  }[focus];

  const move = () => {
    const w = new Cfield(DISP_X.START, DISP_X.END, g_rect_b.wide, 0, PPx.Extract(`%*windowrect(${g_hwnd.c},w)`));
    const h = new Cfield(DISP_Y.START, DISP_Y.END, g_rect_b.height, g_height_e, 0);
    const x = {
      'b': () => ({ l: g_hwnd.b, r: g_hwnd.c, wide1: w.hor['c'], wide2: w.hor['b'] }),
      'c': () => ({ l: g_hwnd.c, r: g_hwnd.b, wide1: w.hor['b'], wide2: w.hor['c'] })
    }[g_args.sync]();

    const leftPPc = () => {
      PPx.Execute('*string p,togglepos=1');
      PPx.Execute(`*windowposition ${x.l}, ${w.zero}, ${h.vert['x']}`);
      PPx.Execute(`*windowposition ${x.r}, ${x.wide1}, ${h.zero}`);
      if (g_hwnd.e !== 0) {
        PPx.Execute(`*windowposition ${g_hwnd.e}, ${w.zero}, ${h.vert['e']}`);
      }
    };

    const rightPPc = () => {
      PPx.Execute('*string p,togglepos=2');
      PPx.Execute(`*windowposition ${x.l}, ${x.wide2}, ${h.vert['x']}`);
      PPx.Execute(`*windowposition ${x.r}, ${w.zero}, ${h.zero}`);
      if (g_hwnd.e !== 0) {
        PPx.Execute(`*windowposition ${g_hwnd.e}, ${x.wide2}, ${h.vert['e']}`);
      }
    };

    if (g_hwnd.e !== 0) {
      PPx.Execute(`*windowsize ${g_hwnd.e},${x.wide1},${g_height_e}`);
    }

    (flag === 2) ? leftPPc() : rightPPc();
  };

  return {
    focus: hwnd,
    move: move
  };
})();

run.move();
PPx.Execute(`*pptray -c *focus #${run.focus}`);

