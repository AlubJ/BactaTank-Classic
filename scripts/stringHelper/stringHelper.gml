/*
	stringHelper
	-------------------------------------------------------------------------
	Script:			stringHelper
	Version:		v1.00
	Created:		22/11/2024 by Alun Jones
	Description:	String Helper Functions
	-------------------------------------------------------------------------
	History:
	 - Created 22/11/2024 by Alun Jones
	
	To Do:
*/

function string_contains_ext(str, substrs)
{
	var length = array_length(substrs);
	for (var i = 0; i < length; i++)
	{
	     sub = substrs[i];
	     if (string_count(sub, str) > 0) return i;
	}
	return false;
}

function string_hex(dec, len = 8)
{
	//return string_copy(string(ptr(dec)), 16 - len, len);
	
    len = is_undefined(len) ? 1 : len;
    var hex = "";
 
    if (dec < 0) {
        len = max(len, ceil(logn(16, 2*abs(dec))));
    }
 
    var dig = "0123456789ABCDEF";
    while (len-- || dec) {
        hex = string_char_at(dig, (dec & $F) + 1) + hex;
        dec = dec >> 4;
    }
 
    return hex;
}

function string_crc32(str)
{
	var table = [  ];
	var polynomial = $EDB88320;
	
	for (var i = 0; i <= $FF; i++)
	{
	    var crc = i;
		
	    repeat (8) 
		{
	        if (crc & 1)
			{
	            crc = (crc >> 1) ^ polynomial;
			}
			else
			{
	            crc = crc >> 1;
	        }
	    }
		
	    table[i] = crc;
	}
	
	var buffer = buffer_create(string_length(str), buffer_fixed, 1);
	buffer_write(buffer, buffer_text, str);
	
	var crc = $FFFFFFFF;
	for (var i = 0; i < buffer_get_size(buffer); i++) crc = table[ ( crc ^ buffer_peek( buffer, i, buffer_u8 ) ) & $FF ] ^ ( crc >> 8 );
	buffer_delete(buffer);
	return crc ^ $FFFFFFFF;
}