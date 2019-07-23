// Project: TierConverter
// Created: 19-07-23

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
SetPrintSize(10)


global arr as string[]

ParseTier1("mainMenu.agc", arr)

do
	Print(ScreenFPS())
	Print(arr.length)
	
	if arr.length >= 0
		for i = 0 to arr.length - 1
			print(arr[i])
		next i
	endif
	
	Sync()
loop





// Dump all code text into an array by line.
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
			_ts$ = GetStringToken2(_line$, "rem ", 1)
			if len(_ts$) > 0 then _arr.insert(_ts$)
			continue
			
		elseif FindString(_line$, "//") // Comment skipping.
			_ts$ = GetStringToken2(_line$, "//", 1)
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


