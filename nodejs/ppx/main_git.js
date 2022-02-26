// #!/usr/bin/env node
/**
 * argv = [0]node.exe path [1]script path
 */

'use strict';

const { Worker } = require('worker_threads');

const g_args = {
  order: process.argv[2],
  root: process.argv[3],
  pathLf: process.argv[4],
  commit: process.argv[5],
  logMax: process.argv[6],
  diffUnified: process.argv[7]
};

const CreateWorker = (path, data) => {
  const w = new Worker(path, { workerData: data });
  w.on('error', err => console.error(err));
  // w.on('exit', exitcode => console.log('Worker: completed.'));
  w.on('message', msg => console.log(msg));
  return w;
};

({
  'status': () => {
    g_args.listfile = g_args.pathLf + 'gitstatus.xgit';
    CreateWorker(__dirname + '/workerGit.js', g_args);
    g_args.order = 'diff';
    g_args.listfile = g_args.pathLf + 'gitdiff.patch';
    CreateWorker(__dirname + '/workerGit.js', g_args);
  },
  'log': () => {
    g_args.listfile = g_args.pathLf + 'gitlog.xgit';
    CreateWorker(__dirname + '/workerGit.js', g_args);
  },
  'commit': () => {
    g_args.order = 'log_commit';
    g_args.listfile = g_args.pathLf + 'gitlog_commit.xgit';
    CreateWorker(__dirname + '/workerGit.js', g_args);
    g_args.order = 'diff_commit';
    g_args.listfile = g_args.pathLf + 'gitdiff_commit.patch';
    CreateWorker(__dirname + '/workerGit.js', g_args);
  }
})[g_args.order]();
