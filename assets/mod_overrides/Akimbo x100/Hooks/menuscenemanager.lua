MenuSceneManager.new_unit_alt_list = MenuSceneManager.new_unit_alt_list or {}

function MenuSceneManager:AkimboWTF_Spawn(buff_unit, factory_id, blueprint)
	for _, alt in pairs(self.new_unit_alt_list) do
		alt:unlink()
		alt:set_slot(0)
		World:delete_unit(alt)
	end
	self.new_unit_alt_list = {}
	if buff_unit and buff_unit.name and factory_id and type(blueprint) == "table" then
		if not managers.dyn_resource:is_resource_ready(Idstring("unit"), buff_unit:name(), DynamicResourceManager.DYN_RESOURCES_PACKAGE) then
			managers.dyn_resource:load(Idstring("unit"), buff_unit:name(), DynamicResourceManager.DYN_RESOURCES_PACKAGE, false)
			return
		end
		local tweak_factory = tweak_data.weapon.factory.parts
		for _, f_id in pairs(blueprint) do
			if type(tweak_factory[f_id].stats) == "table" and tweak_factory[f_id].stats.akimbo_wtf_buff then
				local akimbo_wtf_buff = tweak_factory[f_id].stats.akimbo_wtf_buff
				local akimbo_wtf_link = tweak_factory[f_id].stats.akimbo_wtf_link
				local function spawn_weapon(pos, rot)
					local w_unit = World:spawn_unit(buff_unit:name(), pos, rot)
					w_unit:base():set_factory_data(factory_id)
					w_unit:base():set_cosmetics_data(cosmetics)
					w_unit:base():set_texture_switches(texture_switches)
					if blueprint then
						w_unit:base():assemble_from_blueprint(factory_id, blueprint, true)
					else
						w_unit:base():assemble(factory_id, true)
					end
					return w_unit
				end
				for i = 1, akimbo_wtf_buff do
					local new_unit_alt = spawn_weapon(buff_unit:position(), buff_unit:rotation())
					table.insert(self.new_unit_alt_list, new_unit_alt)
				end
				buff_unit:link(Idstring(akimbo_wtf_link), self.new_unit_alt_list[1], self.new_unit_alt_list[1]:orientation_object():name())
				for i = 2, akimbo_wtf_buff do
					self.new_unit_alt_list[i-1]:link(Idstring(akimbo_wtf_link), self.new_unit_alt_list[i], self.new_unit_alt_list[i]:orientation_object():name())
				end
				break
			end
		end
	end
end


Hooks:PostHook(MenuSceneManager, "set_character_equipped_weapon", "AkimboWTF_MenuScene_2", function(self, unit, factory_id, blueprint)
	for _, weapon_units in pairs(self._weapon_units) do
		for _, weapon_data in pairs(weapon_units) do
			if weapon_data.unit and weapon_data.unit:base().AKIMBO then
				self:AkimboWTF_Spawn(weapon_data.unit, factory_id, blueprint)
			end
		end
	end
end)

Hooks:PostHook(MenuSceneManager, "spawn_item_weapon", "AkimboWTF_MenuScene_1", function(self, factory_id, blueprint)
	self:AkimboWTF_Spawn(self._item_unit.unit, factory_id, blueprint)
	self:AkimboWTF_Spawn(self._item_unit.second_unit, factory_id, blueprint)
end)