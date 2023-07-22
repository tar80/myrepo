//!*script
/**
 * Private selectppx command
 *
 * @arg {string} 0 - Specify PPx. Same as %*ppxlist() options
 */

if (PPx.getValue('selectppx') === '1') PPx.Quit(1);

const MENU_NAME = 'M_tempselectppx';
const MENU_PPE = 'PP&e';

const id_name = PPx.windowIDName;
const ppe_hwnd = PPx.Extract('%*findwindowclass(PPeditW)');

const correct_arg = (prefix) => {
  const reg = /^(C|V|B|#|##)$/;

  if (prefix !== '' && !reg.test(prefix)) {
    PPx.Echo('select_ppx.js: Invalid argument specified.');
    PPx.Quit(1);
  }

  return prefix;
};

const arr_id = (() => {
  const arg = PPx.Arguments.length ? PPx.Arguments.item(0) : '';
  const spec = correct_arg(arg);
  const arr = PPx.Extract(`%*ppxlist(-${spec})`).slice(0, -1).split(',');
  arr.sort((a, b) => (a.toLowerCase() < b.toLowerCase() ? -1 : 1));

  if (ppe_hwnd !== '0') {
    arr.push(MENU_PPE);
  }

  return arr;
})();

if (~arr_id.indexOf(id_name)) {
  if (arr_id.length <= 1) {
    PPx.Quit(1);
  } else if (arr_id.length === 2) {
    arr_id.splice(arr_id.indexOf(id_name), 1);
    PPx.Execute(`*selectppx ${arr_id}`);
    PPx.Quit(1);
  }
}

const get_filename = function (id, path) {
  return PPx.Extract(`%*extract(${id},"${path}")`).slice(-30).replace(/\\t/g, '\\\\t');
};

let this_id;
const menu_items = [];
const select_ppx = {
  'cs': function () {
    const ppcust_hwnd = PPx.Extract('%*findwindowtitle("PPx Customizer")');

    return menu_items.push(`*setcust ${MENU_NAME}:PPcus&t = #${ppcust_hwnd}`);
  },
  'PP': function () {
    return menu_items.push(`*setcust ${MENU_NAME}:${MENU_PPE} = #${ppe_hwnd}`);
  },
  'C_': function () {
    const filename = get_filename(this_id, '%%FD');

    return menu_items.push(
      `*setcust ${MENU_NAME}:${this_id.replace('_', ': &')} ${filename} = ${this_id}`
    );
  },
  'V_': function () {
    const filename = get_filename(this_id, '%%FC');

    return menu_items.push(
      `*setcust ${MENU_NAME}:${this_id.replace('_', ': &')} ${filename} = ${this_id}`
    );
  },
  'B_': function () {
    return menu_items.push(`*setcust ${MENU_NAME}:${this_id.replace('_', ': &')} = ${this_id}`);
  }
};

const item_count = arr_id.length;

if (item_count === 1) {
  PPx.Execute(`*selectppx ${arr_id[0]}`);
  PPx.Quit(1);
}

for (let i = 0, l = item_count; i < l; i++) {
  this_id = arr_id[i];

  if (this_id === id_name || this_id === 'TRA') {
    continue;
  } else {
    select_ppx[this_id.substring(0, 2)]();
  }
}

PPx.setValue('selectppx', 1);
PPx.Execute(menu_items.join('%:'));
PPx.Execute(`%k"down"%:*selectppx %${MENU_NAME}`);
PPx.Execute(`*deletecust "${MENU_NAME}"`);
PPx.Execute('%K"@LOADCUST"');
PPx.Execute('*wait 1000,2');
PPx.setValue('selectppx', '')
