---
title: Intro to Clean Architectures
layout: default
root: ../..
idx: 6.3
---

## Introduction

Once your mod reaches a respectable size, you'll find it harder and harder to
keep the code clean and free of bugs. This is an especially big problem when using
a dynamically typed language like Lua, given that the compiler gives you very little
compiler-time help when it comes to things like making sure that types are used correctly.

This chapter covers important concepts needed to keep your code clean,
and common design patterns to achieve that. Please note that this chapter isn't
meant to be prescriptive, but to instead give you an idea of the possibilities.
There is no one good way of designing a mod, and good mod design is very subjective.

* [Cohesion, Coupling, and Separation of Concerns](#cohesion-coupling-and-separation-of-concerns)
* [Model-View-Controller](#model-view-controller)
    * [API-View](#api-view)
* [Observer](#observer)
* [Conclusion](#conclusion)



## Cohesion, Coupling, and Separation of Concerns

Without any planning, a programming project will tend to gradually descend into
spaghetti code. Spaghetti code is characterised by a lack of structure - all the
code is thrown in together with no clear boundaries. This ultimately makes a
project completely unmaintainable, ending in its abandonment.

The opposite of this is to design your project as a collection of interacting
smaller programs or areas of code.

> Inside every large program, there is a small program trying to get out.
>
>  --C.A.R. Hoare

This should be done in such a way that you achieve Separation of Concerns -
each area should be distinct and address a separate need or concern.

These programs/areas should have the following two properties:

* **High Cohesion** - the area should be closely/tightly related.
* **Low Coupling** - keep dependencies between areas as low as possible, and avoid
relying on internal implementations. It's a very good idea to make sure you have
a low amount of coupling, as this means that changing the APIs of certain areas
will be more feasible.

Note that these apply both when thinking about the relationship between mods,
and the relationship between areas inside a mod. In both cases you should try
to get high cohesion and low coupling.


## Model-View-Controller

In the next chapter we will discuss how to automatically test your code, and one
of the problems we will have is how to separate your logic
(calculations, what should be done) from API calls (`minetest.*`, other mods)
as much as possible.

One way to do this is to think about:

* What **data** you have.
* What **actions** you can take with this data.
* How **events** (ie: formspec, punches, etc) trigger these actions, and how
  these actions cause things to happen in the engine.

Let's take an example of a land protection mod. The data you have is the areas
and any associated meta data. The actions you can take are `create`, `edit`, or
`delete`. The events that trigger these actions are chat commands and formspec
receive fields. These are 3 areas can usually be separated pretty well.

In your tests, you will be able to make sure that an action when triggered does the right thing
to the data, but you won't need to test that an event calls an action (as this
would require using the Minetest API, and this area of code should be made as
small as possible anyway.)

You should write your data representation using Pure Lua. "Pure" in this context
means that the functions could run outside of Minetest - none of the engine's
functions are called.

{% highlight lua %}
-- Data
function land.create(name, area_name)
    land.lands[aname] = {
        name  = area_name,
        owner = name,
        -- more stuff
    }
end

function land.get_by_name(area_name)
    return land.lands[area_name]
end
{% endhighlight %}

Your actions should also be pure, however calling other functions is more
acceptable.

{% highlight lua %}
-- Controller
function land.handle_create_submit(name, area_name)
    -- process stuff (ie: check for overlaps, check quotas, check permissions)

    land.create(name, area_name)
end

function land.handle_creation_request(name)
    -- This is a bad example, as explained later
    land.show_create_formspec(name)
end
{% endhighlight %}

Your event handlers will have to interact with the Minetest API. You should keep
the amount of calculations to a minimum, as you won't be able to test this area
very easily.

{% highlight lua %}
-- View
function land.show_create_formspec(name)
    -- Note how there's no complex calculations here!
    return [[
        size[4,3]
        label[1,0;This is an example]
        field[0,1;3,1;area_name;]
        button_exit[0,2;1,1;exit;Exit]
    ]]
end

minetest.register_chatcommand("/land", {
    privs = { land = true },
    func = function(name)
        land.handle_creation_request(name)
    end,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    land.handle_create_submit(player:get_player_name(), fields.area_name)
end)
{% endhighlight %}

The above is the Model-View-Controller pattern. The model is a collection of data
with minimal functions. The view is a collection of functions which listen to
events and pass it to the controller, and also receives calls from the controller to
do something with the Minetest API. The controller is where the decisions and
most of the calculations are made.

The controller should have no knowledge about the Minetest API - notice how
there are no Minetest calls or any view functions that resemble them.
You should *NOT* have a function like `view.hud_add(player, def)`.
Instead the view defines some actions the controller can tell the view to do,
like `view.add_hud(info)` where info is a value or table which doesn't relate
to the Minetest API at all.

<figure class="right_image">
    <img
        width="100%"
        src="{{ page.root }}//static/mvc_diagram.svg"
        alt="Diagram showing a centered text element">
</figure>

It is important that each area only communicates with its direct neighbours,
as shown above, in order to reduce how much you needs to change if you modify
an area's internals or externals. For example, to change the formspec you
would only need to edit the view. To change the view API, you would only need to
change the view and the controller, but not the model at all.

In practice, this design is rarely used because of the increased complexity
and because it doesn't give many benefits for most types of mods. Instead,
you tend to see a lot more of a less formal and strict kind of design -
varients of the API-View.


### API-View

In an ideal world, you'd have the above 3 areas perfectly separated with all
events going into the controller before going back to the normal view. But
this isn't the real world. A good half-way house is to reduce the mod into 2
parts:

* **API** - what was the model and controller. There should be no uses of
    `minetest.` here.
* **View** - the view as before. It's a good idea to structure this into separate
    files for each type of event.

rubenwardy's [crafting mod](https://github.com/rubenwardy/crafting) roughly
follows this design. `api.lua` is almost all pure Lua functions handling the data
storage and controller-style calculations. `gui.lua` is the view for formspecs
and formspec submission, and `async_crafter.lua` is the view and controller for
a node formspec and node timers.

Separating the mod like this means that you can very easily test the API part,
as it doesn't use any Minetest APIs - as shown in the
[next chapter](unit_testing.html) and seen in the crafting mod.


## Observer

Reducing coupling may seem hard to do to begin with, but you'll make a lot of
progress by splitting your code up well using a design like the one given above.
It's not always possible to remove the need for one area to communicate with
another, but there are ways to decouple anyway - one such way being the Observer
pattern.

Let's take the example of unlocking an achievement when a player first kills a
rare animal. The naive approach would be to have achievement code in the mob
kill function, checking the mob name and unlocking the award if it matches.
This is a bad idea however, as it makes the mobs mod coupled to the achievements
code. If you kept on doing this - for example, adding XP to the mob death code -
you could end up with a lot of messy dependencies.

Enter the Observer pattern. Instead of the mobs mod caring about awards, mobs
exposes a way for other areas of code to register their interest in an event
and receive data about the event.

{% highlight lua %}
mobs.registered_on_death = {}
function mobs.register_on_death(func)
    table.insert(mobs.registered_on_death, func)
end

-- mob death code
for i=1, #mobs.registered_on_death do
    mobs.registered_on_death[i](entity, reason)
end
{% endhighlight %}

Then the other code registers its interest:

{% highlight lua %}

-- awards
mobs.register_on_death(function(mob, reason)
    if reason.type == "punch" and reason.object and reason.object:is_player() then
        awards.notify_mob_kill(reason.object, mob.name)
    end
end)
{% endhighlight %}

You may be thinking - wait a second, this looks awfully familiar. And you're right!
The Minetest API is heavily Observer based to stop the engine having to care about
what is listening to something.

## Conclusion

Good code design is subjective, and depends on the project you're making. As a
general rule, try to keep cohesion high and coupling low. Phrased differently,
keep related code together and unrelated code apart, and keep dependencies simple.

I highly recommend reading the [Game Programming Patterns](http://gameprogrammingpatterns.com/)
book. It's freely available to [read online](http://gameprogrammingpatterns.com/contents.html)
and goes into much more detail on common programming patterns relevant to games.
