_G.Safe4Stealth = _G.Safe4Stealth or {}

Safe4Stealth.ModPath = ModPath

Safe4Stealth.SavePath = SavePath.."Safe4Stealth.txt"

Hooks:Add("LocalizationManagerPostInit", "Safe4Stealth_loc", function(loc)
	loc:load_localization_file(Safe4Stealth.ModPath.."Loc.json")
end)

function Safe4Stealth:default()
	return {
		weapon = true,
		throw = true,
		allow_throw_molotov = false
	}
end

Safe4Stealth.Settings = Safe4Stealth:default()

function Safe4Stealth:save()
	local _file = io.open(self.SavePath, "w+")
	if _file then
		_file:write(json.encode(self.Settings))
		_file:close()
	end
end

function Safe4Stealth:load()
	local _file = io.open(self.SavePath, "r")
	if _file then
		for k, v in pairs(json.decode(_file:read("*all")) or {}) do
			if k then
				self.Settings[k] = v
			end
		end
		_file:close()
	else
		self.Settings = self:default()
		self:save()
	end
end

Hooks:Add("MenuManagerInitialize", "MenManInitSafe4Stealth", function()
	function MenuCallbackHandler:Safe4Stealth_toggle_save()
		Safe4Stealth:save()
	end
	function MenuCallbackHandler:Safe4Stealth_weapon_kick(item)
		Safe4Stealth.Settings.weapon = tostring(item:value()) == 'on' and true or false
	end
	function MenuCallbackHandler:Safe4Stealth_throw_kick(item)
		Safe4Stealth.Settings.throw = tostring(item:value()) == 'on' and true or false
	end
	function MenuCallbackHandler:Safe4Stealth_allow_throw_molotov(item)
		Safe4Stealth.Settings.allow_throw_molotov = tostring(item:value()) == 'on' and true or false
	end
	Safe4Stealth:load()
	MenuHelper:LoadFromJsonFile(Safe4Stealth.ModPath.."Menu.json", Safe4Stealth, Safe4Stealth.Settings)
end)


function Safe4Stealth:Kick_Peer(type, peer)
	if peer and peer:id() and peer:id() ~= 1 and self.Settings[type] and Steam and Steam:logged_on() then
		for _, friend in ipairs(Steam:friends() or {}) do
			if friend:id() == peer:user_id() then
				return
			end
		end
		managers.ban_list:ban(identifier, peer:name())
		managers.network:session():send_to_peers("kick_peer", peer:id(), 6)
		managers.network:session():on_peer_kicked(peer, peer:id(), 6)
	end
end

function Safe4Stealth:DoAnnounce(peer_id)
	if not peer_id or peer_id == 1 then
		return
	end
	for i = 1, 3 do
		DelayedCalls:Add("Safe4StealthAnnounceDelay_"..tostring(peer_id), 3*i, function()
			local peer_an = managers.network:session() and managers.network:session():peer(peer_id)
			if peer_an then
				peer_an:send("send_chat_message", ChatManager.GAME, "[Safe4Stealth] Please don't use any loud weapon")
			end
		end)
	end
end

if ModCore then
	ModCore:new(Safe4Stealth.ModPath .. "Config.xml", false, true):init_modules()
end