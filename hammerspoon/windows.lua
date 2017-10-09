
-- window management functions

hs.window.animationDuration = 0

function move_window_left()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end

function move_window_right()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x + max.w / 2
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end

function move_window_screen_left()
  local win = hs.window.focusedWindow()
  win:moveOneScreenWest()
  win:maximize()
end

function move_window_screen_right()
  local win = hs.window.focusedWindow()
  win:moveOneScreenEast()
  win:maximize()
end

function maximize_window()
  local win = hs.window.focusedWindow()
  win:maximize()
end

function center_window()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local max = win:screen():frame()

  f.x = max.x + max.w * 0.2
  f.y = max.y
  f.w = max.w * 0.6
  f.h = max.h
  win:setFrame(f)
end


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
  print("match_title: title("..title..") pattern("..pattern..")")
  -- if pattern starts with ! then reverse match
  if string.sub(pattern, 1, 1) == "!" then
    actual_pattern = string.sub(pattern, 2, string.len(pattern))
    return not string.match(title, actual_pattern)
  else
    return string.match(title, pattern) == pattern
  end
end

-- layouts for various number of monitors

layout1Monitor= {
  {"Spotify",                nil,          nil, hs.layout.maximized},
  {"Atom",                   nil,          nil, hs.layout.maximized},
  {"Tweetbot",               nil,          nil, hs.layout.left50},
  {"Google Chrome",          nil,          nil, hs.layout.maximized},
  {"Reeder",                 nil,          nil, hs.layout.maximized},
  {"Microsoft Outlook",      "!Reminder",  nil, hs.layout.maximized},
  {"Slack",                  nil,          nil, hs.layout.maximized},
  {"Hillpeople",             nil,          nil, hs.layout.maximized},
  {"iTerm2",                 nil,          nil, hs.layout.right50},
  {"Remote Desktop Manager", nil,          nil, hs.layout.maximized},
}

layout2Monitor= {
  {"Spotify",                nil,          screen("laptop"), hs.layout.maximized},
  {"Atom",                   "Dropbox",    screen("laptop"), hs.layout.maximized},
  {"Atom",                   "!Dropbox",   screen("main"),   hs.layout.left50},
  {"Tweetbot",               nil,          screen("main"),   hs.layout.left50},
  {"Google Chrome",          nil,          screen("main"),   hs.layout.left50},
  {"Reeder",                 nil,          screen("main"),   hs.layout.left50},
  {"Microsoft Outlook",      "!Reminder",  screen("main"),   hs.layout.left50},
  {"Slack",                  nil,          screen("main"),   hs.layout.right50},
  {"Hillpeople",             nil,          screen("main"),   hs.layout.right50},
  {"iTerm2",                 nil,          screen("main"),   hs.layout.right50},
  {"Remote Desktop Manager", nil,          screen("main"),   hs.layout.maximized},
}

layout3Monitor= {
  {"Spotify",                nil,          screen("laptop"), hs.layout.maximized},
  {"Atom",                   "Dropbox",    screen("laptop"), hs.layout.maximized},
  {"Atom",                   "!Dropbox",   screen("main"),   hs.layout.maximized},
  {"Tweetbot",               nil,          screen("main"),   hs.layout.left50},
  {"Google Chrome",          nil,          screen("main"),   hs.layout.maximized},
  {"Reeder",                 nil,          screen("main"),   hs.layout.maximized},
  {"Microsoft Outlook",      "!Reminder",  screen("main"),   hs.layout.maximized},
  {"Slack",                  nil,          screen("right"),  hs.layout.maximized},
  {"Hillpeople",             nil,          screen("right"),  hs.layout.maximized},
  {"iTerm2",                 nil,          screen("right"),  hs.layout.maximized},
  {"Remote Desktop Manager", nil,          screen("right"),  hs.layout.maximized},
}

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
