# minL

Am estoric programming language with an absolutely tiny syntax.

---

## Hello, World!

Currently under development.

---

## Running

You need a version of Lua that is at least compatible with v5.1.

    lua min.lua --file MYFILE
    
Or to enter a REPL, if you're feeling sadistic:

    lua min.lua -
    
If you provide no arguments, it will also enter the REPL.

---

## Syntax

minL has two operators, and a function call table.

    .

The dot operator calls a function from the call table, based on the table pointer.

    ,
    
The comma operator increments the table pointer. When the table pointer reaches it's maximum value, and is incremented, it returns to it's initial value.

Any other character is simply ignored by the program.

---

## Standard Library

The functions called, correspond to a simple stack machine.

There is a tape of 255 cells, which can each contain a value of 0 to 255.

If the table pointer is 0, and a function is called via the dot operator, it increments the value of the current cell being pointed to on the tape. If the cell already contains a value of 255, it becomes a value of 0.

If the table pointer is 1, and a function is called via the dot operator, it decrements the value of the current cell being pointed to on the tape. If the cell already contains a value of 0, it becomes a value of 255.

If the table pointer is 2, and a function is called via the dot operator, then the next cell is selected. If the selected cell was already the last on the tape, the first cell becomes selected.

If the table pointer is 3, and a function is called via the dot operator, then the previous cell is selected. If the selected cell was already the first on the tape, the last cell becomes selected.

If the table pointer is 4, and a function is called via the dot operator, a loop jump point is set.

If the table pointer is 5, and a function is called via the dot operator, and the current cell does not have a value of 0, then the program jumps execution to the last loop jump point that was set, and that jump point is removed.

If the table pointer is 6, and a function is called via the dot operator, then the current cell's value is converted to it's ASCII representation and outputted directly to the standard output, without any other output.

If the table pointer is 7, and a function is called via the dot operator, then the program asks for user input from the keyboard, and takes the first given key and converts it from the ASCII representation to a single byte, and replaces the current cell value with that byte value.

---

## License

See  the [LICENSE](LICENSE) file.

---

## Contributing

The min.lua file is ignored, and shouldn't be changed.

Rather, develop on the min.moon file, written in [Moonscript](https://moonscript.org/).
