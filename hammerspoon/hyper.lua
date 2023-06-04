--
-- Special "Hyper" modifier functionality
--
-- Right-Command is bound to Control + Command + Option, using Karabiner Elements
-- This is then used for magic
--

hyper_bind = function(key, fun)
  hs.hotkey.bind({"ctrl", "shift", "cmd", "option"}, key, fun)
end

-- reload Hammerspoon on hyper + r
hyper_bind('r', function()
  hs.reload()
end)

-- open Hammerspoon console on hyper + c
hyper_bind('c', function()
  hs.openConsole()
end)

hyper_bind('d', function()
  hs.eventtap.keyStrokes(os.date("%Y-%m-%d"))
end)


-- window management bindings
hyper_bind('left', hyper_left)
hyper_bind('right', hyper_right)
hyper_bind('up', toggle_up)
hyper_bind('down', toggle_down)
hyper_bind(';', center_window_horizontally)

-- hyper_bind(',', move_window_screen_left)
-- hyper_bind('.', move_window_screen_right)
hyper_bind('m', move_window_screen_down)
hyper_bind('n', move_window_screen_up)



-- -- window focus bindings
-- hyper_bind('h', focus_window_left)
-- hyper_bind('j', focus_window_down)
-- hyper_bind('k', focus_window_up)
-- hyper_bind('l', focus_window_right)


-- layout bindings
hyper_bind('u', function()
  hs.layout.apply(layout1Monitor, match_title)
end)
hyper_bind('i', function()
  hs.layout.apply(layout2Monitor, match_title)
end)
hyper_bind('o', function()
  hs.layout.apply(layout4MonitorHome, match_title)
end)
