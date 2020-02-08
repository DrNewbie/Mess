local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function CopDamage:ndb_reset_health()
	self._health = self._HEALTH_INIT
	self._health_ratio = 1
end
