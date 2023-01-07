// ==UserScript==
// @name        twitter fix
// @namespace   http://userstyles.org
// @include     https://twitter.com/*
// @version     1
// ==/UserScript==

(() => {
  const css = `
    .r-urgr8i,
    .r-1upvrn,
    .r-1h3ijdo {
          display: none !important;
          }
`;
  if (typeof GM_addStyle != 'undefined') {
    GM_addStyle(css);
  } else if (typeof PRO_addStyle != 'undefined') {
    PRO_addStyle(css);
  } else if (typeof addStyle != 'undefined') {
    addStyle(css);
  } else {
    const node = document.createElement('style');
    node.type = 'text/css';
    node.appendChild(document.createTextNode(css));
    const heads = document.getElementsByTagName('head');
    (heads.length > 0)
      ? heads[0].appendChild(node)
      : document.documentElement.appendChild(node);
  }
})();
