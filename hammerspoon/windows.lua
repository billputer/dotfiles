
-- window management functions

hs.window.animationDuration = 0.5

-- hs.window.setFrameCorrectness = true

-- geometry units describing window locations
g_top_half = hs.geometry(0, 0, 1, 0.5)
g_bottom_half = hs.geometry(0, 0.5, 1, 1)
g_right_half = hs.geometry(0.5, 0, 0.5, 1)
g_left_half = hs.geometry(0, 0, 0.5, 1)
g_centered_vertically = hs.geometry(0, 0.2, 1, 0.6)
g_centered_horizontally = hs.geometry(0.2, 0, 0.6, 1)
g_maximized = hs.geometry(0, 0, 1, 1)

-- context-dependent move window left
function hyper_left()
  local win = hs.window.focusedWindow()
  local current_screen = win:screen()

  -- if on right screen, move to right half of primary
  if is_screen_right_of_primary(current_screen) then
    local west_screen = current_screen:toWest(nil, true)
    win:move(g_right_half, west_screen)
  -- if in left half, move to left screen
  elseif is_window_positioned(win, g_left_half) then
    local west_screen = current_screen:toWest(nil, true)
    win:move(g_maximized, west_screen)
  -- else, move to left half of current screen
  else
    win:move(g_left_half, current_screen, true)
  end
end

-- context-dependent move window right
function hyper_right()
  local win = hs.window.focusedWindow()
  local current_screen = win:screen()

  -- if on left screen, move to left half of primary
  if is_screen_left_of_primary(current_screen) then
    local east_screen = current_screen:toEast(nil, true)
    win:move(g_left_half, east_screen)
  -- if in right half, move to right screen
  elseif is_window_positioned(win, g_right_half) then
    local east_screen = current_screen:toEast(nil, true)
    win:move(g_maximized, east_screen)
  -- else, move to right half of current screen
  else
    win:move(g_right_half, current_screen, true)
  end
end

-- toggles between maximized and top half of screeen
function toggle_up()
  local win = hs.window.focusedWindow()
  if is_window_positioned(win, g_maximized) then
    win:move(g_top_half)
  else
    win:move(g_maximized)
  end
end

-- toggles between centered vertically and bottom half of screen
function toggle_down()
  local win = hs.window.focusedWindow()
  if is_window_positioned(win, g_centered_vertically) then
    win:move(g_bottom_half)
  else
    win:move(g_centered_vertically)
  end
end

function move_window_left()
  local win = hs.window.focusedWindow()
  win:move(g_left_half, win:screen(), true)
end

function move_window_right()
  local win = hs.window.focusedWindow()
  win:move(g_right_half, win:screen(), true)
end

function center_window_horizontally()
  local win = hs.window.focusedWindow()
  win:move(g_centered_horizontally)
end


function move_window_screen_left()
  local win = hs.window.focusedWindow()
  local west_screen = win:screen():toWest(nil, true)
  win:move(g_maximized, west_screen)
end

function move_window_screen_right()
  local win = hs.window.focusedWindow()
  local east_screen = win:screen():toEast(nil, true)
  win:move(g_maximized, east_screen)
end

function move_window_screen_down()
  local win = hs.window.focusedWindow()
  local south_screen = win:screen():toSouth(nil, true)
  win:move(g_maximized, south_screen)
end

function move_window_screen_up()
  local win = hs.window.focusedWindow()
  local north_screen = win:screen():toNorth(nil, true)
  win:move(g_left_half, north_screen)
end


-- determines if window is positioned in specified location
function is_window_positioned(window, unit_rect)
  local win_frame = window:frame()
  local correct_frame = unit_rect:fromUnitRect(window:screen():frame())

  -- fromUnitRect sometimes scales to a float, but we want ints for comparison
  correct_frame.w = math.floor(correct_frame.w)
  correct_frame.h = math.floor(correct_frame.h)
  correct_frame.x = math.floor(correct_frame.x)
  correct_frame.y = math.floor(correct_frame.y)

  if win_frame:equals(correct_frame) then
    return true
  else
    return false
  end
end

function is_primary_screen(screen)
  return screen == hs.screen.primaryScreen()
end

function is_laptop_screen(screen)
  return screen == hs.screen.find("Built%-in Retina Display")
end

function is_screen_left_of_primary(screen)
  return screen == hs.screen.primaryScreen():toWest(nil, true)
end

function is_screen_right_of_primary(screen)
  return screen == hs.screen.primaryScreen():toEast(nil, true)
end

-- focus functions
function focus_window_left()
  local win = hs.window.focusedWindow()
  win:focusWindowWest(nil, true)
end

function focus_window_right()
  local win = hs.window.focusedWindow()
  win:focusWindowEast(nil, true)
end

function focus_window_down()
  local win = hs.window.focusedWindow()
  win:focusWindowSouth(nil, true)
end

function focus_window_up()
  local win = hs.window.focusedWindow()
  win:focusWindowNorth(nil, true)
end

function debugging()
  -- print_table(hs.screen.screenPositions())
  -- print(hs.screen.find("Built%-in Retina Display"))
  print(is_screen_left_of_primary(hs.window.focusedWindow():screen()))
  print(is_screen_right_of_primary(hs.window.focusedWindow():screen()))
end

