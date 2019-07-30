// Project: TierConverter
// Created: 19-07-23

#include "source/tier_1_parser.agc"

#constant CHR_TAB chr(9)
#constant CHR_SPACE chr(32)
#constant CHR_QUOTE chr(34)

#constant FALSE 0
#constant TRUE 1

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle("TierConverter")
SetWindowSize(1024, 768, 0)
SetWindowAllowResize(1) // allow the user to resize the window

// set display properties
SetVirtualResolution(1024, 768) // doesn't have to match the window
SetOrientationAllowed(1, 1, 1, 1) // allow both portrait and landscape on mobile devices
SetSyncRate(30, 0) // 30fps instead of 60 to save battery
SetScissor(0, 0, 0, 0) // use the maximum available screen space, no black borders
UseNewDefaultFonts(1)

// set print properties
SetPrintColor(255, 255, 0)
SetPrintSize(26)
//~SetPrintSize(11)


global arr as string[]

ParseTier1("example_code/mainMenu.agc", arr)

//~ExtractVariable("cuntVariable = 123")
//~ExtractVariable("cuntVariable# = 123.321")
//~ExtractVariable("cuntVariable$ = " + CHR_QUOTE + "123 Big ol buttholes me boi" + CHR_QUOTE)

//~ExtractVariable("cuntVariable as integer = 123")
//~ExtractVariable("cuntVariable as float = 123.321")
ExtractVariable("cuntVariable as string = " + CHR_QUOTE + "123 Big ol buttholes me boi" + CHR_QUOTE)

//~ExtractVariable("cuntVariable=123")
//~ExtractVariable("cuntVariable#=123.321")
//~ExtractVariable("cuntVariable$=" + CHR_QUOTE + "123 Big ol buttholes me boi" + CHR_QUOTE)

//~ExtractVariable("global cuntVariable=123")
//~ExtractVariable("global cuntVariable#=123.321")
//~ExtractVariable("global cuntVariable$=" + CHR_QUOTE + "123 Big ol buttholes me boi" + CHR_QUOTE)

do
	Print(ScreenFPS())
	Print(arr.length)
	PrintC("space: ") : Print(asc(" "))
	PrintC("tab: ") : Print(asc("	"))
	
	if arr.length >= 0
		for i = 0 to arr.length - 1
			print(arr[i])
		next i
	endif
	
	Sync()
loop





// Dump all code text into a string array by line.
// Then parse the array for code syntax.
function ParseTier1(_file$, _arr ref as string[])
	if GetFileExists(_file$) = 0 then exitfunction
	
	f = OpenToRead(_file$)
	
	while FileEOF(f) = 0
		_commentBlock = 0
		
		_line$ = ReadLine(f)
		
		
		if FindString(_line$, "remstart ") // Comment block skipping.
			_commentBlock = 1
			
		elseif FindString(_line$, "/*") // Comment block skipping.
			_commentBlock = 2
			
		elseif FindString(_line$, "rem ") // Comment skipping.
			_ts$ = GetString(_line$, "rem ")
			if len(_ts$) > 0 then _arr.insert(_ts$)
			continue
			
		elseif FindString(_line$, "//") // Comment skipping.
			_ts$ = GetString(_line$, "//")
			if OnlySpaces(_ts$) then continue
			if len(_ts$) > 0 then _arr.insert(_ts$)
			continue
			
		elseif len(_line$) < 3
			continue
		endif
		
		// Comment block skipping.
		if _commentBlock
			_go = 1
			while _go
				if FileEOF(f)
					CloseFile(f)
					exitfunction
				endif
				
				_line$ = ReadLine(f)
				if _commentBlock = 1
					if FindString(_line$, "remend ")
						_go = 0
						_commentBlock = -1
					endif
				elseif _commentBlock = 2
					if FindString(_line$, "*/")
						_go = 0
						_commentBlock = -1
					endif
				endif
			endwhile
		endif
		
		if _commentBlock = -1 then continue
		
		_arr.insert(_line$)
	endwhile
	CloseFile(f)
endfunction




// Returns the left most string up to the first occurence of the delimiter.
function GetString(_str$, _delimiter$)
	for i = 1 to len(_str$)
		if CompareString(mid(_str$, i, len(_delimiter$)), _delimiter$)
			exitfunction left(_str$, i - 1)
		endif
	next i
endfunction ""


// Returns true if the string contains only spaces or tabs, false if anything other than spaces or tabs are present.
function OnlySpaces(_str$)
	_count = 0
	for i = 1 to len(_str$)
		if CompareString(mid(_str$, i, 1), CHR_SPACE) or CompareString(mid(_str$, i, 1), CHR_TAB) then inc _count
	next i
	if _count = len(_str$) and _count > 0 and len(_str$) > 0 then exitfunction TRUE
endfunction FALSE


// Returns the quote string from the line of code.
// Ex: myString$ = "A new string."
// Returns -> A new string.
function GetQuoteString(_line$)
	_ret$ = ""
	_toCopy = FALSE
	for i = 1 to len(_line$)
		_chr$ = mid(_line$, i, 1)
		if _toCopy
			if CompareString(_chr$, CHR_QUOTE) then exit
			_ret$ = _ret$ + _chr$
			continue
		endif
		if CompareString(_chr$, CHR_QUOTE) then _toCopy = TRUE
	next i
endfunction _ret$


