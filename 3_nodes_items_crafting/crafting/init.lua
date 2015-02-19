minetest.register_craftitem("mymod:diamond_chair", {
	description = "Diamond Chair",
	inventory_image = "mymod_diamond_chair.png"
})

minetest.register_craft({
	output = "mymod:diamond_chair 99",
	recipe = {
		{"mymod:diamond_fragments", "", ""},
		{"mymod:diamond_fragments", "mymod:diamond_fragments", ""},
		{"mymod:diamond_fragments", "mymod:diamond_fragments",  ""}
	}
})
