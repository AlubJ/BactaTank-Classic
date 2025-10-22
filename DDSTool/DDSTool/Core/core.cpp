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

// Includes
#include "core.h"

// HRESULT to string
std::string HrToString(HRESULT hr)
{
	char* msgBuf = nullptr;

	DWORD size = FormatMessageA(
		FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
		nullptr,
		hr,
		MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
		(LPSTR)&msgBuf,
		0,
		nullptr);

	std::string message;

	if (size && msgBuf)
	{
		message.assign(msgBuf, size);
		LocalFree(msgBuf);
	}
	else
	{
		message = "Unknown error (HRESULT = 0x" + std::to_string((unsigned long)hr) + ")";
	}

	return message;
}