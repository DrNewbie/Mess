local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local object = CopDamage
local function_names = {
	'damage_bullet',
	'damage_fire',
	'damage_explosion',
	'damage_tase',
	'damage_melee',
}
for _, function_name in pairs(function_names) do
	local original_function = object[function_name]
	local EnhancedHitmarkers = EnhancedHitmarkers
	if original_function then
		object[function_name] = function(self, attack_data)
			EnhancedHitmarkers.direct_hit = false

			EnhancedHitmarkers.hooked = true
			local result = original_function(self, attack_data)
			EnhancedHitmarkers.hooked = false

			if EnhancedHitmarkers.direct_hit then
				local headshot = attack_data.headshot
				if not headshot and self._head_body_name then
					if not self._damage_reduction_multiplier and not self._char_tweak.ignore_headshot then
						headshot = attack_data.col_ray.body and attack_data.col_ray.body:name() == self._ids_head_body_name
					end
				end
				local kill_confirmed = attack_data.result and attack_data.result.type == 'death'
				managers.hud:on_damage_confirmed(kill_confirmed, headshot)
			end

			return result
		end
	end
end
