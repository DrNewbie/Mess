local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "BST_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

local func1 = __Name("take_ammo")
local msgr1 = __Name("OnWeaponFired")
local bullet_storm_hold = __Name("bullet_storm_hold")
local is_bool = __Name("is_bool")

local function __Run()
	if managers.player and AmmoBagBase and type(AmmoBagBase[bullet_storm_hold]) == "number" and AmmoBagBase[bullet_storm_hold] > 0 then
		managers.player:add_to_temporary_property("bullet_storm", AmmoBagBase[bullet_storm_hold], 1)
		AmmoBagBase[bullet_storm_hold] = false				
	end
	return
end

if AmmoBagBase and not AmmoBagBase[is_bool] then
	AmmoBagBase[is_bool] = true

	AmmoBagBase[func1] = AmmoBagBase[func1] or AmmoBagBase.take_ammo

	AmmoBagBase[bullet_storm_hold] = AmmoBagBase[func1] or false

	function AmmoBagBase:take_ammo(__unit, ...)
		local __interacted, __bullet_storm = self[func1](self, __unit, ...)
		if managers.player and __unit and alive(__unit) and __unit == managers.player:player_unit() then
			if __bullet_storm and type(__bullet_storm) == "number" and __bullet_storm > 0 then
				AmmoBagBase[bullet_storm_hold] = __bullet_storm
				__bullet_storm = false
				managers.player:unregister_message(Message.OnWeaponFired, msgr1)
				managers.player:register_message(Message.OnWeaponFired, msgr1, function()
					pcall(__Run)
				end)
			end
		end
		return __interacted, __bullet_storm
	end
end

if SawHit and not SawHit[is_bool] then
	SawHit[is_bool] = true
	
	Hooks:PostHook(SawHit, "on_collision", __Name("SawHit::on_collision"), function(...)
		pcall(__Run)
	end)
end