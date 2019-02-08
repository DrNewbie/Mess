_G.RWSN2W = _G.RWSN2W or {}
RWSN2W.ModPath = ModPath
RWSN2W.Configs = RWSN2W.Configs or {}

function RWSN2W:Add(id, func)
	if not func then
		return
	end
	if not id then
		id = Idstring("RWSN2W_"..tostring(func)):key()
	end
	RWSN2W.Configs[id] = func
end

function RWSN2W:Init()
	local configs = file.GetFiles(self.ModPath.."/configs/")
	for i, cfg in pairs(configs) do
		dofile(self.ModPath.."/configs/"..cfg)
	end
	--[[
	for weapon_id, data in pairs(tweak_data.weapon) do
		if type(data) == "table" and data.categories then
			tweak_data.weapon[weapon_id].desc_id = tweak_data.weapon[weapon_id].desc_id or RWSN2W_empty_desc
			tweak_data.weapon[weapon_id].has_description = true
		end
	end
	]]
end

function RWSN2W:Run(data)
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
	for i, func in pairs(self.Configs) do
		func(weapon_data, stat_name, stat_data, them)
	end
end

function RWSN2W:Simple_Set(them, stat_name, txt, color)
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

function RWSN2W:Simple_Set_Weapon_Title(them, txt, color)
	if not them._info_texts or not them._info_texts[1] then
		return
	end
	if txt then
		them._info_texts[1]:set_text(txt)
	end
	if color then
		them._info_texts[1]:set_color(color)
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

RWSN2W:Init()

--[[
Hooks:Add("LocalizationManagerPostInit", "RWSN2W_AddMyLoc", function(loc)
	loc:add_localized_strings({
		RWSN2W_empty_desc = ""
	})
end)
]]