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
})

minetest.register_node("mymod:air", {
	description = "MyAir (you hacker you!)",
	drawtype = "airlike",

	paramtype = "light",
	-- ^ Allows light to propagate through the node with the
	--   light value falling by 1 per node.

	sunlight_propagates = true, -- Sunlight shines through
	walkable     = false, -- Would make the player collide with the air node
	pointable    = false, -- You can't select the node
	diggable     = false, -- You can't dig the node
	buildable_to = true,  -- Nodes can be replace this node.
	                      -- (you can place a node and remove the air node
	                      -- that used to be there)

	air_equivalent = true,
	drop = "",
	groups = {not_in_creative_inventory=1}
})

-- Some properties have been removed as they are beyond the scope of this chapter.
minetest.register_node(":default:water_source", {
	drawtype = "liquid",
	paramtype = "light",

	inventory_image = minetest.inventorycube("default_water.png"),
	-- ^ this is required to stop the inventory image from being animated

	tiles = {
		{
			name = "default_water_source_animated.png",
			animation = {
				type     = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length   = 2.0
			}
		}
	},

	special_tiles = {
		-- New-style water source material (mostly unused)
		{
			name      = "default_water_source_animated.png",
			animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 2.0},
			backface_culling = false,
		}
	},

	--
	-- Behavior
	--
	walkable     = false, -- The player falls through
	pointable    = false, -- The player can't highlight it
	diggable     = false, -- The player can't dig it
	buildable_to = true,  -- Nodes can be replace this node

	alpha = 160,

	--
	-- Liquid Properties
	--
	drowning = 1,
	liquidtype = "source",

	liquid_alternative_flowing = "default:water_flowing",
	-- ^ when the liquid is flowing

	liquid_alternative_source = "default:water_source",
	-- ^ when the liquid is a source

	liquid_viscosity = WATER_VISC,
	-- ^ how far

	post_effect_color = {a=64, r=100, g=100, b=200},
	-- ^ color of screen when the player is submerged
})

minetest.register_node("mymod:obsidian_glass", {
	description = "Obsidian Glass",
	drawtype = "glasslike",
	tiles = {"default_obsidian_glass.png"},
	paramtype = "light",
	is_ground_content = false,
	sunlight_propagates = true,
	sounds = default.node_sound_glass_defaults(),
	groups = {cracky=3,oddly_breakable_by_hand=3},
})

minetest.register_node("mymod:glass", {
	description = "Glass",
	drawtype = "glasslike_framed",

	tiles = {"default_glass.png", "default_glass_detail.png"},
	inventory_image = minetest.inventorycube("default_glass.png"),

	paramtype = "light",
	sunlight_propagates = true, -- Sunlight can shine through block
	is_ground_content = false, -- Stops caves from being generated over this node.

	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults()
})

minetest.register_node("mymod:leaves", {
	description = "Leaves",
	drawtype = "allfaces_optional",
	tiles = {"default_leaves.png"}
})

minetest.register_node("mymod:torch", {
	description = "Foobar Torch",
	drawtype = "torchlike",
	tiles = {
		{"foobar_torch_floor.png"},
		{"foobar_torch_ceiling.png"},
		{"foobar_torch_wall.png"}
	},
	inventory_image = "foobar_torch_floor.png",
	wield_image = "default_torch_floor.png",
	light_source = LIGHT_MAX-1,

	-- Determines how the torch is selected, ie: the wire box around it.
	-- each value is { x1, y1, z1, x2, y2, z2 }
	-- (x1, y1, y1) is the bottom front left corner
	-- (x2, y2, y2) is the opposite - top back right.
	-- Similar to the nodebox format.
	selection_box = {
		type = "wallmounted",
		wall_top = {-0.1, 0.5-0.6, -0.1, 0.1, 0.5, 0.1},
		wall_bottom = {-0.1, -0.5, -0.1, 0.1, -0.5+0.6, 0.1},
		wall_side = {-0.5, -0.3, -0.1, -0.5+0.3, 0.3, 0.1},
	}
})

minetest.register_node("mymod:stair_stone", {
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
			{-0.5, 0, 0, 0.5, 0.5, 0.5},
		},
	}
})

minetest.register_node("mymod:sign", {
	drawtype = "nodebox",
	node_box = {
		type = "wallmounted",

		-- Ceiling
		wall_top    = {
			{-0.4375, 0.4375, -0.3125, 0.4375, 0.5, 0.3125}
		},

		-- Floor
		wall_bottom = {
			{-0.4375, -0.5, -0.3125, 0.4375, -0.4375, 0.3125}
		},

		-- Wall
		wall_side   = {
			{-0.5, -0.3125, -0.4375, -0.4375, 0.3125, 0.4375}
		}
	},
})
