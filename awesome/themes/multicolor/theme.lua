
local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}
theme.confdir                                   = os.getenv("HOME") .. "/.config/awesome/themes/multicolor"
--theme.wallpaper                                 = theme.confdir .. "/wallpaper.jpg"
theme.font                                      = "Noto Sans Regular 9"
theme.taglist_font                              = "Noto Sans Regular 10"
theme.menu_bg_normal                            = "#000000"
theme.menu_bg_focus                             = "#000000"
theme.bg_normal                                 = "#000000"
theme.bg_focus                                  = "#000000"
theme.bg_urgent                                 = "#000000"
theme.fg_normal                                 = "#aaaaaa"
theme.fg_focus                                  = "#ff8c00"
theme.fg_urgent                                 = "#af1d18"
theme.fg_minimize                               = "#ffffff"
theme.border_width                              = dpi(1) 
theme.border_normal                             = "#000000"
theme.border_focus                              = "#ff00ff" --"#e33a6e"--"#5e81ac"
theme.border_marked                             = "#ff0000"
theme.menu_border_width                         = 0
theme.menu_height                               = dpi(25)
theme.menu_width                                = dpi(210)
theme.menu_submenu_icon                         = theme.confdir .. "/icons/submenu.png"
theme.menu_fg_normal                            = "#aaaaaa"
theme.menu_fg_focus                             = "#ff8c00"
theme.menu_bg_normal                            = "#050505dd"
theme.menu_bg_focus                             = "#050505dd"
theme.widget_temp                               = theme.confdir .. "/icons/temp.png"
theme.widget_ac                                 = theme.confdir .. "/icons/ac.png"
theme.widget_cpu                                = theme.confdir .. "/icons/cpu.png"
theme.widget_weather                            = theme.confdir .. "/icons/dish.png"
theme.widget_fs                                 = theme.confdir .. "/icons/fs.png"
theme.widget_mem                                = theme.confdir .. "/icons/mem.png"
theme.widget_netdown                            = theme.confdir .. "/icons/net_down.png"
theme.widget_netup                              = theme.confdir .. "/icons/net_up.png"
theme.widget_mail                               = theme.confdir .. "/icons/mail.png"
theme.widget_batt                               = theme.confdir .. "/icons/bat.png"

theme.widget_battfull                           = theme.confdir .. "/icons/batfull.png"
theme.widget_batt10                             = theme.confdir .. "/icons/bat10.png"
theme.widget_batt50                             = theme.confdir .. "/icons/bat50.png"
theme.widget_batt25                             = theme.confdir .. "/icons/bat25.png"
theme.widget_batt75                             = theme.confdir .. "/icons/bat75.png"
theme.widget_batt85                             = theme.confdir .. "/icons/bat85.png"
theme.widget_battcharging                       = theme.confdir .. "/icons/batcharging.gif"
theme.widget_battplug                           = theme.confdir .. "/icons/batcharge.png"  

theme.widget_clock                              = theme.confdir .. "/icons/clock.png"
theme.widget_vol                                = theme.confdir .. "/icons/spkr.png"
theme.widget_music                              = theme.confdir .. "/icons/note.png"
theme.widget_music_on                           = theme.confdir .. "/icons/note.png"
theme.widget_music_pause                        = theme.confdir .. "/icons/pause.png"
theme.widget_music_stop                         = theme.confdir .. "/icons/stop.png"
theme.taglist_squares_sel                       = theme.confdir .. "/icons/square_a.png"
theme.taglist_squares_unsel                     = theme.confdir .. "/icons/square_b.png"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = 2
theme.layout_tile                               = theme.confdir .. "/icons/tile.png"
theme.layout_fairv                              = theme.confdir .. "/icons/fairv.png"
theme.layout_max                                = theme.confdir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.confdir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.confdir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.confdir .. "/icons/floating.png"

local markup = lain.util.markup

-- Textclock
os.setlocale(os.getenv("LANG")) -- to localize the clock
local clockicon = wibox.widget.imagebox(theme.widget_clock)
local mytextclock = wibox.widget.textclock(markup("#7788af", "%a, %d %B ") .. markup("#535f7a", ">") .. markup("#de5e1e", " %I:%M %p "))
mytextclock.font = theme.font

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { mytextclock },
    notification_preset = {
        font = "Noto Sans Mono Medium 10",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})

