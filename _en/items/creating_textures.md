---
title: Creating Textures
layout: default
root: ../..
idx: 2.2
description: An introduction to making textures in your editor of choice, an a guide on GIMP.
redirect_from: /en/chapters/creating_textures.html
---

## Introduction

Being able to create and optimise textures is a very useful skill when
developing for Minetest.
There are many techniques relevant to working on pixel art textures,
and understanding these techniques will greatly improve
the quality of the textures you create.

* [Learning to Draw](#learning-to-draw)
* [Techniques](#techniques)
* [Editors](#editors)

## Learning to Draw

Teaching how to draw good pixel art is out of scope of this book.

* [16×16 Pixel Art Tutorial on photonstorm.com](http://www.photonstorm.com/art/tutorials-art/16x16-pixel-art-tutorial)

## Techniques

### Using the Pencil

The pencil tool is available in most editors. When set to its lowest size,
it allows you to edit one pixel at a time without changing any other parts
of the image. By manipulating the pixels one at a time, you create clear
and sharp textures without unnecessary blurring. It also gives you a high
level of precision and control.

### Tiling

Textures used for nodes should generally be designed to tile. This means
when you place multiple nodes with the same texture together, the edges line
up correctly.

<!-- IMAGE NEEDED - cobblestone that tiles correctly -->

If you fail to match the edges correctly, the result is far less pleasing
to look at.

<!-- IMAGE NEEDED - node that doesn't tile correctly -->

### Transparency

Transparency is important when designing textures for special nodes,
such as glass or water, which players should be able to see through,
and for craft item textures.
It's important to remember that not all editors support transparency,
so make sure you choose an editor which is suitable for the textures
you wish to create.

## Editors

### MS Paint

MS Paint is a simple editor which can be useful for basic texture
design; however, it does not support transparency.
This usually won't matter when making textures for the sides of nodes,
but if you need transparency in your textures you should choose a
different editor.

### GIMP

GIMP is commonly used in the Minetest community. It has quite a high
learning curve because many of its features are not immediately
obvious.

When using GIMP, the pencil tool can be selected from the Toolbox:

<figure>
    <img src="{{ page.root }}//static/pixel_art_gimp_pencil.png" alt="Pencil in GIMP">
</figure>

It's also advisable to select the Hard edge checkbox for the eraser tool.
