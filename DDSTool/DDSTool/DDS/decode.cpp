#include "../Core/core.h"

// Load DDS
GMEXPORT double DDSLoad(void* ddsData, double ddsSize)
{
	// Use DirectX Namespace
	using namespace DirectX;

	// Create GM Texture
	auto texture = new GMTexture;

	// Create Metadata and Scratch Image
	TexMetadata metadata;
	ScratchImage image;

	// Load DDS Data
	HRESULT hr = LoadFromDDSMemory((uint8_t*)ddsData, ddsSize, DDS_FLAGS_NONE, &metadata, image);
	if (FAILED(hr))
	{
		std::cout << "Failed Load" << std::endl;
		std::cout << HrToString(hr) << std::endl;
		return false;
	}

	// Make sure it's compressed
	if (!IsCompressed(metadata.format))
		return false; // not BCn

	// Set Compression Type
	switch (metadata.format)
	{
		case DXGI_FORMAT_BC1_UNORM:
		case DXGI_FORMAT_BC1_UNORM_SRGB:
			texture->compressionType = (int)DXT1;
			break;
		case DXGI_FORMAT_BC2_UNORM:
		case DXGI_FORMAT_BC2_UNORM_SRGB:
			texture->compressionType = (int)DXT3;
			break;
		case DXGI_FORMAT_BC3_UNORM:
		case DXGI_FORMAT_BC3_UNORM_SRGB:
			texture->compressionType = (int)DXT5;
			break;
		default:
			texture->compressionType = (int)DXT1;
			break;
	}

	// Decompress to RGBA8
	ScratchImage decompressed;
	hr = Decompress(image.GetImages(), image.GetImageCount(),
		metadata,
		DXGI_FORMAT_R8G8B8A8_UNORM,
		decompressed);
	if (FAILED(hr))
	{
		std::cout << "Failed Convert " << std::endl;
		std::cout << HrToString(hr) << std::endl;
		return false;
	}

	// Handle Cubemap
	if (metadata.IsCubemap())
	{
		size_t faceW = metadata.width;
		size_t faceH = metadata.height;

		// Create crossed layout
		ScratchImage cross;
		hr = cross.Initialize2D(DXGI_FORMAT_R8G8B8A8_UNORM, faceW * 4, faceH * 3, 1, 1);
		if (FAILED(hr)) return false;

		const Image* dst = cross.GetImage(0, 0, 0);

		// Grab each cubemap face (mip 0)
		const Image* posX = decompressed.GetImage(0, 0, 0);
		const Image* negX = decompressed.GetImage(0, 1, 0);
		const Image* posY = decompressed.GetImage(0, 2, 0);
		const Image* negY = decompressed.GetImage(0, 3, 0);
		const Image* posZ = decompressed.GetImage(0, 4, 0);
		const Image* negZ = decompressed.GetImage(0, 5, 0);

		// Copy into cross layout
		CopyRectangle(*posX, Rect(0, 0, faceW, faceH), *dst, TEX_FILTER_DEFAULT, faceW * 2, faceH);
		CopyRectangle(*negX, Rect(0, 0, faceW, faceH), *dst, TEX_FILTER_DEFAULT, 0, faceH);
		CopyRectangle(*posY, Rect(0, 0, faceW, faceH), *dst, TEX_FILTER_DEFAULT, faceW, 0);
		CopyRectangle(*negY, Rect(0, 0, faceW, faceH), *dst, TEX_FILTER_DEFAULT, faceW, faceH * 2);
		CopyRectangle(*posZ, Rect(0, 0, faceW, faceH), *dst, TEX_FILTER_DEFAULT, faceW, faceH);
		CopyRectangle(*negZ, Rect(0, 0, faceW, faceH), *dst, TEX_FILTER_DEFAULT, faceW * 3, faceH);

		// Copy cross image into GMTexture
		const Image* img = cross.GetImage(0, 0, 0);

		// Create New Image
		texture->image = {};
		texture->image.width = img->width;
		texture->image.height = img->height;
		texture->image.format = img->format;
		texture->image.rowPitch = img->rowPitch;
		texture->image.slicePitch = img->slicePitch;

		// Allocate Memory
		texture->blob.Initialize(img->slicePitch);
		memcpy(texture->blob.GetBufferPointer(), img->pixels, img->slicePitch);

		// Set Memory
		texture->image.pixels = (uint8_t*)texture->blob.GetBufferPointer();

		// Save DDS Size
		texture->bufferSize = texture->blob.GetBufferSize();

		// Set Texture Format
		texture->format = DXGI_FORMAT_R8G8B8A8_UNORM;

		// Set Cubemap
		texture->isCubemap = true;
	}
	else
	{
		// Decompress Texture
		const DirectX::Image* img = decompressed.GetImage(0, 0, 0);

		// Create New Image
		texture->image = {};
		texture->image.width = img->width;
		texture->image.height = img->height;
		texture->image.format = img->format;
		texture->image.rowPitch = img->rowPitch;
		texture->image.slicePitch = img->slicePitch;

		// Allocate Memory
		texture->blob.Initialize(img->slicePitch);
		memcpy(texture->blob.GetBufferPointer(), img->pixels, img->slicePitch);

		// Set Memory
		texture->image.pixels = (uint8_t*)texture->blob.GetBufferPointer();

		// Save DDS Size
		texture->bufferSize = texture->blob.GetBufferSize();

		// Set Texture Format
		texture->format = DXGI_FORMAT_R8G8B8A8_UNORM;

		// Set Cubemap
		texture->isCubemap = false;
	}

	// Return Texture
	return reinterpret_cast<uintptr_t>(texture);
}

// Decode DDS
//GMEXPORT double DecodeDDS(void* ddsData, double ddsSize, void* rawData, double rawSize)
//{
//	// Create Metadata and Scratch Image
//	DirectX::TexMetadata metadata;
//	DirectX::ScratchImage image;
//
//	// Load DDS Data
//	HRESULT hr = DirectX::LoadFromDDSMemory((uint8_t*)ddsData, ddsSize, DirectX::DDS_FLAGS_NONE, &metadata, image);
//	if (FAILED(hr))
//	{
//		std::cout << "Failed Load" << std::endl;
//		std::cout << HrToString(hr) << std::endl;
//		return false;
//	}
//
//	// Make sure it's compressed
//	if (!DirectX::IsCompressed(metadata.format))
//		return false; // not BCn
//
//	// Decompress to RGBA8
//	DirectX::ScratchImage decompressed;
//	hr = DirectX::Decompress(image.GetImages(), image.GetImageCount(),
//		metadata,
//		DXGI_FORMAT_R8G8B8A8_UNORM,
//		decompressed);
//	if (FAILED(hr))
//	{
//		std::cout << "Failed Convert " << std::endl;
//		std::cout << HrToString(hr) << std::endl;
//		return false;
//	}
//
//	const DirectX::Image* img = decompressed.GetImage(0, 0, 0);
//	//outWidth = img->width;
//	//outHeight = img->height;
//
//	size_t requiredSize = img->width * img->height * 4;
//	if (FAILED(hr))
//	{
//		std::cout << "Out Buffer Size Too Small" << std::endl;
//		std::cout << HrToString(hr) << std::endl;
//		return false;
//	}
//
//	// Copy row by row (in case rowPitch != width*4)
//	uint8_t* dst = static_cast<uint8_t*>(rawData);
//	const uint8_t* src = img->pixels;
//	for (size_t y = 0; y < img->height; y++)
//	{
//		memcpy(dst + y * img->width * 4,
//			src + y * img->rowPitch,
//			img->width * 4);
//	}
//
//	return true;
//}