_G.RWSN2W = _G.RWSN2W or {}

function RWSN2W:ReplaceWepStatsNumber2Words(data)
	local weapon_data = data.weapon_data
	local stat_name = data.stat_name
	local stat_data = data.stat_data
	local them = data.them
--==============================================--
--==============================================--
	if stat_name == "damage" then
		local damage_e = tonumber(stat_data.equip)
		if damage_e and damage_e > 400 then
			them._stats_texts[stat_name].base:set_text("")
			them._stats_texts[stat_name].mods:set_text("")
			them._stats_texts[stat_name].skill:set_text("")
			them._stats_texts[stat_name].equip:set_size(90, 20)
			them._stats_texts[stat_name].equip:set_text("xxabcdefghijkzz")
			them._stats_texts[stat_name].equip:set_color(Color(1, 0, 0))
		end
	end
end

function BlackMarketGui:HookReplaceWepStatsNumber2Words()
	if type(Global.blackmarket_manager) == "table" and type(Global.blackmarket_manager.crafted_items) == "table" and type(self._stats_shown) == "table" and type(self._slot_data) == "table" and type(self._slot_data.slot) == "number" and type(self._slot_data.category) == "string" then
		local craft = Global.blackmarket_manager.crafted_items
		local slot = self._slot_data.slot
		local cat = self._slot_data.category
		if craft[cat] and craft[cat][slot] then			
			for i, stat in pairs(self._stats_shown) do
				RWSN2W:ReplaceWepStatsNumber2Words({
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
					--[[
					stat.name = {
						"concealment",
						"suppression",
						"totalammo",
						"recoil",
						"spread",
						"reload",
						"damage",
						"fire_rate",
						"magazine"
					}
					]]
					them = self
				})
			end
		end
	end
end

Hooks:PostHook(BlackMarketGui, "show_stats", "RWSN2W_PostHook_show_stats", function(self)
	self:HookReplaceWepStatsNumber2Words()
end)

Hooks:PostHook(BlackMarketGui, "_update_borders", "RWSN2W_PostHook_update_borders", function(self)
	self:HookReplaceWepStatsNumber2Words()
end)

Hooks:PostHook(BlackMarketGui, "update_info_text", "RWSN2W_PostHook_set_info_text", function(self)
	self:HookReplaceWepStatsNumber2Words()
end)

Hooks:PostHook(BlackMarketGui, "_setup", "RWSN2W_PostHook_setup", function(self)
	self:HookReplaceWepStatsNumber2Words()
end)