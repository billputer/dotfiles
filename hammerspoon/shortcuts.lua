-- navigate between tabs with left hand
hs.hotkey.bind({"ctrl", "cmd"}, 'e',
  function()
    immediateKeyStroke({"cmd", "shift"}, "[")
  end
)
hs.hotkey.bind({"ctrl", "cmd"}, 'r',
  function()
    immediateKeyStroke({"cmd", "shift"}, "]")
  end
)


-- TODO: figure out how to do this without manually binding in System Preferences
-- trigger mission control with left-hand
-- mission_control_hotkey = hs.hotkey.bind({"ctrl"}, 's', nil,
--   function()
--     immediateKeyStroke({"ctrl"}, "up")
--   end
-- )

-- TODO: figure out how to trigger an actual ctrl+s so that we don't always trigger mission control
-- hs.hotkey.bind({"ctrl", "shift"}, 's',
--   function()
--     mission_control_hotkey:disable()
--     immediateKeyStroke({"ctrl"}, "s")
--     mission_control_hotkey:enable()
--   end
-- )

-- trigger events for extra mouse buttons
-- Note: for the Razer mouse, this also triggers otherMouseDown, causing a double tap
-- middleMouseDownEventtap = hs.eventtap.new({hs.eventtap.event.types.middleMouseDown},
--   function(evt)
--
--     handleButtonPressed(evt)
--   end
-- ):start()


  -- leftMouseDownEventtap = hs.eventtap.new({hs.eventtap.event.types.leftMouseDown},
  --   function(evt)
  --     print(hs.inspect(e:getRawEventData()))
  --   end
  -- ):start()

otherMouseDownEventtap = hs.eventtap.new({hs.eventtap.event.types.otherMouseDown},
  function(evt)
    handleButtonPressed(evt)
  end
):start()

function handleButtonPressed(evt)
  button_prop = hs.eventtap.event.properties["mouseEventButtonNumber"]
  button_pressed = evt:getProperty(button_prop)

  print(hs.inspect(button_pressed))

  -- trigger mission control with middle click
  if button_pressed == 2 then
    -- disabled in favor of a Karabiner binding
    -- hs.execute('"/Applications/Mission Control.app/Contents/MacOS/Mission Control"')
    -- immediateKeyStroke({"ctrl"}, "up")
  end
  -- if cmd held, then use tab navigation with thumb buttons
  if evt:getFlags()["cmd"] then
    if button_pressed == 3 then
      immediateKeyStroke({"cmd", "shift"}, "[")
    elseif button_pressed == 4 then
      immediateKeyStroke({"cmd", "shift"}, "]")
    end
  -- trigger back and forward with thumb buttons
  -- don't send this, will double-tap
  -- else
  --   if button_pressed == 3 then
  --     immediateKeyStroke({"cmd"}, "[")
  --   elseif button_pressed == 4 then
  --     immediateKeyStroke({"cmd"}, "]")
  --   end
  end
end


function debugEventTypes()
  print(hs.inspect(hs.eventtap.event.types))
end


-- map control + command + s to display sleep
-- NOTE: this doesn't work
hs.hotkey.bind({"ctrl", "cmd"}, 's',
  function()
    local evt = hs.eventtap.event.newSystemKeyEvent("EJECT", true)
    e = evt:setFlags({"ctrl", "shift"})
    e:post()
  end
)

-- only quit if cmd + q is held
quit_timer = hs.timer.delayed.new(0.4, function()
  hs.application.frontmostApplication():kill()
end)

hs.hotkey.bind({"cmd"}, 'q',
  function()
    quit_timer:start()
  end,
  function()
    quit_timer:stop()
  end
)

-- map control + command + b to center cursor on primary monitor
hs.hotkey.bind({"ctrl", "cmd"}, 'b',
  function()
    local screen = hs.screen.primaryScreen()
    local rect = screen:fullFrame()
    local center = hs.geometry.rectMidPoint(rect)
    hs.mouse.setAbsolutePosition(center)
  end
)


function sleep (a)
  local sec = tonumber(os.clock() + a);
  while (os.clock() < sec) do
  end
end

-- map control + command + t to spam clicks
hs.hotkey.bind({"ctrl", "cmd"}, 't',
  function()
    local pos = hs.mouse.absolutePosition()
    hs.eventtap.leftClick(pos)
    for i = 1, 100 do
      hs.eventtap.leftClick(pos)
      -- sleep(0.0001)
    end
  end
)
