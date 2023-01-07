//!*script
/** 
 * polyfill
 *
 * ↓読み込み用のコード
 * Function('return ' + PPx.Extract('%*script(%\'scr\'%\\module\\pf_object.js)') + '()')();
 *
 * Object { keys }
 */

// https://jonlabelle.com/snippets/view/javascript/ecmascript-5-polyfills
// ES5 15.2.3.14 Object.keys ( O )
// https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Object/keys
PPx.Result = function () {
  if (!Object.keys) {
    Object.keys = function (o) {
      if (o !== Object(o)) {
        throw TypeError('Object.keys called on non-object');
      }
      var ret = [],
        p;
      for (p in o) {
        if (Object.prototype.hasOwnProperty.call(o, p)) {
          ret.push(p);
        }
      }
      return ret;
    };
  }
};
