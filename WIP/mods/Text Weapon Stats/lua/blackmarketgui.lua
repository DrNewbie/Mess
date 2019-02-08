_G.RWSN2W = _G.RWSN2W or {}

function RWSN2W:Run(data)
	local RunMeNow = function(weapon_data, stat_name, stat_data, them)
		if stat_name == "damage" then
			local damage_e = tonumber(stat_data.equip)
			if damage_e then
				if damage_e > 9000 then
					self:Set(them, "damage", "IT'S OVER 9000!!!!!", Color(1, 0, 0))
				elseif damage_e > 4000 then
					self:Set(them, "damage", "IT'S CLOSE TO 9000!!", Color(1, 1, 0))
				elseif damage_e <= 40 then
					self:Set(them, "damage", "I'd rather kill myself", Color(0, 1, 1))
				end
			end
		end	
	end
	local weapon_data = data.weapon_data
	--[[
		weapon_id	string
		factory_id	string
		blueprint	table
	]]
	local stat_name = data.stat_name
	--[[
		"concealment", "suppression", "totalammo",
		"recoil", "spread", "reload", "damage",
		"fire_rate", "magazine"
	]]
	local stat_data = data.stat_data
	--[[equip, total, mods, base, skill, name, removed]]
	local them = data.them
	--[[BlackMarketGui]]
	RunMeNow(weapon_data, stat_name, stat_data, them)
end

function RWSN2W:Set(them, stat_name, txt, color)
	if txt then
		them._stats_texts[stat_name].base:set_text("")
		them._stats_texts[stat_name].mods:set_text("")
		them._stats_texts[stat_name].skill:set_text("")
		them._stats_texts[stat_name].equip:set_text(txt)
		them._stats_texts[stat_name].equip:set_size(200, 20)
		them._stats_texts[stat_name].equip:parent():set_w(200)
	end
	if color then
		them._stats_texts[stat_name].equip:set_color(color)
	end
end

function BlackMarketGui:RWSN2W()
	if type(Global.blackmarket_manager) == "table" and type(Global.blackmarket_manager.crafted_items) == "table" and type(self._stats_shown) == "table" and type(self._slot_data) == "table" and type(self._slot_data.slot) == "number" and type(self._slot_data.category) == "string" then
		local craft = Global.blackmarket_manager.crafted_items
		local slot = self._slot_data.slot
		local cat = self._slot_data.category
		if craft[cat] and craft[cat][slot] then			
			for i, stat in pairs(self._stats_shown) do
				RWSN2W:Run({
					weapon_data = {
						weapon_id = craft[cat][slot].weapon_id,
						factory_id = craft[cat][slot].factory_id,
						blueprint = craft[cat][slot].blueprint
					},
					stat_name = stat.name,
					stat_data = {
						total = tostring(self._stats_texts[stat.name].total:text()),
						mods = tostring(self._stats_texts[stat.name].mods:text()),
						base = tostring(self._stats_texts[stat.name].base:text()),
						skill = tostring(self._stats_texts[stat.name].skill:text()),
						name = tostring(self._stats_texts[stat.name].name:text()),
						removed = tostring(self._stats_texts[stat.name].removed:text()),
						equip = tostring(self._stats_texts[stat.name].equip:text())
					},
					them = self
				})
			end
		end
	end
end

Hooks:PostHook(BlackMarketGui, "show_stats", "RWSN2W_PostHook_show_stats", function(self)
	self:RWSN2W(1)
end)

Hooks:PostHook(BlackMarketGui, "_update_borders", "RWSN2W_PostHook_update_borders", function(self)
	self:RWSN2W(2)
end)

Hooks:PostHook(BlackMarketGui, "update_info_text", "RWSN2W_PostHook_set_info_text", function(self)
	self:RWSN2W(3)
end)

Hooks:PostHook(BlackMarketGui, "_setup", "RWSN2W_PostHook_setup", function(self)
	self:RWSN2W(4)
end)