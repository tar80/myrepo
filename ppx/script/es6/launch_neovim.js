//!*script
/**
 * Launch Neovim, depending on the situation.
 *
 * @arg {number} 0 Process existence of the Neovim. 0:false | -1:true
 * @arg {number} 1 Vimserver port number
 * @arg {string} 2 Edit-order. edit | args | diff | command
 * @arg {string} 3 CommandLine to apply. If Edit-order is "command"
 */

'use strict';

const script_name = PPx.scriptName;

const errors = (method) => {
  PPx.Execute('*script "%*getcust(S_ppm#global:lib)\\errors.js",' + method + ',' + script_name);
  PPx.Quit(-1);
};

const g_nvim = ((args = PPx.Arguments) => {
  const len = PPx.Arguments.length;

  if (len < 3) {
    errors('arg');
  }

  return {
    process: args.Item(0),
    port: args.Item(1),
    order: args.Item(2),
    command: len > 3 ? args.Item(3) : null
  };
})();

const g_cmd = {
  edit() {
    const path = PPx.Extract('%*script(%*getcust(S_ppm#global:lib)\\entity_path.js)');
    return `edit ${path}`;
  },
  args() {
    const path = PPx.Extract('%*script(%*getcust(S_ppm#global:lib)\\entity_path.js)');

    if (PPx.EntryMarkCount > 1) {
      return `args! ${path}`;
    }

    g_nvim.order = 'edit';
    return `edit ${path}`;
  },
  diff() {
    const path =
      PPx.EntryMarkCount === 2
        ? PPx.Extract('%#;FDC').split(';')
        : [PPx.Extract('%FDC'), PPx.Extract('%~FDC')];

    return `silent! edit ${path[1]}|silent! vertical diffsplit ${path[0]}`;
  },
  command() {
    const cmd = g_nvim.command;

    if (cmd === null) {
      errors('arg');
    }

    return `${cmd}`;
  }
}[g_nvim.order]();

const g_opt = ((v = g_nvim, cmd = g_cmd) => {
  const remote_opt = {
    '0': `--remote-send "<Cmd>${cmd}<CR>"`,
    '-1': `--remote-send "<Cmd>stopinsert|tabnew|${cmd}<CR>"`
  };

  return remote_opt[v.process];
})();

PPx.Execute(`%Obd nvim --server "\\\\.\\pipe\\nvim.${g_nvim.port}.0" ${g_opt}`);
