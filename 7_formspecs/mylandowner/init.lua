--
-- Step 1) set context when player requests the formspec
--

-- land_formspec_context[playername] gives the player's context.
local land_formspec_context = {}

minetest.register_chatcommand("land", {
	func = function(name, param)
		if param == "" then
			minetest.chat_send_player(name, "Incorrect parameters - supply a land ID")
			return
		end

		-- Save information
		land_formspec_context[name] = {id = param}

		minetest.show_formspec(name, "mylandowner:edit",
				"size[4,4]" ..
				"field[1,1;3,1;plot;Plot Name;]" ..
				"field[1,2;3,1;owner;Owner;]" ..
				"button_exit[1,3;2,1;exit;Save]")
	end
})



--
-- Step 2) retrieve context when player submits the form
--
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "mylandowner:edit" then
		return false
	end

	-- Load information
	local context = land_formspec_context[player:get_player_name()]

	if context then
		minetest.chat_send_player(player:get_player_name(), "Id " .. context.id .. " is now called " ..
				fields.plot .. " and owned by " .. fields.owner)

		-- Delete context if it is no longer going to be used
		land_formspec_context[player:get_player_name()] = nil

		return true
	else
		-- Fail gracefully if the context does not exist.
		minetest.chat_send_player(player:get_player_name(), "Something went wrong, try again.")
	end
end)
