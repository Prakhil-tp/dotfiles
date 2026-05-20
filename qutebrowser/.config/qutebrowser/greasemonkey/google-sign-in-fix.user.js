// ==UserScript==
// @name        Google Sign-in Fix for Qutebrowser
// @match       *://accounts.google.com/*
// @match       *://*.google.com/*
// @run-at      document-start
// ==/UserScript==

// Override navigator.userAgentData — QtWebEngine exposes "Chromium" brand
// without "Google Chrome", which triggers Google's embedded browser block
const brandData = {
    brands: [
        { brand: 'Google Chrome', version: '140' },
        { brand: 'Chromium', version: '140' },
        { brand: 'Not-A.Brand', version: '24' },
    ],
    mobile: false,
    platform: 'Linux',
    getHighEntropyValues: async () => ({
        brands: [
            { brand: 'Google Chrome', version: '140' },
            { brand: 'Chromium', version: '140' },
            { brand: 'Not-A.Brand', version: '24' },
        ],
        mobile: false,
        platform: 'Linux',
        architecture: 'x86',
        bitness: '64',
        model: '',
        platformVersion: '6.0.0',
        uaFullVersion: '140.0.0.0',
        fullVersionList: [
            { brand: 'Google Chrome', version: '140.0.0.0' },
            { brand: 'Chromium', version: '140.0.0.0' },
            { brand: 'Not-A.Brand', version: '24.0.0.0' },
        ],
    }),
};

Object.defineProperty(navigator, 'userAgentData', { get: () => brandData });

// Add window.chrome — its absence signals a non-Chrome browser to Google
if (!window.chrome) {
    window.chrome = {
        runtime: {},
        loadTimes: function () { return {}; },
        csi: function () { return {}; },
        app: { isInstalled: false },
    };
}
