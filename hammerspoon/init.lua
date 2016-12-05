
require('hyper')
require('shortcuts')
require('tap-escape')
require('hints')

-- Reload config when any lua file in config directory changes
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == '.lua' then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
configWatcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig):start()


-- Replacement for hs.eventtap.keyStroke without 200 ms delay
-- See https://github.com/Hammerspoon/hammerspoon/issues/1011#issuecomment-256453649
immediateKeyStroke = function(modifiers, character)
    local event = require("hs.eventtap").event
    event.newKeyEvent(modifiers, string.lower(character), true):post()
    event.newKeyEvent(modifiers, string.lower(character), false):post()
end

hs.alert.show("Hammerspoon loaded")
