// #!/usr/bin/env node
/**
 *
 * argv = [0]node.exe path [1]script path
 */

'use strict';

const { workerData } = require('worker_threads');
const getlog = require(__dirname + '/module/git_getlog');

getlog[workerData.order](workerData);
