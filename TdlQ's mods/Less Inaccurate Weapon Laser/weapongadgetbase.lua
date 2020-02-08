local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local mvec3_set = mvector3.set

local liwl_original_weapongadgetbase_init = WeaponGadgetBase.init
function WeaponGadgetBase:init(unit)
	liwl_original_weapongadgetbase_init(self, unit)
	if _G.liwl_is_local_player then
		self.liwl_is_local_player = true
		self.liwl_previous_raycast_from = Vector3()
	end
end

local liwl_original_weapongadgetbase_seton = WeaponGadgetBase._set_on
function WeaponGadgetBase:_set_on(on, ...)
	if on and self.liwl_is_local_player then
		local player_unit = managers.player:player_unit()
		camera = player_unit and player_unit:camera()
		if camera then
			mvec3_set(self.liwl_previous_raycast_from, camera:position())
		end
	end

	liwl_original_weapongadgetbase_seton(self, on, ...)
end
