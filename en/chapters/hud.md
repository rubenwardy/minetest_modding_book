---
title: HUD
layout: default
root: ../../
---

## Introduction

Heads Up Display (HUD) elements allow you to show text, images, and other graphical elements.

The HUD doesn't accept user input. For that, you should use a [Formspec](formspecs.html).

* [Basic Interface](#basic-interface)
* [Positioning](#positioning)
* [Text Elements](#text-elements)
* [Image Elements](#image-elements)
* [Other Elements](#other-elements)

## Basic Interface

HUD elements are created using a player object.
You can get the player object from a username:

{% highlight lua %}
local player = minetest.get_player_by_name("username")
{% endhighlight %}

Once you have the player object, you can create a HUD element:

{% highlight lua %}
local idx = player:hud_add({
         hud_elem_type = "text",
         position = {x = 1, y = 0},
         offset = {x=-100, y = 20},
         scale = {x = 100, y = 100},
         text = "My Text"
})
{% endhighlight %}

The attributes in the HUD element table and what they do vary depending on
the `hud_elem_type`.\\
The `hud_add` function returns a number which is needed to identify the HUD element
if you wanted to change or delete it.

You can change an attribute after creating a HUD element. For example, you can change
the text:

{% highlight lua %}
player:hud_change(idx, "text", "New Text")
{% endhighlight %}

You can also delete the element:

{% highlight lua %}
player:hud_remove(idx)
{% endhighlight %}

## Positioning

Screens come in different sizes, and HUD elements need to work well on all screens.
You locate an element using a combination of a position and an offset.

The position is a co-ordinate between (0, 0) and (1, 1) which determines where,
relative to the screen width and height, the element is located.
For example, an element with a position of (0.5, 0.5) will be in the center of the screen.

The offset applies a pixel offset to the position.\\
For example, an element with a position of (0, 0) and an offset of (10, 10) will be at the screen
co-ordinates (0 * width + 10, 0 * height + 10).

Please note that offset scales to DPI and a user defined factor.

## Text Elements

A text element is the simplest type of HUD element.\\
Here is the earlier example, but with comments to explain each part:

{% highlight lua %}
local idx = player:hud_add({
    hud_elem_type = "text",     -- This is a text element
    position = {x = 1, y = 0},
    offset = {x=-100, y = 20},
    scale = {x = 100, y = 100}, -- Maximum size of text, text outside these bounds is cropped
    text = "My Text"            -- The actual text shown
})
{% endhighlight %}

### Colors

Use the `number` attribute to apply colors to the text.
Colors are in [Hexadecimal form](http://www.colorpicker.com/).
For example:

{% highlight lua %}
local idx = player:hud_add({
    hud_elem_type = "text",
    position = {x = 1, y = 0},
    offset = {x=-100, y = 20},
    scale = {x = 100, y = 100},
    text = "My Text",
    number = 0xFF0000 -- Red
})
{% endhighlight %}

## Image Elements

Image elements display an image on the HUD.

The X co-ordinate of the `scale` attribute is the scale of the image, with 1 being the original texture size.
Negative values represent the percentage of the screen the image should use. For example, x=-100 means 100% (width).

Use `text` to specify the name of the texture.

## Other Elements

Read [lua_api.txt]({{ page.root }}lua_api.html#hud-element-types) for a complete list of HUD elements.