-- Weather
local weathericon = wibox.widget.imagebox(theme.widget_weather) --my api key = 15afb58db613c57c348f437b57e9b3c9 
theme.weather = lain.widget.weather({
    city_id = 1282988, -- placeholder (Nepal)
    notification_preset = { font = "Noto Sans Mono Medium 10", fg = theme.fg_normal },
    weather_na_markup = markup.fontfg(theme.font, "#eca4c4", "N/A "),
    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(markup.fontfg(theme.font, "#eca4c4", descr .. " @ " .. units .. "°C "))
    end
})

-- / fs
--[[ commented because it needs Gio/Glib >= 2.54
local fsicon = wibox.widget.imagebox(theme.widget_fs)
theme.fs = lain.widget.fs({
    notification_preset = { font = "Noto Sans Mono Medium 10", fg = theme.fg_normal },
    settings  = function()
        widget:set_markup(markup.fontfg(theme.font, "#80d9d8", string.format("%.1f", fs_now["/"].used) .. "% "))
    end
})
--]]

-- Mail IMAP check
--[[ commented because it needs to be set before use
local mailicon = wibox.widget.imagebox()
theme.mail = lain.widget.imap({
    timeout  = 180,
    server   = "server",
    mail     = "mail",
    password = "keyring get mail",
    settings = function()
        if mailcount > 0 then
            mailicon:set_image(theme.widget_mail)
            widget:set_markup(markup.fontfg(theme.font, "#cccccc", mailcount .. " "))
        else
            widget:set_text("")
            --mailicon:set_image() -- not working in 4.0
            mailicon._private.image = nil
            mailicon:emit_signal("widget::redraw_needed")
            mailicon:emit_signal("widget::layout_changed")
        end
    end
})
--]]

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
--[[local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, "#e33a6e", cpu_now.usage .. "% "))
    end
})
]]

-- Coretemp
local tempicon = wibox.widget.imagebox(theme.widget_temp)
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, "#f1af5f", coretemp_now .. "°C  "))
    end
})
-- Battery

local baticon = wibox.widget.imagebox(theme.widget_batt50)
--[[
local bat = lain.widget.bat({
    settings = function()
        local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or bat_now.perc

--my try
	local bat_per = tonumber(bat_now.perc) --getting battery percentage

	if bat_per > 0 and bat_per < 20 then
		baticon:set_image(theme.widget_batt10)
	elseif bat_per >= 20 and bat_per < 40 then
		baticon:set_image(theme.widget_batt25)
	elseif bat_per >=40 and bat_per < 60 then
		baticon:set_image(theme.widget_batt50)
	elseif bat_per >=60 and bat_per < 80 then
		baticon:set_image(theme.widget_batt75)
	elseif bat_per >=80 and bat_per < 95 then
		baticon:set_image(theme.widget_batt85)
	else 
		baticon:set_image(theme.widget_battfull)
	end
--mytryend

        if bat_now.ac_status == 1 then
            perc = perc .. " plug "
	    baticon:set_image(theme.widget_battplug)    
        end
	

        widget:set_markup(markup.fontfg(theme.font, theme.fg_normal, " " .. perc .. " "))
    end
})
]]
--Battery widget
--[[local batwidget = wibox.widget.progressbar()
batwidget:set_width(8)
batwidget:set_height(10)
batwidget:set_vertical(true)
batwidget:set_background_color("#494B4F")
batwidget:set_border_color(nil)
batwidget:set_color("#AECF96")
batwidget:set_gradient_colors({ "#AECF96", "#88A175", "#FF5656" })
vicious.register(batwidget, vicious.widgets.bat, "$2", 61, "0")]]

local batwidget = {
	{
		max_value = 1,
		value = 0.33,
		forced_width = 33,
		color = "#ff00ff",
		background_color = "#494B4F",
		shape = gears.shape.octogon,
		bar_shape = gears.shape.octogon,
		bar_border_width = 1,
		border_width = 2,
		paddings = 1,
		widget = wibox.widget.progressbar,
	},
	{
		text = "33%",
		widget = wibox.widget.textbox,
	},
	layout = wibox.layout.stack,

}
--vicious.register(batwidget, vicious.widgets.bat, "$2", 61, "0")

