minetest.register_on_joinplayer(function(player)
	local idx = player:hud_add({
		hud_elem_type = "text",
		position = {x = 1, y = 0},
		offset = {x=-100, y = 20},
		scale = {x = 100, y = 100},
		text = "My Text"
	})
end)
