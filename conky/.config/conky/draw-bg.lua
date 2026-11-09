-- Rounded semi-transparent card behind the "System Status" conky.
-- Drawn before the text (lua_draw_hook_pre = 'draw_bg'), so text sits on top.
require 'cairo'

local function rounded_rect(cr, x, y, w, h, r)
    local deg = math.pi / 180
    cairo_new_sub_path(cr)
    cairo_arc(cr, x + w - r, y + r,     r, -90 * deg,   0 * deg)
    cairo_arc(cr, x + w - r, y + h - r, r,   0 * deg,  90 * deg)
    cairo_arc(cr, x + r,     y + h - r, r,  90 * deg, 180 * deg)
    cairo_arc(cr, x + r,     y + r,     r, 180 * deg, 270 * deg)
    cairo_close_path(cr)
end

function conky_draw_bg()
    if conky_window == nil then return end
    local w, h = conky_window.width, conky_window.height
    if w == 0 or h == 0 then return end

    -- conky >=1.25: conky owns the surface; get it fresh each frame, never destroy it
    local cs = conky_surface()
    if not cs then return end
    local cr = cairo_create(cs)

    -- Clear the whole window to fully transparent first. Without this, the
    -- corner regions outside the rounded card keep conky's opaque black
    -- background, which reads as a black square around the card.
    cairo_set_operator(cr, CAIRO_OPERATOR_CLEAR)
    cairo_paint(cr)
    cairo_set_operator(cr, CAIRO_OPERATOR_OVER)

    local inset, radius = 2, 20
    rounded_rect(cr, inset, inset, w - 2 * inset, h - 2 * inset, radius)

    -- fill: Catppuccin crust (#11111b) @ 88%, no border
    cairo_set_source_rgba(cr, 0x11 / 255, 0x11 / 255, 0x1b / 255, 0.88)
    cairo_fill(cr)

    cairo_destroy(cr)
end
