local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if Network:is_client() then
	return
end

_G.KeepItClean = _G.KeepItClean or {}
KeepItClean.path = ModPath
KeepItClean.data_path = SavePath .. 'keep_it_clean.txt'
KeepItClean.settings = {
	attractiveness = 1,
	cops_in_disguise = 2,
}
KeepItClean.attractiveness_rate = { 0.02, 0.04, 0.06 }
KeepItClean.cops_in_disguise_chance = { 0.05, 0.1, 0.2, 0.5, 1 }
KeepItClean.civilians_killed_by_player = {}
KeepItClean.civilians_to_avenge_nr = 0
KeepItClean.winters = {
	can_be_modified = true,
	next_modifier = 1,
	max_modifier = 3,
	original_increase_intervall = tweak_data.group_ai.phalanx.vip.damage_reduction.increase_intervall,
	original_respawn_delay = 600, -- ignore phalanx.spawn_chance.respawn_delay, once engaged, set a nice cooldown of 10 mins
	original_spawn_chance_increase = tweak_data.group_ai.phalanx.spawn_chance.increase
}

function KeepItClean:load()
	local file = io.open(self.data_path, 'r')
	if file then
		for k, v in pairs(json.decode(file:read('*all')) or {}) do
			self.settings[k] = v
		end
		file:close()
	end
end

function KeepItClean:save()
	local file = io.open(self.data_path, 'w+')
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

KeepItClean:load()

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_KeepItClean', function(loc)
	local language_filename
	for _, filename in pairs(file.GetFiles(KeepItClean.path .. 'loc/')) do
		local str = filename:match('^(.*).txt$')
		if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
			language_filename = filename
			break
		end
	end

	if language_filename then
		loc:load_localization_file(KeepItClean.path .. 'loc/' .. language_filename)
	end
	loc:load_localization_file(KeepItClean.path .. 'loc/english.txt', false)
end)

Hooks:Add('MenuManagerInitialize', 'MenuManagerInitialize_KeepItClean', function(menu_manager)
	MenuCallbackHandler.KeepItClean_set_cops_in_disguise = function(this, item)
		KeepItClean.settings.cops_in_disguise = item:value()
	end

	MenuCallbackHandler.KeepItClean_set_attractiveness = function(this, item)
		KeepItClean.settings.attractiveness = item:value()
	end

	MenuCallbackHandler.KeepItClean_save = function(this, item)
		KeepItClean:save()
	end

	MenuHelper:LoadFromJsonFile(KeepItClean.path .. 'menu/options.txt', KeepItClean, KeepItClean.settings)
end)

function KeepItClean:set_winters_modifiable(state)
	self.winters.can_be_modified = state
end

function KeepItClean:is_winters_modifiable()
	return self.civilians_to_avenge_nr > 0 and self.winters.can_be_modified
end

function KeepItClean:change_winters_modifier()
	self.winters.next_modifier = self.winters.next_modifier + 1
	if self.winters.next_modifier > self.winters.max_modifier then
		self.winters.next_modifier = 1
		self:set_winters_modifiable(false)
	end
end

function KeepItClean:modify_winters()
	if self.winters.next_modifier == 1 then
		tweak_data.group_ai.phalanx.vip.damage_reduction.increase_intervall = self.winters.original_increase_intervall / 2
		tweak_data.group_ai.phalanx.spawn_chance.respawn_delay = 240
		tweak_data.group_ai.phalanx.spawn_chance.increase = 0.2
	elseif self.winters.next_modifier == 2 then
		tweak_data.group_ai.phalanx.spawn_chance.respawn_delay = 120
		tweak_data.group_ai.phalanx.vip.damage_reduction.increase_intervall = self.winters.original_increase_intervall / 5
	elseif self.winters.next_modifier == 3 then
		tweak_data.group_ai.phalanx.spawn_chance.increase = 0.4
	else
		return
	end

	self.civilians_to_avenge_nr = self.civilians_to_avenge_nr - 1

	self:change_winters_modifier()
end

function KeepItClean:update_winters()
	if self:is_winters_modifiable() then
		self:modify_winters()
	end
end

function KeepItClean:on_civilian_killed(civilian_unit, peer)
	local steam_id = peer:user_id()
	local ck_nr = self.civilians_killed_by_player[steam_id] or 0
	self.civilians_killed_by_player[steam_id] = ck_nr + 1

	self.civilians_to_avenge_nr = self.civilians_to_avenge_nr + 1

	self:update_winters()
end

function KeepItClean:reset_winters()
	managers.groupai:state()._phalanx_current_spawn_chance = 0.25 -- GroupAIStateBesiege:phalanx_despawned() doesn't reset it
	tweak_data.group_ai.phalanx.vip.damage_reduction.increase_intervall = self.winters.original_increase_intervall
	tweak_data.group_ai.phalanx.spawn_chance.respawn_delay = self.winters.original_respawn_delay
	tweak_data.group_ai.phalanx.spawn_chance.increase = self.winters.original_spawn_chance_increase

	self:set_winters_modifiable(true)
	self:update_winters()
end
