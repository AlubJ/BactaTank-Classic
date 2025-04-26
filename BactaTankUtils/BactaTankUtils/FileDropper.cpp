/*
    FileDropper
    -------------------------------------------------------------------------
    File:			FileDropper.cpp
    Version:		v1.00
    Created:		13/01/2025 by DragoniteSpam (Implemented into BactaTankUtils by Alun Jones)
    Description:	File Dropper Source
    -------------------------------------------------------------------------
    History:
     - Created 13/01/2025 by DragoniteSpam (Implemented into BactaTankUtils by Alun Jones)

    To Do:
*/

// Includes
#include "FileDropper.h"

namespace FileDropper
{
    LONG_PTR windowOriginal;
    std::vector<std::wstring> names;

    void Init(HWND hWnd)
    {
        windowOriginal = GetWindowLongPtr(hWnd, GWLP_WNDPROC);
        DragAcceptFiles(hWnd, true);
    }

    int Count()
    {
        return (int)names.size();
    }

    char* Get(int n)
    {
        std::wstring path(names.at(n));
        wchar_t* cstr = new wchar_t[path.size() + 1];
        wcscpy_s(cstr, path.size() + 1, path.c_str());
        return (char*)cstr;
    }

    void Flush()
    {
        names.clear();
    }

    void Handle(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
    {
        HDROP hdr = ((HDROP)wParam);

        Flush();
        int count = DragQueryFileW(hdr, 0xffffffff, NULL, 0);

        std::vector<wchar_t> buffer;

        for (int i = 0; i < count; i++)
        {
            int size = (int)DragQueryFileW(hdr, i, NULL, 0);
            if (size > 0)
            {
                buffer.resize(size + (size_t)(1));
                DragQueryFileW(hdr, i, buffer.data(), size + 1);
                std::wstring path(buffer.data());
                names.push_back(std::wstring(path.begin(), path.end()));
            }
        }

        DragFinish(hdr);
    }
}