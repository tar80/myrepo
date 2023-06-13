//!*script
/**
 * Use mpv for Entrytip preview
 *
 * arg 0 Entrytip width
 * arg 1 Entrytip height
 *
 */

var MPV_PATH = 'mpv.exe';
var TIP_WIDTH = 300;
var TIP_HEIGHT = 180;

var saved_stip = PPx.Extract('%*getcust(X_stip)');
var new_stip = (function (args) {
  var size = [TIP_WIDTH, TIP_HEIGHT];
  var ary = saved_stip.split(',');

  for (var i = 0; i < args.length; i++) {
    size[i] = args(i);
  }

  ary[6] = size[0];
  ary[7] = size[1];

  return ary.join(',');
})(PPx.Arguments);

PPx.Execute('*customize X_stip=' + new_stip);
PPx.Execute('*wait 0,2')
PPx.Execute('*entrytip preview -c %%Obd ' + MPV_PATH + ' "%si\'TipTarget\'" --wid=%%N-F');
PPx.Execute('*wait 0,2')
PPx.Execute('*customize X_stip=' + saved_stip);
