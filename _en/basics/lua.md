---
title: Lua Scripts
layout: default
root: ../../
idx: 1.2
description: A basic introduction to Lua, including a guide on global/local scope.
---

## Introduction

In this chapter we will talk about scripting in Lua, the tools required,
and go over some techniques which you will probably find useful.

* Tools
    * Recommended Editors
    * Integrated Programming Environments
* Coding in Lua
    * Selection
* Programming
* Local and Global
* Including other Lua Scripts

## Tools

A text editor with code highlighting is sufficient for writing scripts in Lua.
Code highlighting gives different colors to different words and characters
depending on what they mean. This allows you to spot mistakes.

{% highlight lua %}
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
{% endhighlight %}

For example, keywords in the above snippet are highlighted such as if, then, end, return.
table.insert is a function which comes with Lua by default.

### Recommended Editors

Other editors are available, of course.

* Windows: [Notepad++](http://notepad-plus-plus.org/), [Atom](http://atom.io/)
* Linux: Kate, Gedit, [Atom](http://atom.io/)
* OSX: [Atom](http://atom.io/)

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

<div class="notice">
    This section is a Work in Progress. May be unclear.
</div>

Programs are a series of commands that run one after another.
We call these commands "statements."

Program flow is important, it allows you to direct or skip over
statements. There are three main types of flow:

* Sequence: Just run one statement after another, no skipping.
* Selected: Skip over statements depending on conditions.
* Iteration: Repeating, looping. Keep running the same
  statements until a condition is met.

So, what do statements in Lua look like?

{% highlight lua %}
local a = 2     -- Set 'a' to 2
local b = 2     -- Set 'b' to 2
local result = a + b -- Set 'result' to a + b, which is 4
a = a + 10
print("Sum is "..result)
{% endhighlight %}

Woah, what happened there? a, b, and result are **variables**. They're like what
you get in mathematics, A = w * h. The equals signs are **assignments**, so
"result" is set to a + b. Variable names can be longer than one character
unlike in mathematics, as seen with the "result" variable. Lua is **case sensitive**.
A is a different variable than a.

The word "local" before they are first used means that they have local scope,
I'll discuss that shortly.

### Variable Types

| Type     | Description                                        | Example                                   |
|----------|----------------------------------------------------|-------------------------------------------|
| Integer  | Whole number                                       | local A = 4                               |
| Float    | Decimal                                            | local B = 3.2, local C = 5 / 2            |
| String   | A piece of text                                    | local D = "one two three"                 |
| Boolean  | True or False                                      | local is_true = false, local E = (1 == 1) |
| Table    | Lists                                              | Explained below                           |
| Function | Can run. May require inputs and may return a value | local result = func(1, 2, 3)              |

Not an exhaustive list. Doesn't contain every possible type.

### Arithmetic Operators

| Symbol | Purpose        | Example                   |
|--------|----------------|---------------------------|
| A + B  | Addition       | 2 + 2 = 4                 |
| A - B  | Subtraction    | 2 - 10 = -8               |
| A * B  | Multiplication | 2 * 2 = 4                 |
| A / B  | Division       | 100 / 50 = 2              |
| A ^ B  | Powers         | 2 ^ 2 = 2<sup>2</sup> = 4 |
| A .. B | Join strings   | "foo" .. "bar" = "foobar" |

A string in programming terms is a piece of text.

Not an exhaustive list. Doesn't contain every possible operator.

### Selection

The most basic selection is the if statement. It looks like this:

{% highlight lua %}
local random_number = math.random(1, 100) -- Between 1 and 100.

if random_number > 50 then
    print("Woohoo!")
else
    print("No!")
end
{% endhighlight %}

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

{% highlight lua %}
if not A and B then
    print("Yay!")
end
{% endhighlight %}

Which prints "Yay!" if A is false and B is true.

Logical and arithmetic operators work exactly the same, they both accept inputs
and return a value which can be stored.

{% highlight lua %}
local A = 5
local is_equal = (A == 5)

if is_equal then
    print("Is equal!")
end
{% endhighlight %}

## Programming

Programming is the action of talking a problem, such as sorting a list
of items, and then turning it into steps that a computer can understand.

Teaching you the logical process of programming is beyond the scope of this book;
however, the following websites are quite useful in developing this:

### Codecademy
[Codecademy](http://www.codecademy.com/) is one of the best resources for learning to 'code',
it provides an interactive tutorial experience.

### Scratch
[Scratch](https://scratch.mit.edu) is a good resource when starting from absolute basics,
learning the problem solving techniques required to program.\\
Scratch is **designed to teach children** how to program, it isn't a serious programming language.

## Local and Global

Whether a variable is local or global determines where it can be written to or read to.
A local variable is only accessible from where it is defined. Here are some examples:

{% highlight lua %}
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
{% endhighlight %}

Whereas global variables can be accessed from anywhere in the script file, and from any other mod.

{% highlight lua %}
my_global_variable = "blah"

function one()
    my_global_variable = "three"
end

print(my_global_variable) -- Output: "blah"
one()
print(my_global_variable) -- Output: "three"
{% endhighlight %}


### Locals should be used as much as possible

Lua is global by default (unlike most other programming languages).
Local variables must be identified as such.

{% highlight lua %}
function one()
    foo = "bar"
end

function two()
    print(dump(foo))  -- Output: "bar"
end

one()
two()
{% endhighlight %}

dump() is a function that can turn any variable into a string so the programmer can
see what it is. The foo variable will be printed as "bar", including the quotes
which show it is a string.

This is sloppy coding, and Minetest will in fact warn you about this:

    [WARNING] Assigment to undeclared global 'foo' inside function at init.lua:2

To correct this, use "local":

{% highlight lua %}
function one()
    local foo = "bar"
end

function two()
    print(dump(foo))  -- Output: nil
end

one()
two()
{% endhighlight %}

Nil means **not initalised**. The variable hasn't been assigned a value yet,
doesn't exist, or has been uninitialised. (ie: set to nil)

The same goes for functions. Functions are variables of a special type.
You should make functions as local as much as possible,
as other mods could have functions of the same name.

{% highlight lua %}
local function foo(bar)
    return bar * 2
end
{% endhighlight %}

If you want your functions to be accessible from other scripts or mods, it is recommended that
you add them all into a table with the same name as the mod:

{% highlight lua %}
mymod = {}

function mymod.foo(bar)
    return "foo" .. bar
end

-- In another mod, or script:
mymod.foo("foobar")
{% endhighlight %}

## Including other Lua Scripts

You can include Lua scripts from your mod or another mod like this:

{% highlight lua %}
dofile(minetest.get_modpath("modname") .. "/script.lua")
{% endhighlight %}

"local" variables declared outside of any functions in a script file will be local to that script.
You won't be able to access them from any other scripts.

As for how you divide code up into files, it doesn't matter that much.
The most important thing is that your code is easy to read and edit.
You won't need to use it for smaller projects.
