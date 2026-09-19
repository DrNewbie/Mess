local DeadManSysMain = _G.DeadManSysMain

if DeadManSysMain._hooks.disable_trading then
	return
else
	DeadManSysMain._hooks.disable_trading = true
end

if not DeadManSysMain._funcs.__IsHost() then
	return
end

local old_is_trade_allowed = TradeManager.is_trade_allowed

function TradeManager:is_trade_allowed(...)
	if DeadManSysMain._funcs.__IsHost() then
		return false
	end
	return old_is_trade_allowed(self, ...)
end

local old_is_stockholm_syndrome_allowed = TradeManager.is_stockholm_syndrome_allowed

function TradeManager:is_stockholm_syndrome_allowed(...)
	if DeadManSysMain._funcs.__IsHost() then
		return false, false, false, false
	end
	return old_is_stockholm_syndrome_allowed(self, ...)
end