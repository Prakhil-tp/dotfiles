if(!self.define){let e,i={};const n=(n,s)=>(n=new URL(n+".js",s).href,i[n]||new Promise((i=>{if("document"in self){const e=document.createElement("script");e.src=n,e.onload=i,document.head.appendChild(e)}else e=n,importScripts(n),i()})).then((()=>{let e=i[n];if(!e)throw new Error(`Module ${n} didn’t register its module`);return e})));self.define=(s,r)=>{const o=e||("document"in self?document.currentScript.src:"")||location.href;if(i[o])return;let l={};const c=e=>n(e,o),f={module:{uri:o},exports:l,require:c};i[o]=Promise.all(s.map((e=>f[e]||c(e)))).then((e=>(r(...e),l)))}}define(["./workbox-2d118ab0"],(function(e){"use strict";e.setCacheNameDetails({prefix:"tabliss-cache"}),self.addEventListener("message",(e=>{e.data&&"SKIP_WAITING"===e.data.type&&self.skipWaiting()})),e.precacheAndRoute([{url:"/icons/128.png",revision:"1b642323f660397b60b9fdf523c4c1a7"},{url:"/icons/32.png",revision:"8b54e7fc37a6b28ff90a90c8b461b576"},{url:"/icons/48.png",revision:"0445020e266388aaecfdd86aaf485b98"},{url:"/icons/96.png",revision:"1d03aa38660a0d26be5a3f9297b0b219"},{url:"/index.html",revision:"fd7d95e61a2102cd02965617c04538a2"},{url:"/main.65245b4be6f9.css",revision:null},{url:"/main.cc554e5f4149.js",revision:null},{url:"/main.cc554e5f4149.js.LICENSE.txt",revision:null},{url:"/polyfills.9932af86c9bb.js",revision:null},{url:"/pwa.json",revision:"9d1158fd57a26b10f4d24b3b7612eff2"},{url:"/theme.js",revision:"2e93918dba6e919a4069efabceb933a6"}],{})}));
//# sourceMappingURL=service-worker.js.map