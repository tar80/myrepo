// ==UserScript==
// @name        ecosia two columns
// @namespace   http://userstyles.org
// @include     http://www.ecosia.org/*
// @include     https://www.ecosia.org/*
// @include     http://*.www.ecosia.org/*
// @include     https://*.www.ecosia.org/*
// @version     1
// ==/UserScript==

(() => {
  const css = `
    .main-header__search,
    .main-header__install-cta,
      .banner.cookie-notice,
      .images-snippet,
      .videos-snippet,
      .sidebar,
      .main-footer__card,
      .main-footer__content {
          display: none !important;
      }
    .result:not(.card-transparent) {
          display: inline-block !important;
          min-height: 0px !important;
          margin-right: 5px !important;
          margin-bottom: 5px !important;
          padding: 5px 10px 5px 10px !important;
          border: 2px solid lightblue !important;
          border-left: solid 20px lightblue !important;
          border-radius: 10px !important;
          background: #d9ebff57 !important;
          /* border: 1px solid violet ! important; */;
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
