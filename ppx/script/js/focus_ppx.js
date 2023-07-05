//!*script
/**
 * Private selectppx command
 *
 * @arg {string} 0 - Specify PPx. Same as %*ppxlist() options
 */

var MENU_NAME = 'M_tempfocusppx';
var MENU_PPE = 'PP&e';

var id_name = PPx.windowIDName;
var ppe_hwnd = PPx.Extract('%*findwindowclass(PPeditW)');

var correct_arg = function (prefix) {
  var reg = /^(C|V|B|#|C#[#A-Z]?)$/;

  if (prefix !== '' && !reg.test(prefix)) {
    PPx.Echo('select_ppx.js: Invalid argument specified.');
    PPx.Quit(1);
  }

  return prefix;
};

var array_match = function (arr, target) {
  for (var i = 0, l = arr.length; i < l; i++) {
    if (arr[i] == target) {
      return true;
    }
  }
};

var arr_id = (function () {
  var arg = PPx.Arguments.length ? PPx.Arguments.item(0) : '';
  var spec = correct_arg(arg);
  var arr = PPx.Extract('%*ppxlist(-' + spec + ')') .slice(0, -1) .split(',');
  // arr.sort((a, b) => (a.toLowerCase() < b.toLowerCase() ? -1 : 1));

  if (ppe_hwnd !== '0') {
    arr.push(MENU_PPE);
  }

  return arr;
})();

if (array_match(arr_id, id_name)) {
  if (arr_id.length <= 1) {
    PPx.Quit(1);
  } else if (arr_id.length === 2) {
    arr_id.splice(array_match(arr_id, id_name), 1);
    PPx.Execute('*focus ' + arr_id);
    PPx.Quit(1);
  }
}

var menu_items = [];
var this_id;
var get_filename = function (id, path) {
  return PPx.Extract('%*extract(' + id + ',"' + path + '")')
    .slice(-30)
    .replace(/\\t/g, '\\\\t');
};

var select_ppx = {
  'cs': function () {
    var ppcust_hwnd = PPx.Extract('%*findwindowtitle("PPx Customizer")');

    return menu_items.push('*setcust ' + MENU_NAME + ':PPcus&t = #' + ppcust_hwnd);
  },
  'PP': function () {
    return menu_items.push('*setcust ' + MENU_NAME + ':' + MENU_PPE + ' = #' + ppe_hwnd);
  },
  'C_': function () {
    return menu_items.push(
      '*setcust ' +
        MENU_NAME +
        ':' +
        this_id.replace('_', ':&') +
        ' ' +
        get_filename(this_id, '%%FD') +
        '= ' +
        this_id
    );
  },
  'V_': function () {
    return menu_items.push(
      '*setcust ' +
        MENU_NAME +
        ':' +
        this_id.replace('_', ':&') +
        ' ' +
        get_filename(this_id, '%%FC') +
        '= ' +
        this_id
    );
  },
  'B_': function () {
    return menu_items.push(
      '*setcust ' + MENU_NAME + ':' + this_id.replace('_', ':&') + ' = ' + this_id
    );
  }
};

var item_count = arr_id.length;

if (item_count === 1) {
  PPx.Execute('*focus ' + arr_id[0]);
  PPx.Quit(1);
}

for (var i = 0, l = item_count; i < l; i++) {
  this_id = arr_id[i];

  if (this_id === id_name || this_id === 'TRA') {
    continue;
  } else {
    select_ppx[this_id.substring(0, 2)]();
  }
}

PPx.Execute(menu_items.join('%:'));
PPx.Execute('%k"down"%:*focus %' + MENU_NAME);
PPx.Execute('*deletecust "' + MENU_NAME + '"');
