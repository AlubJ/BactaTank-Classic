/*
    FileDropper
    -------------------------------------------------------------------------
    File:			FileDropperDLL.cpp
    Version:		v1.00
    Created:		13/01/2025 by DragoniteSpam (Implemented into BactaTankUtils by Alun Jones)
    Description:	File Dropper DLL Source
    -------------------------------------------------------------------------
    History:
     - Created 13/01/2025 by DragoniteSpam (Implemented into BactaTankUtils by Alun Jones)

    To Do:
*/

// Includes
#include "FileDropper.h"

DLLEX double file_drop_init(HWND hWnd) {
    FileDropper::Init(hWnd);
    SetWindowLongPtr(hWnd, GWLP_WNDPROC, (LONG_PTR)MsgProc);
    return 1.0;
}

DLLEX double file_drop_count() {
    return 1.0 * FileDropper::Count();
}

DLLEX char* file_drop_get(double n) {
    return FileDropper::Get((int)n);
}

DLLEX double file_drop_flush() {
    FileDropper::Flush();
    return 0.0;
}

// internal stuff

LRESULT WINAPI MsgProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    switch (msg) {
    case WM_DROPFILES:
    {
        FileDropper::Handle(hWnd, msg, wParam, lParam);
        break;
    }
    default:
    {
        return CallWindowProc((WNDPROC)FileDropper::windowOriginal, hWnd, msg, wParam, lParam);
    }
    }

    return (LRESULT)0;
}