---
title: Automatic Error Checking
layout: default
root: ../..
idx: 6.2
description: Use LuaCheck to find errors
redirect_from: /en/chapters/luacheck.html
---

## Introduction

In this chapter you will learn how to use a tool called LuaCheck to automatically
scan your mod for any mistakes. This tool can be used in combination with your
editor to provide alerts to any mistakes.

* [Installing LuaCheck](#installing-luacheck)
    * [Windows](#windows)
    * [Linux](#linux)
* [Running LuaCheck](#running-luacheck)
* [Configuring LuaCheck](#configuring-luacheck)
    * [Troubleshooting](#troubleshooting)
* [Checking Commits with Travis](#checking-commits-with-travis)

## Installing LuaCheck

### Windows

Simply download luacheck.exe from
[the Github Releases page](https://github.com/mpeterv/luacheck/releases).

### Linux

First you'll need to install LuaRocks:

    sudo apt install luarocks

You can then install LuaCheck globally:

    sudo luarocks install luacheck

Check that it's installed with the following command:

    luacheck -v

## Running LuaCheck

The first time you run LuaCheck, it will probably pick up a lot of false
errors. This is because it still needs to be configured.

On Windows, open powershell or bash in the root folder of your project
and run `path\to\luacheck.exe .`

On Linux, run `luacheck .` whilst in the root folder of your project.

## Configuring LuaCheck

Create a file called .luacheckrc in the root of your project. This could be the
root of your game, modpack, or mod.

Put the following contents in it:

{% highlight lua %}
unused_args = false
allow_defined_top = true

globals = {
    "minetest",
}

read_globals = {
    string = {fields = {"split"}},
    table = {fields = {"copy", "getn"}},

    -- Builtin
    "vector", "ItemStack",
    "dump", "DIR_DELIM", "VoxelArea", "Settings",

    -- MTG
    "default", "sfinv", "creative",
}
{% endhighlight %}

Next you'll need to test that it works by running LuaCheck. You should get a lot
less errors this time. Starting at the first error you get, either modify the
configuration to take it into account, or if there's a bug then fix it - take
a look at the list below.

### Troubleshooting

* **accessing undefined variable foobar** - If `foobar` is meant to be a global,
  then add it to `read_globals`. Otherwise add any missing `local`s to the mod.
* **setting non-standard global variable foobar** - If `foobar` is meant to be a global,
  then add it to `globals`. Remove from `read_globals` if present there.
  Otherwise add any missing `local`s to the mod.
* **mutating read-only global variable 'foobar'** - Move `foobar` from `read_globals` to
  `globals`.

## Using with editor

It is highly recommended that you find an install a plugin for your editor of choice
to show you errors without running a command. Most editors will likely have a plugin
available.

* **Atom** - `linter-luacheck`
* **Sublime** - `SublimeLinter-luacheck`

## Checking Commits with Travis

If your project is public and is on Github, you can use TravisCI - a free service
to run jobs on commits to check them. This means that every commit you push will
be checked against LuaCheck, and a green tick or red cross displayed next to them
depending on whether LuaCheck finds any mistakes. This is especially helpful for
when your project receives a pull request - you'll be able to see the LuaCheck output
without downloading the code.

First you should visit [travis-ci.org](https://travis-ci.org/) and sign in with
your Github account. Then find your project's repo in your Travis profile,
and enable travis by flipping the switch.

Next, create a file called .travis.yml with the following content:

{% highlight yml %}
language: generic
sudo: false
addons:
  apt:
    packages:
    - luarocks
before_install:
  - luarocks install --local luacheck
script:
- $HOME/.luarocks/bin/luacheck --no-color .
notifications:
  email: false
{% endhighlight %}

If your project is a game rather than a mod or mod pack,
change the line after `script:` to:

{% highlight yml %}
- $HOME/.luarocks/bin/luacheck --no-color mods/
{% endhighlight %}

Now commit and push to Github. Go to your project's page on Github, and click
commits. You should see an orange disc next to the commit you just made. After
a while it should change either into a green tick or a red cross depending on the
outcome of LuaCheck. In either case, you can click the icon to see the build logs
and the output of LuaCheck.
