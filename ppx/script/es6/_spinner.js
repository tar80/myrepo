//!*script
/**
 * Spinner
 *
 */

'use strict';

PPx.setProcessValue('spin', 1);

const dots = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];

const spinning = () => {
  for (let i = 0; i < dots.length; i++) {
    if (PPx.getProcessValue('spin') !== '1') {
      return;
    }

    PPx.linemessage(`!"${dots[i]}`);
    PPx.Execute('*wait 300,2');
  }
};

while (PPx.getProcessValue('spin') == 1) {
  spinning();
}

PPx.linemessage('!"');
