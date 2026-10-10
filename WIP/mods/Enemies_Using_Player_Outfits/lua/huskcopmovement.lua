local ThisModPath = ModPath

local __Name = function(__id)
	return "E_"..Idstring(string.format('%q %q', tostring(__id), ThisModPath)):key()
end

local ThisModName = __Name("Enemies_Using_Player_Outfits")

_G[ThisModName] = _G[ThisModName] or {}

local ids_unit = Idstring("unit")

function CopMovement:set_player_style_alt_mod(__data)
	if not self._unit or not alive(self._unit) then
		return
	end
	local character_name = "dallas"
	local glove_id = "heist_default" --[[table.random_key(tweak_data.blackmarket.gloves)
	if not type(tweak_data.blackmarket.gloves[glove_id]) == "table" or not type(tweak_data.blackmarket.gloves[glove_id].unit) == "string" or not DB:has(ids_unit, Idstring(tweak_data.blackmarket.gloves[glove_id].unit)) then
		glove_id = "heist_default"
	end
	managers.dyn_resource:load(ids_unit, Idstring(tweak_data.blackmarket.gloves[glove_id].unit), DynamicResourceManager.DYN_RESOURCES_PACKAGE, function()

	end)]]
	local visual_state = {
		is_local_peer = false,
		visual_seed = CriminalsManager.get_new_visual_seed(),
		player_style = __data.player_style,
		suit_variation = __data.suit_variation,
		glove_id = glove_id,
		mask_id = "none",
		armor_id = "level_1",
		armor_skin = "none"
	}
	local spawn_manager = self._unit:spawn_manager()
	local unit_damage = self._unit:damage()
	if spawn_manager and unit_damage then
		pcall(CriminalsManager.set_character_visual_state, self._unit, character_name, visual_state)
		local char_mesh_unit = spawn_manager:get_unit("char_mesh")
		if char_mesh_unit and alive(char_mesh_unit) then
			if self._unit:base()._tweak_table ~= "spooc" then
				if self._unit:get_object(Idstring("g_body")) then
					self._unit:get_object(Idstring("g_body")):set_visibility(false)
				end
			end
		end
	end
end

Hooks:PostHook(CopMovement, "set_character_anim_variables", __Name(1), function(self)
	if CopDamage.is_cop(self._unit:base()._tweak_table) then
		local u_key = self._unit:name():key()
		_G[ThisModName].ThisModMenuSave[u_key] = _G[ThisModName].ThisModMenuSave[u_key] or {}
		local possible_ply_style_name = {}
		for ply_style_name, ply_style_onoff in pairs(_G[ThisModName].ThisModMenuSave[u_key]) do
			if tonumber(tostring(ply_style_onoff)) == 1 then
				possible_ply_style_name[ply_style_name] = true
			end
		end
		local use_this_player_style = table.random_key(possible_ply_style_name)
		local player_style_unit_name = tweak_data.blackmarket:get_player_style_value(use_this_player_style, "dallas", "third_unit")
		player_style_unit_name = tostring(player_style_unit_name)
		if DB:has(ids_unit, Idstring(player_style_unit_name)) then
			if managers.dyn_resource:is_resource_ready(ids_unit, Idstring(player_style_unit_name), managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
				local tmp_ps = tweak_data.blackmarket.player_styles[use_this_player_style].material_variations
				local use_this_suit_variation = type(tmp_ps) == "table" and table.random_key(tmp_ps) or "default"
				call_on_next_update(callback(self, self, "set_player_style_alt_mod", {player_style = use_this_player_style, suit_variation = use_this_suit_variation}))
				log("u_key", u_key, "load", "use_this_player_style", use_this_player_style)
			else
				managers.dyn_resource:load(ids_unit, Idstring(player_style_unit_name), DynamicResourceManager.DYN_RESOURCES_PACKAGE)
				log("u_key", u_key, "loading", "use_this_player_style", use_this_player_style)
			end
		end
	end
end)

HuskCopMovement.set_player_style_alt_mod = HuskCopMovement.set_player_style_alt_mod or CopMovement.set_player_style_alt_mod

Hooks:PostHook(HuskCopMovement, "set_character_anim_variables", __Name(2), function(self)
	CopMovement.set_character_anim_variables(self)
end)