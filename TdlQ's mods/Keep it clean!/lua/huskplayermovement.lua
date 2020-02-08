local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if not Network:is_server() then
	return
end

local kic_original_huskplayermovement_applyattentionsettingmodifications = HuskPlayerMovement._apply_attention_setting_modifications
function HuskPlayerMovement:_apply_attention_setting_modifications(setting)
	kic_original_huskplayermovement_applyattentionsettingmodifications(self, setting)

	local steam_id = managers.network:session():peer_by_unit(self._unit):user_id()
	local ck_nr = KeepItClean.civilians_killed_by_player[steam_id]
	if ck_nr then
		setting.weight_mul = (setting.weight_mul or 1) * (1 + ck_nr * 0.02)
	end
end
