/*
	ddsLoad
	-------------------------------------------------------------------------
	Script:			ddsLoad
	Version:		v1.00
	Created:		04/09/2023 by Alun Jones
	Description:	Load DDS Textures
	-------------------------------------------------------------------------
	History:
	 - Created 04/09/2023 by Alun Jones
	
	To Do:
	 - Read Mipmap Data
	 - Read Cubemap Data
*/

function ddsLoad(buffer)
{
	// Skip ahead a little
	buffer_seek(buffer, buffer_seek_start, 0x0c);
	
	// Read Width and Height
	var height = buffer_read(buffer, buffer_s32);
	var width = buffer_read(buffer, buffer_s32);
	
	// Mip-Map Count
	buffer_seek(buffer, buffer_seek_relative, 0x08);
	var mipCount = buffer_read(buffer, buffer_s32);
	
	// Read Compression Type
	buffer_seek(buffer, buffer_seek_relative, 0x34);
	var compressionType = buffer_read(buffer, buffer_string);
	
	// Cubemap Check?
	var isCubemap = buffer_peek(buffer, 0x71, buffer_u8) > 0;
	
	// Skip ahead
	buffer_seek(buffer, buffer_seek_start, 0x80);
	
	// Create Image Buffer
	var imageBuffer = buffer_create(width * height * 4, buffer_fixed, 1);
	
	// Block Counts
	var blockCountX = floor((width + 3) / 4);
	var blockCountY = floor((height + 3) / 4);
	
	// Read DXT blocks
	for (var yy = 0; yy < blockCountY; yy++)
	{
	    for (var xx = 0; xx < blockCountX; xx++)
	    {
			switch (compressionType)
			{
				case "DXT1":
					readDXT1Block(buffer, imageBuffer, xx, yy, width, height);
					break;
				case "DXT3":
					readDXT3Block(buffer, imageBuffer, xx, yy, width, height);
					break;
				case "DXT5":
					readDXT5Block(buffer, imageBuffer, xx, yy, width, height);
					break;
			}
		}
	}
	
	// Convert to sprite
	var surface = surface_create(width, height);
	buffer_set_surface(imageBuffer, surface, 0);
	var sprite = sprite_create_from_surface(surface, 0, 0, width, height, false, false, 0, 0);
	
	// Cleanup
	surface_free(surface);
	buffer_delete(imageBuffer);
	
	// Return
	return sprite;
}

function ddsLoadSurface(buffer)
{
	// Skip ahead a little
	buffer_seek(buffer, buffer_seek_start, 0x0c);
	
	// Read Width and Height
	var height = buffer_read(buffer, buffer_s32);
	var width = buffer_read(buffer, buffer_s32);
	
	// Mip-Map Count
	buffer_seek(buffer, buffer_seek_relative, 0x08);
	var mipCount = buffer_read(buffer, buffer_s32);
	
	// Read Compression Type
	buffer_seek(buffer, buffer_seek_relative, 0x34);
	var compressionType = buffer_read(buffer, buffer_string);
	
	// Cubemap Check?
	var isCubemap = buffer_peek(buffer, 0x71, buffer_u8) > 0;
	
	// Skip ahead
	buffer_seek(buffer, buffer_seek_start, 0x80);
	
	// Create Image Buffer
	var imageBuffer = buffer_create(width * height * 4, buffer_fixed, 1);
	
	// Block Counts
	var blockCountX = floor((width + 3) / 4);
	var blockCountY = floor((height + 3) / 4);
	
	// Read DXT blocks
	for (var yy = 0; yy < blockCountY; yy++)
	{
	    for (var xx = 0; xx < blockCountX; xx++)
	    {
			switch (compressionType)
			{
				case "DXT1":
					readDXT1Block(buffer, imageBuffer, xx, yy, width, height);
					break;
				case "DXT3":
					readDXT3Block(buffer, imageBuffer, xx, yy, width, height);
					break;
				case "DXT5":
					readDXT5Block(buffer, imageBuffer, xx, yy, width, height);
					break;
			}
		}
	}
	
	// Convert to sprite
	var surface = surface_create(width, height);
	buffer_set_surface(imageBuffer, surface, 0);
	
	// Return
	return surface;
}

