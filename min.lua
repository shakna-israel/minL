local call_table
call_table = function(value)
  if value == 0 then
    return "inc"
  elseif value == 1 then
    return "dec"
  elseif value == 2 then
    return "next"
  elseif value == 3 then
    return "prev"
  elseif value == 4 then
    return "loop"
  elseif value == 5 then
    return "endloop"
  elseif value == 6 then
    return "put"
  elseif value == 7 then
    return "get"
  else
    return "err"
  end
end
local parse
parse = function(program)
  local ast = { }
  local ptr = 0
  for chr in program:gmatch(".") do
    if chr == "," then
      if ptr == 7 then
        ptr = 0
      else
        ptr = ptr + 1
      end
    elseif chr == "." then
      ast[#ast + 1] = call_table(ptr)
    end
  end
  return ast
end
local eval
eval = function(ast, program_ptr, jump_table, stack, stack_ptr)
  if program_ptr == nil then
    program_ptr = 1
  end
  if jump_table == nil then
    jump_table = { }
  end
  if stack == nil then
    stack = { }
  end
  if stack_ptr == nil then
    stack_ptr = 1
  end
  if #stack == 0 then
    for i = 1, 255 do
      stack[i] = 0
    end
  end
  while program_ptr <= #ast do
    local com = ast[program_ptr]
    if com ~= nil then
      if stack_ptr > 255 then
        stack_ptr = 0
      elseif stack_ptr < 0 then
        stack_ptr = 255
      end
      if stack[stack_ptr] > 255 then
        stack[stack_ptr] = 0
      elseif stack[stack_ptr] < 0 then
        stack[stack_ptr] = 255
      end
      if com == "inc" then
        stack[stack_ptr] = stack[stack_ptr] + 1
        program_ptr = program_ptr + 1
      elseif com == "dec" then
        stack[stack_ptr] = stack[stack_ptr] - 1
        program_ptr = program_ptr + 1
      elseif com == "next" then
        stack_ptr = stack_ptr + 1
        program_ptr = program_ptr + 1
      elseif com == "prev" then
        stack_ptr = stack_ptr - 1
        program_ptr = program_ptr + 1
      elseif com == "loop" then
        jump_table[#jump_table + 1] = program_ptr
        program_ptr = program_ptr + 1
      elseif com == "endloop" then
        if stack[stack_ptr] == 0 then
          table.remove(jump_table, #jump_table)
          program_ptr = program_ptr + 1
        else
          program_ptr = jump_table[#jump_table]
        end
      elseif com == "put" then
        io.write(string.char(stack[stack_ptr]))
        io.flush()
        program_ptr = program_ptr + 1
      elseif com == "get" then
        stack[stack_ptr] = string.byte(io.read(1))
        program_ptr = program_ptr + 1
      end
    end
  end
  return {
    ast = ast,
    program_ptr = program_ptr,
    jump_table = jump_table,
    stack = stack,
    stack_ptr = stack_ptr
  }
end
if arg[1] == "--file" then
  local f = io.open(arg[2], "r")
  if f then
    local program = f:read()
    f:close()
    return eval(parse(program))
  else
    return print("Could not open file.")
  end
elseif arg[1] == "-" then
  local program = io.read()
  local data = eval(parse(program))
  while true do
    data = eval(data["ast"], data["program_ptr"], data["jump_table"], data["stack"], data["stack_ptr"])
  end
else
  local program = io.read()
  local data = eval(parse(program))
  while true do
    data = eval(data["ast"], data["program_ptr"], data["jump_table"], data["stack"], data["stack_ptr"])
  end
end