-- ALSA volume
local volicon = wibox.widget.imagebox(theme.widget_vol)
theme.volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            volume_now.level = volume_now.level .. "M"
        end

        widget:set_markup(markup.fontfg(theme.font, "#7493d2", volume_now.level .. "% "))
    end
})
--[[
-- Net
local netdownicon = wibox.widget.imagebox(theme.widget_netdown)
local netdowninfo = wibox.widget.textbox()
local netupicon = wibox.widget.imagebox(theme.widget_netup)
local netupinfo = lain.widget.net({
    settings = function()
        if iface ~= "network off" and
           string.match(theme.weather.widget.text, "N/A")
        then
            theme.weather.update()
        end

        widget:set_markup(markup.fontfg(theme.font, "#e54c62", net_now.sent .. " "))
        netdowninfo:set_markup(markup.fontfg(theme.font, "#87af5f", net_now.received .. " "))
    end
})
]]
-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
--[[local memory = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, "#e0da37", mem_now.used .. "M "))
    end
})

-- MPD
--[[
local musicplr = "urxvt -title Music -g 130x34-320+16 -e ncmpcpp"
local mpdicon = wibox.widget.imagebox(theme.widget_music)
mpdicon:buttons(my_table.join(
    awful.button({ modkey }, 1, function () awful.spawn.with_shell(musicplr) end),
    --[[awful.button({ }, 1, function ()
        awful.spawn.with_shell("mpc prev")
        theme.mpd.update()
    end),
    --]]
    --[[awful.button({ }, 2, function ()
        awful.spawn.with_shell("mpc toggle")
        theme.mpd.update()
    end),
    awful.button({ modkey }, 3, function () awful.spawn.with_shell("pkill ncmpcpp") end),
    awful.button({ }, 3, function ()
        awful.spawn.with_shell("mpc stop")
        theme.mpd.update()
    end)))
theme.mpd = lain.widget.mpd({
    settings = function()
        if mpd_now.state == "play" then
            artist = " " .. mpd_now.artist .. " "
            title  = mpd_now.title  .. " "
            mpdicon:set_image(theme.widget_music_on)
            widget:set_markup(markup.font(theme.font, markup("#FFFFFF", artist) .. " " .. title))
        elseif mpd_now.state == "pause" then
            widget:set_markup(markup.font(theme.font, " mpd paused "))
            mpdicon:set_image(theme.widget_music_pause)
        else
            widget:set_text("")
            mpdicon:set_image(theme.widget_music)
        end
    end
})
]]

--Memory widget
--[[
memwidget = widget({ type = "textbox" })
vicious.cache(vicious.widgets.mem)
vicious.register(memwidget, vicious.widgets.mem, "$1 ($2MB/$3MB)", 13)]]

  --updated every 13 seconds, appends "MB" to 2nd and 3rd returned
    --values and enables caching of this widget type

function theme.at_screen_connect(s)
    -- Quake application
   -- s.quake = lain.util.quake({ app = awful.util.terminal })
   s.quake = lain.util.quake({ app = "termite", height = 0.50, argname = "--name %s" })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    --s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(15), bg = theme.bg_normal, fg = theme.fg_normal })	

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        --s.mytasklist, -- Middle widget
        nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            --mailicon,
            --mail.widget,
            --mpdicon,
            --theme.mpd.widget,
            --netdownicon,
            --netdowninfo,
            --netupicon,
            --netupinfo.widget,
            volicon,
            theme.volume.widget,
            memicon,
            --memory.widget,
	    --memwidget
            cpuicon,
            --cpu.widget,
            weathericon,
            theme.weather.widget,
            --tempicon,
            --temp.widget,
            baticon,
            batwidget,
            clockicon,
            mytextclock,
            wibox.widget.systray(),
	    s.mylayoutbox,
        },
    }

--[[
    -- Create the bottom wibox
    s.mybottomwibox = awful.wibar({ position = "bottom", screen = s, border_width = 0, height = dpi(20), bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the bottom wibox
    s.mybottomwibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            s.mylayoutbox,
        },
    }
]]
end

return theme
