---
title: Formspecs
layout: default
root: ../..
idx: 4.5
redirect_from: /en/chapters/formspecs.html
minetest510:
    level: warning
    title: Real coordinates will be in 5.1.0
    classes: web-only
    message: This chapter describes the use of a feature that hasn't been released yet.
         You can still use this chapter and the code in Minetest 5.0, but elements will
         be positioned differently to what is shown.
submit_vuln:
    level: warning
    title: Malicious clients can submit anything at anytime
    message: You should never trust a formspec submission. A malicious client
             can submit anything they like at any time - even if you never showed
             them the formspec. This means that you should check privileges
             and make sure that they should be allowed to perform the action.
---

## Introduction <!-- omit in toc -->

<figure class="right_image">
    <img src="{{ page.root }}//static/formspec_example.png" alt="Furnace Inventory">
    <figcaption>
        Screenshot of furnace formspec, labelled.
    </figcaption>
</figure>

In this chapter we will learn how to create a formspec and display it to the user.
A formspec is the specification code for a form.
In Minetest, forms are windows such as the player inventory and can contain a
variety of elements, such as labels, buttons and fields.

Note that if you do not need to get user input, for example when you only need
to provide information to the player, you should consider using
[Heads Up Display (HUD)](hud.html) elements instead of forms, because
unexpected windows tend to disrupt gameplay.

