// #!/usr/bin/env node
/**
 * args = {
 *   order: module name
 *   root: git root path
 *   pathLf: logs directory path + prefix
 *   listfile: listfile path
 *   commit: refs hash
 *   logMax: git log maximum acquisitions
 *   diffUnified: diff unified
 * };
 */

'use strict';

const fs = require('fs');
const { exec } = require('child_process');

// 置換結果書き出し
const writeFile = (res, dest) => {
  fs.writeFileSync(dest , '');
  const fd = fs.openSync(dest, 'w');
  const buf = res.join('\u000D\u000A');
  return new Promise((resolve, reject) => {
    fs.write(fd, buf, 0, buf.length, (err) => {
      if (err) {
        reject(err);
      }

      resolve();
    });
  });
};

module.exports.status = (args) => {
  const result = `;ListFile,;Base=${args.root}|1,;git-status`.split(',');
  return new Promise((resolve, reject) => {
    exec(`cd ${args.root} && git status --porcelain -uall`, (err, stdout) => {
      if (err) {
        reject(err);
      }

      const gitStatus = stdout.split('\u000A');
      for (const line of gitStatus) {
        line.replace(/^(.)(.)\s(.*)/, (match, p1, p2, p3) => {
          if (p1 === 'R') {
            p3 = p3.replace(/^.*\s->\s(.*)/, '$1');
          }

          const p4 = (() => {
            const symColor = new Map([[' ', 1], ['D', 2], ['!', 3]]);
            for (const [key, value] of symColor) {
              if (~p2.indexOf(key)) {
                return value;
              }
            }

            return 8;
          })();

          result.push(`"${p3}","",A:H${p4},C:0.0,L:0.0,W:0.0,S:0.0,R:0.0,H:0,M:0,T:"${p1}${p2}"`);
        });
      }

      resolve(writeFile(result, args.listfile));
    });
  });
};

module.exports.log = (args) => {
  const result = `;ListFile,;Base=${args.root}|1,;git-log`.split(',');
  return new Promise((resolve, reject) => {
    exec(`cd ${args.root} && git log -n${args.logMax} --all --date=short --graph --format="%h @[%ad]@ %d%s"`, (err, stdout) => {
      if (err) {
        reject(err);
      }

      const gitLog = stdout.split('\u000A');
      let clmnWide = 0;

      for (const line of gitLog) {
        if (!~line.indexOf('@')) {
          result.push(`"","${line}",`);
          continue;
        }

        line.replace(/^(\W*)(\w*)\s@(.[0-9-]*.)@(.*)/, (match, p1, p2, p3, p4) => {
          const p5 = (() => {
            const symColor = new Map([['(HEAD', 10], ['(master', 1], ['(origin', 8]]);
            for (const [key, value] of symColor) {
              if (~p4.indexOf(key)) {
                return value;
              }
            }

            return 0;
          })();

          clmnWide = Math.max(clmnWide, p1.length);
          result.push(`"${p2}","${p1}",A:H${p5},C:0.0,L:0.0,W:0.0,S:0,R:0.0,H:0,M:0,T:"${p3}${p4}"`);
        });
      }

      // exec(`C:\\bin\\ppx\\ppbw -c *setcust MC_celS:gitlog=M Wf${colWide} F8 C120 s1` , (err) => {
      //   if (err) { console.log(err); }
      // });
      resolve(writeFile(result, args.listfile));
    });
  });
};

module.exports.log_commit = (args) => {
  const result = `;ListFile,;Base=${args.root}|1,;git-commit`.split(',');

  return new Promise((resolve, reject) => {
    exec(`cd ${args.root} && git log -n1 --date=short --name-status --format="%h (%cr)%s %d" ${args.commit}`, (err, stdout) => {
      if (err) {
        reject(err);
      }

      const gitLogC = stdout.split('\u000A');
      let flag = true;

      for (const line of gitLogC) {
        if (flag) {
          flag = false;
          result.push(`"${line.replace(/\//g, '-')}","**",A:H10,C:0.0,L:0.0,W:0.0,S:0.0,R:0.0,H:0,M:0,T:"${args.commit}"`);
        } else {
          line.replace(/^(.)\t?(.*)/, (match, p1, p2) => {
            const p3 = (() => {
              const symColor = new Map([['M', 0], ['D', 5], ['A', 1], [' ', 0]]);
              for (const [key, value] of symColor) {
                if (~p1.indexOf(key)) {
                  return value;
                }
              }

              return 8;
            })();

            result.push(`"${p2}","${p1}",A:H${p3},C:0.0,L:0.0,W:0.0,S:0.0,R:0.0,H:0,M:0,T:"${args.commit}"`);
          });
        }
      }

      resolve(writeFile(result, args.listfile));
    });
  });
};

module.exports.diff = (args) => {
  return new Promise((resolve, reject) => {
    /* default git-diff */
    // exec(`cd ${args.root} && git diff -U${args.diffUnified} --diff-filter=AM --no-prefix --color-words HEAD^ > ${args.listfile}`,
    /* use delta */
    exec(`cd ${args.root} && git diff -U${args.diffUnified} HEAD^ | delta --zero-style=#666666 --plus-emph-style="normal 28" --file-style="yellow ul" --hunk-header-decoration-style="gray ul" --keep-plus-minus-markers --width=variable > ${args.listfile}`,
      (err) => {
        if (err) {
          reject(err);
        }

        resolve();
      });
  });
};

module.exports.diff_commit = (args) => {
  return new Promise((resolve, reject) => {
    /* default git-diff */
    // exec(`cd ${args.root} && git show --no-prefix --color ${args.commit} > ${args.listfile}`, (err) => {
    /* use delta */
    exec(`cd ${args.root} && git diff -U${args.diffUnified} ${args.commit} | delta --zero-style=#666666 --plus-emph-style="normal 28" --file-style=plain --hunk-style=plain --keep-plus-minus-markers --width=variable > ${args.listfile}`, (err) => {
      if (err) {
        reject(err);
      }

      resolve();
    });
  });
};

