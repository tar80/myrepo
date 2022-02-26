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

/////////* 初期設定 *////////////

// 画面の使用領域
var DISP_X = {START: 10, END: 1000}; // 横軸[始点, 終点]
var DISP_Y = {START: 10, END: 720}; // 縦軸[始点, 終点]

// PPb[A]がなかったときのPPcのローテーション。
// キー名は順番、3つでなくてもいい。値は*windowpositionの'X,Y'
var ROTATER = {
  1: '700,300',
  2: '320,100',
  3: '700,0'
};

// PPb[A]がなかったときのPPcのローテーション。
// キー名は順番、3つでなくてもいい。値は*windowpositionの'X,Y'
var ROTATER = {
  1: '700,300',
  2: '320,100',
  3: '700,0'
};

/////////////////////////////////

var g_ppcId = (function () {
  var id = PPx.Extract('%n#');
  return id ? id + '#' : PPx.Extract('%n');
})();

var g_hwnd = (function () {
  return {
    b: PPx.Extract('%*extract(%%NBA)') | 0,
    c: PPx.Extract('%*Extract(%%N' + g_ppcId + ')') | 0,
    e: PPx.Extract('%*findwindowclass(PPeditW)') | 0
  };
})();

// PPb[A]がなかった場合
if (g_hwnd.b === 0) {
  var cpos = PPx.Extract('%su"c_pos"') | 0;
  var key_num = 0;
  var hop = Object.prototype.hasOwnProperty;
  for (var key in ROTATER) {
    if (hop.call(ROTATER, key)) {
      key_num++;
    }
  }
  cpos = (cpos < key_num && cpos) + 1;

  PPx.Execute('*windowposition %N' + g_ppcId + ',' + ROTATER[cpos]);
  PPx.Execute('*string u,c_pos=' + cpos);
  PPx.Quit(1);
}

if (PPx.Arguments.length < 3) {
  throw new Error('引数が足りません');
}

var g_args = (function (a0, a1, a2) {
  var error = function (num) {
    throw new Error('第' + num + '引数が間違っています');
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
function Cfield(zero, end, bWH, eWH, cW) {
  this.zero = zero;
  this.end = end;
  this.bWH = bWH | 0;
  this.eWH = eWH | 0;
  this.cW = cW | 0;
  this.length = end - zero;
  this.hor = {b: this.zero + this.cW, c: this.zero + this.bWH};
  this.vert = {
    'top': {x: this.zero + this.eWH, e: this.zero},
    'bottom': {x: this.zero, e: this.length - g_height_e}
  }[g_args.posE];
}

var g_height_e = g_ppcId.e !== 0 ? PPx.Extract('%*windowrect(' + g_ppcId.e + ',h)') | 0 : 0;
PPx.Execute('*focus #' + g_hwnd.b);
var g_rect_b = {
  wide: PPx.Extract('%*windowrect(' + g_hwnd.b + ',w)'),
  height: PPx.Extract('%*windowrect(' + g_hwnd.b + ',h)')
};

var run = (function () {
  var focus = g_args.focus;
  var flag = PPx.Extract('%sp"togglepos"') | 0;
  var hwnd = {
    'b': g_hwnd.b,
    'c': g_hwnd.c,
    'e': g_hwnd.e
  }[focus];

  var move = function () {
    var w = new Cfield(
      DISP_X.START,
      DISP_X.END,
      g_rect_b.wide,
      0,
      PPx.Extract('%*windowrect(' + g_hwnd.c + ',w)')
    );
    var h = new Cfield(DISP_Y.START, DISP_Y.END, g_rect_b.height, g_height_e, 0);
    var x = {
      b: function () {
        return {l: g_hwnd.b, r: g_hwnd.c, wide1: w.hor['c'], wide2: w.hor['b']};
      },
      c: function () {
        return {l: g_hwnd.c, r: g_hwnd.b, wide1: w.hor['b'], wide2: w.hor['c']};
      }
    }[g_args.sync]();

    var leftPPc = function () {
      PPx.Execute('*string p,togglepos=1');
      PPx.Execute('*windowposition ' + x.l + ', ' + w.zero + ', ' + h.vert['x']);
      PPx.Execute('*windowposition ' + x.r + ', ' + x.wide1 + ', ' + h.zero);
      if (g_hwnd.e !== 0) {
        PPx.Execute('*windowposition ' + g_hwnd.e + ', ' + w.zero + ', ' + h.vert['e']);
      }
    };

    var rightPPc = function () {
      PPx.Execute('*string p,togglepos=2');
      PPx.Execute('*windowposition ' + x.l + ', ' + x.wide2 + ', ' + h.vert['x']);
      PPx.Execute('*windowposition ' + x.r + ', ' + w.zero + ', ' + h.zero);
      if (g_hwnd.e !== 0) {
        PPx.Execute('*windowposition ' + g_hwnd.e + ', ' + x.wide2 + ', ' + h.vert['e']);
      }
    };

    if (g_hwnd.e !== 0) {
      PPx.Execute('*windowsize ' + g_hwnd.e + ',' + x.wide1 + ',' + g_height_e);
    }

    if (focus === 'e') {
      flag === 2 ? rightPPc() : leftPPc();
    } else {
      flag === 2 ? leftPPc() : rightPPc();
    }
  };

  return {
    focus: hwnd,
    move: move
  };
})();

run.move();
PPx.Execute('*pptray -c *focus #' + run.focus);