#region DXT1

function readDXT1Block(buffer, imageBuffer, xx, yy, width, height)
{
	var c0 = buffer_read(buffer, buffer_u16);
    var c1 = buffer_read(buffer, buffer_u16);
	
	var r0, g0, b0;
	var r1, g1, b1;
	var temp;
	
    temp = (c0 >> 11) * 255 + 16;
	r0 = ((temp / 32 + temp) / 32);
	temp = ((c0 & 0x07E0) >> 5) * 255 + 32;
	g0 = ((temp / 64 + temp) / 64);
	temp = (c0 & 0x001F) * 255 + 16;
	b0 = ((temp / 32 + temp) / 32);
	
    temp = (c1 >> 11) * 255 + 16;
	r1 = ((temp / 32 + temp) / 32);
	temp = ((c1 & 0x07E0) >> 5) * 255 + 32;
	g1 = ((temp / 64 + temp) / 64);
	temp = (c1 & 0x001F) * 255 + 16;
	b1 = ((temp / 32 + temp) / 32);
	
    var lookupTable = buffer_read(buffer, buffer_u32);
	
    for (var blockY = 0; blockY < 4; blockY++)
    {
        for (var blockX = 0; blockX < 4; blockX++)
        {
			var r = 0, g = 0, b = 0, a = 255;
            var index = (lookupTable >> 2 * (4 * blockY + blockX)) & 0x03;
            
            if (c0 > c1)
            {
                switch (index)
                {
					case 0:
						r = r0;
						g = g0;
						b = b0;
						break;
					case 1:
						r = r1;
						g = g1;
						b = b1;
						break;
                    case 2:
						r = ((2 * r0 + r1) / 3);
						g = ((2 * g0 + g1) / 3);
						b = ((2 * b0 + b1) / 3);
						break;
                    case 3:
						r = ((r0 + 2 * r1) / 3);
						g = ((g0 + 2 * g1) / 3);
						b = ((b0 + 2 * b1) / 3);
						break;
                }
            }
            else
            {
                switch (index)
                {
					case 0:
						r = r0;
						g = g0;
						b = b0;
						break;
					case 1:
						r = r1;
						g = g1;
						b = b1;
						break;
					case 2:
						r = ((r0 + r1) / 2);
						g = ((g0 + g1) / 2);
						b = ((b0 + b1) / 2);
						break;
					case 3:
						r = 0;
						g = 0;
						b = 0;
						a = 0;
						break;
                }
            }

			var px = (xx << 2) + blockX;
			var py = (yy << 2) + blockY;
			if ((px < width) && (py < height))
			{
				var offset = ((py * width) + px) << 2;
				buffer_poke(imageBuffer, offset, buffer_u8, r);
				buffer_poke(imageBuffer, offset + 1, buffer_u8, g);
				buffer_poke(imageBuffer, offset + 2, buffer_u8, b);
				buffer_poke(imageBuffer, offset + 3, buffer_u8, a);
			}
        }
	}
}

#endregion

#region DXT3

