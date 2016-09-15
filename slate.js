//
// slate javascript configuration
//
// https://github.com/mattr-/slate
//

slate.configAll({
  "defaultToCurrentScreen" : true,
  "secondsBetweenRepeat" : 0.1,
  "checkDefaultsOnLoad" : true,
  "focusCheckWidthMax" : 3000,
  "orderScreensLeftToRight" : true,
  "menuBarIconHidden": false,

  // Window hinting
  "windowHintsShowIcons": true,
  "windowHintsIgnoreHiddenWindows": false,
  "windowHintsDuration": 5,
  "windowHintsSpread": true,
  "windowHintsOrder": "leftToRight",
  "windowHintsRoundedCornerSize": 10,
  "windowHintsFontColor": "238;232;213;1.0",

});

// operations

var moveFull = slate.op("move", {
  "x": "screenOriginX",
  "y": "screenOriginY",
  "width": "screenSizeX",
  "height": "screenSizeY",
});

var moveLeftHalf = slate.op("move", {
  "x": "screenOriginX",
  "y": "screenOriginY",
  "width": "screenSizeX*.5",
  "height": "screenSizeY",
});

var moveRightHalf = slate.op("move", {
  "x": "screenOriginX+screenSizeX*.5",
  "y": "screenOriginY",
  "width": "screenSizeX*.5",
  "height": "screenSizeY",
});

var moveCenter = slate.op("move", {
  "x": "screenOriginX+screenSizeX*.2",
  "y": "screenOriginY",
  "width": "screenSizeX*.6",
  "height": "screenSizeY",
});

function throwTo(monitor, section) {
  var move = {
    "screen": monitor,
    "x": "screenOriginX",
    "y": "screenOriginY",
    "width": "screenSizeX",
    "height": "screenSizeY",
  };

  switch (section) {
    case "full":
      break;
    case "leftHalf":
      move["width"] = "screenSizeX*.5";
      break;
    case "rightHalf":
      move["x"] = "screenOriginX+screenSizeX*.5";
      move["width"] = "screenSizeX*.5";
      break;
  }

  return slate.op("move", move);
}

function atomLayout(defaultOperation) {
  return function(windowObject) {
    var title = windowObject.title();
    // throw Projects to leftmost monitor
    if (title !== undefined && title.match(/Projects/)) {
      windowObject.doOperation(throwTo(0, "full"));
    } else {
      windowObject.doOperation(defaultOperation);
    }
  };
}

function outlookLayout(defaultOperation) {
  return function(windowObject) {
    var title = windowObject.title();
    if (title !== undefined && title.match(/Reminder/)) {
      // don't move reminders around
    } else {
      windowObject.doOperation(defaultOperation);
    }
  };
}

// wrapper function to include ignore-fail and repeat
function layoutWindow(operations) {
  // accepts either array or single operation
  if (!Array.isArray(operations)) {
    operations = [operations];
  }
  return {
    "operations": operations,
    "ignore-fail": true,
    "repeat": true,
  };
}

// layouts

var oneMonitor = slate.layout("oneMonitor", {
  "Atom": layoutWindow(
    throwTo(0, "leftHalf")
  ),
  "Tweetbot": layoutWindow(
    throwTo(0, "leftHalf")
  ),
  "Google Chrome": layoutWindow(
    throwTo(0, "full")
  ),
  "Microsoft Outlook": layoutWindow(
    outlookLayout(throwTo(0, "full"))
  ),
  "Slack": layoutWindow(
    throwTo(0, "full")
  ),
  "Hillpeople": layoutWindow(
    throwTo(0, "full")
  ),
  "iTerm2": layoutWindow(
    throwTo(0, "rightHalf")
  ),
});

var twoMonitor = slate.layout("twoMonitor", {
  "Atom": layoutWindow(
    atomLayout(throwTo(1, "leftHalf"))
  ),
  "Tweetbot": layoutWindow(
    throwTo(1, "leftHalf")
  ),
  "Google Chrome": layoutWindow(
    throwTo(1, "leftHalf")
  ),
  "Microsoft Outlook": layoutWindow(
    outlookLayout(throwTo(1, "leftHalf"))
  ),
  "Slack": layoutWindow(
    throwTo(1, "rightHalf")
  ),
  "Hillpeople": layoutWindow(
    throwTo(1, "rightHalf")
  ),
  "iTerm2": layoutWindow(
    throwTo(1, "rightHalf")
  ),
});

var threeMonitor = slate.layout("threeMonitor", {
  "Atom": layoutWindow(
    atomLayout(throwTo(1, "full"))
  ),
  "Tweetbot": layoutWindow(
    throwTo(1, "leftHalf")
  ),
  "Google Chrome": layoutWindow(
    throwTo(1, "full")
  ),
  "Microsoft Outlook": layoutWindow(
    outlookLayout(throwTo(1, "full"))
  ),
  "Slack": layoutWindow(
    throwTo(2, "full")
  ),
  "Hillpeople": layoutWindow(
    throwTo(2, "full")
  ),
  "iTerm2": layoutWindow(
    throwTo(2, "full")
  ),
});

slate.default(1, oneMonitor);
slate.default(2, twoMonitor);
slate.default(3, threeMonitor);


// bindings

slate.bnda({
  // move bindings
  "left:ctrl;alt;cmd": moveLeftHalf,
  "right:ctrl;alt;cmd": moveRightHalf,
  "up:ctrl;alt;cmd": moveFull,
  "down:ctrl;alt;cmd": moveCenter,

  // throw bindings
  ",:ctrl;alt;cmd": slate.op("throw", {"screen": "left", "width": "screenSizeX", "height": "screenSizeY" }),
  ".:ctrl;alt;cmd": slate.op("throw", {"screen": "right", "width": "screenSizeX", "height": "screenSizeY" }),

  // layout bindings
  "j:ctrl;alt;cmd": slate.op("layout", { "name": oneMonitor }),
  "k:ctrl;alt;cmd": slate.op("layout", { "name": twoMonitor }),
  "l:ctrl;alt;cmd": slate.op("layout", { "name": threeMonitor }),

  // window hints
  "e:cmd": slate.op("hint",  {"characters" : "ASDFGQWERT"}),

});
