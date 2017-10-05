call_table = (value) ->
  if value == 0
    "inc"
  elseif value == 1
    "dec"
  elseif value == 2
    "next"
  elseif value == 3
    "prev"
  elseif value == 4
    "loop"
  elseif value == 5
    "endloop"
  elseif value == 6
    "put"
  elseif value == 7
    "get"
  else
    "err" -- This should never happen.

parse = (program) ->
  ast = {}
  ptr = 0
  for chr in program\gmatch "."
    if chr == ","
      if ptr == 7
        ptr = 0
      else
        ptr = ptr + 1
    elseif chr == "."
      ast[#ast + 1] = call_table ptr
  ast

eval = (ast, program_ptr=1, jump_table={}, stack={}, stack_ptr=1) ->
  if #stack == 0
    for i=1, 255
      stack[i] = 0
  
  -- Continue till program ends
  while program_ptr <= #ast
    com = ast[program_ptr]
    
    -- Validate
    if com != nil
      if stack_ptr > 255
        stack_ptr = 0
      elseif stack_ptr < 0
        stack_ptr = 255
      if stack[stack_ptr] > 255
        stack[stack_ptr] = 0
      elseif stack[stack_ptr] < 0
        stack[stack_ptr] = 255

      -- Interpret
      if com == "inc"
        stack[stack_ptr] = stack[stack_ptr] + 1
        program_ptr = program_ptr + 1
      elseif com == "dec"
        stack[stack_ptr] = stack[stack_ptr] - 1
        program_ptr = program_ptr + 1
      elseif com == "next"
        stack_ptr = stack_ptr + 1
        program_ptr = program_ptr + 1
      elseif com == "prev"
        stack_ptr = stack_ptr - 1
        program_ptr = program_ptr + 1
      elseif com == "loop"
        jump_table[#jump_table + 1] = program_ptr
        program_ptr = program_ptr + 1
      elseif com == "endloop"
        if stack[stack_ptr] == 0
          table.remove(jump_table, #jump_table)
          program_ptr = program_ptr + 1
        else
          program_ptr = jump_table[#jump_table]
      elseif com == "put"
        io.write(string.char(stack[stack_ptr]))
        io.flush!
        program_ptr = program_ptr + 1
      elseif com == "get"
        stack[stack_ptr] = string.byte(io.read(1))
        program_ptr = program_ptr + 1
  {:ast, :program_ptr, :jump_table, :stack, :stack_ptr}
        
if arg[1] == "--file"
  f = io.open(arg[2], "r")
  if f
    program = f\read!
    f\close!
    eval(parse(program))
  else
    print "Could not open file."
elseif arg[1] == "-"
  program = io.read!
  data = eval(parse(program))
  while true
    data = eval(data["ast"], data["program_ptr"], data["jump_table"], data["stack"], data["stack_ptr"])
    
else
  program = io.read!
  data = eval(parse(program))
  while true
    data = eval(data["ast"], data["program_ptr"], data["jump_table"], data["stack"], data["stack_ptr"])