function readDXT3Block(buffer, imageBuffer, xx, yy, width, height)
{
    var a0 = buffer_read(buffer, buffer_u8);
	var a1 = buffer_read(buffer, buffer_u8);
	var a2 = buffer_read(buffer, buffer_u8);
	var a3 = buffer_read(buffer, buffer_u8);
	var a4 = buffer_read(buffer, buffer_u8);
	var a5 = buffer_read(buffer, buffer_u8);
	var a6 = buffer_read(buffer, buffer_u8);
	var a7 = buffer_read(buffer, buffer_u8);
            
    var c0 = buffer_read(buffer, buffer_u16);
    var c1 = buffer_read(buffer, buffer_u16);

	var r0, g0, b0;
	var r1, g1, b1;
	var temp;
		
    temp = (c0 >> 11) * 255 + 16;
	r0 = ((temp / 32 + temp) / 32);
	temp = ((c0 & 0x07E0) >> 5) * 255 + 32;
	g0 = ((temp / 64 + temp) / 64);
	temp = (c0 & 0x001F) * 255 + 16;
	b0 = ((temp / 32 + temp) / 32);
		
    temp = (c1 >> 11) * 255 + 16;
	r1 = ((temp / 32 + temp) / 32);
	temp = ((c1 & 0x07E0) >> 5) * 255 + 32;
	g1 = ((temp / 64 + temp) / 64);
	temp = (c1 & 0x001F) * 255 + 16;
	b1 = ((temp / 32 + temp) / 32);

    var lookupTable = buffer_read(buffer, buffer_u32);

	var alphaIndex = 0;
    for (var blockY = 0; blockY < 4; blockY++)
    {
        for (var blockX = 0; blockX < 4; blockX++)
        {
			var r = 0, g = 0, b = 0, a = 0;

            var index = (lookupTable >> 2 * (4 * blockY + blockX)) & 0x03;
					
			switch (alphaIndex)
			{
				case 0:
					a = ((a0 & 0x0F) | ((a0 & 0x0F) << 4));
					break;
				case 1:
					a = ((a0 & 0xF0) | ((a0 & 0xF0) >> 4));
					break;
				case 2:
					a = ((a1 & 0x0F) | ((a1 & 0x0F) << 4));
					break;
				case 3:
					a = ((a1 & 0xF0) | ((a1 & 0xF0) >> 4));
					break;
				case 4:
					a = ((a2 & 0x0F) | ((a2 & 0x0F) << 4));
					break;
				case 5:
					a = ((a2 & 0xF0) | ((a2 & 0xF0) >> 4));
					break;
				case 6:
					a = ((a3 & 0x0F) | ((a3 & 0x0F) << 4));
					break;
				case 7:
					a = ((a3 & 0xF0) | ((a3 & 0xF0) >> 4));
					break;
				case 8:
					a = ((a4 & 0x0F) | ((a4 & 0x0F) << 4));
					break;
				case 9:
					a = ((a4 & 0xF0) | ((a4 & 0xF0) >> 4));
					break;
				case 10:
					a = ((a5 & 0x0F) | ((a5 & 0x0F) << 4));
					break;
				case 11:
					a = ((a5 & 0xF0) | ((a5 & 0xF0) >> 4));
					break;
				case 12:
					a = ((a6 & 0x0F) | ((a6 & 0x0F) << 4));
					break;
				case 13:
					a = ((a6 & 0xF0) | ((a6 & 0xF0) >> 4));
					break;
				case 14:
					a = ((a7 & 0x0F) | ((a7 & 0x0F) << 4));
					break;
				case 15:
					a = ((a7 & 0xF0) | ((a7 & 0xF0) >> 4));
					break;
			}
			++alphaIndex;

            switch (index)
            {
				case 0:
					r = r0;
					g = g0;
					b = b0;
					break;
				case 1:
					r = r1;
					g = g1;
					b = b1;
					break;
				case 2:
					r = ((2 * r0 + r1) / 3);
					g = ((2 * g0 + g1) / 3);
					b = ((2 * b0 + b1) / 3);
					break;
				case 3:
					r = ((r0 + 2 * r1) / 3);
					g = ((g0 + 2 * g1) / 3);
					b = ((b0 + 2 * b1) / 3);
					break;
			}

			var px = (xx << 2) + blockX;
			var py = (yy << 2) + blockY;
			if ((px < width) && (py < height))
			{
				var offset = ((py * width) + px) << 2;
				buffer_poke(imageBuffer, offset, buffer_u8, r);
				buffer_poke(imageBuffer, offset + 1, buffer_u8, g);
				buffer_poke(imageBuffer, offset + 2, buffer_u8, b);
				buffer_poke(imageBuffer, offset + 3, buffer_u8, a);
			}
		}
    }
}

