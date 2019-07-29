
type t_Variable
	name as string
	_type as string
	scope as string
	
	int_val as integer
	float_val as float
	str_val as string
endtype


type t_Function
	name as string
	variables as t_Variable[]
endtype


type t_Class
	name as string
	variables as t_Variable[]
	functions as t_Function[]
endtype





function Variable(_name$, _type$, _scope$)
	_nv as t_Variable
	_nv.name = _name$
	_nv._type = _type$
	_nv.scope = _scope$
endfunction _nv


function ExtractVariable(_line$)
	_nv as t_Variable
	_islands as string[]
	_backup as string[]
	for i = 1 to CountStringTokens(_line$, CHR_SPACE + CHR_TAB)
		_islands.insert(GetStringToken(_line$, CHR_SPACE + CHR_TAB, i))
	next i
	_backup = _islands
	
	if CompareString(_islands[0], "global")
		_nv.scope = "global"
		_islands.remove(0)
	elseif CompareString(_islands[0], "local")
		_nv.scope = "local"
		_islands.remove(0)
	else
		_nv.scope = "local"
	endif
	
	_nv.name = _islands[0]
	_islands.remove(0)
	
	if CompareString(_islands[0], "as")
		_islands.remove(0)
		
		if CompareString(_islands[0], "integer")
			_nv._type = "integer"
			
		elseif CompareString(_islands[0], "float")
			_nv._type = "float"
			
		elseif CompareString(_islands[0], "string")
			_nv._type = "string"
		endif
		
		_islands.remove(0)
		
		if CompareString(_islands[0], "=")
			_islands.remove(0)
			select _nv._type
				case "integer":
					_nv.int_val = val(_islands[0])
				endcase
				
				case "float":
					_nv.float_val = ValFloat(_islands[0])
				endcase
				
				case "string":
					_nv.str_val = GetQuoteString(_line$)
				endcase
			endselect
			_islands.remove(0)
		endif
		
	elseif CompareString(_islands[0], "=")
		_islands.remove(0)
		
		if FindString(_nv.name, "#")
			_nv._type = "float"
			_nv.name = left(_nv.name, len(_nv.name) - 1)
			
		elseif FindString(_nv.name, "$")
			_nv._type = "string"
			_nv.name = left(_nv.name, len(_nv.name) - 1)
			
		else
			_nv._type = "integer"
		endif
		
		select _nv._type
			case "integer":
				_nv.int_val = val(_islands[0])
			endcase
			
			case "float":
				_nv.float_val = ValFloat(_islands[0])
			endcase
			
			case "string":
				_nv.str_val = GetQuoteString(_line$)
			endcase
		endselect
		
	endif
	
	
//~	do
//~		Print(_line$)
//~		Print("")
//~		Print("")
//~		for i = 0 to _islands.length
//~			PrintC(_islands[i])
//~			if i < _islands.length then PrintC("-")
//~		next i
//~		Print("")
//~		Print("")
//~		for i = 0 to _backup.length
//~			PrintC(_backup[i])
//~			if i < _backup.length then PrintC("-")
//~		next i
//~		Print("")
//~		Print("")
//~		PrintC("Name: ") : Print(_nv.name)
//~		PrintC("Type: ") : Print(_nv._type)
//~		PrintC("Scope: ") : Print(_nv.scope)
//~		
//~		PrintC("Int: ") : Print(_nv.int_val)
//~		PrintC("Float: ") : Print(_nv.float_val)
//~		PrintC("Str: ") : Print(_nv.str_val)
//~		sync()
//~	loop
endfunction _nv




function ConvertToClass(_arr ref as string[])
	_nc as t_Class
	for i = 0 to _arr.length - 1
		if FindString(_arr[i], "type")
			for j = i to _arr.length - 1
				if FindString(_arr[j], "endtype") then exit
			next j
			
			
		endif
		
	next i
endfunction