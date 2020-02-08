local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

_G.mtga_users = mtga_users or {}

local mtga_original_networkpeer_load = NetworkPeer.load
function NetworkPeer:load(data)
	mtga_original_networkpeer_load(self, data)

	if data.id then
		mtga_users[data.id] = self == managers.network:session():local_peer()
	end
end
