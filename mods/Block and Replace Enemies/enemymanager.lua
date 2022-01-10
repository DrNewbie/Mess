_G.BoR_Enemy = _G.BoR_Enemy or {}
BoR_Enemy = BoR_Enemy or {}

local func1 = BoR_Enemy:Name("EnemyManager:update")
local func2 = BoR_Enemy:Name("EnemyManager:update:dt")

local function is_self_check(unit_type, BoR_type)
	if BoR_type == 1 then
		--Default, always ignore
		return false
	elseif BoR_type == 2 then
		--Block, always kill
		return true
	elseif unit_type == BoR_type then
		--Same one, ignore it
		return false
	elseif BoR_type == 10 then
		--Bulldozer+, it should spawn dozer only now
		if unit_type ~= 3 and unit_type ~= 8 and unit_type ~= 9 then
			return true
		end
	elseif BoR_type >= 3 and BoR_type <= 9 and BoR_type ~= unit_type then
		return true
	elseif BoR_type == 11 then
		--Random, don't care if it spawn the same one
	end
	return false
end

Hooks:PostHook(EnemyManager, "update", func1, function(self, t, dt)
	if self[func2] then
		self[func2] = self[func2] - dt
		if self[func2] <= 0 then
			self[func2] = 1
			for u_key, u_data in pairs(self._enemy_data.unit_data) do
				if u_data.unit and alive(u_data.unit) and u_data.unit.character_damage and u_data.unit:character_damage() then
					if not u_data.unit:base().__is_BoR_E then
						u_data.unit:base().__is_BoR_E = true
						local unit_type = BoR_Enemy:Get_EnemyType(u_data.unit:name())
						if type(unit_type) == "number" and unit_type > 0 and unit_type < 999 then
							local BoR_type = BoR_Enemy:Get_Value("value::"..unit_type) or 1
							if type(BoR_type) == "number" and is_self_check(unit_type, BoR_type) then
								local __hp = u_data.unit:character_damage()._health or 1
								u_data.unit:character_damage():damage_mission({damage = __hp * 10})
							end
						end
					end
				end
			end
		end
	else
		self[func2] = 1
	end
end)