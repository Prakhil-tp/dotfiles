--      ██╗  ██╗███████╗██╗   ██╗███████╗
--      ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝
--      █████╔╝ █████╗   ╚████╔╝ ███████╗
--      ██╔═██╗ ██╔══╝    ╚██╔╝  ╚════██║
--      ██║  ██╗███████╗   ██║   ███████║
--      ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local bling = require("bling")

-- Define mod keys
local modkey = "Mod4"
local altkey = "Mod1"
-- local terminal = "alacritty"
local terminal = "kitty"


-- define module table
local keys = {}


-- ===================================================================
-- Scratchpads
-- ===================================================================
local term_scratch = bling.module.scratchpad {
  -- command = "alacritty --class spad",
  command                 = "kitty --class spad",
  rule                    = { instance = "spad" },                             -- The rule that the scratchpad will be searched by
  sticky                  = true,                                              -- Whether the scratchpad should be sticky
  autoclose               = true,                                              -- Whether it should hide itself when losing focus
  floating                = true,                                              -- Whether it should be floating (MUST BE TRUE FOR ANIMATIONS)
  geometry                = { x = 340, y = 200, height = 1400, width = 2200 }, -- The geometry in a floating state
  reapply                 = true,                                              -- Whether all those properties should be reapplied on every new opening of the scratchpad (MUST BE TRUE FOR ANIMATIONS)
  dont_focus_before_close = false,                                             -- When set to true, the scratchpad will be closed by the toggle function regardless of whether its focused or not. When set to false, the toggle function will first bring the scratchpad into focus and only close it on a second call
}

-- ===================================================================
-- Helper functions
-- ===================================================================

local function focus_screen_and_warp(dir)
  awful.screen.focus_relative(dir)
  local s = awful.screen.focused()
  mouse.coords({ x = s.geometry.x + 10, y = s.geometry.y + 10 })
end

-- ===================================================================
-- Desktop Key bindings
-- ===================================================================

