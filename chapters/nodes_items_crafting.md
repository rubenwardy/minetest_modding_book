---
title: Nodes, Items and Crafting
layout: default
root: ../
---

Introduction
------------

In this chapter we will learn how to register a new node or craftitem,
and create craft recipes.

* Item Strings
* Textures
* Registering a Craftitem
* Foods
* Registering a  basic Node
* Crafting
* Groups

Item Strings
------------

Each item, whether that be a node, craftitem, tool or entity, has an item string.\\
This is oftenly refered to as just name or registered name.
A string in programming terms is a piece of text.

	modname:itemname

The modname is the name of the folder your mod is in.
You may call the itemname any thing you like, however it should be relevant to what the item is,
and it can't be already registered.

### Overriding

Overriding allows you to:

* Create an item in another mod's namespace.
* Override an existing item.

To override, you prefix the item string with a colon, ``:``.
Declaring an item as ``:default:dirt`` will override the default:dirt in the default mod.

Textures
--------

Normally textures have a resolution of 16x16, but they can be in the order of 2: 16, 32, 64, 128, etc.

Textures should be placed in textures/. Their name should match ``modname_itemname.png``.\\
JPEGs are supported, but they do not support transparency and are generally bad quality at low resolutions.

Registering a Craftitem
-----------------------

Craftitems are the simplest item in Minetest. Craftitems cannot be placed in the world.
They are used in recipes to create other items, or they can be used be the player, such as food.

{% highlight lua %}
minetest.register_craftitem("mymod:diamond_fragments", {
	description = "Alien Diamond Fragments",
	inventory_image = "mymod_diamond_fragments.png"
})
{% endhighlight %}

Definitions are usually made up of an [item string](#item-strings) to identify the definition,
and a definition table.

### Foods

Foods are items that cure health. To create a food item, you need to define the on_use property like this:

{% highlight lua %}
minetest.register_craftitem("mymod:mudpie", {
	description = "Alien Mud Pie",
	inventory_image = "myfood_mudpie.png",
	on_use = minetest.item_eat(20)
})
{% endhighlight %}

The number supplied to the minetest.item_eat function is the number of hit points that are healed by this food.
Two hit points make one heart, and because there are 10 hearts there are 20 hitpoints.
Hitpoints don't have to be integers (whole numbers), they can be decimals.


Registering a basic node
------------------------

In Minetest, a node is an item that you can place.
Most nodes are 1m x 1m x 1m cubes, however the shape doesn't
have to be a cube - as we will explore later.

Let's get onto it. A node's definition table is very similar to a craftitem's
definition table, however you need to set the textures for the faces of the cube.

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

Crafting
--------

There are several different types of crafting,
identified by the ``type`` property.

* shaped - Ingredients must be in the correct position.
* shapeless - It doesn't matter where the ingredients are,
  just that there is the right amount.
* cooking - Recipes for the furnace to use.
* tool_repair - Used to allow the repairing of tools.

Craft recipes do not use Item Strings.

### Shaped

Shaped recipes are the normal recipes - the ingredients have to be in the
right place.
For example, when you are making a pickaxe the ingredients have to be in the
right place for it to work.

{% highlight lua %}
minetest.register_craft({
	output = "mymod:diamond_chair",
	recipe = {
		{"mymod:diamond_fragments", "", ""},
		{"mymod:diamond_fragments", "mymod:diamond_fragments", ""},
		{"mymod:diamond_fragments", "mymod:diamond_fragments,  ""}
	}
})
{% endhighlight %}

This is pretty self-explanatory. You don't need to define the type, as
shaped crafts are default.

If you notice, there is a blank column at the far end.
This means that the craft must always be exactly that.
In most cases, such as the door recipe, you don't care if the ingredients
are always in an exact place, you just want them correct relative to each
other. In order to do this, delete any empty rows and columns.
In the above case, their is an empty last column, which, when removed,
allows the recipe to be crafted if it was all moved one place to the right.

{% highlight lua %}
minetest.register_craft({
	output = "mymod:diamond_chair",
	recipe = {
		{"mymod:diamond_fragments", ""},
		{"mymod:diamond_fragments", "mymod:diamond_fragments",
		{"mymod:diamond_fragments", "mymod:diamond_fragments}
	}
})
{% endhighlight %}

(Explainations of more crafting types are coming soon)

Groups
------

Items can be members of many groups, and groups may have many members.
Groups are usually identified using ``group:group_name``
There are several reason you use groups.

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
