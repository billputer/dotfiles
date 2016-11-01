
-- navigate between tabs with left hand
hs.hotkey.bind({"cmd", "ctrl"}, 'e',
  function()
    hs.eventtap.keyStroke({"cmd", "shift"}, "[")
  end
)
hs.hotkey.bind({"cmd", "ctrl"}, 'r',
  function()
    hs.eventtap.keyStroke({"cmd", "shift"}, "]")
  end
)
