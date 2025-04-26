/*
    FileDropper
    -------------------------------------------------------------------------
    File:			FileDropper.h
    Version:		v1.00
    Created:		13/01/2025 by DragoniteSpam (Implemented into BactaTankUtils by Alun Jones)
    Description:	File Dropper Header
    -------------------------------------------------------------------------
    History:
     - Created 13/01/2025 by DragoniteSpam (Implemented into BactaTankUtils by Alun Jones)

    To Do:
*/

#pragma once

// Includes
#include "Core.h"
#include <windows.h>
#include <fstream>
#include <vector>

namespace FileDropper
{
	extern LONG_PTR windowOriginal;
	extern std::vector<std::wstring> names;
	LRESULT WINAPI MsgProc(HWND, UINT, WPARAM, LPARAM);

	void Init(HWND);

	int Count();
	char* Get(int n);
	void Flush();

	void Handle(HWND, UINT, WPARAM, LPARAM);
}

LRESULT WINAPI MsgProc(HWND, UINT, WPARAM, LPARAM);