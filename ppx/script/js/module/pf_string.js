//!*script
/**
 * polyfill
 *
 * ↓読み込み用のコード
 * Function('return ' + PPx.Extract('%*script(%\'scr\'%\\module\\pf_string.js)') + '()')();
 *
 * String.prototype { repeat, trim, counter }
 */

PPx.Result = function () {
  // Stringを引数回リピート
  if (!String.prototype.repeat) {
    String.prototype.repeat = function(count) {
      if (this == null)
        throw new TypeError('can\'t convert ' + this + ' to object');

      var str = '' + this;
      // To convert string to integer.
      count = +count;
      // Check NaN
      if (count != count)
        count = 0;

      if (count < 0)
        throw new RangeError('repeat count must be non-negative');

      if (count == Infinity)
        throw new RangeError('repeat count must be less than infinity');

      count = Math.floor(count);
      if (str.length == 0 || count == 0)
        return '';

      // Ensuring count is a 31-bit integer allows us to heavily optimize the
      // main part. But anyway, most current (August 2014) browsers can't handle
      // strings 1 << 28 chars or longer, so:
      if (str.length * count >= 1 << 28)
        throw new RangeError('repeat count must not overflow maximum string size');

      var maxCount = str.length * count;
      count = Math.floor(Math.log(count) / Math.log(2));
      while (count) {
        str += str;
        count--;
      }
      str += str.substring(0, maxCount - str.length);
      return str;
    };
  }

  /**
   * String.prototype.trim() polyfill
   * https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/Trim#Polyfill
   */

  if (!String.prototype.trim) {
    String.prototype.trim = function () {
      return this.replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, '');
    };
  }

  // String内の引数と同じ文字数をカウント。最大max回
  if (!String.prototype.counter) {
    String.prototype.counter = function (seq, max) {
      var i = this.split(seq).length - 1;
      var _max = max || 100;
      return (i < _max) ? i : _max;
    };
  }
};
