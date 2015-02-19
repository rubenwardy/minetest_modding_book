print("This file will be run at load time!")

minetest.register_node("example:node", {
	description = "This is a node",
	tiles = {
		"mymod_node.png",
		"mymod_node.png",
		"mymod_node.png",
		"mymod_node.png",
		"mymod_node.png",
		"mymod_node.png"
	},
	groups = {cracky = 1}
})
