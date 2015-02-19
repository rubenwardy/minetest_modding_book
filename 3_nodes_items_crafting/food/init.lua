minetest.register_craftitem("mymod:mudpie", {
	description = "Alien Mud Pie",
	inventory_image = "myfood_mudpie.png",
	on_use = minetest.item_eat(20)
})

minetest.register_craftitem("mymod:mudpie_ex", {
	description = "Alien Mud Pie Extended",
	inventory_image = "myfood_mudpie.png",
	on_use = function(itemstack, user, pointed_thing)
		hp_change = 20
		replace_with_item = nil

		minetest.chat_send_player(user:get_player_name(), "You ate an alien mud pie!")

		-- Support for hunger mods using minetest.register_on_item_eat
		for _, callback in pairs(minetest.registered_on_item_eats) do
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
