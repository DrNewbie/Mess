_G.SurvivorModeBase = _G.SurvivorModeBase or {}

function SurvivorModeBase:talk2all(msg)
	return managers.chat:send_message(ChatManager.GAME, name or "" , msg or "")
end