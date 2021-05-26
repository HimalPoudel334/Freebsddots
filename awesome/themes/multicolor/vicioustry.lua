--Date widget
  datewidget = widget({ type = "textbox" })
  vicious.register(datewidget, vicious.widgets.date, "%b %d, %R")

  - updated every 2 seconds (the default interval), uses standard
    date sequences as the format string

--Memory widget
  memwidget = widget({ type = "textbox" })
  vicious.cache(vicious.widgets.mem)
  vicious.register(memwidget, vicious.widgets.mem, "$1 ($2MB/$3MB)", 13)

  - updated every 13 seconds, appends "MB" to 2nd and 3rd returned
    values and enables caching of this widget type

HDD temperature widget
  hddtempwidget = widget({ type = "textbox" })
  vicious.register(hddtempwidget, vicious.widgets.hddtemp, "${/dev/sda} °C", 19)

  - updated every 19 seconds, requests the temperature level of the
    {/dev/sda} key/disk and appends "°C" to the returned value, does
    not provide the port argument so default port is used

Mbox widget
  mboxwidget = widget({ type = "textbox" })
  vicious.register(mboxwidget, vicious.widgets.mbox, "$1", 5, "/home/user/mail/Inbox")

  - updated every 5 seconds, provides full path to the mbox as an
    argument

Battery widget
  batwidget = awful.widget.progressbar()
  batwidget:set_width(8)
  batwidget:set_height(10)
  batwidget:set_vertical(true)
  batwidget:set_background_color("#494B4F")
  batwidget:set_border_color(nil)
  batwidget:set_color("#AECF96")
  batwidget:set_gradient_colors({ "#AECF96", "#88A175", "#FF5656" })
  vicious.register(batwidget, vicious.widgets.bat, "$2", 61, "BAT0")

  - updated every 61 seconds, requests the current battery charge
    level and displays a progressbar, provides "BAT0" battery ID as an
    argument

CPU usage widget
  cpuwidget = awful.widget.graph()
  cpuwidget:set_width(50)
  cpuwidget:set_background_color("#494B4F")
  cpuwidget:set_color("#FF5656")
  cpuwidget:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" })
  vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 3)

  - updated every 3 seconds, feeds the graph with total usage
    percentage of all CPUs/cores


Format functions
----------------
You can use a function instead of a string as the format parameter.
Then you are able to check the value returned by the widget type and
change it or perform some action. You can change the color of the
battery widget when it goes below a certain point, hide widgets when
they return a certain value or maybe use string.format for padding.

  - Do not confuse this with just coloring the widget, in those cases
    standard pango markup can be inserted into the format string.

The format function will get the widget as its first argument, table
with the values otherwise inserted into the format string as its
second argument, and will return the text/data to be used for the
widget.

Example
  mpdwidget = widget({ type = "textbox" })
  vicious.register(mpdwidget, vicious.widgets.mpd,
    function (widget, args)
      if   args["{state}"] == "Stop" then return ""
      else return '<span color="white">MPD:</span> '..
             args["{Artist}"]..' - '.. args["{Title}"]
      end
    end)

  - hides the mpd widget when no song is playing, updated every 2
    seconds (the default interval)

Example
  uptimewidget = widget({ type = "textbox" })
  vicious.register(uptimewidget, vicious.widgets.uptime,
    function (widget, args)
      return string.format("Uptime: %2dd %02d:%02d ", args[1], args[2], args[3])
    end, 61)

  - uses string.format for padding uptime values to a minimum amount
    of digits, updated every 61 seconds

When it comes to padding it is also useful to mention how a widget can
be configured to have a fixed width. You can set a fixed width on your
textbox widgets by changing their .width field (by default width is
automatically adapted to text width).

Example
  uptimewidget = widget({ type = "textbox" })
  uptimewidget.width, uptimewidget.align = 50, "right"
  vicious.register(uptimewidget, vicious.widgets.uptime, "$1 $2:$3", 61)

  - forces a fixed width of 50px to the uptime widget, and aligns its
    text to the right