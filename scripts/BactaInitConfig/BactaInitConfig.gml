///
/// Initialise the default config
///
function BactaInitConfig()
{
    // Register window config
    ReggieRegister("window.x", undefined);
    ReggieRegister("window.y", undefined);
    ReggieRegister("window.width", 1366);
    ReggieRegister("window.height", 768);
    ReggieRegister("window.maximised", false);
}