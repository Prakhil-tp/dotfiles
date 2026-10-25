-- ============================================================
-- Custom Notification Popup — Catppuccin Mocha, macOS/GNOME style
-- Header row (app badge + app name + time), bold title, body.
-- (AwesomeWM 4.3)
-- ============================================================

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local M = {}

M.colors = {
    base     = "#1e1e2e",
    glass    = "#1e1e2ea6", -- base at 65%; picom blurs what's behind
    surface0 = "#313244",
    overlay  = "#7f849c",
    subtext  = "#a6adc8",
    text     = "#cdd6f4",
    lavender = "#b4befe",
    red      = "#f38ba8",
    teal     = "#94e2d5",
}

local urgency_accent = {
    low      = M.colors.teal,
    normal   = M.colors.lavender,
    critical = M.colors.red,
}

local width   = dpi(360)
local radius  = dpi(14)
local pad     = dpi(14)
local margin  = dpi(12)
local spacing = dpi(8)
local badge   = dpi(18)

local function colorize(text, color)
    return string.format('<span foreground="%s">%s</span>', color, text)
end

local function rounded(r)
    return function(cr, w, h) gears.shape.rounded_rect(cr, w, h, r) end
end

-- Resolve an icon argument to an image (surface or file path), or nil.
-- Short strings are treated as glyphs (e.g. Nerd Font icons from keys.lua).
local function resolve_image(icon)
    if not icon then return nil end
    if type(icon) ~= "string" then return icon end -- cairo surface from dbus
    local path = icon:gsub("^file://", "")
    if path:sub(1, 1) == "/" then
        return gears.filesystem.file_readable(path) and path or nil
    end
    for _, dir in ipairs(naughty.config.icon_dirs or {}) do
        for _, ext in ipairs(naughty.config.icon_formats or {}) do
            local p = dir .. icon .. "." .. ext
            if gears.filesystem.file_readable(p) then return p end
        end
    end
    return nil
end

