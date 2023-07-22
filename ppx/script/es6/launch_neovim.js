//!*script
/**
 * Launch Neovim, depending on the situation.
 *
 * @arg {number} 0 - Process existence of the Neovim. 0:false | -1:true
 * @arg {number} 1 - Vimserver port number
 * @arg {string} 2 - Edit-order. edit | args | diff | command
 * @arg {string} 3 - CommandLine to apply. If Edit-order is "command"
 */

'use strict';

const scriptName = PPx.scriptName;

const errors = (method) => {
  PPx.Execute('*script "%*getcust(S_ppm#global:lib)\\errors.js",' + method + ',' + scriptName);
  PPx.Quit(-1);
};

const gNvim = ((args = PPx.Arguments) => {
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

const adjustPath = () => {
  const path = PPx.Extract('%*script(%*getcust(S_ppm#global:lib)\\entity_path.js)');

  return path.replace(/^"(.+)"$/, '$1');
};

const gCmd = {
  edit() {
    const path = adjustPath();
    return `edit ${path}`;
  },
  args() {
    const path = adjustPath();

    if (PPx.EntryMarkCount > 1) {
      return `args! ${path}`;
    }

    gNvim.order = 'edit';
    return `edit ${path}`;
  },
  diff() {
    const path =
      PPx.EntryMarkCount === 2
        ? PPx.Extract('%#;FDCN').split(';')
        : [PPx.Extract('%FDCN'), PPx.Extract('%~FDCN')];

    return `silent! edit ${path[1]}|silent! vertical diffsplit ${path[0]}`;
  },
  command() {
    const cmd = gNvim.command;

    if (cmd === null) {
      errors('arg');
    }

    return cmd;
  }
}[gNvim.order]();

const gOpt = ((v = gNvim, cmd = gCmd) => {
  const remoteOption = {
    '0': `--remote-send "<Cmd>${cmd}<CR>"`,
    '-1': `--remote-send "<Cmd>stopinsert|tabnew|${cmd}<CR>"`
  };

  return remoteOption[v.process];
})();

PPx.Execute(`%Obd nvim --server "\\\\.\\pipe\\nvim.${gNvim.port}.0" ${gOpt}`);
