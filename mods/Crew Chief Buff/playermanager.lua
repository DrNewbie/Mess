local mod_ids = Idstring("Crew Chief Buff"):key()
local func10 = "F_"..Idstring("func10::"..mod_ids):key()
local func99 = "F_"..Idstring("func99::"..mod_ids):key()

PlayerManager[func10] = PlayerManager[func10] or PlayerManager.upgrade_value

function PlayerManager:upgrade_value(c1, c2, ...)
	local __ans = self[func10](self, c1, c2, ...)
	if c1 == "player" and (c2 == "civ_intimidation_mul" or c2 == "passive_intimidate_range_mul" or c2 == "intimidate_aura") then
		if self:has_category_upgrade("player", "ccb_intimidate_range_mul") then
			local __buff = self:upgrade_value("player", "ccb_long_dis_revive_range_mul", 1)
			if c1 == "player" and c2 == "civ_intimidation_mul" then
				__ans = __ans + __buff - 1
			elseif c1 == "player" and c2 == "passive_intimidate_range_mul" then
				__ans = __ans + __buff - 1
			elseif c1 == "player" and c2 == "intimidate_aura" then
				__ans = __ans * __buff
			end
		end
	end
	return __ans
end

PlayerManager[func99] = PlayerManager[func99] or PlayerManager.body_armor_skill_multiplier

function PlayerManager:body_armor_skill_multiplier(...)
	local __ans = self[func99](self, ...)
	if self:has_category_upgrade("player", "ccb_hostage_armor_multiplier") then
		local __hostages = managers.groupai and managers.groupai:state():hostage_count() or 0
		local __minions = 0--self:num_local_minions() or 0
		local __buff = self:upgrade_value("player", "ccb_hostage_armor_multiplier", 1)
		__buff = __buff - 1
		__ans = __ans + __buff * math.min(4, __hostages + __minions)
	end
	return __ans
end