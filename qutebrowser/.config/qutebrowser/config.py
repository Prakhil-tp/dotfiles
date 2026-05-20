# import dracula.draw
import catppuccin
import keybindings


config.load_autoconfig(True)
#key
c.bindings.default = keybindings.key_action_map

# theme
# dracula.draw.blood(c, {
#    "spacing": {
#        "vertical": 6,
#        "horizontal": 8
#    }
# })
catppuccin.setup(c, 'mocha', True)



c.backend = "webengine"
c.downloads.location.directory = "/home/blue/Downloads"
c.statusbar.show = "in-mode"
c.tabs.show = "always"
c.url.default_page = "https://start.duckduckgo.com/"
c.scrolling.smooth = True
c.content.blocking.method = "both"
c.url.start_pages = "/home/blue/.config/qutebrowser/tabliss/index.html"
c.url.default_page = c.url.start_pages

# search engines
c.url.searchengines = {
    "DEFAULT": "https://google.com/search?q={}", 
    "st": "https://startpage.com/do/search?q={}",
    "le": "https://www.britannica.com/dictionary/{}", 
    "yt": "https://youtube.com/results?search_query={}",
    "aw": "https://wiki.archlinux.org/?search={}",
    "olam": "https://olam.in/Dictionary/en_ml/{}",
    "pronounce": "https://youglish.com/pronounce/{}/english"
}

c.aliases = {
    "adb": "config-cycle -t content.blocking.enabled",
    "dev": "devtools",
    "incognito": "open --private",
    "bk": "bookmark-add",
    "o": "open",
    "q": "quit",
    "wq": "quit --save",
    "qrcode": "spawn st -e watch --color -t -x qrcode-terminal \"{url}\"",
    "paywall": "open https://www.google.com/search?q=cache:{url}"
    # "lastpass": "hint --first inputs ;; spawn --userscript qute-lastpass"
}

# flags (hardware acceleration)
c.qt.args= [
    "enable-gpu-rasterization",
    "ignore-gpu-blocklist",
    "enable-native-gpu-memory-buffers",
    "num-raster-threads=4",
    "enable-accelerated-video-decode"
]  

c.bindings.key_mappings = {
    "<Ctrl+6>": "<Ctrl+^>",
    "<Ctrl+Enter>": "<Ctrl+Return>",
    "<Ctrl+i>": "<Tab>",
    "<Ctrl+j>": "<Return>",
    "<Ctrl+m>": "<Return>",
    "<Ctrl+[>": "<Escape>",
    "<Enter>": "<Return>",
    "<Shift+Enter>": "<Return>",
    "<Shift+Return>": "<Return>"
}

# Ad blocklist
c.content.blocking.adblock.lists = [
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2022.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2023.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2024.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2025.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/lan-block.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/quick-fixes.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/ubol-filters.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt",
]

# Bindings for normal mode (default: normal mode)
config.bind(",,", "config-cycle statusbar.show always never ;; config-cycle tabs.show always switching")
config.bind(",b", "config-cycle statusbar.show always never")
config.bind(",t", "config-cycle tabs.show always switching")
config.bind(",v", "spawn --detach mpv -- {clipboard}")

# Spoof Chrome user-agent + client hints for Google (fixes sign-in)
# Version must match actual QtWebEngine Chromium version (currently 140)
_chrome_ua = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36'
_google_patterns = ['*://accounts.google.com/*', '*://*.google.com/*', '*://google.com/*']
for _pattern in _google_patterns:
    config.set('content.headers.user_agent', _chrome_ua, _pattern)
    config.set('content.headers.custom', {
        'sec-ch-ua': '"Google Chrome";v="140", "Chromium";v="140", "Not-A.Brand";v="24"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"Linux"',
    }, _pattern)
