local mod_ids = Idstring("Phlogistinator Weapon Mod"):key()
local is_mod = "F_"..Idstring("is_mod:"..mod_ids):key()
local func5 = "F_"..Idstring("func5:"..mod_ids):key()
local func6 = "F_"..Idstring("func6:"..mod_ids):key()
local func7 = "F_"..Idstring("func7:"..mod_ids):key()
local func20 = "F_"..Idstring("func20:"..mod_ids):key()
local func40 = "F_"..Idstring("func40:"..mod_ids):key()

Hooks:PostHook(PlayerStandard, "_check_action_steelsight", func20, function(self, t, input)
	if alive(self._equipped_unit) then
		local weap_base = self._equipped_unit:base()
		if input.btn_steelsight_press then
			if not weap_base[func6] and type(weap_base[func5]) == "number" and weap_base[func5] > 1000 and weap_base[is_mod] then
				managers.player:local_player():sound_source():post_event("pyro_paincrticialdeath01")
				weap_base[func40] = false
				weap_base[func6] = true
				weap_base[func5] = 0
				weap_base[func7] = managers.player:player_timer():time() + 8
				local obj = {}
				for _, wd in pairs(weap_base._blueprint) do
					if tweak_data.weapon.factory.parts[wd] then
						table.insert(obj, tweak_data.weapon.factory.parts[wd].a_obj)
					end
				end
				local aobjs = {}
				for i = 1, 3 do
					local key = table.random_key(obj)
					if obj[key] then
						table.insert(aobjs, obj[key])
						obj[key] = nil
					end
				end
				for _, aobj in pairs(aobjs) do
					World:effect_manager():spawn({
						effect = Idstring("effects/payday2/particles/character/taser_thread"),
						parent = self._equipped_unit:get_object(Idstring(aobj))
					})
				end
			end
		end
	end
end)