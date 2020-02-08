DelayedCalls:Add('DelayedModFCSCM_whispermode', 0, function()
	if managers.groupai then
		managers.groupai:state():add_listener('DelayedModFCSCM_enemyweaponshot', {'enemy_weapons_hot'}, callback(ModifierLessConcealment, ModifierLessConcealment, 'on_enemy_weapons_hot'))
	end
end)

function ModifierLessConcealment:on_enemy_weapons_hot()
	ModifierLessConcealment.modify_value = ModifierLessConcealment.dont_modify_value
end

function ModifierLessConcealment:dont_modify_value(id, value)
	return value
end
