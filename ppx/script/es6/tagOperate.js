//!*script
/**
 * コメントにタグを付けたり外したり
 *
 * PPx.Arguments(
 *  0: push | remove
 *  1: tags
 * )
 */

'use strict';

const g_args = (() => {
  if (PPx.Arguments.length === 0) {
    PPx.Echo('引数が足りません');
    PPx.Quit(-1);
  }

  return {
    order: PPx.Arguments(0),
    tags: PPx.Arguments(1).split(' ')
  };
})();

const cmd = {};
cmd['push'] = (cmnts) => {
  let cmnts1 = (cmnts.length === 0) ? g_args.tags : [...cmnts.split(' '), ...g_args.tags];
  cmnts1 = Array.from(new Set([...cmnts1]));
  return cmnts1.sort((a, b) => (a.toLowerCase() < b.toLowerCase()) ? -1 : 1);
};

cmd['remove'] = (cmnts) => {
  let cmnts2 = cmnts.split(' ');
  const rmTags = Array.from(new Set([...g_args.tags]));
  for (const tag of rmTags.values()) {
    cmnts2 = cmnts2.filter(v => v !== tag);
  }

  return cmnts2;
};

const thisEntry = PPx.Entry;
thisEntry.FirstMark;
do {
  const thisComment = (() => cmd[g_args.order](thisEntry.comment))();

  thisEntry.comment = thisComment.join(' ');
} while (thisEntry.NextMark);

PPx.Execute('*color back');

