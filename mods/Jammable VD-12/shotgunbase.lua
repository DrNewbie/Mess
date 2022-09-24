local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "VDJ_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end

local Bool1 = __Name("Bool1")
local Time1 = __Name("Time1")
local Speed1 = __Name("Speed1")
local Smoke1 = __Name("Smoke1")
local Jammed1 = __Name("Jammed1")
local ReloadSpeedMul = function ()
	return 0.15
end
local SmokeSpawnRate = function ()
	if math.random() >= 0.5 then
		return true
	end
	return false
end
local IsJammedNow = function (them)
	if math.random() >= 0.001 and them[Time1] >= 3 then
		return true
	end
	return false
end

Hooks:PreHook(ShotgunBase, "setup_default", __Name("setup_default"), function(self)
	if tostring(self._name_id) == "sko12" then
		self[Bool1] = true
		self[Jammed1] = false
		self[Time1] = 0
		self[Speed1] = self._reload or 1
		self[Smoke1] = {}
	end
end)

Hooks:PreHook(ShotgunBase, "_fire_raycast", __Name("_fire_raycast"), function(self)
	if self[Bool1] then
		self[Time1] = self[Time1] + 1
		if IsJammedNow(self) then
			--[[Jammed]]
			self[Jammed1] = true
			self:set_ammo_remaining_in_clip(0)
			self._reload = self._reload * ReloadSpeedMul()
			managers.explosion:play_sound_and_effects(self._unit:position(), math.UP, 100, {
				camera_shake_max_mul = 4,
				effect = "effects/particles/explosions/explosion_flash_grenade",
				sound_event = "concussion_explosion",
				feedback_range = 100
			})
			World:effect_manager():spawn({
				effect = Idstring("effects/particles/explosions/explosion_grenade"),
				position = self._unit:position(),
				normal = self._unit:rotation():y()
			})
			local sound_source = SoundDevice:create_source("TripMineBase")
			sound_source:set_position(self._unit:position())
			sound_source:post_event("trip_mine_explode")
			managers.enemy:add_delayed_clbk("TrMiexpl", callback(TripMineBase, TripMineBase, "_dispose_of_sound", {
				sound_source = sound_source
			}), TimerManager:game():time() + 4)
			local __part = self._parts[table.random_key(self._parts)]
			if SmokeSpawnRate() and __part and __part.unit and alive(__part.unit) and __part.unit.orientation_object and __part.unit:orientation_object() then
				table.insert(self[Smoke1] ,World:effect_manager():spawn({
					effect = Idstring("effects/payday2/particles/weapons/rpg_smoke_trail"),
					parent = __part.unit:orientation_object()
				}))
			end
		end
	end
end)

Hooks:PreHook(ShotgunBase, "on_reload", __Name("on_reload"), function(self)
	if self[Bool1] and self[Jammed1] then
		self[Jammed1] = false
		self[Time1] = 0
		self._reload = self[Speed1]
		for __id, __data in pairs(self[Smoke1]) do
			World:effect_manager():fade_kill(__data)
			--World:effect_manager():kill(__data)
			self[Smoke1][__id] = nil
		end
	end
end)