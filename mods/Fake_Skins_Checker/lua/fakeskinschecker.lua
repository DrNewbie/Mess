function cosmeticsid2all(loadout)
	data_using = tweak_data.blackmarket.weapon_skins[loadout]
	for id, data in pairs( tweak_data.weapon ) do
		if tostring(id) == data_using.weapon_id then
			weapon_name = managers.localization:to_upper_text(data.name_id)
			break
		end
	end
	for id, data in pairs( tweak_data.economy.contents ) do
		for id2, data2 in pairs( data.contains.weapon_skins ) do
			if tostring(data2) == loadout then
				safes_name = tostring(id)
			break
			end
		end
	end
	for id, data in pairs( tweak_data.economy.safes ) do
		if tostring(id) == safes_name then
			safes_name = managers.localization:to_upper_text(data.name_id)
			break
		end
	end
	skins_name = managers.localization:text(data_using.name_id)
	return weapon_name, skins_name, safes_name
end

function download_data(peer)
	local _bool = false
	dohttpreq( "http://steamcommunity.com/profiles/" .. peer:user_id() .. "/inventory/json/218620/2/", function( data, id )
		local f = io.open( "mods/Fake Skins Checker/".. peer:id() .."_list.ini", "w+" )
		if f ~= nil then
			data = data:gsub( "\r\n+", "\n" )
			data = data:gsub( "{", "{\n" )
			data = data:gsub( "}", "}\n" )
			data = data:gsub( "\",\"", "\",\n\"" )
			f:write( data )
			f:close()
		end
	end)
end

function checkskins_func(peer)
	if managers.network and managers.network:session() then
		local outfit, tweak, _bool, primary, primary_color, secondary, secondary_color
		_bool = false
		if peer:has_blackmarket_outfit() then
			outfit = peer:blackmarket_outfit()
			local color_data = {
				["common"] = "2360D8",
				["uncommon"] = "9900FF",
				["rare"] = "FF00FF",
				["epic"] = "FF0000",
				["legendary"] = "FFAA00"
			}
			for _, weapon in ipairs({"primary", "secondary"}) do
				if outfit[weapon] and outfit[weapon].cosmetics then
					tweak = tweak_data.blackmarket.weapon_skins[outfit[weapon].cosmetics.id]
					if tweak then
						_bool = true
						if weapon == "primary" then
							primary = outfit[weapon].cosmetics.id
							primary_color = color_data[tweak.rarity]
						elseif weapon == "secondary" then
							secondary = outfit[weapon].cosmetics.id
							secondary_color = color_data[tweak.rarity]
						else
						end						
					end
				end
			end
			local primary_search1, primary_search2, secondary_search1, secondary_search2 = "", "", "", ""
			if _bool == true then
				if primary then	
					local weapon_name, skins_name, safes_name = cosmeticsid2all(primary)
					primary_search1 = "\"market_name\":\"".. "" .. tostring(weapon_name) .. " | " .. tostring(skins_name) .. ""
					primary_search2 = "\"name_color\":\"" .. primary_color
				end
				if secondary then
					local weapon_name, skins_name, safes_name = cosmeticsid2all(secondary)					
					secondary_search1 = "\"market_name\":\"".. "" .. tostring(weapon_name) .. " | " .. tostring(skins_name) .. ""
					secondary_search2 = "\"name_color\":\"" .. secondary_color
				end
			end
			local f = io.open( "mods/Fake Skins Checker/".. peer:id() .."_list.ini", "r" )
			local line = nil
			local _txt = ""
			local _p, _s = false, false
			local _s_0, _s_1, _s_2 = false, false, false
			if f and _bool then
				line = f:read()
				while line do
					_txt = tostring(line)
					if _s_0 or _txt:find( "success\":true," ) then
						_s_0 = true
						_p = (primary_search1 and _txt:find( primary_search1 ))
						_s = (secondary_search1 and _txt:find( secondary_search1 ))
						if _p or _s then
							line = f:read()
							_txt = tostring(line)
							if primary_search2 and _txt:find( primary_search2 ) and _p then
								_s_1 = true
							end
							if secondary_search2 and _txt:find( secondary_search2 ) and _s then
								_s_2 = true
							end
						end
					end
					line = f:read()
				end
				f:close()
				if _s_0 then
					if primary then
						if _s_1 then
							managers.chat:_receive_message(1, "[Skin Checker]", "I find match primary weapon skins from '" .. peer:name() .. "'", Color.white)
						else
							managers.chat:_receive_message(1, "[Skin Checker]", "I can't find match primary weapon skins from '" .. peer:name() .. "'", Color.white)
						end
					end
					if secondary then
						if _s_2 then
							managers.chat:_receive_message(1, "[Skin Checker]", "I find match secondary weapon skins from '" .. peer:name() .. "'", Color.white)
						else
							managers.chat:_receive_message(1, "[Skin Checker]", "I can't find match secondary weapon skins from '" .. peer:name() .. "'", Color.white)
						end
					end
				else
					managers.chat:_receive_message(1, "[Skin Checker]", "'" .. peer:name() .. "' hide his data.", Color.white)
				end
			else
				managers.chat:_receive_message(1, "[Skin Checker]", "I can't check '" .. peer:name() .. "' data, the reason maybe there is no data or he doesn't use weapon skins.", Color.white)
			end
		end
	end
