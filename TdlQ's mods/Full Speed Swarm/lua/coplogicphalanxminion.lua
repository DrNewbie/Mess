local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local fs_original_coplogicphalanxminion_chkshouldbreakup = CopLogicPhalanxMinion.chk_should_breakup
function CopLogicPhalanxMinion.chk_should_breakup()
	if alive(managers.groupai:state():phalanx_vip()) then
		fs_original_coplogicphalanxminion_chkshouldbreakup()
	end
end