-- helper function to set correct screen
function screen(name)
  if name == "primary" then
    return hs.screen.primaryScreen()
  elseif name == "laptop" then
    return hs.screen.find("Built%-in Retina Display")
  elseif name == "left" then
    return hs.screen.primaryScreen():toWest(nil, true)
  elseif name == "right" then
    return hs.screen.primaryScreen():toEast(nil, true)
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
  {"Plexamp",                nil,          nil, hs.layout.maximized},
  {"Spotify",                nil,          nil, hs.layout.maximized},
  {"Atom",                   nil,          nil, hs.layout.maximized},
  {"Visual Studio Code",     nil,          nil, hs.layout.maximized},
  {"Tweetbot",               nil,          nil, hs.layout.left50},
  {"Firefox",                nil,          nil, hs.layout.maximized},
  {"Google Chrome",          nil,          nil, hs.layout.maximized},
  {"Reeder",                 nil,          nil, hs.layout.maximized},
  {"Microsoft Outlook",      "!Reminder",  nil, hs.layout.maximized},
  {"Slack",                  nil,          nil, hs.layout.maximized},
  {"Hillpeople",             nil,          nil, hs.layout.maximized},
  {"iTerm2",                 nil,          nil, hs.layout.right50},
  {"Remote Desktop Manager", nil,          nil, hs.layout.maximized},
}

layout2Monitor= {
  {"Plexamp",                nil,          screen("laptop"), hs.layout.maximized},
  {"Spotify",                nil,          screen("laptop"), hs.layout.maximized},
  {"Atom",                   "Dropbox",    screen("laptop"), hs.layout.maximized},
  {"Atom",                   "!Dropbox",   screen("primary"),   hs.layout.left50},
  {"Visual Studio Code",     "Projects",   screen("laptop"),    hs.layout.maximized},
  {"Visual Studio Code",     "!Projects",  screen("primary"),   hs.layout.left50},
  {"Tweetbot",               nil,          screen("primary"),   hs.layout.left50},
  {"Firefox",                nil,          screen("primary"),   hs.layout.left50},
  {"Google Chrome",          nil,          screen("primary"),   hs.layout.left50},
  {"Reeder",                 nil,          screen("primary"),   hs.layout.left50},
  {"Microsoft Outlook",      "!Reminder",  screen("primary"),   hs.layout.left50},
  {"Slack",                  nil,          screen("primary"),   hs.layout.right50},
  {"Hillpeople",             nil,          screen("primary"),   hs.layout.right50},
  {"iTerm2",                 nil,          screen("primary"),   hs.layout.right50},
  {"Remote Desktop Manager", nil,          screen("primary"),   hs.layout.maximized},
}

layout3Monitor= {
  {"Plexamp",                nil,          screen("left"), hs.layout.maximized},
  {"Spotify",                nil,          screen("left"), hs.layout.maximized},
  {"Microsoft To Do",        nil,          screen("left"), hs.layout.maximized},
  {"Atom",                   "Dropbox",    screen("left"), hs.layout.maximized},
  {"Atom",                   "!Dropbox",   screen("primary"),   hs.layout.maximized},
  {"Visual Studio Code",     "Projects",   screen("left"), hs.layout.maximized},
  {"Visual Studio Code",     "!Projects",  screen("primary"),   hs.layout.left50},
  {"Tweetbot",               nil,          screen("primary"),   hs.layout.left50},
  {"Firefox",                nil,          screen("primary"),   hs.layout.maximized},
  {"Google Chrome",          nil,          screen("primary"),   hs.layout.maximized},
  {"Reeder",                 nil,          screen("primary"),   hs.layout.maximized},
  {"Microsoft Outlook",      "!Reminder",  screen("primary"),   hs.layout.maximized},
  {"Slack",                  nil,          screen("right"),  hs.layout.maximized},
  {"Hillpeople",             nil,          screen("right"),  hs.layout.maximized},
  {"iTerm2",                 nil,          screen("right"),  hs.layout.maximized},
  {"Remote Desktop Manager", nil,          screen("right"),  hs.layout.maximized},
}

layout4MonitorHome= {
  {"Plexamp",                nil,          screen("left"),      hs.layout.maximized},
  {"Spotify",                nil,          screen("left"),      hs.layout.maximized},
  {"Firefox",                nil,          screen("left"),      hs.layout.maximized},
  {"Atom",                   "!Dropbox",   screen("primary"),   hs.layout.left50},
  {"Atom",                   "Dropbox",    screen("laptop"),    hs.layout.maximized},
  {"Visual Studio Code",     "!Projects",  screen("primary"),   hs.layout.left50},
  {"Visual Studio Code",     "Projects",   screen("laptop"),    hs.layout.maximized},
  {"Tweetbot",               nil,          screen("primary"),   hs.layout.left50},
  {"Google Chrome",          nil,          screen("primary"),   hs.layout.left50},
  {"Reeder",                 nil,          screen("primary"),   hs.layout.left50},
  {"Microsoft Outlook",      "!Reminder",  screen("primary"),   hs.layout.left50},
  {"Remote Desktop Manager", nil,          screen("primary"),   hs.layout.right50},
  {"Slack",                  nil,          screen("primary"),   hs.layout.right50},
  {"Hillpeople",             nil,          screen("primary"),   hs.layout.right50},
  {"Discord",                nil,          screen("primary"),   hs.layout.right50},
  {"iTerm2",                 nil,          screen("primary"),   hs.layout.right50},
}
