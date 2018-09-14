---
title: Automatic Unit Testing
layout: default
root: ../..
idx: 7.4
---

## Introduction

Unit tests are an essential tool in proving and reassuring yourself that your code
is correct. This chapter will show you how to write tests for Minetest mods and
games using busted. Writing unit tests for functions where you call Minetest
functions is quite difficult, but luckily [in the previous chapter](clean_arch.html)
 we discussed how to make your code avoid this.

* [Installing Busted](#installing-busted)
* [Your First Test](#your-first-test)
* [Mocking: Using External Functions](#mocking-using-external-functions)
* [Checking Commits with Travis](#checking-commits-with-travis)
* [Conclusion](#conclusion)

## Installing Busted

First you'll need to install LuaRocks.

* Windows: Follow the [installation instructions on LuaRock's wiki](https://github.com/luarocks/luarocks/wiki/Installation-instructions-for-Windows).
* Debian/Ubuntu Linux: `sudo apt install luarocks`

Next you should then install Busted globally:

    sudo luarocks install busted

Finally, check that it is installed:

    busted --version


## Your First Test

Busted is Lua's leading unit test framework. Busted looks for Lua files with
names ending in `_spec`, and then executes them in a standalone Lua environment.

    mymod/
    ├── init.lua
    ├── api.lua
    └── tests
        └── api_spec.lua


### init.lua

{% highlight lua %}
mymod = {}

dofile(minetest.get_modpath("mymod") .. "/api.lua")
{% endhighlight %}



### api.lua

{% highlight lua %}
function mymod.add(x, y)
    return x + y
end
{% endhighlight %}

### tests/api_spec.lua

{% highlight lua %}
-- Look for required things in
package.path = "../?.lua;" .. package.path

-- Set mymod global for API to write into
_G.mymod = {} --_
-- Run api.lua file
require("api")

-- Tests
describe("add", function()
    it("adds", function()
        assert.equals(2, mymod.add(1, 1))
    end)

    it("supports negatives", function()
        assert.equals(0,  mymod.add(-1,  1))    
        assert.equals(-2, mymod.add(-1, -1))
    end)
end)
{% endhighlight %}

You can now run the tests by opening a terminal in the mod's directory and
running `busted .`

It's important that the API file doesn't create the table itself, as globals in
Busted work differently. Any variable which would be global in Minetest is instead
a file local in busted. This would have been a better way for Minetest to do things,
but it's too late for that now.

Another thing to note is that any files you're testing should avoid calls to any
functions not inside of it. You tend to only write tests for a single file at once.


## Mocking: Using External Functions

Mocking is the practice of replacing functions that the thing you're testing depends
on. This can have two purposes - firstly, the function may not be available in the
test environment. Secondly, you may want to capture calls to the function and any
passed arguments.

If you follow the advice in the [Clean Architectures](clean_arch.html) chapter,
you'll already have a pretty clean file to test. You will still have to mock
things not in your area however - for example, you'll have to mock the view when
testing the controller/API. If you didn't follow the advice, then things are a
little harder as you may have to mock the Minetest API.

{% highlight lua %}
-- As above, make a table
_G.minetest = {}

-- Define the mock function
local chat_send_all_calls = {}
function minetest.chat_send_all(name, message)
    table.insert(chat_send_all_calls, { name = name, message = message })
end

-- Tests
describe("list_areas", function()
    it("returns a line for each area", function()
        chat_send_all_calls = {} -- reset table

        mymod.list_areas_to_chat("singleplayer", "singleplayer")

        assert.equals(2, #chat_send_all_calls)
    end)

    it("sends to right player", function()
        chat_send_all_calls = {} -- reset table

        mymod.list_areas_to_chat("singleplayer", "singleplayer")

        for _, call in pairs(chat_send_all_calls) do --_
            assert.equals("singleplayer", call.name)
        end
    end)

    -- The above two tests are actually pointless, as this one tests both things
    it("returns correct thing", function()
        chat_send_all_calls = {} -- reset table

        mymod.list_areas_to_chat("singleplayer", "singleplayer")

        local expected = {
            { name = "singleplayer", message = "Town Hall (2,43,63)" },
            { name = "singleplayer", message = "Airport (43,45,63)" },
        }
        assert.same(expected, chat_send_all_calls)
    end)
end)
{% endhighlight %}


## Checking Commits with Travis

The Travis script from the [Error Checking](luacheck.html)
chapter can be modified to also run Busted.

{% highlight yml %}
language: generic
sudo: false
addons:
  apt:
    packages:
    - luarocks
before_install:
  - luarocks install --local luacheck && luarocks install --local busted
script:
- $HOME/.luarocks/bin/luacheck --no-color .
- $HOME/.luarocks/bin/busted .
notifications:
  email: false
{% endhighlight %}


## Conclusion

Unit tests will greatly increase the quality and reliability of your project if used
well, but they require you to structure your code in a different way than usual.

For an example of a mod with lots of unit tests, see
[crafting by rubenwardy](https://github.com/rubenwardy/crafting).