- [Real or Legacy Coordinates](#real-or-legacy-coordinates)
- [Anatomy of a Formspec](#anatomy-of-a-formspec)
  - [Elements](#elements)
  - [Header](#header)
- [Guessing Game](#guessing-game)
  - [Padding and Spacing](#padding-and-spacing)
  - [Receiving Formspec Submissions](#receiving-formspec-submissions)
  - [Contexts](#contexts)
- [Formspec Sources](#formspec-sources)
  - [Node Meta Formspecs](#node-meta-formspecs)
  - [Player Inventory Formspecs](#player-inventory-formspecs)
  - [Your Turn](#your-turn)


## Real or Legacy Coordinates

In older versions of Minetest, formspecs were inconsistent. The way that different
elements were positioned varied in unexpected ways; it was hard to predict the
placement of elements and align them. Minetest 5.1.0 contains a feature
called real coordinates which aims to rectify this by introducing a consistent
coordinate system. The use of real coordinates is highly recommended, and so
this chapter will use them exclusively.

{% include notice.html notice=page.minetest510 %}


## Anatomy of a Formspec

### Elements

Formspec is a domain-specific language with an unusual format.
It consists of a number of elements with the following form:

    type[param1;param2]

The element type is declared and then any parameters are given
in square brackets. Multiple elements can be joined together, or placed
on multiple lines, like so:

    foo[param1]bar[param1]
    bo[param1]


Elements are items such as text boxes or buttons, or can be metadata such
as size or background. You should refer to
[lua_api.txt](https://github.com/minetest/minetest/blob/master/doc/lua_api.txt#L1019)
for a list of all possible elements. Search for "Formspec" to locate the correct
part of the document.


### Header

The header of a formspec contains information which must appear first. This
includes the size of the formspec, the position, the anchor, and whether the
game-wide theme should be applied.

The elements in the header must be defined in a specific order, otherwise you
will see an error. This order is given in the above paragraph, and, as always,
documented in [lua_api.txt](../../lua_api.html#sizewhfixed_size)

The size is in formspec slots - a unit of measurement which is roughly
around 64 pixels, but varies based on the screen density and scaling
settings of the client. Here's a formspec which is `2,2` in size:

    size[2,2]
    real_coordinates[true]

Notice how we explicitly need to enable the use of the real coordinate system.
Without this, the legacy system will instead be used to size the formspec, which will
result in a larger size. This element is a special case, as it is the only element
which may appear both in the header and the body of a formspec. When in the header,
it must appear immediately after the size.

The position and anchor elements are used to place the formspec on the screen.
The position sets where on the screen the formspec will be, and defaults to
the center (`0.5,0.5`). The anchor sets where on the formspec the position is,
allowing you to line the formspec up with the edge of the screen. The formspec
can be placed to the left of the screen like so:

    size[2,2]
    real_coordinates[true]
    position[0,0.5]
    anchor[0,0.5]

This sets the anchor to the left middle edge of the formspec box, and then the
position of that anchor to the left of the screen.


## Guessing Game

<figure class="right_image">
    <img src="{{ page.root }}/static/formspec_guessing.png" alt="Guessing Formspec">
    <figcaption>
        The guessing game formspec.
    </figcaption>
</figure>

The best way to learn is to make something, so let's make a guessing game.
The principle is simple: the mod decides on a number, then the player makes
guesses on the number. The mod then says if the guess is higher or lower then
the actual number.

First, let's make a function to create the formspec code. It's good practice to
do this, as it makes it easier to reuse elsewhere.

<div style="clear: both;"></div>

```lua
guessing = {}

function guessing.get_formspec(name)
    -- TODO: display whether the last guess was higher or lower
    local text = "I'm thinking of a number... Make a guess!"

    local formspec = {
        "size[6,3.476]",
        "real_coordinates[true]",
        "label[0.375,0.5;", minetest.formspec_escape(text), "]",
        "field[0.375,1.25;5.25,0.8;number;Number;]",
        "button[1.5,2.3;3,0.8;guess;Guess]"
    }

    -- table.concat is faster than string concatenation - `..`
    return table.concat(formspec, "")
end
```

In the above code, we place a field, a label, and a button. A field allows text
entry, and a button is used to submit the form. You'll notice that the elements
are positioned carefully in order to add padding and spacing, this will be explained
later.

Next, we want to allow the player to show the formspec. The main way to do this
is using `show_formspec`:

```lua
function guessing.show_to(name)
    minetest.show_formspec(name, "guessing:game", guessing.get_formspec(name))
end

minetest.register_chatcommand("game", {
    func = function(name)
        guessing.show_to(name)
    end,
})
```

The show_formspec function accepts a player name, the formspec name, and the
formspec itself. The formspec name should be a valid itemname, ie: in the format
`modname:itemname`.


### Padding and Spacing

<figure class="right_image">
    <img src="{{ page.root }}/static/formspec_padding_spacing.png" alt="Padding and spacing">
    <figcaption>
        The guessing game formspec.
    </figcaption>
</figure>

Padding is the gap between the edge of the formspec and its contents, or between unrelated
elements, shown in red. Spacing is the gap between related elements, shown in blue.

It is fairly standard to have a padding of `0.375` and a spacing of `0.25`.

<div style="clear: both;"></div>


### Receiving Formspec Submissions

When `show_formspec` is called, the formspec is sent to the client to be displayed.
For formspecs to be useful, information needs to be returned from the client to server.
The method for this is called formspec field submission, and for `show_formspec`, that
submission is received using a global callback:

```lua
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "guessing:game" then
        return
    end

    if fields.guess then
        local pname = player:get_player_name()
        minetest.chat_send_all(pname .. " guessed " .. fields.number)
    end
end)
```

The function given in minetest.register_on_player_receive_fields is called
every time a user submits a form. Most callbacks will need to check the formname given
to the function, and exit if it is not the right form; however, some callbacks
may need to work on multiple forms, or on all forms.

The `fields` parameter to the function is a table of the values submitted by the
user, indexed by strings. Named elements will appear in the field under their own
name, but only if they are relevent for the event that caused the submission.
For example, a button element will only appear in fields if that particular button
was pressed.

{% include notice.html notice=page.submit_vuln %}

So, now the formspec is sent to the client and the client sends information back.
The next step is to somehow generate and remember the target value, and to update
the formspec based on guesses. The way to do this is using a concept called
"contexts".


### Contexts

In many cases you want minetest.show_formspec to give information
to the callback which you don't want to send to the client. This might include
what a chat command was called with, or what the dialog is about. In this case,
the target value that needs to be remembered.

A context is a per-player table to store information, and the contexts for all
online players are stored in a file-local variable:

```lua
local _contexts = {}
local function get_context(name)
    local context = _contexts[name] or {}
    _contexts[name] = context
    return context
end

minetest.register_on_leaveplayer(function(player)
    _contexts[player:get_player_name()] = nil
end)
```

Next, we need to modify the show code to update the context
before showing the formspec:

```lua
function guessing.show_to(name)
    local context = get_context(name)
    context.target = context.target or math.random(1, 10)

    local fs = guessing.get_formspec(name, context)
    minetest.show_formspec(name, "guessing:game", fs)
end
```

We also need to modify the formspec generation code to use the context:

```lua
function guessing.get_formspec(name, context)
    local text
    if not context.guess then
        text = "I'm thinking of a number... Make a guess!"
    elseif context.guess == context.target then
        text = "Hurray, you got it!"
    elseif context.guess > context.target then
        text = "To high!"
    else
        text = "To low!"
    end
```

Note that it's good practice for get_formspec to only read the context, and not
update it at all. This can make the function simpler, and also easier to test.

And finally, we need to update the handler to update the context with the guess:

```lua
if fields.guess then
    local name = player:get_player_name()
    local context = get_context(name)
    context.guess = tonumber(fields.number)
    guessing.show_to(name)
end
```


## Formspec Sources

There are three different ways that a formspec can be delivered to the client:

* [show_formspec](#guessing-game): the method used above, fields are received by register_on_player_receive_fields.
* [Node Meta Formspecs](#node-meta-formspecs): the node contains a formspec in its meta data, and the client
     shows it *immediately* when the player rightclicks. Fields are received by a
     method in the node definition called `on_receive_fields`.
* [Player Inventory Formspecs](#player-inventory-formspecs): the formspec is sent to the client at some point, and then
     shown immediately when the player presses `i`. Fields are received by
     register_on_player_receive_fields.

### Node Meta Formspecs

minetest.show_formspec is not the only way to show a formspec; you can also
add formspecs to a [node's metadata](node_metadata.html). For example,
this is used with chests to allow for faster opening times -
you don't need to wait for the server to send the player the chest formspec.

```lua
minetest.register_node("mymod:rightclick", {
    description = "Rightclick me!",
    tiles = {"mymod_rightclick.png"},
    groups = {cracky = 1},
    after_place_node = function(pos, placer)
        -- This function is run    when the chest node is placed.
        -- The following code sets the formspec for chest.
        -- Meta is a way of storing data onto a node.

        local meta = minetest.get_meta(pos)
        meta:set_string("formspec",
                "size[5,5]"..
                "label[1,1;This is shown on right click]"..
                "field[1,2;2,1;x;x;]")
    end,
    on_receive_fields = function(pos, formname, fields, player)
        if(fields.quit) then return end
        print(fields.x)
    end
})
```

Formspecs set this way do not trigger the same callback. In order to
receive form input for meta formspecs, you must include an
`on_receive_fields` entry when registering the node.

This style of callback triggers when you press enter
in a field, which is impossible with `minetest.show_formspec`;
however, this kind of form can only be shown by right-clicking on a
node. It cannot be triggered programmatically.

### Player Inventory Formspecs

The player inventory formspec is the one shown when the player presses i.
The global callback is used to receive events from this formspec, and the
formname is `""`.

There are a number of different mods which allow multiple mods to customise
the player inventory. The officially recommended mod is
[Simple Fast Inventory (sfinv)](sfinv.html), and is included in Minetest Game.


### Your Turn

* Extend the Guessing Game to keep track of each player's top score, where the
  top score is how many guesses it took.
* Make a node called "Inbox" where users can open up a formspec and leave messages.
  This node should store the placers' name as `owner` in the meta, and should use
  `show_formspec` to show different formspecs to different players.
