// ==UserScript==
// @name          DuckDuckGo - Multi-Columns v.26_mod
// @namespace     http://userstyles.org
// @description	  Firefox and Chrome tested.
// @author        decembre
// @homepage      https://userstyles.org/styles/102738
// @include       http://duckduckgo.com/*
// @include       https://duckduckgo.com/*
// @include       http://*.duckduckgo.com/*
// @include       https://*.duckduckgo.com/*
// @run-at        document-start
// @version       0.20210317073613
// ==/UserScript==

(() => {
  const css = `
         .footer ,
         #bottom_spacing2 {
             padding-bottom: 0px;
             display: none !important;
         }
         .module-slot:not(:empty){
             float: left !important;
             height: auto !important;
             width: 98.3% !important;
             margin-left: 0% !important;
         /*     margin-bottom: 15px !important; */
         /*     padding-bottom: 54px ; */
             border-radius: 5px ;
         border: 1px solid gray !important;
         }
         .module--carousel__image.is-center-image {
         background-color: black !important;
         }
         #results--main.serp__results js-serp-results  .results--main .ia-modules.js-ia-modules{
             height: 0 !important;
         }
         .module.module--carousel.js-module--news {
             height: auto !important;
         /* border: 1px solid red !important; */
         }
         .module--carousel__items {
             height: auto !important;
             overflow: hidden;
             position: relative;
             white-space: nowrap;
         }
         #links.results.js-results  #organic-module:not(:empty) {
             float: left !important;
             height: auto !important;
             width: 98.3% !important;
             margin-left: 0% !important;
             margin-bottom: 15px !important;
             border-radius: 5px ;
         border: 1px solid  !important;
         /* border: 1px solid aqua !important; */
         }
         .module--carousel .module__header, .module--carousel .module__footer {
             margin-left: 11px;
         }
         #links.results.js-results  #organic-module:not(:empty)  .module.module--carousel.js-module--news .module--carousel__items.js-carousel-module-items:not(:last-child) .module--carousel__item {
             height: 280px !important;
             width: 17.2% !important;
             margin-top: 8px!important;
             margin-left: -0.3%!important;
             margin-right: 1.3%!important;
         border: 1px solid gray !important;
         /* border: 1px solid green !important; */
         }
         #links.results.js-results  #organic-module:not(:empty)  .module.module--carousel.js-module--news .module--carousel__items.js-carousel-module-items:not(:last-child) .module--carousel__item:first-of-type {
             margin-left: 5%!important;
         }
         #links.results.js-results  #organic-module:not(:empty)  .module.module--carousel.js-module--news .module--carousel__items.js-carousel-module-items:not(:last-child) {
             height: auto !important;
             width: 97.7% !important;
             margin-right: 0% !important;
             margin-left: 0% !important;
             padding: 0px 20px !important;
         /* border: 1px solid gray !important; */
         /* border: 1px solid tomato !important; */
         }
         #links.results.js-results #organic-module:not(:empty) .module.module--carousel.js-module--news .module--carousel__items.js-carousel-module-items + .js-carousel-module-more.module__footer {
             float: left !important;
             width: 98% !important;
             margin-top: 0px !important;
         /* border: 1px solid gray !important; */
         /* outline: 1px solid aqua !important; */
         }
         .module--carousel__left.js-carousel-module-left.ddgsi.ddgsi-left {
             float: right !important;
             margin-top: -40px !important;
             margin-left: 0px !important;
         /* outline: 1px solid violet !important; */
         }
         .module--carousel__right.js-carousel-module-right.ddgsi.ddgsi-right {
             float: left !important;
             margin-top: -40px !important;
             margin-right: 6px !important;
         /* outline: 1px solid tan !important; */
         }
         .js-news-module-title.module__header.module__header--link   {
             margin-left: -4px !important;
             padding-left: 14px !important;
             top: -30px !important;
         }
         .module.module--news.js-module--news {
             display: inline-block !important;
             width: 99% !important;
             height: 183px !important;
         z-index: 0 !important;
         background: #222 !important;
         }
         .module--news__items.js-news-module-items   {
             height: 162px !important;
             top: -31px !important;
             padding-left: 1.3%;
             padding-right: 1.8%;
         /* border: 1px solid red !important; */
         }
         .module--news__items.js-news-module-items   .module--news__item   {
             height: 158px !important;
         }
         .module--news__item {
             position: relative;
             display: inline-block;
             vertical-align: top;
             height: 230px;
             width: 20%;
             margin-top: 4px;
             margin-left: -0.5% !important;
             padding: 0px 5px !important;
             box-shadow: 0 2px 3px rgba(0, 0, 0, 0.06);
             box-sizing: border-box;
             cursor: pointer;
             white-space: normal;
         /* background: #222 !important; */
         }
         .module--news__item:not(:last-child) {
             margin-right: 1.2%;
             margin-left: -1% !important;
         }
         .module--news__item:last-child {
         /* margin-right: -1.4% !important; */
             margin-left: -1% !important;
         }
         .module--news__body {
           box-sizing: border-box;
         /* height: 135px !important; */
             padding: 0.25em !important;
         }
         .module--news__body__title {
             display: block;
             font-size: 15px;
             line-height: 1.2;
             margin-bottom: 0.20em;
             max-height: 5em;
             overflow: hidden;
         }
         .module--news__body__content {
             font-size: 0.8176em !important;
             line-height: 1.2 !important;
             min-height: 70px  !important;
             max-height: 4.1em !important;
             overflow: hidden;
         }
         .module--news__image {
             background-size: contain !important;
             height: 100%;
             width: 100%;
         }
         .module--news__right {
             padding-left: 1px;
             right: 13px !important;
         }
         .js-news-module-more.module__footer {
             top: -20px !important;
         /* background: red !important; */
         }
         .module--carousel__item {
             width: 17.2% !important;
             height: 280px;
         }
         .module--carousel__item:first-child{
             margin-left: 4%;
         }
         .module--carousel__image-wrapper {
             position: relative;
             float: left;
             height: 72%;
             width: 100%;
         background-color: #f7f7f7;
         }
         .module--carousel__item  >  .module--carousel__body {
             width: 100% ;
             height: 280px ;
             margin-bottom: 20px !important;
             padding: 0 0.75em ;
             text-align: center ;
             overflow: hidden ;
         /* background: red !important; */
         }
         .module--carousel__item  > .module--carousel__image-wrapper + .module--carousel__body {
             width: 100% ;
             height: 78px ;
             margin-bottom: 20px !important;
             padding: 0 0.75em ;
             text-align: center ;
             overflow: hidden ;
         /* background: red !important; */
         }
         .module.module--carousel.js-module--videosl {
           box-shadow: none;
           height: 351px !important;
           overflow: initial;
         }
         .module.module--carousel.js-module--videos .module--carousel__items.js-carousel-module-items {
           height: 299px !important;
         }
         .module.module--carousel.js-module--videos .module--carousel__items.js-carousel-module-items .module--carousel__item.has-image {
         height: 270px !important;
         }
         .module.module--carousel.js-module--videos .module--carousel__item.has-image .module--carousel__image-wrapper.js-carousel-item-image-wrapper {
         height: 200px !important;
         }
         .module.module--carousel.js-module--videos .module--carousel__item.has-image .module--carousel__image-wrapper.js-carousel-item-image-wrapper .module--carousel__image {
             background-position: center center;
             background-repeat: no-repeat;
             background-size: contain;
         }
         .has-extra-row .module--carousel__body__title {
             height: 1.5em !important;
             line-height: 1.5em !important;
             white-space: nowrap;
             text-overflow: ellipsis;
             overflow: hidden;
         }
         .has-extra-row .module--carousel__footer {
             height: 44px !important;
             top: 222px !important;
         }
         .module.module--carousel.js-module--videos  .module--carousel__right.js-carousel-module-right.ddgsi.ddgsi-right{
           margin-right: 20px !important;
         }
         .module--carousel .module__footer {
             top: 5px !important;
             margin-bottom: -14px ;
         }
         #links_wrapper.serp__results.js-serp-results  .ia-modules.js-ia-modules{
             width: 98.3%;
             padding: 0 !important;
         border: 1px solid gray ;
         }
         .serp__results.js-serp-results #links.results.js-results #r1-0.result:not(:hover) .result__body .result__check, 
         .serp__results.js-serp-results #links.results.js-results #r1-0.result:hover .result__body .result__check {
             height: 100%;
             min-height: 64px !important;
             max-height: 64px !important;
         border-left: 2px solid gray;
         background: rgba(115, 108, 108, 0.28) none repeat scroll 0 0;
         }
         .results__sitelink--organics {
              float: left ;
             width: 97.7%;
             margin-top: 16px ;
             padding: 5px ;
             border-radius: 5px ;
             overflow: hidden;
         border: 1px solid gray;
         }
         .serp__results.js-serp-results #links.results.js-results #r1-0 .results__sitelink--organics {
             float: left;
             width: 98.3%;
             margin-bottom: 1.2em;
             margin-top: 0;
             overflow: hidden;
         border: 1px solid gray ;
         }
         .result__sitelink-col {
             float: left;
             margin-bottom: 0.6em;
             padding-left: 25px;
             width: 255px;
         border-radius: 5px ;
         border: 1px solid gray;
         }
         .result__sitelink-row {
         /*     height: 122px !important; */
         margin: 0 1% 0 0 !important;
         }
         .result__sitelink-row:first-of-type {
         margin: 0 1% 0 1% !important;
         }
         .js-sitelink.result__sitelink-col {
             height: 122px !important;
         margin: 0 0.2% 0 0 !important;
         }
         .serp__results.js-serp-results #links.results.js-results #r1-0 {
             display: inline-block !important;
             height: auto !important;
         height: 100%;
         min-height: 100px !important;
         max-height: 100px !important;
         width: 100% !important;
         min-width: 98.5% !important;
         max-width: 98.5% !important;
             margin-top: 0px;
             overflow: hidden !important;
         border: 1px solid !important;
         }
         #links.results.js-results #r1-0 .result__body.links_main.links_deep {
             height: auto !important;
             margin-top: -10px;
         padding: 5px 10px !important;
         }
         #r1-0.result.results_links_deep.highlight_d  .result__snippet  {
             height: auto !important;
             overflow-x: hidden;
             overflow-y: auto;
         }
         #links.results.js-results #r1-0 .result__body.links_main.links_deep .result__menu {
             display: inline-block !important;
             float: right;
             overflow: hidden;
             text-align: right;
             text-overflow: ellipsis;
             white-space: nowrap;
         }
         .results--sidebar.js-results-sidebar {
             position: absolute !important;
             display: block !important;
             height: 45px !important;
             min-width: 460px !important;
             max-width: 460px !important;
             top:  -10px !important;
             text-align: center ;
             z-index: 50;
             overflow: hidden !important;
             overflow-y: hidden !important;
             transition: all ease 0.7s ;
         /* border: 1px solid aqua ; */
         }
         #zero_click_wrapper ~ #web_content_wrapper .cw   .results--sidebar.js-results-sidebar {
             top: 0px;
             padding: 0 ;
         }
         #zero_click_wrapper ~ #web_content_wrapper .cw   .results--sidebar.js-results-sidebar:not(:hover) .module.module--about.js-about-module.has-content-height {
             height: 45px;
             width: 100% !important;
             min-width: 460px !important;
             max-width: 460px !important;
         }
         #zero_click_wrapper ~ #web_content_wrapper .cw .results--sidebar.js-results-sidebar:not(:hover) .module.module--about.js-about-module.has-content-height .mapkit-static__map {
             background-position: left center;
             background-repeat: no-repeat;
             background-size: contain;
             position: relative;
         }
         #zero_click_wrapper ~ #web_content_wrapper .cw .results--sidebar.js-results-sidebar:not(:hover) .module.module--about.js-about-module.has-content-height  .mapkit-static__img{
             display: block;
             height: 30px;
             opacity: 0;
         }
         #zero_click_wrapper ~ #web_content_wrapper .cw .results--sidebar.js-results-sidebar:not(:hover) .module.module--about.js-about-module.has-content-height  .module__title {
             position: absolute ;
             display: inline-block ;
             width: 100% !important;
             min-width: 460px !important;
             max-width: 460px !important;
             height: 43px;
             line-height: 40px;
             top: 0px ;
             left: 0 ;
             margin-left: 0% !important;
             text-align: center !important;
         z-index: 500 !important;
         background: rgba(17, 17, 17, 0.71) !important;
         }
         #zero_click_wrapper ~ #web_content_wrapper .cw .results--sidebar.js-results-sidebar:hover .module.module--about.js-about-module.has-content-height  .module__title {
             position: absolute ;
             display: inline-block ;
             width: 100% !important;
             top: 5px ;
             margin-left: -5% !important;
             text-align: center !important;
         }
         #zero_click_wrapper ~ #web_content_wrapper .cw .results--sidebar.js-results-sidebar .module--about.is-expanded .module__content:before, 
         #zero_click_wrapper ~ #web_content_wrapper .cw .results--sidebar.js-results-sidebar .module--about.is-expanded .module__content::after {
             color: yellow;
             content: \"▼\";
             font-size: 15px;
             position: absolute ;
             display: inline-block ;
             top: 0 ;
         }
         #zero_click_wrapper ~ #web_content_wrapper .cw   .results--sidebar.js-results-sidebar:hover {
             height: auto !important;
             min-height: 43px;
             max-height: 85vh !important; 
             overflow: hidden !important;
         border-radius: 0 0 5px  5px !important;
         /* border: 1px solid red !important; */
         }
         .results--sidebar.js-results-sidebar .module__content.js-about-module-content .module__title span.module__title__link {
             display: inline-block;
             width: 54% !important;
             font-size: 18px !important;
         /* border: 1px solid violet !important; */
         }
         .results--sidebar.js-results-sidebar:not(:hover) .module__content.js-about-module-content .module__title:before ,
         .results--sidebar.js-results-sidebar:not(:hover) .module__content.js-about-module-content .module__title:after {
             content: \"▼\" ;
             color: green ;
             font-size: 15px !important;
         }
         .results--sidebar.js-results-sidebar .module__text {
             margin-top: 31px;
         }
         #zero_click_wrapper ~ #web_content_wrapper .cw   .results--sidebar.js-results-sidebar:hover #m0-0:empty:before {
         content: \"No More Infos \";
             display: inline-block ;
             height: 43px !important;
             width: 100% ;
             line-height: 43px !important;
         text-align: center ;
         font-size: 20px ;
         opacity: 0.2 ;
         border: none ;
         color: gray ;
         background: #111 ;
         }
         .results--sidebar.js-results-sidebar:hover {
             height: auto  !important;
             min-height: 43px !important;
             text-align: left ;
             transition: all ease 0.7s ;
         }
         .js-sidebar-modules:not(:empty) {
             min-height: 243px !important;
         margin-bottom: -20px ;
         background: #111 ;
         }
         .js-sidebar-modules:empty {
             height: 0px !important;
             overflow: hidden !important;
         }
         .module--about {
             height: 40px;
             margin-top: 0;
             padding-top: 2px ;
             overflow: hidden !important;
             overflow-y: hidden !important;
             transition: all ease 0.7s ;
         }
         .results--sidebar:hover .module--about {
             height: auto ;
             padding-top: 2px;
             margin-bottom: 0;
             overflow: hidden;
             overflow-y: auto ;
             transition: all ease 0.7s ;
         }
         .module__content.js-about-module-content {
             padding-top: 0;
         }
         .vertical--map__sidebar__wrapper .module--about {
             height: auto !important;
             margin-top: 0;
             padding-top: 2px ;
         }
         .js-about-module-image {
             padding: 0px !important;
             transform: scale(0.7) !important;
             transform-origin: center center ;
         }
         .result__snippet a.linkifyplus {
         /* color: rgba(64, 51, 218, 0.76) !important; */
         color: rgba(190, 124, 58, 0.9) !important;
         }
         .linkifyplus img {
             max-width: 10% !important;
             max-height: 51px !important;
             float: left !important;
             clear: none!important;
             padding: 1px !important;
         color: pink !important;
         overflow: hidden !important;
         border: 1px solid violet !important;
         /* background: red !important; */
         }
         .linkifyplus:after {
         content: \"LinkiFy\" !important;
         /* position: absolute !important; */
         display: inline-block !important;
             width: 35px !important;
             height: 15px !important;
         float: none !important;
         /* clear: none!important; */
         /* top: 0 !important; */
         /* left: 0 !important; */
             padding: 1px !important;
         font-size: 10px !important;
         text-align: center !important;
         /* overflow: hidden !important; */
         opacity: 0.2 !important;
         background: yellow !important;
         }
         .linkifyplus:hover:after {
         content: \"LinkiFy\" !important;
         /* position: absolute !important; */
         display: inline-block !important;
             width: 35px !important;
             height: 15px !important;
         float: none !important;
         /* clear: none!important; */
         /* top: 0 !important; */
         /* left: 0 !important; */
             padding: 1px !important;
         font-size: 10px !important;
         text-align: center !important;
         /* overflow: hidden !important; */
         opacity: 1 !important;
         background: yellow !important;
         }
         .header__logo-wrap {
             left: 90px !important;
             width: 58px !important;
         }
         .header__content.header__search {
         /* width: 1800px !important; */
         /* width: 93% !important; */
             width: 769px !important;
         /* margin-left: 88px; */
             left: 62px !important;
         }
         .search--header:not(.js-vertical-map-search) {
             width: 805px !important;
             height: 38px;
             padding-left: 9px;
         border-right-width: 3em !important;
             background-color: #f7f7f7 !important;
         }
         .header__search-wrap {
             position: relative;
             width: 808px !important;
             max-width: 808px !important;
             margin-bottom: 3px;
             margin-top: 1px;
         }
         #search_form {
         /* width: 100% !important; */
         /* max-width: 1800px !important; */
         }
         #search_form_input  {
             width: 695px !important;
         /* border-right: 1px solid red !important; */
             color: black !important;
         }
         .tile-nav.can-scroll, 
         .tile-nav.can-scroll::after {
             background-color: #de5833 !important;
             color: #fff;
         }
         .result.results_links_deep.highlight_d.highlight {
         /* border: 1px solid red !important; */
         }
         .result.results_links_deep.highlight_d.highlight .result__check::before {
             display: inline-block !important;
             left: -33px !important;
             right: 655px !important;
             content: \"☑\";
             float: right;
             font-family: \"ddg-serp-icons\" !important;
             font-style: normal;
             font-variant: normal;
             font-weight: normal !important;
             line-height: 1;
             text-decoration: none !important;
             text-transform: none;
         /* outline: 1px solid red !important; */
         }
         .result__check__tt::before {
              display: none !important;
         }
         .result.results_links_deep.highlight_d.highlight {
         /* background: red !important; */
             border: 1px solid red !important;
         }
         .result.results_links_deep.highlight_d .result__snippet b {
             color: mediumvioletred !important;
         }
         .result__check {
             position: absolute;
             width: 1em;
             top: 1.6em !important;
             margin-right: 1em;
             right: 93% !important;
             font-size: 0.8em;
             white-space: nowrap;
         /* border: 1px solid violet !important; */
         }
         .result:not(:hover) .result__body .result__check ,
         .result:hover .result__body .result__check {
             height: 100% ! important;
             min-height: 118px !important;
             max-height: 118px !important;
             width: 100%! important;
             min-width: 20px ! important;
             max-width: 20px ! important;
             margin-top: -24px !important;
             left: 2px !important;
             padding: 30px 5px 2px 2px  !important;
             border-left: 2px solid gray !important;
             background: rgba(115, 108, 108, 0.28) !important;
         }
         .result:not(:hover) .result__body .result__check:visited ,
         .result:hover .result__body .result__check:visited {
             border-left: 2px solid blue !important;
         }
         .result__check:hover span  {
             display: none !important;
         }
         .result__check:visited:before {
             color: #205984  ! important;
             background: rgba(0, 108, 108, 0.28) !important;
         }
         .result__check .result__check,
         .result__check:hover .result__check__tt {
             height: 20px !important;
             top: 7px !important;
             left: -9px!important;
             visibility: visible;
             opacity: 1;
             transition-delay: 0.75s;
         }
         .results  {
             max-width: 100% ! important;
             min-width: 100% ! important;
         /*     left: -90px ! important; */
         /* outline: 1px solid green ! important; */
         }
         .cw {
             max-width: 105% ! important;
             min-width: 105% ! important;
             left: -90px ! important;
         }
         .results--main {
             max-width: 100% ! important;
             min-width: 100% ! important;
         /*     left: -90px ! important; */
         /* outline: 1px solid green ! important; */
         }
         .results-wrapper {
             min-width: 91.2% ! important;
             max-width: 91.2% ! important;
             padding-right: 0px !important;
         /* outline: 1px solid red ! important; */
         }
         .cw #links_wrapper.results-wrapper #links.results {
             display: inline-block !important;
             float: left !important;
             max-width: 99% ! important;
             min-width:90% ! important;
         /* outline: 1px solid red ! important; */
         }
         .result__title {
           display: block;
           font-size: 1.31em;
           line-height: 1.15;
           max-width: 100%;
           overflow: hidden;
           padding: 0;
           position: static;
           vertical-align: middle;
         margin-top: -10px !important;
         }
         #links .result:not(.result--sep):not(.result--more) {
             display: inline-block !important;
             float: left !important;
             clear: none !important;
             min-height: 155px ! important;
             max-height: 155px ! important;
             min-width: 32.7% ! important;
             max-width: 32.7% ! important;
             margin-right: 4px ! important;
             margin-bottom: 3px !important;
             padding: 1px 1px 1px 35px ! important;
             border: 1px solid gray ! important;
         /* border: 1px solid violet ! important; */
         }
         .result__body.links_main.links_deep {
             margin-top: -20px;
             height: 127px !important;
             overflow: hidden !important;
         }
         .result__snippet {
             height: 95px !important;
             overflow: hidden !important;
             overflow-y: auto !important;
         }
          .results--sidebar.js-results-sidebar .region-switch  {
             position: absolute !important;
             right: -0.7em !important;
             top: -20px !important;
             text-align: right;
             z-index: 200 !important;
         }
         .region-switch .switch {
             float: left;
             height: 14px !important;
             line-height: 14px !important;
             margin-right: 8px;
         }
         .switch__knob {
             position: absolute;
             display: block;
             height: 12px !important;
             width: 12px !important;
             top: 1px !important;
             left: 2px;
             border-radius: 9px;
             transition: all 0.1s ease 0s, all 0s linear 0s, left 0.3s ease-in-out 0s;
             background-color: #fff;
         }
         .switch__on {
             position: absolute;
             line-height: 12px !important;
             left: 10px;
             color: #fff;
             font-size: 12px !important;
         }
         .region-flag__wrap--small {
         /* height: 14px !important; */
         /* width: 14px !important; */
         /* left: -4px !important; */
         /* margin-top: 11px !important; */
         }
         .region-flag__wrap--small .region-flag__img {
             height: 14px !important;
         }
         .search-filter__icon.region-flag__wrap.region-flag__wrap--small.has-region.js-region-filter-icon {
             height: 14px !important;
             width: 14px !important;
             left: -4px !important;
             margin-top: 11px !important;
         }
         .result.result--more {
             position: absolute !important;
             bottom: 0px!important;
             left: 0px !important;
             width: 50% !important;
             margin-left: 30% !important;
             margin-bottom: -10px!important;
         }
         .no-results {
             position: relative !important;
             display: inline-block !important;
             min-width: 99% ! important;
             max-width: 99% ! important;
             bottom: 0 !important;
             padding-left: 0.75em;
             padding-top: 2em;
             margin-left: 0% !important;
             text-align: center !important;
         /* outline: 1px solid peru ! important; */
         }
         #links .result--sep  {
             float: left!important;
             min-height: 10px ! important;
             max-height: 10px ! important;
             line-height: 5px ! important; 
             min-width: 97.4% ! important;
             max-width: 97.4% ! important;
             margin-top: 0px !important;
             margin-left: 20px ! important;
             bottom: -5px !important;
         /* outline: 1px solid peru ! important; */
         }
         .result--sep--hr::before {
             position: absolute;
             display: block;
             content: \"\";
             height: 1px;
             left: 10px;
             right: 20px;
             top: 0.25em !important;
             background-color: #e0e0e0;
         }
         .result__pagenum--side {
             position: absolute;
             width: 1.6em;
             height: 1.6em;
             line-height: 1.6em;
             top: -6px !important;
             left: 50% !important;
             padding: 0;
             border-radius: 50%;
             text-align: center;
         }
         #links .results_links_deep {
             counter-increment: myIndex ! important;
         }
         #links .results_links_deep:before {
             display: inline-block ! important;
             min-width: 15px ! important;
             margin-left: -27px ! important;
             content: counter(myIndex, decimal-leading-zero);
             border-radius: 8px ! important;
             font-size: 10px ! important;
             text-align: center ! important;
             color: whitesmoke ! important;
             background: cadetblue ! important;
             z-index: 10 !important;
         }
         .tile--img__details {
             position: absolute;
             display: inline-block !important;
         /*     min-width: 80% !important; */
             max-width: 80% !important;
         /*     min-height: 80% !important; */
             max-height: 80% !important;
             top: 10% !important;
             right: 0;
             bottom: 0;
             left: 10% !important;
             border-radius: 5px !important;
             text-align: center;
             background: rgba(0, 0, 0, 0.9) !important;
             color: gold !important;
         transform: scale(0.7) !important;
             opacity: 1 !important;
         /* visibility: visible !important; */
         transition: all ease 1s !important;
         }
         .tile--img__details:hover  {
             position: absolute;
             display: inline-block !important;
         /*     min-width: 80% !important; */
             max-width: 80% !important;
         /*     min-height: 80% !important; */
             max-height: 80% !important;
             top: 10% !important;
             right: 0;
             bottom: 0;
             left: 10% !important;
             border-radius: 5px !important;
             text-align: center;
             background: rgba(0, 0, 0, 0.4) !important;
             color: gold !important;
         transform: scale(0.7) !important;
             opacity: 1 !important;
         /* visibility: visible !important; */
         transition: transform ease 1s !important;
         }
         .tile.tile--img.has-detail:hover {
         outline: 1px solid violet !important;
         }
         .tile.tile--img.has-detail .tile--img__media:hover {
         outline: 1px solid peru !important;
         }
         .tile.tile--img.has-detail .tile--img__media .tile--img__img.js-lazyload:hover {
         outline: 1px solid yellow !important;
         }
         .tile.tile--img.has-detail .tile--img__media .tile--img__media__i .tile--img__img.js-lazyload:before {
         content: attr(alt) !important;
         content: \"XXXX\" !important;
         /* position: absolute !important; */
         position: relative !important;
         display: inline-block !important;
         height: 20px !important;
         width: 200px !important;
         font-size: 30px !important;
         color: cyan !important;
         z-index: 500000 !important;
         }
         .results--sidebar--mid {
             position: fixed;
             display: inline-block ! important;
             max-width: 44em;
             width: 20px ! important;
             height: 10px ! important;
             left: -150px !important;
             top: 20px ! important;
             z-index: 5;
         }
         .has-zcm .header-wrap:after {
             height: 9px !important;
         }
         .body--html .header.header--html {
         display: inline-block !important;
             width: 100%;
             max-width: none;
             padding: 17px 0 9px;
             text-align: center !important;
             border-bottom: 1px solid #d0d0d0;
         background: #222 !important;
         }
         .body--html .header__form {
             position: relative !important;
             display: inline-block ;
             float: none;
             padding-left: 0;
             width: 100%;
             text-align: center;
         }
         .body--html .search--header {
             position: relative !important;
             display: inline-block ;
             width: 805px !important;
             height: 38px;
             margin: auto !important;
             padding-left: 9px;
             border-right-width: 3em;
         background-color: #f7f7f7;
         }
         .body--html .frm__select {
             position: relative !important;
             display: inline-block ;
             float: none !important;
             height: auto;
         /*     left: 30% ; */
             width: 145px;
             margin : 10px auto ;
             background-color: silver;
         }
         .body--html {
         background: #222 !important;
         }
         .body--html .serp__results {
             max-width: 100%;
             padding-left: 10px;
         color: gray !important;
         background: #222 !important;
         }
         .body--html .result:hover {
         color: gold !important;
             background-color: #333 !important;
         }
         .body--html .result .result__title {
             margin-top: 0 !important;
         }
         .body--html .result .result__title a  {
             color: peru !important;
         }
         .body--html .result .result__title a:visited  {
             color: violet !important;
         }
         .body--html .result .result__snippet {
             height: 90px !important;
             overflow-x: hidden;
             overflow-y: auto;
         color: #ccc !important;
         }
         .body--html .result .result__snippet > b{
             color: gold;
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
