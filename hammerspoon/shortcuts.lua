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


-- trigger mission control with left-hand
mission_control_hotkey = hs.hotkey.bind({"ctrl"}, 's', nil,
  function()
    immediateKeyStroke({"ctrl"}, "up")
  end
)

-- TODO: figure out how to trigger an actual ctrl+s so that we don't always trigger mission control
hs.hotkey.bind({"ctrl", "shift"}, 's',
  function()
    mission_control_hotkey:disable()
    immediateKeyStroke({"ctrl"}, "s")
    mission_control_hotkey:enable()
  end
)

-- trigger events for extra mouse buttons
middleMouseDownEventtap = hs.eventtap.new({hs.eventtap.event.types.middleMouseDown},
  function(evt)
    button_prop = hs.eventtap.event.properties["mouseEventButtonNumber"]
    button_pressed = evt:getProperty(button_prop)

    print(hs.inspect(button_pressed))
    -- trigger mission control with middle click
    if button_pressed == 2 then
      immediateKeyStroke({"ctrl"}, "up")
    end
    -- if cmd held, then use tab navigation with thumb buttons
    if evt:getFlags()["cmd"] then
      if button_pressed == 3 then
        immediateKeyStroke({"cmd", "shift"}, "[")
      elseif button_pressed == 4 then
        immediateKeyStroke({"cmd", "shift"}, "]")
      end
    -- trigger back and forward with thumb buttons
    else
      if button_pressed == 3 then
        immediateKeyStroke({"cmd"}, "[")
      elseif button_pressed == 4 then
        immediateKeyStroke({"cmd"}, "]")
      end
    end
  end
):start()


-- leftMouseDownEventtap = hs.eventtap.new({hs.eventtap.event.types.leftMouseDown},
--   function(evt)
--     print(hs.inspect(e:getRawEventData()))
--   end
-- ):start()

otherMouseDownEventtap = hs.eventtap.new({hs.eventtap.event.types.otherMouseDown},
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


-- Unsupported Spaces extension. Uses private APIs!
-- (http://github.com/asmagill/hammerspoon_asm.undocumented)
spaces = require("hs._asm.undocumented.spaces")

-- Returns a list of space ids for all "user" spaces (not fullscreen, expose, etc)
function generateUserSpaceIds()
  local space_ids = spaces.layout()[spaces.mainScreenUUID()]
  local user_space_ids = {}
  for k, space_id in pairs(space_ids) do
    if spaces.spaceType(space_id) == 0 then
      table.insert(user_space_ids, space_id)
    end
  end
  return user_space_ids
end

function debugSpaces()
  print("debugging spaces")

  print("activeSpace:", spaces.activeSpace())
  print("mainScreenUUID:", spaces.mainScreenUUID())
  -- print(spaces.types)
  -- print(spaces.debug.report())

  print("spaces.layout")
  for k, v in pairs(spaces.layout()[spaces.mainScreenUUID()]) do
    print(k, "space_id:", v, "type:", spaces.spaceType(v))
  end

  -- print("queried spaces:")
  -- queried_spaces = spaces.query(spaces.masks["otherSpaces"])
  -- for k, v in pairs(queried_spaces) do
  --   print(k, "space_id:", v)
  -- end

  print("generateUserSpaceIds:")
  for k, v in pairs(generateUserSpaceIds()) do
    print(k, "space_id:", v)
  end
end

function displayCurrentSpace(space_index)
  hs.fnutils.each(hs.screen.allScreens(), function(screen)
    hs.alert.show("Space: " .. space_index, screen)
  end)
end

function moveWindowToSpaceByIndex(window, space_index)
  local target_space_id = generateUserSpaceIds()[space_index]
  spaces.moveWindowToSpace(window:id(), target_space_id)
  spaces.changeToSpace(target_space_id)
  displayCurrentSpace(space_index)
  -- debugSpaces()
end

function changeSpaceRelative(offset)
  local space_ids = spaces.layout()[spaces.mainScreenUUID()]
  local num_spaces = #space_ids
  local activeSpace = spaces.activeSpace()

  local space_id_to_index = {}
  for index, space_id in pairs(space_ids) do
    space_id_to_index[space_id] = index
  end
  local current_space_index = space_id_to_index[activeSpace]
  local target_space_index = (current_space_index + offset) % num_spaces

  if target_space_index == 0 then
    target_space_index = num_spaces
  end

  spaces.changeToSpace(space_ids[target_space_index])
  displayCurrentSpace(target_space_index)
end

hs.hotkey.bind({"ctrl", "cmd"}, 'w',
  function() changeSpaceRelative(-1) end
)
hs.hotkey.bind({"ctrl", "cmd"}, 't',
  function() changeSpaceRelative(1) end
)

hs.hotkey.bind({"ctrl", "cmd"}, '1',
  function() moveWindowToSpaceByIndex(hs.window.focusedWindow(), 1) end
)
hs.hotkey.bind({"ctrl", "cmd"}, '2',
  function() moveWindowToSpaceByIndex(hs.window.focusedWindow(), 2) end
)
hs.hotkey.bind({"ctrl", "cmd"}, '3',
  function() moveWindowToSpaceByIndex(hs.window.focusedWindow(), 3) end
)
hs.hotkey.bind({"ctrl", "cmd"}, '4',
  function() moveWindowToSpaceByIndex(hs.window.focusedWindow(), 4) end
)
hs.hotkey.bind({"ctrl", "cmd"}, '5',
  function() moveWindowToSpaceByIndex(hs.window.focusedWindow(), 5) end
)
hs.hotkey.bind({"ctrl", "cmd"}, '6',
  function() moveWindowToSpaceByIndex(hs.window.focusedWindow(), 6) end
)
