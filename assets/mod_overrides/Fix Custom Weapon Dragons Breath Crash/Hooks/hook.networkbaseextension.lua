local PreHook_NetSend_57d0bae779d97ae3 = NetworkBaseExtension.send

function NetworkBaseExtension:send(d1, d2, d3, d4, d5, d6, d7, d8, ...)
	if tostring(d1) == "damage_fire" then
		if tweak_data.weapon.factory.parts[d8] and tweak_data.weapon.factory.parts[d8].custom then
			d7 = 2
			d8 = "wpn_fps_upg_a_dragons_breath"
		end
	end
	PreHook_NetSend_57d0bae779d97ae3(self, d1, d2, d3, d4, d5, d6, d7, d8, ...)
end