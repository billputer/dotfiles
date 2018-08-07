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
    immediateKeyStroke({"cmd", "alt", "ctrl"}, key)
  end
end

-- reload Hammerspoon on hyper + r
hyper:bind({}, 'r', function()
  hs.reload()
end)

-- open Hammerspoon console on hyper + c
hyper:bind({}, 'c', function()
  hs.openConsole()
end)


-- window management bindings
hyper:bind({}, 'left', move_window_left)
hyper:bind({}, 'right', move_window_right)
hyper:bind({}, 'up', maximize_window)
hyper:bind({}, 'down', center_window)
hyper:bind({}, ',', move_window_screen_left)
hyper:bind({}, '.', move_window_screen_right)


-- window focus bindings
hyper:bind({}, 'h', focus_window_left)
hyper:bind({}, 'j', focus_window_down)
hyper:bind({}, 'k', focus_window_up)
hyper:bind({}, 'l', focus_window_right)


-- layout bindings
hyper:bind({}, 'u', function()
  hs.layout.apply(layout1Monitor, match_title)
end)
hyper:bind({}, 'i', function()
  hs.layout.apply(layout2Monitor, match_title)
end)
hyper:bind({}, 'o', function()
  hs.layout.apply(layout3Monitor, match_title)
end)
