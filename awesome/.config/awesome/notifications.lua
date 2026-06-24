-- ============================================================
-- Custom Notification Popup — Gruvbox Dark, flat minimal
-- (AwesomeWM 4.3)
-- ============================================================

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local M = {}

M.colors = {
    bg0    = "#282828",
    bg0_h  = "#1d2021",
    bg1    = "#3c3836",
    bg2    = "#504945",
    fg1    = "#ebdbb2",
    fg2    = "#d5c4a1",
    fg4    = "#a89984",
    red    = "#fb4934",
    green  = "#b8bb26",
    yellow = "#fabd2f",
    blue   = "#83a598",
    purple = "#d3869b",
    aqua   = "#8ec07c",
    orange = "#fe8019",
}

local urgency_accent = {
    low      = M.colors.aqua,
    normal   = M.colors.orange,
    critical = M.colors.red,
}

local function colorize(text, color)
    return string.format('<span foreground="%s">%s</span>', color, text)
end

-- Rounded on top only; the bottom edge stays square so the
-- progress underline runs the full width
local function rrect(radius)
    return function(cr, w, h)
        gears.shape.partially_rounded_rect(cr, w, h, true, true, false, false, radius)
    end
end

local active_notifs = {}

local function dismiss_notif(n)
    for i, item in ipairs(active_notifs) do
        if item == n then
            table.remove(active_notifs, i)
            break
        end
    end
    n.visible = false
    M._reposition()
end

function M._reposition()
    local s = awful.screen.focused()
    if not s then return end
    local margin = dpi(12)
    local spacing = dpi(8)
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

function M.notify(args)
    args = args or {}
    local urgency = args.urgency or "normal"
    local accent = urgency_accent[urgency] or M.colors.orange
    local timeout = args.timeout or 5

    local margin = dpi(12)
    local max_width = dpi(360)
    local min_width = dpi(160)
    local pad_x = dpi(16)

    local s = awful.screen.focused()
    if not s then return nil end

    -- Title (accent color carries the urgency)
    local title_w = wibox.widget {
        font   = "Lato Black 11",
        align  = "left",
        markup = colorize(args.title or "", accent),
        widget = wibox.widget.textbox,
    }

    -- Message
    local msg_w = wibox.widget {
        font   = "Open Sans 10",
        align  = "left",
        wrap   = "word",
        markup = colorize(args.text or args.message or "", M.colors.fg2),
        widget = wibox.widget.textbox,
    }

    -- Thin progress underline, flush with the card bottom
    local progress = wibox.widget {
        max_value        = 100,
        value            = 100,
        forced_height    = dpi(2),
        background_color = "#00000000",
        color            = accent,
        widget           = wibox.widget.progressbar,
    }

    local text_col = wibox.widget {
        title_w,
        msg_w,
        spacing = dpi(3),
        layout  = wibox.layout.fixed.vertical,
    }

    -- Vertically centered text with generous side padding
    local content = wibox.widget {
        {
            text_col,
            halign = "left",
            valign = "center",
            widget = wibox.container.place,
        },
        left   = pad_x,
        right  = pad_x,
        widget = wibox.container.margin,
    }

    -- Size the box to its text, clamped to [min_width, max_width]
    local title_tw = title_w:get_preferred_size(s)
    local msg_tw = msg_w:get_preferred_size(s)
    local width = math.max(title_tw, msg_tw) + pad_x * 2 + dpi(2)
    width = math.max(min_width, math.min(max_width, width))

    -- Background clips the stack, so the underline follows the
    -- rounded corners
    local final = wibox.widget {
        {
            content,
            {
                {
                    -- keep the underline inside the 1px card border
                    progress,
                    left   = dpi(1),
                    right  = dpi(1),
                    bottom = dpi(1),
                    widget = wibox.container.margin,
                },
                valign                  = "bottom",
                content_fill_horizontal = true,
                widget                  = wibox.container.place,
            },
            layout = wibox.layout.stack,
        },
        bg           = M.colors.bg0,
        shape        = rrect(dpi(10)),
        border_width = dpi(1),
        border_color = M.colors.bg2,
        widget       = wibox.container.background,
    }

    -- Create wibox
    local n = wibox({
        screen  = s,
        ontop   = true,
        visible = false,
        width   = width,
        height  = dpi(64),
        x       = s.geometry.x + s.geometry.width - width - margin,
        y       = s.geometry.y + margin,
        bg      = "#00000000",
    })
    n:set_widget(final)

    -- Click anywhere to dismiss
    n:buttons(gears.table.join(
        awful.button({}, 1, function() dismiss_notif(n) end)
    ))

    -- Auto-dismiss with progress animation
    if timeout > 0 then
        local total_time = timeout
        local elapsed = 0
        local interval = 0.1

        local timer = gears.timer {
            timeout   = interval,
            call_now  = false,
            autostart = true,
            callback  = function()
                elapsed = elapsed + interval
                local remaining = math.max(0, 100 - (elapsed / total_time * 100))
                progress.value = remaining
                if remaining <= 0 then
                    dismiss_notif(n)
                    timer:stop()
                end
            end,
        }
    end

    n.visible = true
    table.insert(active_notifs, n)
    M._reposition()

    return n
end

return M
