_G.SomeonNotHome = _G.SomeonNotHome or {}

function CriminalsManager:is_not_at_home(name)
	if SomeonNotHome and SomeonNotHome.Settings and SomeonNotHome.Settings[name] then
		return true	
	end
	return false
end