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

-- hyper+left becomes cmd+alt+ctrl+left
-- this triggers slate
-- next step is to do these within hammerspoon
hyper:bind({}, 'left', tapWithMods("left"))
hyper:bind({}, 'right', tapWithMods("right"))
hyper:bind({}, 'up', tapWithMods("up"))
hyper:bind({}, 'down', tapWithMods("down"))
hyper:bind({}, ',', tapWithMods(","))
hyper:bind({}, '.', tapWithMods("."))
hyper:bind({}, 'j', tapWithMods("j"))
hyper:bind({}, 'k', tapWithMods("k"))
hyper:bind({}, 'l', tapWithMods("l"))
hyper:bind({}, 'r', tapWithMods("r"))
