-- Show form when the /formspec command is used.
minetest.register_chatcommand("formspec", {
	func = function(name, param)
		minetest.show_formspec(name, "first_formspec:form",
				"size[4,3]" ..
				"label[0,0;Hello, " .. name .. "]" ..
				"field[1,1.5;3,1;name;Name;]" ..
				"button_exit[1,2;2,1;exit;Save]")
	end
})

-- Register callback
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "first_formspec:form" then
		-- Formname is not mymod:form,
		-- exit callback.
		return false
	end

	-- Send message to player.
	minetest.chat_send_player(player:get_player_name(), "You said: " .. fields.name .. "!")

	-- Return true to stop other minetest.register_on_player_receive_fields
	-- from receiving this submission.
	return true
end)