#endregion

#region DXT5

function readDXT5Block(buffer, imageBuffer, xx, yy, width, height)
{
	var alpha0 = buffer_read(buffer, buffer_u8);
    var alpha1 = buffer_read(buffer, buffer_u8);
	
    var alphaMask = buffer_read(buffer, buffer_u8);
    alphaMask += buffer_read(buffer, buffer_u8) << 8;
    alphaMask += buffer_read(buffer, buffer_u8) << 16;
    alphaMask += buffer_read(buffer, buffer_u8) << 24;
    alphaMask += buffer_read(buffer, buffer_u8) << 32;
    alphaMask += buffer_read(buffer, buffer_u8) << 40;
	
    var c0 = buffer_read(buffer, buffer_u16);
    var c1 = buffer_read(buffer, buffer_u16);
	
	var r0, g0, b0;
	var r1, g1, b1;
	var temp;
		
    temp = (c0 >> 11) * 255 + 16;
	r0 = ((temp / 32 + temp) / 32);
	temp = ((c0 & 0x07E0) >> 5) * 255 + 32;
	g0 = ((temp / 64 + temp) / 64);
	temp = (c0 & 0x001F) * 255 + 16;
	b0 = ((temp / 32 + temp) / 32);
	
    temp = (c1 >> 11) * 255 + 16;
	r1 = ((temp / 32 + temp) / 32);
	temp = ((c1 & 0x07E0) >> 5) * 255 + 32;
	g1 = ((temp / 64 + temp) / 64);
	temp = (c1 & 0x001F) * 255 + 16;
	b1 = ((temp / 32 + temp) / 32);
	
    var lookupTable = buffer_read(buffer, buffer_u32);
	
    for (var blockY = 0; blockY < 4; blockY++)
    {
        for (var blockX = 0; blockX < 4; blockX++)
        {
			var r = 0, g = 0, b = 0, a = 255;
            var index = (lookupTable >> 2 * (4 * blockY + blockX)) & 0x03;
			
			var alphaIndex = ((alphaMask >> 3 * (4 * blockY + blockX)) & 0x07);
            if (alphaIndex == 0)
			{
                a = alpha0;
            }
			else if (alphaIndex == 1)
			{
                a = alpha1;
            }
			else if (alpha0 > alpha1)
			{
                a = (((8 - alphaIndex) * alpha0 + (alphaIndex - 1) * alpha1) / 7);
            }
			else if (alphaIndex == 6)
			{
                a = 0;
            }
			else if (alphaIndex == 7)
			{
                a = 0xff;
            }
			else
			{
                a = (((6 - alphaIndex) * alpha0 + (alphaIndex - 1) * alpha1) / 5);
            }
			
			switch (index)
			{
				case 0:
					r = r0;
					g = g0;
					b = b0;
					break;
				case 1:
					r = r1;
					g = g1;
					b = b1;
					break;
				case 2:
					r = ((2 * r0 + r1) / 3);
					g = ((2 * g0 + g1) / 3);
					b = ((2 * b0 + b1) / 3);
					break;
				case 3:
					r = ((r0 + 2 * r1) / 3);
					g = ((g0 + 2 * g1) / 3);
					b = ((b0 + 2 * b1) / 3);
					break;
			}
			
			var px = (xx << 2) + blockX;
			var py = (yy << 2) + blockY;
			if ((px < width) && (py < height))
			{
				var offset = ((py * width) + px) << 2;
				buffer_poke(imageBuffer, offset, buffer_u8, r);
				buffer_poke(imageBuffer, offset + 1, buffer_u8, g);
				buffer_poke(imageBuffer, offset + 2, buffer_u8, b);
				buffer_poke(imageBuffer, offset + 3, buffer_u8, a);
			}
		}
    }
}

#endregion