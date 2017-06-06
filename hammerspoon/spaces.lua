

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
    hs.alert.show("Space: " .. space_index, hs.alert.defaultStyle, screen, 0.4)
  end)
end

function moveWindowToSpaceByIndex(window, space_index)
  local target_space_id = generateUserSpaceIds()[space_index]
  spaces.moveWindowToSpace(window:id(), target_space_id)
  spaces.changeToSpace(target_space_id)
  displayCurrentSpace(space_index)
  -- debugSpaces()
end

function changeSpaceIndex(space_index)
  -- debugging
  keys = hs.hotkey.getHotkeys()
  print_table(keys)

  displayCurrentSpace(space_index)
  -- TODO: actually change space
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

-- keys to change spaces left and right
hs.hotkey.bind({"ctrl", "cmd"}, 'w', function() changeSpaceRelative(-1) end)
hs.hotkey.bind({"ctrl", "cmd"}, 't', function() changeSpaceRelative(1) end)
hs.hotkey.bind({"ctrl"}, 'left', function() changeSpaceRelative(-1) end)
hs.hotkey.bind({"ctrl"}, 'right', function() changeSpaceRelative(1) end)

hs.hotkey.showHotkeys({"ctrl", "cmd"}, '/')
hs.hotkey.bind({"ctrl"}, "1", function() changeSpaceIndex(1) end)
hs.hotkey.bind({"cmd"}, '1', function() changeSpaceIndex(1) end)

hs.hotkey.bind({"ctrl", "cmd"}, '1', function() moveWindowToSpaceByIndex(hs.window.focusedWindow(), 1) end)
hs.hotkey.bind({"ctrl", "cmd"}, '2', function() moveWindowToSpaceByIndex(hs.window.focusedWindow(), 2) end)
hs.hotkey.bind({"ctrl", "cmd"}, '3', function() moveWindowToSpaceByIndex(hs.window.focusedWindow(), 3) end)
hs.hotkey.bind({"ctrl", "cmd"}, '4', function() moveWindowToSpaceByIndex(hs.window.focusedWindow(), 4) end)
hs.hotkey.bind({"ctrl", "cmd"}, '5', function() moveWindowToSpaceByIndex(hs.window.focusedWindow(), 5) end)
hs.hotkey.bind({"ctrl", "cmd"}, '6', function() moveWindowToSpaceByIndex(hs.window.focusedWindow(), 6) end)
