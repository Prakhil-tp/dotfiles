pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

local beautiful = require("beautiful")                    -- theme handling
local naughty = require("naughty")                        -- notification
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")


-- ===================================================================
-- Error Handler
-- ===================================================================

if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end

-- ===================================================================


-- Themes define colours, icons, font and wallpapers.
--beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
--beautiful.init(gears.filesystem.get_configuration_dir().."themes/pastel.lua" )
beautiful.init(gears.filesystem.get_configuration_dir().."themes/default/theme.lua" )
naughty.config.icon_dirs = {"/usr/share/icons/dracula-icons/scalable/apps/", "/usr/share/icons/custom-icons/"}
naughty.config.icon_formats = {"png","svg"}

-- This is used later as the default terminal and editor to run.
local terminal = "alacritty"
local editor = "nvim" or "vi"
local editor_cmd = terminal .. " -e " .. editor
local modkey = "Mod4"

-- Define layouts
awful.layout.layouts = {
	awful.layout.suit.tile,
	--awful.layout.suit.floating,
  awful.layout.suit.max,
	awful.layout.suit.spiral,
	awful.layout.suit.magnifier,
	awful.layout.suit.fair
}

-- Keyboard map indicator and switcher
--mykeyboardlayout = awful.widget.keyboardlayout()

awful.screen.connect_for_each_screen(function(s)
	-- Each screen has its own tag table.
  local names = { "dev", "2", "3", "4", "www", "6", "7", "8", "music" } 
  local l = awful.layout.suit
  local layouts = {l.tile, l.tile, l.tile, l.tile, l.max, l.tile, l.tile, l.tile, l.max}
	awful.tag(names, s, layouts)
end)

-- Import Keybindings
local keys = require("keys")
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

-- Import Rules
local createrules = require("rules").create 
awful.rules.rules = createrules(keys.clientkeys,keys.clientbuttons)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave (put it at the end of others instead of setting it master.)

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- window on focus 
client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

client.connect_signal("request::activate", function(c)
  if c.minimized then
    c.minimized = false
  end
  awful.ewmh.activate(c, context, hints)
end)

-- Autostart
awful.spawn.with_shell("picom")
awful.spawn.with_shell("clipmenud")   -- clipmenu
awful.spawn.with_shell("~/scripts/change-wallpaper.sh")
awful.spawn.with_shell("~/.config/awesome/autorun.sh")