local function make_badge(args, accent)
    local image = resolve_image(args.icon)
    local inner
    if image then
        inner = wibox.widget {
            image  = image,
            resize = true,
            widget = wibox.widget.imagebox,
        }
    else
        local glyph = (type(args.icon) == "string" and #args.icon <= 4 and args.icon)
            or ((args.app_name or "?"):sub(1, 1):upper())
        inner = wibox.widget {
            markup = colorize(gears.string.xml_escape(glyph), M.colors.base),
            font   = "Noto Sans Bold 8",
            align  = "center",
            valign = "center",
            widget = wibox.widget.textbox,
        }
    end
    return wibox.widget {
        inner,
        bg            = image and "#00000000" or accent,
        shape         = rounded(dpi(5)),
        shape_clip    = true,
        forced_width  = badge,
        forced_height = badge,
        widget        = wibox.container.background,
    }
end

local function textbox(markup, font)
    local tb = wibox.widget { font = font, wrap = "word", widget = wibox.widget.textbox }
    -- dbus bodies may carry (possibly broken) markup; fall back to plain text
    if not tb:set_markup_silently(markup) then tb:set_text(markup) end
    return tb
end

local active_notifs = {}
local by_id = {}

local function dismiss_notif(n)
    for i, item in ipairs(active_notifs) do
        if item == n then
            table.remove(active_notifs, i)
            break
        end
    end
    if n.timer then n.timer:stop() end
    if n.notif_id then by_id[n.notif_id] = nil end
    n.visible = false
    M._reposition()
end

function M._reposition()
    local s = awful.screen.focused()
    if not s then return end
    local y = s.geometry.y + margin
    for _, item in ipairs(active_notifs) do
        if item.visible then
            local geo = item:geometry()
            item:geometry({
                x = s.geometry.x + s.geometry.width - geo.width - margin,
                y = y,
            })
            y = y + geo.height + spacing
        end
    end
end

-- args: title, text|message, urgency ("low"|"normal"|"critical"),
-- app_name, icon (path, icon name, surface or glyph), timeout, id
function M.notify(args)
    args = args or {}
    local urgency = args.urgency or "normal"
    local accent = urgency_accent[urgency] or M.colors.lavender
    -- critical stays until clicked, like naughty's critical preset
    local timeout = args.timeout or (urgency == "critical" and 0 or 5)

    local s = awful.screen.focused()
    if not s then return nil end

    -- Replacing an existing notification (dbus replaces_id)
    if args.id and by_id[args.id] then dismiss_notif(by_id[args.id]) end

    local title = args.title or ""
    local body = args.text or args.message or ""
    if title == "" then title, body = body, "" end

    local header = wibox.widget {
        {
            make_badge(args, accent),
            textbox(colorize(gears.string.xml_escape(args.app_name or "Notification"), M.colors.subtext),
                "Noto Sans 8.5"),
            spacing = dpi(8),
            layout  = wibox.layout.fixed.horizontal,
        },
        nil,
        textbox(colorize("now", M.colors.overlay), "Noto Sans 8.5"),
        layout = wibox.layout.align.horizontal,
    }

    local column = wibox.layout.fixed.vertical()
    column.spacing = dpi(4)
    column:add(header)
    column:add(textbox(colorize(gears.string.xml_escape(title), M.colors.text), "Noto Sans SemiBold 10.5"))
    if body ~= "" then
        column:add(textbox(colorize(body, M.colors.subtext), "Noto Sans 9.5"))
    end

    local card = wibox.widget {
        {
            column,
            margins = pad,
            widget  = wibox.container.margin,
        },
        bg                 = M.colors.glass,
        shape              = rounded(radius),
        shape_clip         = true,
        shape_border_width = dpi(1),
        shape_border_color = urgency == "critical" and M.colors.red or M.colors.surface0,
        forced_width       = width,
        widget             = wibox.container.background,
    }

    -- Height follows the content at the fixed width
    local _, height = card:fit({ dpi = s.dpi }, width, s.geometry.height)

    local n = wibox({
        screen  = s,
        ontop   = true,
        visible = false,
        type    = "notification",
        width   = width,
        height  = math.ceil(height),
        bg      = "#00000000",
        -- The X shape is aliased but clips picom's blur to the card; picom's
        -- slightly larger corner-radius then smooths the edge
        shape   = rounded(radius),
    })
    n:set_widget(card)
    n.notif_id = args.id

    n:buttons(gears.table.join(
        awful.button({}, 1, function() dismiss_notif(n) end)
    ))

    -- Auto-dismiss, paused while the pointer is over the card
    if timeout > 0 then
        n.timer = gears.timer {
            timeout     = timeout,
            single_shot = true,
            autostart   = true,
            callback    = function() dismiss_notif(n) end,
        }
        n:connect_signal("mouse::enter", function() n.timer:stop() end)
        n:connect_signal("mouse::leave", function() n.timer:again() end)
    end

    n.visible = true
    table.insert(active_notifs, n)
    if args.id then by_id[args.id] = n end
    M._reposition()

    return n
end

-- Route every naughty notification (dbus + naughty.notify) through M.notify
function M.hook_naughty()
    naughty.config.notify_callback = function(args)
        local hints = args.freedesktop_hints or {}
        local urgency = "normal"
        if hints.urgency == "\2" or args.preset == naughty.config.presets.critical then
            urgency = "critical"
        elseif hints.urgency == "\0" then
            urgency = "low"
        end
        local id = args.replaces_id
        if args.freedesktop_hints and not id then
            -- naughty's dbus handler replies with the next id right after
            -- this callback returns nil; claim the same id so replaces work
            id = naughty.get_next_notification_id() + 1
        end
        M.notify {
            title    = args.title,
            text     = args.text,
            urgency  = urgency,
            app_name = args.appname,
            icon     = args.icon,
            timeout  = args.timeout,
            id       = id,
        }
        return nil
    end
end

return M
