--
-- Special "Hyper" modifier functionality
--
-- Right-Command is bound to F16, using Karabiner Elements
-- This is then used for magic
--

-- A global variable for the Hyper Modal
-- Note: F20 is never actually pressed, this is just a hack to abuse the
-- modal functionality to make F16 into a modifier
hyper = hs.hotkey.modal.new({}, "F20")

-- Toggle the hyper modal when pressing F16
hs.hotkey.bind({}, 'F16',
  function()
    hyper:enter()
  end,
  function()
    hyper:exit()
  end
)

-- returns a function that taps the key with mods
tapWithMods = function(key)
  return function()
    hs.eventtap.keyStroke({"cmd", "alt", "ctrl"}, key)
  end
end

-- window management bindings
hs.window.animationDuration = 0

hyper:bind({}, 'left', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hyper:bind({}, 'right',  function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x + max.w / 2
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hyper:bind({}, 'up', function()
  local win = hs.window.focusedWindow()
  win:maximize()
end)

hyper:bind({}, 'down', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x + max.w * 0.2
  f.y = max.y
  f.w = max.w * 0.6
  f.h = max.h
  win:setFrame(f)
end)

hyper:bind({}, ',', function()
  local win = hs.window.focusedWindow()
  win:moveOneScreenWest()
  win:maximize()
end)

hyper:bind({}, '.', function()
  local win = hs.window.focusedWindow()
  win:moveOneScreenEast()
  win:maximize()
end)



-- helper function to set correct screen
function screen(name)
  if name == "main" then
    return hs.screen.primaryScreen()
  elseif name == "laptop" then
    return hs.screen.find("Color LCD")
  elseif name == "right" then
    return hs.screen.primaryScreen():toEast()
  else
    return nil
  end
end

-- return true if title matches pattern
function match_title(title, pattern)
  -- if pattern starts with ! then reverse match
  if string.sub(pattern, 1, 1) == "!" then
    actual_pattern = string.sub(pattern, 2, string.len(pattern))
    return not string.match(title, actual_pattern)
  else
    return string.match(title, pattern)
  end
end

-- layouts for various number of monitors

layout1Monitor= {
  {"Spotify",           nil,          nil, hs.layout.maximized},
  {"Atom",              nil,          nil, hs.layout.maximized},
  {"Tweetbot",          nil,          nil, hs.layout.left50},
  {"Google Chrome",     nil,          nil, hs.layout.maximized},
  {"Microsoft Outlook", "!Reminder",  nil, hs.layout.maximized},
  {"Microsoft Outlook", "Reminder",   nil, nil,               },
  {"Slack",             nil,          nil, hs.layout.maximized},
  {"Hillpeople",        nil,          nil, hs.layout.maximized},
  {"iTerm2",            nil,          nil, hs.layout.right50},
}

layout2Monitor= {
  {"Spotify",           nil,          screen("laptop"), hs.layout.maximized},
  {"Atom",              "Projects",   screen("laptop"), hs.layout.maximized},
  {"Atom",              "!Projects",  screen("main"),   hs.layout.left50},
  {"Tweetbot",          nil,          screen("main"),   hs.layout.left50},
  {"Google Chrome",     nil,          screen("main"),   hs.layout.left50},
  {"Microsoft Outlook", nil,          screen("main"),   hs.layout.left50},
  {"Microsoft Outlook", "Reminder",   nil,              nil},
  {"Slack",             nil,          screen("main"),   hs.layout.right50},
  {"Hillpeople",        nil,          screen("main"),   hs.layout.right50},
  {"iTerm2",            nil,          screen("main"),   hs.layout.right50},
}

layout3Monitor= {
  {"Spotify",           nil,          screen("laptop"), hs.layout.maximized},
  {"Atom",              "Projects",   screen("laptop"), hs.layout.maximized},
  {"Atom",              "!Projects",  screen("main"),   hs.layout.maximized},
  {"Tweetbot",          nil,          screen("main"),   hs.layout.left50},
  {"Google Chrome",     nil,          screen("main"),   hs.layout.maximized},
  {"Microsoft Outlook", "!Reminder",  screen("main"),   hs.layout.maximized},
  {"Microsoft Outlook", "Reminder",   nil,              nil},
  {"Slack",             nil,          screen("right"),  hs.layout.maximized},
  {"Hillpeople",        nil,          screen("right"),  hs.layout.maximized},
  {"iTerm2",            nil,          screen("right"),  hs.layout.maximized},
}

-- layout bindings
hyper:bind({}, 'j', function()
  hs.layout.apply(layout1Monitor, match_title)
end)
hyper:bind({}, 'k', function()
  hs.layout.apply(layout2Monitor, match_title)
end)
hyper:bind({}, 'l', function()
  hs.layout.apply(layout3Monitor, match_title)
end)


-- if we run into issues with this triggering accidentally, see this link
-- https://github.com/cmsj/hammerspoon-config/blob/master/init.lua#L355
--

-- trigger layouts when number of screens changes
hs.screen.watcher.new(function()
  numScreens = #hs.screen.allScreens()
  if numScreens == 1 then
    hs.layout.apply(layout1Monitor, match_title)
  elseif numScreens == 2 then
    hs.layout.apply(layout2Monitor, match_title)
  elseif numScreens == 3 then
    hs.layout.apply(layout3Monitor, match_title)
  end
end):start()
