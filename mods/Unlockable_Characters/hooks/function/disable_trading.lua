local UnlockableCharactersSys = _G.UnlockableCharactersSys

if UnlockableCharactersSys._hooks.disable_trading then
	return
else
	UnlockableCharactersSys._hooks.disable_trading = true
end

if not UnlockableCharactersSys._funcs.__IsHost() then
	return
end

if UnlockableCharactersSys._funcs.__IsTutorialHeists() then
	return
end

local old_is_trade_allowed = TradeManager.is_trade_allowed

function TradeManager:is_trade_allowed(...)
	if not UnlockableCharactersSys._funcs.__IsTutorialHeists() then
		if UnlockableCharactersSys._funcs.__IsHost() then
			return false
		end
	end
	return old_is_trade_allowed(self, ...)
end

local old_is_stockholm_syndrome_allowed = TradeManager.is_stockholm_syndrome_allowed

function TradeManager:is_stockholm_syndrome_allowed(...)
	if not UnlockableCharactersSys._funcs.__IsTutorialHeists() then
		if UnlockableCharactersSys._funcs.__IsHost() then
			return false, false, false, false
		end
	end
	return old_is_stockholm_syndrome_allowed(self, ...)
end