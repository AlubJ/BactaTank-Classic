/*
    Core
    -------------------------------------------------------------------------
    File:			core.h
    Version:		v1.00
    Created:		13/09/2025 by Alun Jones
    Description:	Core Header File
    -------------------------------------------------------------------------
    History:
     - Created 13/09/2025 by Alun Jones

    To Do:
*/

#pragma once

// GMEXPORT
#define GMEXPORT extern "C" __declspec(dllexport)

// DLL Export
#define DLLEX extern "C" __declspec(dllexport)

// DirectXTex
#include "DirectXTex.h"
#include <iostream>
#include <windows.h>
#include <string>

std::string HrToString(HRESULT hr);

struct GMTexture
{
    size_t width;
    size_t height;
    size_t bufferSize;
    bool generateMipmaps;
    bool isCubemap;
    int compressionType;
    DXGI_FORMAT format;
    DirectX::Image image;
    DirectX::TEX_COMPRESS_FLAGS flags;
    DirectX::Blob blob;
};

#define DXT1 0
#define DXT3 1
#define DXT5 2