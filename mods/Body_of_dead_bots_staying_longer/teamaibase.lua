local ThisModPath = ModPath

local ThisModDelay = 30

local function __Name(__text)
	return "F_"..Idstring(tostring(__text)..ThisModPath):key()
end

local ThisModBool = __Name("ThisModBool")

if TeamAIBase and not TeamAIBase[ThisModBool] then
	TeamAIBase[ThisModBool] = true
	function TeamAIBase:on_death_exit()
		TeamAIBase.super.on_death_exit(self)
		self:unregister()
		DelayedCalls:Add(__Name(self._unit), ThisModDelay, function()
			self:set_slot(self._unit, 0)
		end)
	end
end

if HuskTeamAIBase and not HuskTeamAIBase[ThisModBool] then
	HuskTeamAIBase[ThisModBool] = true
	function HuskTeamAIBase:on_death_exit()
		HuskTeamAIBase.super.on_death_exit(self)
		TeamAIBase.unregister(self)
		DelayedCalls:Add(__Name(self._unit), ThisModDelay, function()
			self:set_slot(self._unit, 0)
		end)
	end
end