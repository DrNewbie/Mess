if Network:is_client() then
	return
end

HeavySecurity = HeavySecurity or {
	options_menu = "HeavySecurity_menu_id",
	ModPath = ModPath,
	SaveFile = SavePath.."HeavySecurity.txt",
	settings = {}	
}

function HeavySecurity:Default()
	return {
		Level = 1,
		Enemy_Type = 1,
		Enable = true,
		AllEnemies = false,
		AllCivilians = false,
		AddonFollower = 0
	}
end

function HeavySecurity:Save()
	local file = io.open(self.SaveFile, "w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

function HeavySecurity:Reset()
	self.settings = self:Default()
	self:Save()
end

function HeavySecurity:Load()
	local file = io.open(self.SaveFile, "r")
	if file then
		self.settings = self:Default()
		for key, value in pairs(json.decode(file:read("*all"))) do
			if type(value) == type(self:Default()[key]) then
				self.settings[key] = value
			end
		end
		file:close()
	else
		self:Reset()
	end
end

HeavySecurity:Load()

function HeavySecurity:Spawn(_cop, them, special_target)
	local _spawn_list = {
		"units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1",
		"units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2",
		"units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3",
		"units/payday2/characters/ene_spook_1/ene_spook_1",
		"units/payday2/characters/ene_shield_2/ene_shield_2",
		"units/payday2/characters/ene_tazer_1/ene_tazer_1",
		"units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun",
		"units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic"
	}
	local _spawn_select
	if _spawn_list[self.settings.Enemy_Type] then
		_spawn_select = Idstring(_spawn_list[self.settings.Enemy_Type])
	end
	if self.settings.Enemy_Type == 10 or self.settings.Enemy_Type == 11 then
		table.insert(_spawn_list, "units/payday2/characters/ene_sniper_1/ene_sniper_1")
		table.insert(_spawn_list, "units/payday2/characters/ene_sniper_2/ene_sniper_2")
		table.insert(_spawn_list, "units/payday2/characters/ene_shield_1/ene_shield_1")
	end
	if self.settings.Enemy_Type == 10 then
		_spawn_select = Idstring(_spawn_list[math.random(#_spawn_list)])
	end
	local _u, team_id
	local new_objective = {
		type = "follow",
		follow_unit = _cop,
		scan = true,
		is_default = true
	}
	if self.settings.Enemy_Type == 12 then
		_spawn_select = _cop:name()
	end
	if self.settings.Enemy_Type == 9 then
		if math.random() > 0.5 then
			_spawn_select = Idstring("units/payday2/characters/ene_sniper_1/ene_sniper_1")
		else
			_spawn_select = Idstring("units/payday2/characters/ene_sniper_2/ene_sniper_2")			
		end
	elseif self.settings.Enemy_Type == 5 then
		if math.random() > 0.5 then
			_spawn_select = Idstring("units/payday2/characters/ene_shield_1/ene_shield_1")
		else
			_spawn_select = Idstring("units/payday2/characters/ene_shield_2/ene_shield_2")			
		end
	elseif self.settings.Enemy_Type == 11 then
		_spawn_select = Idstring(_spawn_list[math.random(#_spawn_list)])
	end
	if special_target then
		local _pos_offset = function ()
			local ang = math.random() * 360 * math.pi
			local rad = math.random(3, 5)
			rad = rad * 800
			return Vector3(math.cos(ang) * rad, math.sin(ang) * rad, 0)
		end
		_u = safe_spawn_unit(_spawn_select, special_target:position() + _pos_offset(), special_target:rotation())
		new_objective.follow_unit = special_target
	else
		_u = safe_spawn_unit(_spawn_select, them:get_orientation())
	end	
	if _u then
		if not team_id then
			team_id = tweak_data.levels:get_default_team_ID(_u:base():char_tweak().access == "gangster" and "gangster" or "combatant")
		end
		if them._values.participate_to_group_ai then
			managers.groupai:state():assign_enemy_to_group_ai(_u, team_id)
		else
			managers.groupai:state():set_char_team(_u, team_id)
		end
		_u:brain():set_spawn_ai( { init_state = "idle", params = { scan = true }, objective = new_objective } )
		_u:brain():on_reload()
		_u:brain():terminate_all_suspicion()
		_u:movement():set_cool(true)
		_u:brain():on_cool_state_changed(true)
		managers.groupai:state():_clear_criminal_suspicion_data()
	end
	return _u
end

Hooks:Add("LocalizationManagerPostInit", "HeavySecurity_loc", function(Loc)
	Loc:load_localization_file(HeavySecurity.ModPath.."loc.EN.json")
end)

Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_HeavySecurityOptions", function()
	MenuCallbackHandler.HeavySecurity_menu_back_callback = function()
		HeavySecurity:Save()
	end
	MenuCallbackHandler.HeavySecurity_menu_enable_callback = function(_, item)
		HeavySecurity.settings.Enable = tostring(item:value()) == 'on' and true or false
	end
	MenuCallbackHandler.HeavySecurity_menu_level_callback = function(_, item)
		HeavySecurity.settings.Level = math.floor(item:value())
	end
	MenuCallbackHandler.HeavySecurity_menu_enemy_type_callback = function(_, item)
		HeavySecurity.settings.Enemy_Type = item:value()
	end
	MenuCallbackHandler.HeavySecurity_menu_apply2allenemies_callback = function(_, item)
		HeavySecurity.settings.AllEnemies = tostring(item:value()) == 'on' and true or false
	end
	MenuCallbackHandler.HeavySecurity_menu_apply2allcivilians_callback = function(_, item)
		HeavySecurity.settings.AllCivilians = tostring(item:value()) == 'on' and true or false
	end
	MenuCallbackHandler.HeavySecurity_menu_addonfollower_callback = function(_, item)
		HeavySecurity.settings.AddonFollower = math.floor(item:value())
	end
	MenuHelper:LoadFromJsonFile(HeavySecurity.ModPath.."menu.Main.json", HeavySecurity, HeavySecurity.settings)
end)

if Announcer then
	Announcer:AddHostMod("Heavy Security, ( https://modworkshop.net/mod/16274 )")
end