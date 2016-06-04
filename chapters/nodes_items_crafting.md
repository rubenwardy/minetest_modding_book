---
title: Nodes, Items, and Crafting
layout: default
root: ../
---

## Introduction

In this chapter we will learn how to register a new node or craftitem,
and create craft recipes.

* Item Strings
* Textures
* Registering a Craftitem
* Foods
* Registering a  basic Node
* Crafting
* Groups

## Item Strings

Each item, whether that be a node, craftitem, tool, or entity, has an item string.\\
This is sometimes referred to as registered name or just name.
A string in programming terms is a piece of text.

	modname:itemname

The modname is the name of the folder your mod is in.
You may call the itemname anything you like; however, it should be relevant to
what the item is and it can't already be registered.

### Overriding

Overriding allows you to:

* Redefine an existing item.
* Use an item string with a different modname.

To override, you prefix the item string with a colon, ``:``.
Declaring an item as ``:default:dirt`` will override the default:dirt in the default mod.

## Textures

Textures are usually 16 by 16 pixels.
They can be any resolution, but it is recommended that they are in the order of 2 (eg, 16, 32, 64, 128, etc),
as other resolutions may not be supported correctly on older devices.

Textures should be placed in textures/. Their name should match ``modname_itemname.png``.\\
JPEGs are supported, but they do not support transparency and are generally bad quality at low resolutions.

## Registering a Craftitem

Craftitems are the simplest items in Minetest. Craftitems cannot be placed in the world.
They are used in recipes to create other items, or they can be used by the player, such as food.

{% highlight lua %}
minetest.register_craftitem("mymod:diamond_fragments", {
	description = "Alien Diamond Fragments",
	inventory_image = "mymod_diamond_fragments.png"
})
{% endhighlight %}

