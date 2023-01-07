//!*script
// deno-lint-ignore-file no-var
/**
 * module git log
 */

var objArg = {
  order: PPx.Arguments(0), // module name
  root: PPx.Arguments(1), // git root path
  listfile: PPx.Arguments(2), // listfile path
  commit: PPx.Arguments(3), // refs hash
  logmax: PPx.Arguments(4), // git log maximum acquisitions
  diffUnified: PPx.Arguments(5) // diff unified
};

var arrHeader = function (root, name) {
  return [';ListFile', ';Base=' + root + '|1,;git-' + name];
};

var loadADODB = function (listfile, callback) {
  var _objSt = PPx.CreateObject('ADODB.stream');
  _objSt.Mode = 3;
  _objSt.Type = 2;
  _objSt.Charset = 'UTF-8';
  _objSt.LineSeparator = 10;
  _objSt.Open;
  _objSt.LoadFromFile(listfile);
  _objSt.Position = 0;

  var _objHOP = Object.prototype.hasOwnProperty;
  var result = callback(_objSt, _objHOP);

  _objSt.Close;

  _objSt.Open;
  _objSt.WriteText(result.join('\u000D\u000A'));
  _objSt.SaveToFile(listfile, 2);
  _objSt.Close;
  _objSt = null;
};

var get = {};
get['status'] = function (root, listfile, commit, logmax, unified) {
  PPx.Execute('*cd ' + root + ' %: %On *ppb -c git status --porcelain -uall >' + listfile + ' %&');
  var _arrListS = arrHeader(root, 'status');
  loadADODB(listfile, function (stream, hop) {
    do {
      stream.ReadText(-2).replace(/^(.)(.)\s(.*)/, function (match, p1, p2, p3) {
        var p4 = (function () {
          var _objColorS = {' ': 1, 'D': 2, '!': 3};
          for (var key in _objColorS) {
            if (hop.call(_objColorS, key)) {
              if (~p2.indexOf(key)) {
                return _objColorS[key];
              }
            }
          }

          return 8;
        })();

        _arrListS.push(
          '"' + p3 + '","",A:H' + p4 + ',C:0.0,L:0.0,W:0.0,S:0.0,R:0.0,H:0,M:0,T:"' + p1 + p2 + '"'
        );
      });
    } while (!stream.EOS);

    return _arrListS;
  });

  return;
};

get['log'] = function (root, listfile, commit, logmax, unified) {
  PPx.Execute(
    '*cd ' +
      root +
      ' %:' +
      '%On *ppb -c git log -n' +
      logmax +
      ' --all --date=short --graph --format="%%OD%%%%h @[%%%%ad]@ %%%%d%%%%s%%OD-" >"' +
      listfile +
      ' %&'
  );
  var _arrListL = arrHeader(root, 'log');
  loadADODB(listfile, function (stream, hop) {
    var _iColumnWide = 0;
    do {
      var _sLineItemL = stream.ReadText(-2);
      if (!~_sLineItemL.indexOf('@')) {
        _arrListL.push('"","' + _sLineItemL + '",');
        continue;
      }

      _sLineItemL.replace(/^(\W*)(\w*)\s@(.[0-9-]*.)@(.*)/, function (match, p1, p2, p3, p4) {
        var p5 = (function () {
          var _objColorL = {'(HEAD': 10, '(master': 1, '(origin': 8};
          for (var key in _objColorL) {
            if (hop.call(_objColorL, key)) {
              if (~p4.indexOf(key)) {
                return _objColorL[key];
              }
            }
          }

          return 0;
        })();

        _iColumnWide = Math.max(_iColumnWide, p1.length);
        _arrListL.push(
          '"' +
            p2 +
            '","' +
            p1 +
            '",A:H' +
            p5 +
            ',C:0.0,L:0.0,W:0.0,S:0.0,R:0.0,H:0,M:0,T:"' +
            p3 +
            p4 +
            '"'
        );
      });
    } while (!stream.EOS);

    return _arrListL;
  });

  return;
};

get['commit'] = function (root, listfile, commit, logmax, unified) {
  PPx.Execute(
    '*cd ' +
      root +
      ' %:' +
      '%On *ppb -c git log -n1 --date=short --name-status --format="%%OD%%%%h (%%%%cr)%%%%s %%%%d%%OD-" ' +
      commit +
      ' >"' +
      listfile +
      ' %&'
  );
  var _arrListC = arrHeader(root, 'commit');
  var _bFirstline = true;
  loadADODB(listfile, function (stream, hop) {
    do {
      var _sLineItemC = stream.ReadText(-2);
      if (_bFirstline === true) {
        _bFirstline = false;
        _sLineItemC = _sLineItemC.replace(/\//g, '#');
        _arrListC.push(
          '"' +
            _sLineItemC +
            '","**",A:H10,C:0.0,L:0.0,W:0.0,S:0.0,R:0.0,H:0,M:0,T:"' +
            commit +
            '"'
        );
        continue;
      }

      _sLineItemC.replace(/^(.)\t?(.*)/, function (match, p1, p2) {
        var p3 = (function () {
          var _objColorC = {'M': 0, 'D': 5, 'A': 1, ' ': 0};
          for (var key in _objColorC) {
            if (hop.call(_objColorC, key)) {
              if (~p1.indexOf(key)) {
                return _objColorC[key];
              }
            }
          }

          return 8;
        })();

        _arrListC.push(
          '"' +
            p2 +
            '","' +
            p1 +
            '",A:H' +
            p3 +
            ',C:0.0,L:0.0,W:0.0,S:0.0,R:0.0,H:0,M:0,T:"' +
            commit +
            '"'
        );
      });
    } while (!stream.EOS);

    return _arrListC;
  });

  return;
};

get['diff'] = function (root, listfile, commit, logmax, unified) {
  PPx.Execute(
    '*cd ' +
      root +
      ' %:' +
      '%On *ppb -c git diff -U' +
      unified +
      ' --diff-filter=AM --no-prefix --color-words HEAD^ >' +
      listfile
  );
  return;
};

get['diff_commit'] = function (root, listfile, commit, logmax, unified) {
  PPx.Execute(
    '*cd ' + root + ' %:' + '%On *ppb -c git show --no-prefix --color ' + commit + ' >' + listfile
  );
  return;
};

get[objArg.order](objArg.root, objArg.listfile, objArg.commit, objArg.logmax, objArg.diffUnified);
