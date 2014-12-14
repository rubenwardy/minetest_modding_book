---
title: Formspecs
layout: default
root: ../
---

Introduction
------------

In this chapter we will learn how to create a formspec and display it to the user.
A formspec is the specification code for a form.
In Minetest, forms are windows like the Inventory which allow you to move your mouse
and enter information.
You should consider using Heads Up Display (HUD) elements if you do
not need to get user input - notifications, for example - as unexpected windows
tend to disrupt game play.

* Formspec syntax
* Displaying Forms
* Callbacks
* Contexts
* Node Meta Formspecs

Formspec Syntax
---------------

Formspecs have a rather weird syntax.
They consist of a series of tags which are in the following form:

	element[param1;param2;...]

Firstly the element type is declared, and then the attributes are given in square brackets.

### Size[w, h]

Nearly all forms have a size tag. They are used to declare the size of the window required.
**Forms don't use pixels as co-ordinates, they use a grid**, based on inventories.
A size of (1, 1) means the form is big enough to host a 1x1 inventory.
The reason this is used is because it is independent on screen resolution -
The form should work just as well on large screens as small screens.
You can use decimals in sizes and co-ordinates.

	size[5,2]

Co-ordinates and sizes only use one attribute.
The x and y values are separated by a comma, as you can see above.

### Field[x, y; w, h; name; label; default]

Most elements follow a similar form to this. The name attribute is used in callbacks
to get the submitted information. The others are pretty self-explaintary.

	field[1,1;3,1;firstname;Firstname;]

It is perfectly valid to not define an attribute, like above.

### Other Elements

You should look in [lua_api.txt](https://github.com/minetest/minetest/blob/master/doc/lua_api.txt#L1019)
for a list of all possible elements, just search for "Formspec".
It is near line 1019, at time of writing.

Displaying Formspecs
--------------------

Here is a generalized way to show a formspec

	minetest.show_formspec(playername, formname, formspec)

Formnames should be itemnames, however that is not enforced.
There is no need to override a formspec here, formspecs are not registered like
nodes and items are, instead the formspec code is sent to the player's client for them
to see, along with the formname.
Formnames are used in callbacks to identify which form has been submitted,
and see if the callback is relevant.

Callbacks
---------

{% highlight lua %}
-- Show form when the /formspec command is used.
minetest.register_chatcommand("formspec", {
	func = function(name, param)
		minetest.show_formspec(name, "mymod:form",
				"size[4,3]" ..
				"label[0,0;Hello, " .. name .. "]" ..
				"field[1,1.5;3,1;name;Name;]" ..
				"button_exit[1,2;2,1;exit;Save]")
	end
})

-- Register callback
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "mymod:form" then
		-- Formname is not mymod:form,
		-- exit callback.
		return false
	end

	-- Send message to player.
	minetest.chat_send_player(player:get_player_name(), "You said: " .. fields.name .. "!")

	-- Return true to stop other minetest.register_on_player_receive_fields
	-- from receiving this submission.
	return true
end)
{% endhighlight %}

The function given in minetest.register_on_player_receive_fields is called
everytime a user submits a form. Most callbacks will check the formname given
to the function, and exit if it is not the right form. However, some callbacks
may need to work on multiple forms, or all forms - it depends on what you
want to do.

### Fields

The fields parameter to the function is a table, index by string, of the values
submitted by the user. You can access values in the table by doing fields.name,
where 'name' is the name of the element.

As well as having the values of each element, you can also get which button
was clicked. In this case, the button called 'exit' was clicked, so fields.exit
will be true.

Some elements can submit the form without the user having to click a button,
such as a check box. You can detect for these cases by looking
for a clicked button.

Contexts
--------

In quite a lot of cases you want your minetest.show_formspec to give information
to the callback which you don't want to have to send to the client. Information
such as what a chat command was called with, or what the dialog is about.

Let's say you are making a form to handle land protection information. Here is
how you would do it:

{% highlight lua %}
local land_formspec_context = {}

minetest.register_chatcommand("land", {
	func = function(name, param)
		if param == "" then
			minetest.chat_send_player(name, "Incorrect parameters - supply a land ID")
			return
		end

		-- Save information
		land_formspec_context[name] = {id = param}

		minetest.show_formspec(name, "mylandowner:edit",
				"size[4,4]" ..
				"field[1,1;3,1;plot;Plot Name;]" ..
				"field[1,2;3,1;owner;Owner;]" ..
				"button_exit[1,3;2,1;exit;Save]")
	end
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "mylandowner:edit" then
		return false
	end

	-- Load information
	local context = land_formspec_context[player:get_player_name()]

	if context then
		minetest.chat_send_player(player:get_player_name(), "Id " .. context.id .. " is now called " ..
				fields.plot .. " and owned by " .. fields.owner)

		-- Delete context if it is no longer going to be used
		land_formspec_context[player:get_player_name()] = nil

		return true
	else
		-- Fail gracefully if the context does not exist.
		minetest.chat_send_player(player:get_player_name(), "Something went wrong, try again.")
	end
end)
{% endhighlight %}

Node Meta Formspecs
-------------------

minetest.show_formspec is not the only way to show a formspec, you can also
add formspecs to a node's meta data. This is used on nodes such as chests to
allow for faster opening times - you don't need to wait for the server to send
the player the chest formspec.

{% highlight lua %}
minetest.register_node("mymod:rightclick", {
	description = "Rightclick me!",
	tiles = {"mymod_rightclick.png"},
	groups = {cracky = 1},
	after_place_node = function(pos, placer)
		-- This function is run	when the chest node is placed.
		-- The following code sets the formspec for chest.
		-- Meta is a way of storing data onto a node.

		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",
				"size[3,2]"..
				"label[1,1;This is shown on right click]")
	end
})
{% endhighlight %}

Formspecs set this way do not trigger callbacks.
This method really only works for inventories.
Use on_rightclick and minetest.show_formspec if you want callbacks.

*Note: node meta data will have been explained by this point in the full book*
