---
title: Lua Scripting
layout: default
root: ../..
idx: 1.2
description: A basic introduction to Lua, including a guide on global/local scope.
redirect_from: /en/chapters/lua.html
---

## Introduction

In this chapter we will talk about scripting in Lua, the tools required,
and go over some techniques which you will probably find useful.

* [Code Editors](#code-editors)
    * [Integrated Programming Environments](#integrated-programming-environments)
* [Coding in Lua](#coding-in-lua)
    * [Program Flow](#program-flow)
    * [Variable Types](#variable-types)
    * [Arithmetic Operators](#arithmetic-operators)
    * [Selection](#selection)
    * [Logical Operators](#logical-operators)
* [Programming](#programming)
* [Local and Global Scope](#local-and-global-scope)
* [Including other Lua Scripts](#including-other-lua-scripts)

## Code Editors

A code editor with code highlighting is sufficient for writing scripts in Lua.
Code highlighting gives different colours to different words and characters
depending on what they mean. This allows you to spot mistakes.

```lua
function ctf.post(team,msg)
    if not ctf.team(team) then
        return false
    end
    if not ctf.team(team).log then
        ctf.team(team).log = {}
    end

    table.insert(ctf.team(team).log,1,msg)
    ctf.save()

    return true
end
```

For example, keywords in the above snippet are highlighted such as if, then, end, return.
table.insert is a function which comes with Lua by default.

Here is a list of common editors well suited for Lua.
Other editors are available, of course.

* Windows: [Notepad++](http://notepad-plus-plus.org/), [Atom](http://atom.io/), [VS Code](https://code.visualstudio.com/)
* Linux: Kate, Gedit, [Atom](http://atom.io/), [VS Code](https://code.visualstudio.com/)
* OSX: [Atom](http://atom.io/), [VS Code](https://code.visualstudio.com/)

### Integrated Programming Environments

IDEs allow you to debug code like a native application.
These are harder to set up than just a text editor.

One such IDE is Eclipse with the Koneki Lua plugin:

* Install Eclipse + Koneki.
* Create a new Lua project from existing source (specify Minetest's base directory).
* Follow instructions from Koneki wiki how to do "Attach to remote Application" debugging (just a few steps).
* It is suggested to add those lines from wiki at beginning of builtin.lua.
* Start the debugger (set "Break on first line" in debugger configuration to see if it is working).
* Start Minetest.
* Enter the game to startup Lua.

## Coding in Lua

### Program Flow

Programs are a series of commands that run one after another.
We call these commands "statements."
Program flow is how these statements are executed.
Different types of flow allow you to skip or jump over sets of commands.
There are three main types of flow:

* Sequence: Just run one statement after another, no skipping.
* Selection: Skip over sequences depending on conditions.
* Iteration: Repeating, looping. Keep running the same
  statements until a condition is met.

So, what do statements in Lua look like?

```lua
local a = 2     -- Set 'a' to 2
local b = 2     -- Set 'b' to 2
local result = a + b -- Set 'result' to a + b, which is 4
a = a + 10
print("Sum is "..result)
```

Whoa, what happened there?

a, b, and result are *variables*. Local variables are declared
by using the local keyword, and then given an initial value.
Local will be discussed in a bit, as it's part of a very important concept called
*scope*.

The `=` means *assignment*, so `result = a + b` means set "result" to a + b.
Variable names can be longer than one character unlike in mathematics, as seen with the "result" variable.
It's also worth noting that Lua is *case-sensitive*; A is a different variable than a.

### Variable Types

A variable will be only one of the following types and can change type after an
assignment.
It's good practice to make sure a variable is only ever nil or a single non-nil type.

| Type     | Description                     | Example        |
|----------|---------------------------------|----------------|
| Nil      | Not initialised. The variable is empty, it has no value | `local A`, `D = nil` |
| Number   | A whole or decimal number.  | `local A = 4` |
| String   | A piece of text  | `local D = "one two three"` |
| Boolean  | True or False    | `local is_true = false`, `local E = (1 == 1)` |
| Table    | Lists | Explained below |
| Function | Can run. May require inputs and may return a value | `local result = func(1, 2, 3)` |

### Arithmetic Operators

Not an exhaustive list. Doesn't contain every possible operator.

| Symbol | Purpose        | Example                   |
|--------|----------------|---------------------------|
| A + B  | Addition       | 2 + 2 = 4                 |
| A - B  | Subtraction    | 2 - 10 = -8               |
| A * B  | Multiplication | 2 * 2 = 4                 |
| A / B  | Division       | 100 / 50 = 2              |
| A ^ B  | Powers         | 2 ^ 2 = 2<sup>2</sup> = 4 |
| A .. B | Join strings   | "foo" .. "bar" = "foobar" |

### Selection

The most basic selection is the if statement. It looks like this:

```lua
local random_number = math.random(1, 100) -- Between 1 and 100.
if random_number > 50 then
    print("Woohoo!")
else
    print("No!")
end
```

That example generates a random number between 1 and 100. It then prints
"Woohoo!" if that number is bigger than 50, otherwise it prints "No!".
What else can you get apart from '>'?

### Logical Operators

| Symbol  | Purpose                              | Example                                                     |
|---------|--------------------------------------|-------------------------------------------------------------|
| A == B  | Equals                               | 1 == 1 (true), 1 == 2 (false)                               |
| A ~= B  | Doesn't equal                        | 1 ~= 1 (false), 1 ~= 2 (true)                               |
| A > B   | Greater than                         | 5 > 2 (true), 1 > 2 (false), 1 > 1 (false)                  |
| A < B   | Less than                            | 1 < 3 (true), 3 < 1 (false), 1 < 1 (false)                  |
| A >= B  | Greater than or equals               | 5 >= 5 (true), 5 >= 3 (true), 5 >= 6 (false)                |
| A <= B  | Less than or equals                  | 3 <= 6 (true), 3 <= 3 (true)                                |
| A and B | And (both must be correct)           | (2 > 1) and (1 == 1)  (true), (2 > 3) and (1 == 1)  (false) |
| A or B  | either or. One or both must be true. | (2 > 1) or (1 == 2) (true), (2 > 4) or (1 == 3) (false)     |
| not A   | not true                             | not (1 == 2)  (true), not (1 == 1)  (false)                 |

That doesn't contain every possible operator, and you can combine operators like this:

```lua
if not A and B then
    print("Yay!")
end
```

Which prints "Yay!" if A is false and B is true.

Logical and arithmetic operators work exactly the same, they both accept inputs
and return a value which can be stored.

```lua
local A = 5
local is_equal = (A == 5)
if is_equal then
    print("Is equal!")
end
```

## Programming

Programming is the action of talking a problem, such as sorting a list
of items, and then turning it into steps that a computer can understand.

Teaching you the logical process of programming is beyond the scope of this book;
however, the following websites are quite useful in developing this:

* [Codecademy](http://www.codecademy.com/) is one of the best resources for
  learning to 'code', it provides an interactive tutorial experience.
* [Scratch](https://scratch.mit.edu) is a good resource when starting from
  absolute basics, learning the problem solving techniques required to program.\\
  Scratch is **designed to teach children** how to program, it isn't a serious
  programming language.

## Local and Global Scope

Whether a variable is local or global determines where it can be written to or read to.
A local variable is only accessible from where it is defined. Here are some examples:

```lua
-- Accessible from within this script file
local one = 1

function myfunc()
    -- Accessible from within this function
    local two = one + one

    if two == one then
        -- Accessible from within this if statement
        local three = one + two
    end
end
```

Whereas global variables can be accessed from anywhere in the script file, and from any other mod.

```lua
my_global_variable = "blah"

function one()
    my_global_variable = "three"
end

print(my_global_variable) -- Output: "blah"
one()
print(my_global_variable) -- Output: "three"
```


### Locals should be used as much as possible

Lua is global by default (unlike most other programming languages).
Local variables must be identified as such.

```lua
function one()
    foo = "bar"
end

function two()
    print(dump(foo))  -- Output: "bar"
end

one()
two()
```

dump() is a function that can turn any variable into a string so the programmer can
see what it is. The foo variable will be printed as "bar", including the quotes
which show it is a string.

This is sloppy coding, and Minetest will in fact warn about this:

    Assignment to undeclared global 'foo' inside function at init.lua:2

To correct this, use "local":

```lua
function one()
    local foo = "bar"
end

function two()
    print(dump(foo))  -- Output: nil
end

one()
two()
```

Remember that nil means **not initialised**.
The variable hasn't been assigned a value yet,
doesn't exist, or has been uninitialised (ie: set to nil).

The same goes for functions. Functions are variables of a special type, and
should be made local, as other mods could have functions of the same name.

```lua
local function foo(bar)
    return bar * 2
end
```

API tables should be used to allow other mods to call the functions, like so:

```lua
mymod = {}

function mymod.foo(bar)
    return "foo" .. bar
end

-- In another mod, or script:
mymod.foo("foobar")
```

## Including other Lua Scripts

The recommended way to include other Lua scripts in a mod is to use *dofile*.

```lua
dofile(minetest.get_modpath("modname") .. "/script.lua")
```

"local" variables declared outside of any functions in a script file will be local to that script.
A script can return a value, which is useful for sharing private locals:

```lua
-- script.lua
return "Hello world!"

-- init.lua
local ret = dofile(minetest.get_modpath("modname") .. "/script.lua")
print(ret) -- Hello world!
```

Later chapters will discuss how to split up the code of a mod in a lot of detail.
However, the simplistic approach for now is to have different files for different
types of things - nodes.lua, crafts.lua, craftitems.lua, etc.
