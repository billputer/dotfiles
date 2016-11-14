
-- navigate between tabs with left hand
hs.hotkey.bind({"ctrl", "cmd"}, 'e',
  function()
    hs.eventtap.keyStroke({"cmd", "shift"}, "[")
  end
)
hs.hotkey.bind({"ctrl", "cmd"}, 'r',
  function()
    hs.eventtap.keyStroke({"cmd", "shift"}, "]")
  end
)


-- trigger mission control with left-hand
mission_control = hs.hotkey.bind({"ctrl"}, 's',
  function()
    hs.eventtap.keyStroke({"ctrl"}, "up")
  end
)

-- TODO: figure out how to trigger an actual ctrl+s so that we don't always trigger mission control
hs.hotkey.bind({"ctrl", "shift"}, 's',
  function()
    mission_control:disable()
    hs.eventtap.keyStroke({"ctrl"}, "s")
    mission_control:enable()
  end
)

-- trigger events for extra mouse buttons
hs.eventtap.new({hs.eventtap.event.types.middleMouseDown},
  function(evt)
    button_prop = hs.eventtap.event.properties["mouseEventButtonNumber"]
    button_pressed = evt:getProperty(button_prop)

    -- trigger mission control with middle click
    if button_pressed == 2 then
      hs.eventtap.keyStroke({"ctrl"}, "up")
    end
    -- if cmd held, then use tab navigation with thumb buttons
    if evt:getFlags()["cmd"] then
      if button_pressed == 3 then
        hs.eventtap.keyStroke({"cmd", "shift"}, "[")
      elseif button_pressed == 4 then
        hs.eventtap.keyStroke({"cmd", "shift"}, "]")
      end
    -- trigger back and forward with thumb buttons
    else
      if button_pressed == 3 then
        hs.eventtap.keyStroke({"cmd"}, "[")
      elseif button_pressed == 4 then
        hs.eventtap.keyStroke({"cmd"}, "]")
      end
    end
  end
):start()


hs.eventtap.new({hs.eventtap.event.types.leftMouseDown},
  function(evt)
    --print(hs.inspect(e:getRawEventData()))
  end
):start()

hs.eventtap.new({hs.eventtap.event.types.otherMouseDown},
  function(evt)
    print("otherMouseDown")
    print(hs.inspect(evt:getRawEventData()))
  end
):start()


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
