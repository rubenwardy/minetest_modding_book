minetest.register_node("aliens:grass", {
	description = "Alien Grass",
	light_source = 3, -- The node radiates light. Values can be from 1 to 15
	tiles = {"aliens_grass.png"},
	groups = {choppy=1},
	on_use = minetest.item_eat(20)
})

minetest.register_abm({
	nodenames = {"default:dirt_with_grass"},
	neighbors = {"default:water_source", "default:water_flowing"},
	interval = 10.0, -- Run every 10 seconds
	chance = 50, -- Select every 1 in 50 nodes
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.set_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name = "aliens:grass"})
	end
})
