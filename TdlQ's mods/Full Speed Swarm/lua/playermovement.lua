local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_settings = FullSpeedSwarm.final_settings

local fs_original_playermovement_init = PlayerMovement.init
function PlayerMovement:init(unit, ...)
	self.fs_stamina_tick = 0
	self.fs_revive_nr = unit:character_damage():get_revives()
	return fs_original_playermovement_init(self, unit, ...)
end

local fs_original_playermovement_maxstamina = PlayerMovement._max_stamina
function PlayerMovement:_max_stamina()
	local result
	if self.fs_stamina_tick <= 0 then
		self.fs_stamina_tick = 15
		result = fs_original_playermovement_maxstamina(self)
		if fs_settings.tie_stamina_to_lives then
			result = result * self._unit:character_damage():get_revives() / self.fs_revive_nr
		end
		self.fs_max_stamina = result
	else
		self.fs_stamina_tick = self.fs_stamina_tick - 1
		result = self.fs_max_stamina
	end

	return result
end
