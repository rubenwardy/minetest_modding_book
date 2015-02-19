minetest.register_chatcommand("antigravity",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		player:set_physics_override({
			gravity = 0.1 -- set gravity to 10% of its original value
			              -- (0.1 * 9.81)
		})
	end
})
