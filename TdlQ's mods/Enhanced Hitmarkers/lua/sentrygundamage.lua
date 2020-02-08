local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local object = SentryGunDamage
local function_names = {
	'damage_bullet',
	'damage_fire',
	'damage_explosion',
}
for _, function_name in pairs(function_names) do
	local original_function = object[function_name]
	local EnhancedHitmarkers = EnhancedHitmarkers
	if original_function then
		object[function_name] = function(self, attack_data)
			local was_dead = self._dead
			EnhancedHitmarkers.direct_hit = false

			EnhancedHitmarkers.hooked = true
			local result = original_function(self, attack_data)
			EnhancedHitmarkers.hooked = false

			if EnhancedHitmarkers.direct_hit then
				local col_ray = attack_data.col_ray
				local hit_body_name = col_ray and col_ray.body and col_ray.body:name()
				local headshot = hit_body_name and (hit_body_name == self._shield_body_name_ids or hit_body_name == self._bag_body_name_ids)
				local kill_confirmed = was_dead ~= self._dead
				managers.hud:on_damage_confirmed(kill_confirmed, headshot)
			end

			return result
		end
	end
end
