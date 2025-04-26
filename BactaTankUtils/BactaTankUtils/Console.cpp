/*
    Console
    -------------------------------------------------------------------------
    File:			Console.cpp
    Version:		v1.00
    Created:		13/01/2025 by Alun Jones
    Description:	Console Source File
    -------------------------------------------------------------------------
    History:
     - Created 13/01/2025 by Alun Jones

    To Do:
*/

// Includes
#include "Console.h"
#pragma comment (lib, "Dwmapi")
#include "comdef.h"

DLLEX double InitConsole()
{
    // Allocate Console
    if (!AllocConsole()) {
        // Add some error handling here.
        // You can call GetLastError() to get more info about the error.
        return false;
    }

    // std::cout, std::clog, std::cerr, std::cin
    FILE* fDummy;
    freopen_s(&fDummy, "CONOUT$", "w", stdout);
    freopen_s(&fDummy, "CONOUT$", "w", stderr);
    freopen_s(&fDummy, "CONIN$", "r", stdin);
    std::cout.clear();
    std::clog.clear();
    std::cerr.clear();
    std::cin.clear();

    // Print
    printf("<BactaTankConsole> Initialized\n");

    // Return Out
    return true;
}

DLLEX double Print(char* string)
{
    // Print
    printf(string);

    // Return
    return true;
}

DLLEX double SetTitle(char* string)
{
    // Convert String to Wide String
    const size_t stringSize = strlen(string) + 1;
    wchar_t* wideString = new wchar_t[stringSize];
    mbstowcs(wideString, string, stringSize);

    // Set Console Title
    SetConsoleTitle(wideString);

    // Return
    return true;
}

DLLEX double OpenDirectory(char* dir)
{
    // Open Directory
    ShellExecuteA(NULL, "open", dir, NULL, NULL, SW_SHOWDEFAULT);

    // Return
    return true;
}

DLLEX double IsWindowMaximised(char* handle)
{

    WINDOWPLACEMENT placement = { sizeof(WINDOWPLACEMENT) };
    placement.length = sizeof(WINDOWPLACEMENT);
    bool done = GetWindowPlacement((HWND)handle, &placement);
    return placement.showCmd == SW_MAXIMIZE;
}

DLLEX double SetWindowMaximised(char* handle)
{
    return ShowWindow((HWND)handle, SW_MAXIMIZE);
}

DLLEX double SetWindowActive(char* handle)
{
    SetActiveWindow((HWND)handle);
    return true;
}

DLLEX double SetWindowTitleBarDark(char* handle)
{
    BOOL DARK_MODE = true;
    bool SET_WINDOW_DARK = SUCCEEDED(DwmSetWindowAttribute((HWND)handle, DWMWINDOWATTRIBUTE::DWMWA_USE_IMMERSIVE_DARK_MODE, &DARK_MODE, sizeof(DARK_MODE)));
    return SET_WINDOW_DARK;
}

DLLEX double SetWindowTitleBarLight(char* handle)
{
    BOOL DARK_MODE = false;
    bool SET_WINDOW_DARK = SUCCEEDED(DwmSetWindowAttribute((HWND)handle, DWMWINDOWATTRIBUTE::DWMWA_USE_IMMERSIVE_DARK_MODE, &DARK_MODE, sizeof(DARK_MODE)));
    return SET_WINDOW_DARK;
}