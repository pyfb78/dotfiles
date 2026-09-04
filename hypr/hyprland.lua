    -- Hyprland Lua configuration
-- Converted from the legacy hyprlang config for Hyprland 0.55+ / 0.57.
-- Current config location: ~/.config/hypr/hyprland.lua

------------------
---- MONITORS ----
------------------

hl.monitor({
    output = "eDP-1",
    mode = "2560x1600@120.0",
    position = "0x0",
    scale = 1.0,
})

hl.monitor({
    output = "HDMI-A-1",
    mode = "3840x2160@60.0",
    position = "2560x0",
    scale = 1.0,
})

---------------------
---- MY PROGRAMS ----
---------------------

local home = os.getenv("HOME")
local terminal = "kitty"
local fileManager = "thunar"
local rofiRunDir = home .. "/.config/rofi/launchers/type-3"
local rofiRunTheme = "style-1"
local menu = "rofi -show drun -theme " .. rofiRunDir .. "/" .. rofiRunTheme .. ".rasi"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper --config " .. home .. "/.config/hypr/hyprpaper.conf")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("dunst")
    hl.exec_cmd("pkill waybar || waybar")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,

        col = {
            inactive_border = {
                colors = { "rgba(99c199ff)", "rgba(43934dff)" },
                angle = 45,
            },
            active_border = "rgba(66a266ff)",
        },

        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding = 10,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a,
        },

        blur = {
            enabled = true,
            size = 4,
            passes = 4,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

--------------------
---- ANIMATIONS ----
--------------------

hl.curve("easeOutQuint", {
    type = "bezier",
    points = { { 0.23, 1 }, { 0.32, 1 } },
})

hl.curve("easeInOutCubic", {
    type = "bezier",
    points = { { 0.65, 0.05 }, { 0.36, 1 } },
})

hl.curve("linear", {
    type = "bezier",
    points = { { 0, 0 }, { 1, 1 } },
})

hl.curve("almostLinear", {
    type = "bezier",
    points = { { 0.5, 0.5 }, { 0.75, 1.0 } },
})

hl.curve("quick", {
    type = "bezier",
    points = { { 0.15, 0 }, { 0.1, 1 } },
})

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4.0,  bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",     enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",   enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut",  enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

-----------------
---- LAYOUTS ----
-----------------

hl.config({
    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },
})

--------------
---- MISC ----
--------------

hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
    },
})

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,

        touchpad = {
            natural_scroll = true,
        },
    },
})

-- macOS-like 3-finger horizontal workspace swipe
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    scale = 0.3,
    action = "workspace",
})

-- Kept from your original config. If this is only the stock example device
-- and you do not actually have a device with this name, you can delete it.
hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- Programs / window actions
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + N", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("pkill waybar || waybar"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- Move focus with SUPER + arrows / vim keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + h",     hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + l",     hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + k",     hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + j",     hl.dsp.focus({ direction = "d" }))

-- Workspaces 1-10, and SUPER+SHIFT to move a window there
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scratchpad
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys. bindel -> locked + repeating; bindl -> locked.
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),       { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),       { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),      { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -d intel_backlight s 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -d intel_backlight s 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),      { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Resize active window with SUPER+SHIFT+arrows
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 10,  y = 0,   relative = true }))
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.resize({ x = -10, y = 0,   relative = true }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.resize({ x = 0,   y = -10, relative = true }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.resize({ x = 0,   y = 10,  relative = true }))

-- Move active window with CTRL+SHIFT+arrows / vim keys
hl.bind("CTRL + SHIFT + left",  hl.dsp.window.move({ direction = "l" }))
hl.bind("CTRL + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind("CTRL + SHIFT + up",    hl.dsp.window.move({ direction = "u" }))
hl.bind("CTRL + SHIFT + down",  hl.dsp.window.move({ direction = "d" }))
hl.bind("CTRL + SHIFT + h",     hl.dsp.window.move({ direction = "l" }))
hl.bind("CTRL + SHIFT + l",     hl.dsp.window.move({ direction = "r" }))
hl.bind("CTRL + SHIFT + k",     hl.dsp.window.move({ direction = "u" }))
hl.bind("CTRL + SHIFT + j",     hl.dsp.window.move({ direction = "d" }))

-- Fixed malformed "$mainMod$" bindings from the old config
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd("discord"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("emote"))

-- Toggle floating, then resize exactly to 1280x720 without legacy hyprctl syntax
hl.bind("CTRL + SHIFT + F", function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    hl.dispatch(hl.dsp.window.resize({ x = 1280, y = 720 }))
end)

-- Screenshot region to clipboard
hl.bind("CTRL + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))

-- Move current workspace to monitor 2
hl.bind("CTRL + " .. mainMod .. " + SHIFT + 2", hl.dsp.workspace.move({ monitor = 2 }))

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Ignore maximize requests from apps
hl.window_rule({
    name = "windowrule-1",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name = "windowrule-2",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

hl.window_rule({
    name = "windowrule-3",
    match = { class = "^(Zathura)$" },
    opacity = "0.9 0.9",
})

hl.window_rule({
    name = "windowrule-4",
    match = { class = "^(firefox)$" },
    opacity = "0.9",
})

hl.window_rule({
    name = "windowrule-5",
    match = { class = "^(Code)$" },
    opacity = "0.95",
})

hl.window_rule({
    name = "windowrule-6",
    match = { class = "^(nemo)$" },
    opacity = "0.95",
})

hl.window_rule({
    name = "windowrule-7",
    match = { class = "^(discord)$" },
    opacity = "0.9",
})

hl.window_rule({
    name = "windowrule-8",
    match = { class = "^(spotify)$" },
    opacity = "0.9",
})

hl.window_rule({
    name = "windowrule-9",
    match = { class = "^(neovide)$" },
    opacity = "0.9",
})

hl.window_rule({
    name = "windowrule-10",
    match = { class = "^(kitty)$" },
    scroll_touchpad = 1,
})

hl.layer_rule({
    match = {
        namespace = "^swaync-control-center$",
    },
    blur = true,
    ignore_alpha = 0.1,
})