keys.globalkeys = gears.table.join(
  awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
  awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
  awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
  awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),


  -- client(window) Key bindings

  awful.key({ modkey }, "j", function()
    awful.client.focus.byidx(1)
  end, { description = "focus next by index", group = "client" }),
  awful.key({ modkey }, "k", function()
    awful.client.focus.byidx(-1)
  end, { description = "focus previous by index", group = "client" }),

  -- Layout manipulation
  awful.key({ modkey, "Shift" }, "j", function()
    awful.client.swap.byidx(1)
  end, { description = "swap with next client by index", group = "client" }),
  awful.key({ modkey, "Shift" }, "k", function()
    awful.client.swap.byidx(-1)
  end, { description = "swap with previous client by index", group = "client" }),
  awful.key({ modkey, "Control" }, "j", function()
    focus_screen_and_warp(-1)
  end, { description = "focus the next screen", group = "screen" }),
  awful.key({ modkey, "Control" }, "k", function()
    focus_screen_and_warp(1)
  end, { description = "focus the previous screen", group = "screen" }),
  awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
  awful.key({ modkey }, "Tab", function()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end, { description = "go back", group = "client" }),

  -- Standard program
  awful.key({ modkey }, "Return", function()
    awful.spawn(terminal)
  end, { description = "open a terminal", group = "launcher" }),
  awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
  awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
  awful.key({ "Mod1", "Control" }, "Delete", function()
    awful.spawn.with_shell("~/scripts/dm-shutdown")
  end, { description = "shutdown / reboot / logout", group = "System" }),

  -- layout
  awful.key({ modkey }, "l", function()
    awful.tag.incmwfact(0.05)
  end, { description = "increase master width factor", group = "layout" }),
  awful.key({ modkey }, "h", function()
    awful.tag.incmwfact(-0.05)
  end, { description = "decrease master width factor", group = "layout" }),
  awful.key({ modkey, "Shift" }, "h", function()
    awful.tag.incnmaster(1, nil, true)
  end, { description = "increase the number of master clients", group = "layout" }),
  awful.key({ modkey, "Shift" }, "l", function()
    awful.tag.incnmaster(-1, nil, true)
  end, { description = "decrease the number of master clients", group = "layout" }),
  awful.key({ modkey, "Control" }, "h", function()
    awful.tag.incncol(1, nil, true)
  end, { description = "increase the number of columns", group = "layout" }),
  awful.key({ modkey, "Control" }, "l", function()
    awful.tag.incncol(-1, nil, true)
  end, { description = "decrease the number of columns", group = "layout" }),
  awful.key({ modkey }, "Tab", function()
    awful.layout.inc(1)
  end, { description = "select next", group = "layout" }),
  awful.key({ modkey, "Shift" }, "Tab", function()
    awful.layout.inc(-1)
  end, { description = "select previous", group = "layout" }),

  --[[
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
--]]



  -- ====================================
  -- Applications
  -- ====================================
  awful.key({}, "Print", function() awful.spawn("flameshot gui") end,
    { description = "Take a screenshot using flameshot", group = "screenshot" }),
  awful.key({ modkey }, "space", function()
    awful.spawn("rofi -show drun")
  end, { description = "run rofi", group = "launcher" }),
  awful.key({ "Mod1" }, "Tab", function()
    awful.spawn("rofi -show window")
  end, { description = "switch window", group = "launcher" }),
  awful.key({ modkey }, "b", function()
    --awful.spawn("brave")
    --end, { description = "launch brave", group = "applications" }),
    awful.spawn.with_shell("firefox")
  end, { description = "launch thorium", group = "applications" }),
  awful.key({ modkey }, "q", function()
    awful.spawn("qutebrowser")
  end, { description = "launch qutebrowser", group = "applications" }),
  awful.key({ modkey }, "e", function()
    term_scratch:toggle()
  end, { description = "launch scratchpad", group = "applications" }),

  awful.key({ modkey }, "r", function()
    awful.spawn.spawn("dmenu_run")
  end, { description = "launch dmenu_run", group = "applications" }),

  awful.key({ modkey }, "c", function()
    awful.spawn.with_shell("surf https://chatgpt.com/")
  end, { description = "launch chatgpt on surf", group = "applications" }),

  awful.key({ modkey }, "v", function()
    awful.spawn.spawn("kitty -e vifm")
  end, { description = "launch chatgpt on surf", group = "applications" }),

  --
  -- awful.key({ "Control", "Shift" }, "l", function()
  -- 	awful.spawn.with_shell("~/scripts/dm-passmenu")
  -- end, { description = "pass password manager dmenu script", group = "script" }),
  --

  -- awful.key({ modkey }, "o", function()
  --   local handle = io.popen(
  --     "find \"$HOME\" \\( -path \"$HOME/.git\" -o -path \"$HOME/node_modules\" -o -path \"$HOME/__pycache__\" -o -path \"$HOME/.npm\" -o -name \".cache\" \\) -prune -o -type f -print | dmenu -i -l 20")
  --   local result = handle:read("*a")
  --   handle:close()
  --   filepath = result:gsub("\n[^\n]*$", "")
  --
  --   if (filepath ~= "") then
  --     handle = io.popen("xdg-mime query filetype " .. filepath .. " | xargs -e -I {} xdg-mime query default {}")
  --     result = handle:read("*a")
  --     handle:close()
  --     application = result:gsub("\n[^\n]*$", "")
  --
  --     if (application == "nvim.desktop") then
  --       awful.spawn("alacritty -e zsh -c 'source $ZDOTDIR/.minimal-zshrc && nvim " .. filepath .. "'")
  --     else
  --       awful.spawn.with_shell("xdg-open " .. filepath)
  --     end
  --   end
  -- end, { description = "open any files", group = "applications" }),

  -- ===================================
  -- key bindings followed by  Mod + p
  -- ===================================
  awful.key({ modkey }, "p", function()
    awful.keygrabber({
      mask_modkeys = true,
      autostart = true,
      stop_key = "Mod4",
      timeout = 1,
      keybindings = {
        {
          {},
          "w",
          function(self)
            awful.spawn.with_shell("~/scripts/rofi-wifi-menu/rofi-wifi-menu.sh")
            self:stop()
          end,
        },
        {
          {},
          "b",
          function(self)
            awful.spawn.with_shell("~/scripts/rofi-bluetooth/rofi-bluetooth.sh")
            self:stop()
          end,
        },
        {
          {},
          "s",
          function(self)
            awful.spawn.with_shell("spotify")
            awful.spawn.with_shell("~/scripts/spotify-automute.sh >> /tmp/spotify-automute.log")
            self:stop()
          end,
        },
        {
          {},
          "y",
          function(self)
            awful.spawn.with_shell("kitty -e yt-x")
            self:stop()
          end,
        },
        {
          {},
          ".",
          function(self)
            --awful.spawn.with_shell("feh --bg-fill -r -z ~/Pictures/Wallpapers")
            awful.spawn.with_shell("~/scripts/change-wallpaper.sh")
            self:stop()
          end,
        },
        {
          {},
          "o",
          function(self)
            awful.spawn.with_shell("~/scripts/dm-sound")
            self:stop()
          end,
        },
        {
          {},
          "f",
          function(self)
            awful.spawn.with_shell("~/scripts/dm-fontviewer.sh")
            self:stop()
          end,
        },
        {
          {},
          "v",
          function(self)
            awful.spawn.with_shell("clipmenu -i")
            self:stop()
          end,
        },
        {
          {},
          "x",
          function(self)
            awful.spawn.with_shell("~/scripts/rofi-screen.sh")
            self:stop()
          end,
        },
        {
          {},
          "/",
          function(self)
            awful.spawn.with_shell("~/scripts/dm-websearch/dm-websearch")
            self:stop()
          end,
        },
        {
          {},
          "i",
          function(self)
            awful.spawn.with_shell(
              "xdotool type $(grep -v '^|' ~/.local/share/script-files/snippets.txt | dmenu -i -l 20 | cut -d' ' -f1)")
            self:stop()
          end,
        },
        {
          {},
          "c",
          function(self)
            awful.spawn.with_shell("~/scripts/dm-bookmark.sh")
            self:stop()
          end,
        }
      },
    })
  end, { description = "Followed by a key", group = "scripts" }),

  -- ===================================
  -- key bindings followed by  Mod + w
  -- ===================================
  awful.key({ modkey }, "w", function()
    awful.keygrabber({
      mask_modkeys = true,
      autostart = true,
      stop_key = "Mod4",
      timeout = 1,
      keybindings = {
        {
          {},
          ".",
          function(self)
            awful.spawn.with_shell("~/scripts/change-wallpaper.sh")
            self:stop()
          end
        },
        {
          {},
          "d",
          function(self)
            awful.spawn.with_shell("~/scripts/remove-wallpaper.sh")
            self:stop()
          end
        }
      }
    })
  end, { description = "wallpaper scritps", group = "scripts" }),

  -- ===================================
  -- key bindings followed by  Mod + i
  -- ===================================
  awful.key({ modkey }, "i", function()
    awful.keygrabber({
      mask_modkeys = true,
      autostart = true,
      stop_key = "Mod4",
      timeout = 1,
      keybindings = {
        {
          {},
          "t",
          function(self)
            function alignMiddle(short, long)
              local diff = (#long / 2) - (#short / 2)
              for i = 1, diff + 2 do
                short = " " .. short
              end
              return { short, long }
            end

            local list = alignMiddle(os.date("%I:%M %p"), os.date("%A, %b %d"))
            naughty.notify {
              title = list[1],
              text = list[2],
              margin = 10,
              position = "top_middle",
              bg = "#282a36",
              fg = "#f8f8f2",
              border_color = "#bd93f9"
            }
            self:stop()
          end
        },
        {
          {},
          "b",
          function(self)
            if gears.filesystem.file_readable("/sys/class/power_supply/BATT/capacity") then
              local f = io.open("/sys/class/power_supply/BATT/capacity")
              local battery = " " .. f:read() .. "%"
              f:close()
              naughty.notify {
                text = battery,
                margin = 10,
                position = "top_middle",
                bg = "#282a36",
                fg = "#f8f8f2",
                border_color = "#bd93f9"
              }
            else
              naughty.notify {
                title = "Attention!",
                text = "No Battery information available",
              }
            end
            self:stop()
          end
        }
      }
    })
  end, { description = "information", group = "scripts" }),

  -- ===================================
  -- Music keybindings
  -- ===================================

  --[[
	awful.key({ "Control" }, "Right", function()
    awful.spawn.with_shell("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
	end, { description = "Next track", group = "Music" }),

	awful.key({ "Control" }, "Left", function()
    awful.spawn.with_shell("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
	end, { description = "Previous track", group = "Music" }),

	awful.key({ "Control" }, "Down", function()
    awful.spawn.with_shell("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
	end, { description = "Play/Pause track", group = "Music" })
)
]] --


  awful.key({ "Control" }, "Right", function()
    awful.spawn.with_shell("playerctl next")
  end, { description = "Next track", group = "Music" }),

  awful.key({ "Control" }, "Left", function()
    awful.spawn.with_shell("playerctl previous")
  end, { description = "Previous track", group = "Music" }),

  awful.key({ "Control" }, "Down", function()
    awful.spawn.with_shell("playerctl play-pause")
  end, { description = "Play/Pause track", group = "Music" })
)

-- ===================================================================
-- Client Key bindings
-- ===================================================================

keys.clientkeys = gears.table.join(
  awful.key({ modkey }, "f", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end, { description = "toggle fullscreen", group = "client" }),
  awful.key({ modkey, "Shift" }, "c", function(c)
    c:kill()
  end, { description = "close", group = "client" }),
  awful.key(
    { modkey, "Control" },
    "space",
    awful.client.floating.toggle,
    { description = "toggle floating", group = "client" }
  ),
  --awful.key({ modkey, "Control" }, "Return", function(c)
  --c:swap(awful.client.getmaster())
  --end, { description = "move to master", group = "client" }),
  awful.key({ modkey, "Shift" }, "m", function(c)
    c:swap(awful.client.getmaster())
  end, { description = "move to master", group = "client" }),
  awful.key({ modkey, "Control" }, "o", function(c)
    c:move_to_screen()
  end, { description = "move to screen", group = "client" }),
  awful.key({ modkey }, "t", function(c)
    c.ontop = not c.ontop
  end, { description = "toggle keep on top", group = "client" }),
  --minimize
  awful.key({ modkey }, "n", function(c)
    c.minimized = true
  end, { description = "minimize", group = "client" }),
  --unminimize
  awful.key({ modkey, "Shift" }, "n", function()
    local c = awful.client.restore()
    if c then
      c:emit_signal("request::activate", "key.unminimize", { raise = true })
      c.minimized = false
    end
  end, { description = "restore minimized", group = "client" }),
  awful.key({ modkey }, "m", function(c)
    c.maximized = not c.maximized
    c:raise()
  end, { description = "(un)maximize", group = "client" }),
  awful.key({ modkey, "Control" }, "m", function(c)
    c.maximized_vertical = not c.maximized_vertical
    c:raise()
  end, { description = "(un)maximize vertically", group = "client" })
--awful.key({ modkey, "Shift" }, "m", function(c)
--c.maximized_horizontal = not c.maximized_horizontal
--c:raise()
--end, { description = "(un)maximize horizontally", group = "client" })
)


-- ===================================================================
-- Mouse menu & bindings
-- ===================================================================

-- styles
beautiful.menu_height = 20
beautiful.menu_width = 180

-- menu
mousemenu = awful.menu({
  items = {
    { "open alacritty",      terminal },
    { "open xterm",          "xterm" },
    { "open gnome-terminal", "gnome-terminal" },
  }
})

-- button bindings
keys.desktopbuttons = gears.table.join(
  awful.button({}, 3, function()
    mousemenu:toggle()
  end),
  awful.button({}, 4, awful.tag.viewnext),
  awful.button({}, 5, awful.tag.viewprev)
)


keys.clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
  end),
  awful.button({ modkey }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ modkey }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.resize(c)
  end)
)

-- Bind all key numbers to tags.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  keys.globalkeys = gears.table.join(
    keys.globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        tag:view_only()
      end
    end, { description = "view tag #" .. i, group = "tag" }),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end, { description = "toggle tag #" .. i, group = "tag" }),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end, { description = "move focused client to tag #" .. i, group = "tag" }),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end, { description = "toggle focused client on tag #" .. i, group = "tag" })
  )
end

return keys
