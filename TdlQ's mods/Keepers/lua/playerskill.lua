local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

function PlayerSkill.has_skill(category, skill, player)
	if player then
		local player_base = player:base()
		return player_base.upgrade_value and player_base:upgrade_value(category, skill) ~= nil or false
	else
		return managers.player:has_category_upgrade(category, skill)
	end
end

function PlayerSkill.skill_data(category, skill, default, player)
	if player then
		local player_base = player:base()
		return player_base.upgrade_value and player_base:upgrade_value(category, skill) or default
	else
		return managers.player:upgrade_value(category, skill, default)
	end
end

function PlayerSkill.skill_level(category, skill, default, player)
	if player then
		local player_base = player:base()
		return player_base.upgrade_level and player_base:upgrade_level(category, skill) or 0
	else
		return managers.player:upgrade_level(category, skill, default)
	end
end
