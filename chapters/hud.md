---
title: HUD
layout: default
root: ../
---

<div class="notice">
	<h2>Experimental Feature</h2>

	The HUD feature will probably be rewritten in an upcoming Minetest release.
	Be aware that you may need to update your mods if the API is changed.
</div>

Introduction
------------

Heads Up Display (HUD) elements allow you to show text, images, and other graphical elements.

HUD doesn't except user input. For that, you should use a [Formspec](formspecs.html).

* Basic Interface
* Positioning
* Text Elements
* Image Elements
* Other Elements

Basic Interface
---------------

HUD elements are created using a player object.
You can get the player object from a username like this:

{% highlight lua %}
local player = minetest.get_player_by_name("username")
{% endhighlight %}

Once you have the player object, you can create an element:

{% highlight lua %}
local idx = player:hud_add({
         hud_elem_type = "text",
         position = {x = 1, y = 0},
         offset = {x=-100, y = 20},
         scale = {x = 100, y = 100},
         text = "My Text"
})
{% endhighlight %}

This attributes in the above table and what they do vary depending on
the `hud_elem_type`.\\
A number is returned by the hud_add function which is needed to identify the HUD element
at a later time, if you wanted to change or delete it.

You can change an attribute after creating a HUD element, such as what the text
says:

{% highlight lua %}
player:hud_change(idx, "text", "New Text")
{% endhighlight %}

You can also delete the element:

{% highlight lua %}
player:hud_remove(idx)
{% endhighlight %}

Positioning
-----------

Screens come in different sizes, and HUD elements need to work well on all sizes.
You locate an element using a combination of a position and an offset.

The position is a co-ordinate between (0, 0) and (1, 1) which determines where,
relative to the screen width and height, the element goes.
For example, an element with a position of (0.5, 0.5) will be in the center of the screen.

The offset applies a pixel offset to the position.\\
An element with a position of (0, 0) and an offset of (10, 10) will end up at the screen
co-ordinates (0 * width + 10, 0 * height + 10).

Please note that offset scales to DPI and a user defined factor.

Text Elements
-------------

A text element is the simplest form of a HUD element.\\
Here is our earlier example, but with comments to explain each part:

{% highlight lua %}
local idx = player:hud_add({
	hud_elem_type = "text",     -- This is a text element
	position = {x = 1, y = 0},
	offset = {x=-100, y = 20},
	scale = {x = 100, y = 100}, -- Maximum size of text, crops off any out of these bounds
	text = "My Text"            -- The actual text shown
})
{% endhighlight %}

### Colors

You can apply colors to the text, using the `number` attribute.
Colors are in [Hexadecimal form](http://www.colorpicker.com/).

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

Image Elements
--------------

Displays an image on the HUD.

The X co-ordinate of the `scale` attribute is the scale of the image, with 1 being the original texture size.
Negative values represent that percentage of the screen it should take; e.g. x=-100 means 100% (width).

Use `text` to specify the name of the texture.

Other Elements
--------------

Have a look at [lua_api.txt]({{ page.root }}lua_api.html#hud-element-types) for a complete list of HUD elements.