end

if RequiredScript == "lib/setups/menusetup" or RequiredScript == "core/lib/utils/coreclass" then
	if managers.menu then
		managers.menu:open_fakeskinschecker_menu()
	end
end

if RequiredScript == "lib/managers/menumanager" then
	function MenuManager:open_fakeskinschecker_menu()
		if managers.network and managers.network:session() then
			
			managers.menu_component:post_event("menu_enter")
			
			if not SimpleMenu then
				SimpleMenu = class()
			 
				function SimpleMenu:init(title, message, options)
					self.dialog_data = { title = title, text = message, button_list = {},
						id = tostring(math.random(0,0xFFFFFFFF)) }
					self.visible = false
					for _,opt in ipairs(options) do
						local elem = {}
						elem.text = opt.text
						opt.data = opt.data or nil
						opt.callback = opt.callback or nil
						elem.callback_func = callback(self, self, "_do_callback",
									  { data = opt.data,
										callback = opt.callback})
						elem.cancel_button = opt.is_cancel_button or false
						if opt.is_focused_button then
						self.dialog_data.focus_button = #self.dialog_data.button_list+1
						end
						table.insert(self.dialog_data.button_list, elem)
					end
				return self
				end
			 
				function SimpleMenu:_do_callback(info)
				if info.callback then
					if info.data then
					info.callback(info.data)
					else
					info.callback()
					end
				end
				self.visible = false
				end
			 
				function SimpleMenu:show()
				if self.visible then
					return
				end
				self.visible = true
				managers.system_menu:show(self.dialog_data)
				end
			 
				function SimpleMenu:hide()
				if self.visible then
					managers.system_menu:close(self.dialog_data.id)
					self.visible = false
					return
				end
				end
			end 

			optiowho = optiowho or function(data)
				managers.menu_component:post_event("menu_enter")
				if data then
					local opts = {}
					opts[#opts+1] = { text = "Download data", data = data, callback = optiondownload }
					opts[#opts+1] = { text = "Check data", data = data, callback = optioncheck }
					opts[#opts+1] = { text = "CANCEL", is_cancel_button = true }
					mymenu = SimpleMenu:new("Fake Skins Checker", "Choose what you want to do", opts)
					mymenu:show()
				end
			end
			
			optiondownload = optiondownload or function(data)
				managers.menu_component:post_event("menu_enter")
				if data then
					download_data(data)
					managers.chat:_receive_message(1, "[Skin Checker]", "Download data from '" .. data:name() .. "'", Color.white)
				end
			end
			
			optioncheck = optioncheck or function(data)
				managers.menu_component:post_event("menu_enter")
				if data then
					checkskins_func(data)
				end
			end

			function _createmenu()
				local opts = {}
				local _txt = ""
				for i = 1, 4 do
					local peer = managers.network:session():peer(i) or nil
					if peer then
						opts[#opts+1] = { text = "" .. peer:name(), data = peer, callback = optiowho }
					end
				end

				opts[#opts+1] = { text = "CANCEL", is_cancel_button = true }
				mymenu = SimpleMenu:new("Fake Skins Checker", "Choose someone you want to check", opts)
				mymenu:show()
			end
			
			_createmenu()
		end
	end
end