// ==UserScript==
// @name          Dark Reader (Unofficial)
// @icon          https://darkreader.org/images/darkreader-icon-256x256.png
// @namespace     DarkReader
// @description	  Inverts the brightness of pages to reduce eye strain
// @version       4.7.15
// @author        https://github.com/darkreader/darkreader#contributors
// @homepageURL   https://darkreader.org/ | https://github.com/darkreader/darkreader
// @run-at        document-end
// @grant         none
// @include       http*
// @exclude       http*://*.quora.com/*
// @exclude       http*://leetcode.com/*
// @exclude       http*://*.grammarly.com/*
// @exclude       https://web.whatsapp.com/*
// @exclude       https://www.google.com/*
// @exclude       https://www.jiocinema.com/*
// @exclude       https://www.gnu.org/*
// @exclude       https://*.google.com/*
// @exclude       http*://searx.*
// @exclude       http*://*.cloudflare.com/*
// @exclude       http*://*wordtune.com/*
// @exclude       http*://*ultravioletsoftware.com/*
// @exclude       http*://*startpage.com/*
// @exclude       http*://*visualstudio.com/*
// @exclude       http*://*adobe.com/*
// @exclude       http*://localhost*
// @exclude       http*://*mui.com/*
// @exclude       http*://*apexcharts.com/*
// @exclude       http*://*openai.com/*
// @exclude       http*://*amazon.*/*
// @exclude       http*://*reddit.*/*
// @exclude       http*://*github.*/*
//
//#### @exclude       https://www.google.com/search?q=*&tbm=isch*
// @require       https://cdn.jsdelivr.net/npm/darkreader/darkreader.min.js
// @noframes
// ==/UserScript==

DarkReader.enable({
  brightness: 100,
  contrast: 100,
  sepia: 0,
  grayscale: 60,
});

/*
let applyDarkMode = true

// sites to ignore darkmode
const blacklist = `
  [A-Za-z0-9:\/]*(\.)?grammarly\.com\/?[A-Za-z0-9+=?&-]*
`

// url of the current website
const url = window.location.href

const regex = new RegExp(blacklist)

if(regex.test(url)) {
  applyDarkMode = false
}

if(applyDarkMode) {
  DarkReader.enable({
    brightness: 100,
    contrast: 100,
    sepia: 0,
    grayscale:60
  });
}
*/
