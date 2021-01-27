---
title: Lua Scripting
layout: default
root: ../..
idx: 1.2
description: A basic introduction to Lua, including a guide on global/local scope.
redirect_from: /en/chapters/lua.html
---

## Introduction  <!-- omit in toc -->

In this chapter we'll talk about scripting in Lua, the tools required
to assist with this, and some techniques which you may find useful.

- [Code Editors](#code-editors)
- [Coding in Lua](#coding-in-lua)
  - [Program Flow](#program-flow)
  - [Variable Types](#variable-types)
  - [Arithmetic Operators](#arithmetic-operators)
  - [Selection](#selection)
  - [Logical Operators](#logical-operators)
- [Programming](#programming)
- [Local and Global Scope](#local-and-global-scope)
  - [Locals should be used as much as possible](#locals-should-be-used-as-much-as-possible)
- [Including other Lua Scripts](#including-other-lua-scripts)

## Code Editors

A code editor with code highlighting is sufficient for writing scripts in Lua.
Code highlighting uses different colours for words and characters
depending on what they represent. This allows you to easily notice
mistakes and inconsistencies.

For example:

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

Keywords in this example are highlighted, including `if`, `then`, `end`, and `return`.
Functions which come with Lua by default, such as `table.insert`, are also highlighted.

Commonly used editors which are well-suited for Lua include:

* [VSCode](https://code.visualstudio.com/) -
    open source (as Code-OSS or VSCodium), popular, and has
    [plugins for Minetest modding](https://marketplace.visualstudio.com/items?itemName=GreenXenith.minetest-tools).
* [Notepad++](http://notepad-plus-plus.org/) - Windows-only
* [Atom](http://atom.io/)

Other suitable editors are also available.

## Coding in Lua

### Program Flow

Programs are a series of commands that run one after another. We call these
commands "statements." Program flow is how these statements are executed, and
different types of flow allow you to skip or jump over sets of commands.

There are three main types of flow:

* Sequence: runs one statement after another, with no skipping.
* Selection: skips over sequences depending on conditions.
* Iteration: repeats the same statements until a condition is met.

So, what do statements in Lua look like?

```lua
local a = 2     -- Set 'a' to 2
local b = 2     -- Set 'b' to 2
local result = a + b -- Set 'result' to a + b, which is 4
a = a + 10
print("Sum is "..result)
```

In this example, `a`, `b`, and `result` are *variables*. Local variables are
declared by using the `local` keyword, and then given an initial value. Local
will be discussed later, because it's part of a very important concept called
*scope*.

The `=` sign means *assignment*, so `result = a + b` means set the value of
`result` to the value of `a + b`. Variable names can be longer than one
character, as seen with the `result` variable. It's also worth noting that, like
most languages, Lua is *case-sensitive*; `A` is a different variable to `a`.


### Variable Types

A variable will be only one of the following types and can change type after an
assignment.
It's good practice to make sure a variable is only ever nil or a single non-nil type.

| Type     | Description                     | Example        |
|----------|---------------------------------|----------------|
| Nil      | Not initialised. The variable is empty, it has no value | `local A`, `D = nil` |
| Number   | A whole or decimal number.  | `local A = 4` |
| String   | A piece of text.  | `local D = "one two three"` |
| Boolean  | True or False.    | `local is_true = false`, `local E = (1 == 1)` |
| Table    | Lists. | Explained below. |
| Function | Can run. May require inputs and may return a value. | `local result = func(1, 2, 3)` |

### Arithmetic Operators

Operators in Lua include:

| Symbol | Purpose        | Example                   |
|--------|----------------|---------------------------|
| A + B  | Addition       | 2 + 2 = 4                 |
| A - B  | Subtraction    | 2 - 10 = -8               |
| A * B  | Multiplication | 2 * 2 = 4                 |
| A / B  | Division       | 100 / 50 = 2              |
| A ^ B  | Powers         | 2 ^ 2 = 2<sup>2</sup> = 4 |
| A .. B | Join strings   | "foo" .. "bar" = "foobar" |

Please note that this is not an exhaustive list; it doesn't contain every
possible operator.

### Selection

The most basic method of selection is the if statement. For example:

```lua
local random_number = math.random(1, 100) -- Between 1 and 100.
if random_number > 50 then
    print("Woohoo!")
else
    print("No!")
end
```

This generates a random number between 1 and 100. It then prints "Woohoo!" if
that number is bigger than 50, and otherwise prints "No!".


### Logical Operators

Logical operators in Lua include:

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

Please note that this doesn't contain every possible operator.

It is also possible to combine operators. For example:

```lua
if not A and B then
    print("Yay!")
end
```

This prints "Yay!" if A is false and B is true.

Logical and arithmetic operators work the same way; they both accept inputs and
return a value which can be stored. For example:

```lua
local A = 5
local is_equal = (A == 5)
if is_equal then
    print("Is equal!")
end
```

## Programming

Programming is the action of taking a problem, such as sorting a list
of items, and turning it into steps that a computer can understand.

Teaching you the logical process of programming is beyond the scope of this book;
however, the following websites are quite useful in developing this:

* [Codecademy](http://www.codecademy.com/) is one of the best resources for
  learning to write code. It provides an interactive tutorial experience.
* [Scratch](https://scratch.mit.edu) is a good resource for starting from
  absolute basics, and learning the problem-solving techniques required to program.\\
  Scratch is *designed to teach children* how to program and isn't a serious
  programming language.

## Local and Global Scope

Whether a variable is local or global determines where it can be written to or
read from. A local variable is only accessible from where it is defined. Here
are some examples:

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

In contrast, global variables can be accessed from anywhere in the script file, and
from any other mod.

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

Local variables should be used whenever possible. Mods should only create one
global at most, with the same name as the mod. Creating other globals is sloppy
coding, and Minetest will warn about this:

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

Remember that nil means **not initialised**. The variable hasn't been assigned a
value yet, doesn't exist, or has been uninitialised (meaning set to nil).

Functions are variables of a special type, but should also be made local,
because other mods could have functions with the same names.

```lua
local function foo(bar)
    return bar * 2
end
```

To allow mods to call your functions, you should create a table with the same
name as the mod and add your function to it. This table is often called an API
table or namespace.

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

A script can return a value, which is useful for sharing private locals:

```lua
-- script.lua
return "Hello world!"

-- init.lua
local ret = dofile(minetest.get_modpath("modname") .. "/script.lua")
print(ret) -- Hello world!
```

[Later chapters](../quality/clean_arch.html) will discuss how best to split up
code for a mod.