Item definitions like the one seen above are usually made up of a unique
[item string](#item-strings) and a definition table. The definition table
contains attributes which affect the behaviour of the item.

### Foods

Foods are items that cure health. To create a food item you need to define the on_use property like this:

{% highlight lua %}
minetest.register_craftitem("mymod:mudpie", {
	description = "Alien Mud Pie",
	inventory_image = "myfood_mudpie.png",
	on_use = minetest.item_eat(20)
})
{% endhighlight %}

The number supplied to the minetest.item_eat function is the number of hit points that are healed by this food.
Two hit points make one heart and because there are 10 hearts there are 20 hitpoints.
Hitpoints don't have to be integers (whole numbers), they can be decimals.

Sometimes you may want a food to be replaced with another item when being eaten,
for example smaller pieces of cake or bones after eating meat. To do this, use:

	minetest.item_eat(hp, replace_with_item)

Where replace_with_item is an item string.

### Foods, extended

How about if you want to do more than just eat the item,
such as send a message to the player?

{% highlight lua %}
minetest.register_craftitem("mymod:mudpie", {
	description = "Alien Mud Pie",
	inventory_image = "myfood_mudpie.png",
	on_use = function(itemstack, user, pointed_thing)
		hp_change = 20
		replace_with_item = nil

		minetest.chat_send_player(user:get_player_name(), "You ate an alien mud pie!")

		-- Support for hunger mods using minetest.register_on_item_eat
		for _ , callback in pairs(minetest.registered_on_item_eats) do
			local result = callback(hp_change, replace_with_item, itemstack, user, pointed_thing)
			if result then
				return result
			end
		end

		if itemstack:take_item() ~= nil then
			user:set_hp(user:get_hp() + hp_change)
		end

		return itemstack
	end
})
{% endhighlight %}

If you are creating a hunger mod, or if you are affecting foods outside of your
mod, you should consider using minetest.register_on_item_eat

## Registering a basic node

In Minetest, a node is an item that you can place.
Most nodes are 1m x 1m x 1m cubes; however, the shape doesn't
have to be a cube - as we will explore later.

Let's get onto it. A node's definition table is very similar to a craftitem's
definition table; however, you need to set the textures for the faces of the cube.

{% highlight lua %}
minetest.register_node("mymod:diamond", {
	description = "Alien Diamond",
	tiles = {"mymod_diamond.png"},
	is_ground_content = true,
	groups = {cracky=3, stone=1}
})
{% endhighlight %}

Let's ignore  ``groups`` for now, and take a look at the tiles.
The ``tiles`` property is a table of texture names the node will use.
When there is only one texture, this texture is used on every side.

What if you would like a different texture for each side?
Well, you give a table of 6 texture names, in this order:\\
up (+Y), down (-Y), right (+X), left (-X), back (+Z), front (-Z).
(+Y, -Y, +X, -X, +Z, -Z)

Remember: +Y is upwards in Minetest, along with most video games.
A plus direction means that it is facing positive co-ordinates,
a negative direction means that it is facing negative co-ordinates.

{% highlight lua %}
minetest.register_node("mymod:diamond", {
	description = "Alien Diamond",
	tiles = {
		"mymod_diamond_up.png",
		"mymod_diamond_down.png",
		"mymod_diamond_right.png",
		"mymod_diamond_left.png",
		"mymod_diamond_back.png",
		"mymod_diamond_front.png"
	},
	is_ground_content = true,
	groups = {cracky = 3},
	drop = "mymod:diamond_fragments"
	-- ^  Rather than dropping diamond, drop mymod:diamond_fragments
})
{% endhighlight %}

The is_ground_content attribute allows caves to be generated over the stone.

## Crafting

There are several different types of crafting,
identified by the ``type`` property.

* shaped - Ingredients must be in the correct position.
* shapeless - It doesn't matter where the ingredients are,
  just that there is the right amount.
* cooking - Recipes for the furnace to use.
	* fuel - Defines items which can be burned in furnaces.
* tool_repair - Used to allow the repairing of tools.

Craft recipes do not use Item Strings to uniquely identify themselves.

### Shaped

Shaped recipes are the normal recipes - the ingredients have to be in the
right place.
For example, when you are making a pickaxe the ingredients have to be in the
right place for it to work.

{% highlight lua %}
minetest.register_craft({
	output = "mymod:diamond_chair 99",
	recipe = {
		{"mymod:diamond_fragments", "", ""},
		{"mymod:diamond_fragments", "mymod:diamond_fragments", ""},
		{"mymod:diamond_fragments", "mymod:diamond_fragments",  ""}
	}
})
{% endhighlight %}

This is pretty self-explanatory. You don't need to define the type, as
shaped crafts are default. The 99 after the itemname in output makes the
craft create 99 chairs rather than one.

If you notice, there is a blank column at the far end.
This means that the craft must always be exactly that.
In most cases, such as the door recipe, you don't care if the ingredients
are always in an exact place, you just want them correct relative to each
other. In order to do this, delete any empty rows and columns.
In the above case, there is an empty last column, which, when removed,
allows the recipe to be crafted if it was all moved one place to the right.

{% highlight lua %}
minetest.register_craft({
	output = "mymod:diamond_chair",
	recipe = {
		{"mymod:diamond_fragments", ""},
		{"mymod:diamond_fragments", "mymod:diamond_fragments"},
		{"mymod:diamond_fragments", "mymod:diamond_fragments"}
	}
})
{% endhighlight %}

### Shapeless

Shapeless recipes are a type of recipe which is used when it doesn't matter
where the ingredients are placed, just that they're there.
For example, when you craft a bronze ingot, the steel and the copper do not
need to be in any specific place for it to work.

{% highlight lua %}
minetest.register_craft({
	type = "shapeless",
	output = "mymod:diamond",
	recipe = {"mymod:diamond_fragments" "mymod:diamond_fragments", "mymod:diamond_fragments"}
})
{% endhighlight %}

When you are crafting the diamond, the three diamond fragments can be anywhere
in the grid.\\
Note: You can still use options like the number after the result, as mentioned
earlier.

### Cooking

Recipes with the type "cooking" are not made in the crafting grid,
but are cooked in furnaces, or other cooking tools that might be found in mods.
For example, you use a cooking recipe to turn ores into bars.

{% highlight lua %}
minetest.register_craft({
	type = "cooking",
	output = "mymod:diamond_fragments",
	recipe = "default:coalblock",
	cooktime = 10,
})
{% endhighlight %}

As you can see from this example, the only real difference in the code
is that the recipe is just a single item, compared to being in a table
(between braces). They also have an optional "cooktime" parameter which
defines how long the item takes to cook. If this is not set it defaults to 3.

The recipe above works when the coal block is in the input slot,
with some form of a fuel below it.
It creates diamond fragments after 10 seconds!

#### Fuel

This type is an accompaniment to the cooking type, as it defines
what can be burned in furnaces and other cooking tools from mods.

{% highlight lua %}
minetest.register_craft({
	type = "fuel",
	recipe = "mymod:diamond",
	burntime = 300,
})
{% endhighlight %}

They don't have an output like other recipes, but they have a burn time
which defines how long they will last as fuel in seconds.
So, the diamond is good as fuel for 300 seconds!

## Groups

Items can be members of many groups and groups can have many members.
Groups are usually identified using `group:group_name`
There are several reasons you use groups.

Groups can be used in crafting recipes to allow interchangeability
of ingredients. For example, you may use group:wood to allow any wood
item to be used in the recipe.

### Dig types

Let's look at our above ``mymod:diamond`` definition. You'll notice this line:

{% highlight lua %}
groups = {cracky = 3}
{% endhighlight %}

Cracky is a digtype. Dig types specify what type of the material the node is
physically, and what tools are best to destroy it.

| Group                   | Description                                                                                  |
|-------------------------|----------------------------------------------------------------------------------------------|
| crumbly                 | dirt, sand                                                                                   |
| cracky                  | tough but crackable stuff like stone.                                                        |
| snappy                  | something that can be cut using fine tools; e.g. leaves, smallplants, wire, sheets of metal  |
| choppy                  | something that can be cut using force; e.g. trees, wooden planks                             |
| fleshy                  | Living things like animals and the player. This could imply some blood effects when hitting. |
| explody                 | Especially prone to explosions                                                               |
| oddly_breakable_by_hand | Torches, etc, quick to dig                                                                   |
