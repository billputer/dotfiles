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

// layouts

var oneMonitor = slate.layout("oneMonitor", {
  "Atom": {
    "operations": [throwTo(0, "leftHalf")], "ignore-fail": true, "repeat": true,
  },
  "Tweetbot": {
    "operations": [throwTo(0, "leftHalf")], "ignore-fail": true, "repeat": true,
  },
  "Google Chrome": {
    "operations": [throwTo(0, "full")], "ignore-fail": true, "repeat": true,
  },
  "Microsoft Outlook": {
    "operations": [outlookLayout(throwTo(0, "full"))], "ignore-fail": true, "repeat": true,
  },
  "Slack": {
    "operations": [throwTo(0, "full")], "ignore-fail": true, "repeat": true,
  },
  "Hillpeople": {
    "operations": [throwTo(0, "full")], "ignore-fail": true, "repeat": true,
  },
  "iTerm2": {
    "operations": [throwTo(0, "rightHalf")], "ignore-fail": true, "repeat": true,
  },
});

var twoMonitor = slate.layout("twoMonitor", {
  "Atom": {
    "operations": [atomLayout(throwTo(1, "leftHalf"))], "ignore-fail": true, "repeat": true,
  },
  "Tweetbot": {
    "operations": [throwTo(1, "leftHalf")], "ignore-fail": true, "repeat": true,
  },
  "Google Chrome": {
    "operations": [throwTo(1, "leftHalf")], "ignore-fail": true, "repeat": true,
  },
  "Microsoft Outlook": {
    "operations": [outlookLayout(throwTo(1, "leftHalf"))], "ignore-fail": true, "repeat": true,
  },
  "Slack": {
    "operations": [throwTo(1, "rightHalf")], "ignore-fail": true, "repeat": true,
  },
  "Hillpeople": {
    "operations": [throwTo(1, "rightHalf")], "ignore-fail": true, "repeat": true,
  },
  "iTerm2": {
    "operations": [throwTo(1, "rightHalf")], "ignore-fail": true, "repeat": true,
  },
});

var threeMonitor = slate.layout("threeMonitor", {
  "Atom": {
    "operations": [atomLayout(throwTo(1, "full"))], "ignore-fail": true, "repeat": true,
  },
  "Tweetbot": {
    "operations": [throwTo(1, "leftHalf")], "ignore-fail": true, "repeat": true,
  },
  "Google Chrome": {
    "operations": [throwTo(1, "full")], "ignore-fail": true, "repeat": true,
  },
  "Microsoft Outlook": {
    "operations": [outlookLayout(throwTo(1, "full"))], "ignore-fail": true, "repeat": true,
  },
  "Slack": {
    "operations": [throwTo(2, "full")], "ignore-fail": true, "repeat": true,
  },
  "Hillpeople": {
    "operations": [throwTo(2, "full")], "ignore-fail": true, "repeat": true,
  },
  "iTerm2": {
    "operations": [throwTo(2, "full")], "ignore-fail": true, "repeat": true,
  },
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
