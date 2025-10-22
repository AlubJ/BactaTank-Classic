#include "../Core/core.h"

GMEXPORT double DDSCreate(double width, double height, double compression, double mipmaps, double errorDithering)
{
    using namespace DirectX;

    // Create GMTexture Wrapper
    auto texture = new GMTexture;

    // Create Wrapper Image
    texture->image = {};
    texture->image.width = width;
    texture->image.height = height;
    texture->image.format = DXGI_FORMAT_R8G8B8A8_UNORM;
    texture->image.rowPitch = width * 4;
    texture->image.slicePitch = texture->image.rowPitch * height;

    // Set Texture Stuff
    texture->width = width;
    texture->height = height;

    // Do Compression Format
    switch ((int)compression)
    {
        case DXT1:
            texture->format = DXGI_FORMAT_BC1_UNORM;
            break;
        case DXT3:
            texture->format = DXGI_FORMAT_BC2_UNORM;
            break;
        case DXT5:
        default:
            texture->format = DXGI_FORMAT_BC3_UNORM;
            break;
    }

    // Do Compression Flags
    texture->flags = TEX_COMPRESS_DEFAULT;
    if (errorDithering) texture->flags |= TEX_COMPRESS_DITHER;

    // Set Mipmaps
    texture->generateMipmaps = (bool)mipmaps;

    return reinterpret_cast<uintptr_t>(texture);
}

GMEXPORT double DDSCompress(GMTexture* texture, void* rawBuffer)
{
    using namespace DirectX;

    // Set Raw Buffer
    texture->image.pixels = (uint8_t*)rawBuffer;

    // Create Scratch Image
    ScratchImage srcImage;
    HRESULT hr = srcImage.InitializeFromImage(texture->image);
    if (FAILED(hr))
    {
        std::cout << "Failed Initialize" << std::endl;
        std::cout << HrToString(hr) << std::endl;
        return false;
    }

    // Create Mipmapped Image
    ScratchImage workingImage;
    if (texture->generateMipmaps)
    {
        hr = GenerateMipMaps(srcImage.GetImages(), srcImage.GetImageCount(), srcImage.GetMetadata(), TEX_FILTER_LINEAR, 0, workingImage);
        if (FAILED(hr))
        {
            std::cout << "Failed Compress" << std::endl;
            std::cout << HrToString(hr) << std::endl;
            return false;
        }
    }
    else
    {
        workingImage = std::move(srcImage);
    }

    // Create Final Image
    ScratchImage finalImage;
    hr = Compress(workingImage.GetImages(), workingImage.GetImageCount(), workingImage.GetMetadata(), texture->format, texture->flags, 0.5f, finalImage);
    if (FAILED(hr))
    {
        std::cout << "Failed Compress" << std::endl;
        std::cout << HrToString(hr) << std::endl;
        return false;
    }
    
    // Save DDS To Blob
    hr = SaveToDDSMemory(finalImage.GetImages(), finalImage.GetImageCount(), finalImage.GetMetadata(), DDS_FLAGS_NONE, texture->blob);
    if (FAILED(hr))
    {
        std::cout << "Failed Compress" << std::endl;
        std::cout << HrToString(hr) << std::endl;
        return false;
    }

    // Save DDS Size
    texture->bufferSize = texture->blob.GetBufferSize();

    return texture->bufferSize;
}

GMEXPORT double DDSDestroy(GMTexture* texture)
{
    delete texture;
    return true;
}

GMEXPORT double DDSWidth(GMTexture* texture)
{
    return texture ? texture->image.width : 0;
}

GMEXPORT double DDSHeight(GMTexture* texture)
{
    return texture ? texture->image.height : 0;
}

GMEXPORT double DDSSize(GMTexture* texture)
{
    return texture ? texture->bufferSize : 0;
}

GMEXPORT double DDSCopy(GMTexture* texture, void* outBuffer)
{
    if (texture->format == DXGI_FORMAT_R8G8B8A8_UNORM)
    {
        // Copy row by row (in case rowPitch != width*4)
        uint8_t* dst = static_cast<uint8_t*>(outBuffer);
        const uint8_t* src = texture->image.pixels;
        for (size_t y = 0; y < texture->image.height; y++)
        {
            memcpy(dst + y * texture->image.width * 4,
                src + y * texture->image.rowPitch,
                texture->image.width * 4);
        }
    }
    else
    {
        std::memcpy(outBuffer, texture->blob.GetBufferPointer(), texture->bufferSize);
    }
    return true;
}

GMEXPORT double DDSCubemap(GMTexture* texture)
{
    return texture->isCubemap;
}

GMEXPORT double DDSCompression(GMTexture* texture)
{
    return texture->compressionType;
}