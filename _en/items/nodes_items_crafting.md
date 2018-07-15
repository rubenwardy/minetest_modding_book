---
title: Nodes, Items, and Crafting
layout: default
root: ../../
idx: 2.1
description: Learn how to register node, items, and craft recipes using register_node, register_item, and register_craft.
---

## Introduction

Registering new nodes and craftitems, and creating craft recipes, are
basic requirements for many mods.

* [Item Strings](#item-strings)
    * [Overriding](#overriding)
* [Textures](#textures)
* [Registering a Craftitem](#registering-a-craftitem)
    * [Foods](#foods)
    * [Foods, extended](#foods-extended)
* [Registering a Basic Node](#registering-a-basic-node)
* [Crafting](#crafting)
    * [Shaped](#shaped)
    * [Shapeless](#shapeless)
    * [Cooking](#cooking)
    * [Fuel](#fuel)
* [Groups](#groups)
    * [Dig Types](#dig-types)

## Item Strings

A string in programming terms is a piece of text.
Each in-game item, whether a node, craftitem, tool, or entity, has an item string.
This is sometimes referred to as its registered name or just its name. It takes the format:

    modname:itemname

The modname is the name of the mod in which the item is registered, and the
itemname is the name of the item itself.
The itemname should be relevant to what the item is and can't already be registered.

### Overriding

Overriding allows you to:

* Redefine an existing item.
* Use a different modname.

To override an item, prefix the item string with a colon, ``:``.
For example, declaring an item as ``:default:dirt`` will override
default:dirt in the default mod.

## Textures

Textures in Minetest are usually 16 by 16 pixels.
They can be any resolution, but it is recommended that they are in the order of 2,
for example 16, 32, 64, or 128,
because other resolutions may not be supported correctly on older devices.

Textures should be placed in the textures/ folder with names in the format
``modname_itemname.png``.\\
JPEG textures are supported, but do not support transparency and are generally
bad quality at low resolutions. It is often better to use the PNG format.

## Registering a Craftitem

Craftitems are the simplest items in Minetest. They cannot be placed in the world.
They are used in recipes to create other items, or can be used by the player.
Examples include food items which can be eaten and metal ingots which can be
crafted into tools or placeable nodes.

Item definitions usually include a unique
[item string](#item-strings) and a definition table. The definition table
contains attributes which affect the behaviour of the item. For example:

{% highlight lua %}
minetest.register_craftitem("mymod:diamond_fragments", {
    description = "Alien Diamond Fragments",
    inventory_image = "mymod_diamond_fragments.png"
})
{% endhighlight %}

### Foods

Foods are items which restore health. To create a food item you need to define
the on_use property of the item:

{% highlight lua %}
minetest.register_craftitem("mymod:mudpie", {
    description = "Alien Mud Pie",
    inventory_image = "myfood_mudpie.png",
    on_use = minetest.item_eat(20)
})
{% endhighlight %}

The number supplied to the minetest.item_eat function is the number of hit points
healed when this food is consumed.
Each heart icon the player has is worth two hitpoints. A player can usually have up to
10 hearts, which is equal to 20 hitpoints.
Hitpoints don't have to be integers (whole numbers); they can be decimals.

Sometimes you may want a food item to be replaced with another item after it is eaten,
for example smaller pieces of cake or bones after eating meat. To do this, use:

    minetest.item_eat(hp, replace_with_item)

In this example replace_with_item must be an item string.

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
    recipe = {"mymod:diamond_fragments", "mymod:diamond_fragments", "mymod:diamond_fragments"}
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
