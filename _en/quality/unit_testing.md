---
title: Automatic Unit Testing
layout: default
root: ../../
idx: 6.4
---

## Introduction

Unit tests are an essential tool in proving and resuring yourself that your code
is correct. This chapter will show you how to write tests for Minetest mods and
games using busted, and how to structure your code to make this easier - Writing
unit tests for functions where you call Minetest functions is quite difficult,
but luckily [in the previous chapter](mvc.html), we discussed how to make your
code avoid this.

* [Installing Busted](#installing-busted)
    * [Windows](#windows)
    * [Linux](#linux)


## Installing Busted

### Windows

*Todo. No one cares about windows, right?*

### Linux

First you'll need to install LuaRocks:

    sudo apt install luarocks

You can then install Busted globally:

    sudo luarocks install busted

Check that it's installed with the following command:

    busted --version
