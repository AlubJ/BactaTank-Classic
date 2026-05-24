/// @desc Begin initialisation of BactaTank

// Set the window size
PaneSet(640, 480, undefined, undefined, false, false, true);

// Initialisation phase
initPhase = 0;

// Initialisation log
initLog = [  ];

// Log position
initLogX = 16;
initLogY = 16;
initLogYSpace = 16;

// Set window cursor to load
PaneSetCursor(cr_hourglass);