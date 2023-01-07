//!*script
/**
 * Tab key to move windows
 *
 * @arg 0 Ignore PPc. 0 | 1
 * @arg 1 Ignore PPv. 0 | 1
 * @arg 2 Ignore PPb. 0 | 1
 * @arg 3 Focus between PPc/PPv if SyncView is enabled. 0 | 1
 * @arg 4 Activate the opposite window when a single pane. 0 | 1
 * @arg 5 Move panes ignoring tabs. Valid only if each pane is an independent tab. 0 | 1
 * @arg 6 Next or Previous. 0 | 1
 */

'use strict';

const script_name = PPx.scriptName;

const errors = (method) => {
  PPx.Execute(`*script "%*name(D,"${script_name}")\\errors.js",${method},${script_name}`);
  PPx.Quit(-1);
};

const g_order = ((args = PPx.Arguments()) => {
  const len = args.length;

  if (len <= 6) {
    errors('arg');
  }

  const sequence = {
    0: {prev: -1, next: 1},
    1: {prev: 1, next: -1}
  }[args.Item(6)];

  return {
    ppc: args.Item(0) | 0,
    ppv: args.Item(1) | 0,
    ppb: args.Item(2) | 0,
    syncview: args.Item(3) | 0,
    opwin: args.Item(4) | 0,
    tab: args.Item(5) | 0,
    seq: sequence
  };
})();

const g_id = (() => {
  const id = PPx.WindowIDName;
  const subId = id.split('_');

  return {
    win: id,
    syncpair: subId[0] === 'C' ? 'V' : 'C',
    sub: subId[1]
  };
})();

/* Select valid IDs */
const enable_id = (() => {
  const c = g_order.ppc === 0 ? PPx.Extract('%*ppxlist(-C)') : '';
  const v = g_order.ppv === 0 ? PPx.Extract('%*ppxlist(-V)') : '';
  const b = g_order.ppb === 0 ? PPx.Extract('%*ppxlist(-B)') : '';

  return (c + v + b).slice(0, -1).split(',');
})();

/* Response to SyncView */
if (g_order.syncview === 1 && g_order.ppv === 0) {
  const sync = PPx.Extract(`%*extract(C${g_id.sub},"%%*js(PPx.Result=PPx.SyncView;)")`) | 0;

  if (sync !== 0) {
    PPx.Execute(`*focus ${g_id.syncpair}_${g_id.sub}`);
    PPx.Quit(1);
  }
}

/* Response to combo with no opposite window */
if (PPx.Pane.Count === 1 && g_order.ppc === 0 && g_order.opwin === 1) {
  PPx.Execute('%K"@F6');
  PPx.Quit(1);
}

const target_id = (id = enable_id) => {
  id.sort((a, b) => (a < b ? g_order.seq.prev : g_order.seq.next));

  let returnID = id[id.indexOf(g_id.win) + 1] || id[0];

  if (g_order.ppc === 0 && g_order.tab === 1) {
    const eachTab = PPx.Extract('%*getcust(X_combos)').slice(18, 19);

    if (eachTab !== '1') {
      return returnID;
    }

    const skipTabs = [];
    const tabExtraction = (tab) => {
      for (let j = 0, k = tab.length; j < k; j++) {
        const thisTab = tab(j).IDName;

        if (thisTab !== tab(-1).IDName) {
          skipTabs.push(tab(j).IDName);
        }
      }
    };

    tabExtraction(PPx.Pane(-2).Tab);

    if (PPx.Pane.Count > 0 && skipTabs.includes(returnID)) {
      returnID = PPx.Extract('%~n');
    }

    tabExtraction(PPx.Pane(-3).Tab);

    for (let i = id.indexOf(g_id.win) + 1, l = id.length; i < l; i++) {
      const thisId = id[i];

      if (!~skipTabs.findIndex((v) => v === thisId)) {
        return thisId;
      }
    }
  }

  return returnID;
};

PPx.Execute(`*focus ${target_id()}`);
