/*
    TextureUtils
    -------------------------------------------------------------------------
    File:			TextureUils.cpp
    Version:		v1.00
    Created:		31/01/2025 by Alun Jones
    Description:	DirectX Texture Utils Wrapper
    -------------------------------------------------------------------------
    History:
     - Created 31/01/2025 by Alun Jones

    To Do:
*/

#include "Core.h"
#include "DirectXTex.h"
#include <cstdio>
#include <iostream>
#include "comdef.h"
#include "windows.h"
#include <ddraw.h>
#include <wincodec.h>

using namespace DirectX;

DLLEX double DecodeDDS(void* _buffer, double _size)
{
    // Initialize COM
    HRESULT hr = CoInitializeEx(NULL, COINIT_MULTITHREADED);

    if (FAILED(hr))
    {
        printf("COM Failed\n");
        _com_error err(hr);
        LPCTSTR errMsg = err.ErrorMessage();
        MessageBox(NULL, errMsg, L"COM Error", MB_OK);
    }
    else printf("COM Success");


    // Get Buffer and Size
    const uint8_t* buffer = (uint8_t*)_buffer;
    const size_t size = (size_t)_size;

    printf((char*)buffer);
    DDS_FLAGS flags = DDS_FLAGS_NONE;
    TexMetadata metadata;
    DDSMetaData ddsMetadata;
    auto image = std::make_unique<ScratchImage>();

    HRESULT texture = LoadFromDDSMemoryEx(buffer, size, flags, &metadata, &ddsMetadata, *image);
    const wchar_t* file = L"D:\\Projects\\BactaTank\\BactaTank Classic\\datafiles\\Untitled.dds";
    //HRESULT texture = DirectX::LoadFromDDSFile(file, flags, &metadata, *image);

    if (FAILED(texture))
    {
        printf("DirectXTex Failed\n");
        _com_error err(texture);
        LPCTSTR errMsg = err.ErrorMessage();
        MessageBox(NULL, errMsg, L"DirectX Error", MB_OK);
    }
    else printf("DirectXTex Success");

    const Image* img = image->GetImages();
    //assert(img);
    //size_t nimg = image->GetImageCount();
    //assert(nimg > 0);

    // Create Blob
    Blob blob = Blob();

    HRESULT wic = SaveToWICMemory(img[0], WIC_FLAGS_NONE, GUID_ContainerFormatBmp, blob, nullptr, nullptr);

    if (FAILED(wic))
    {
        printf("WIC Failed\n");
        _com_error err(wic);
        LPCTSTR errMsg = err.ErrorMessage();
        MessageBox(NULL, errMsg, L"WIC Error", MB_OK);
    }
    else printf("WIC Success");

    memcpy(_buffer, blob.GetBufferPointer(), 0x200);

    CoUninitialize();

    return 0;
}