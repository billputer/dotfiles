
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

-- trigger mission control with middle click
hs.eventtap.new({hs.eventtap.event.types.middleMouseDown},
  function(evt)
    hs.eventtap.keyStroke({"ctrl"}, "up")
  end
):start()


hs.eventtap.new({hs.eventtap.event.types.leftMouseDown},
  function(evt)
    --print(hs.inspect(e:getRawEventData()))
  end
):start()

hs.eventtap.new({hs.eventtap.event.types.otherMouseDown},
  function(evt)
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
