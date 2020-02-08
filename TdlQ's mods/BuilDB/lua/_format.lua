_G.BDB_Format_Base = _G.BDB_Format_Base or class()
BDB_Format_Base._default_url = 'invalid_url'
BDB_Format_Base._url = nil
BDB_Format_Base._tag = 'invalid_tag'

function BDB_Format_Base:SetUrl(url)
	self._url = url
end

function BDB_Format_Base:ResetSkills()
	for tree, tree_data in ipairs(tweak_data.skilltree.trees) do
		local points_spent = managers.skilltree:points_spent(tree)
		managers.skilltree:_set_points_spent(tree, 0)
		for i = #tree_data.tiers, 1, -1 do
			local tier = tree_data.tiers[i]
			for _, skill in ipairs(tier) do
				managers.skilltree:_unaquire_skill(skill)
			end
		end
		managers.skilltree:_aquire_points(points_spent, true)
	end
end

function BDB_Format_Base:Invest(tree, skill_id, tier, step)
	local skmgr = managers.skilltree
	if not skmgr:has_enough_skill_points(skill_id) or not skmgr:unlock(skill_id) then
		return false
	end

	local points = skmgr:skill_cost(tier, step)
	local skill_points = skmgr:spend_points(points)
	skmgr:_set_points_spent(tree, skmgr:points_spent(tree) + points)

	if managers.menu_component._skilltree_gui then
		managers.menu_component._skilltree_gui:set_skill_point_text(skill_points)
	end

	return true
end

function BDB_Format_Base:GetDeployableRank(i)
	local equipped = managers.blackmarket:equipped_deployable(i)
	for rank, tbl in ipairs(managers.blackmarket:get_sorted_deployables()) do
		if tbl[1] == equipped then
			return rank
		end
	end
end

function BDB_Format_Base:GetSecondDeployableRank()
	return self:GetDeployableRank(2)
end

function BDB_Format_Base:GetDeployableName(rank)
	local deployables = managers.blackmarket:get_sorted_deployables()
	return deployables and deployables[rank] and deployables[rank][1]
end

function BDB_Format_Base:GetThrowableRank()
	local equipped = managers.blackmarket:equipped_grenade()
	for rank, tbl in ipairs(managers.blackmarket:get_sorted_grenades()) do
		if tbl[1] == equipped then
			return rank
		end
	end
end

function BDB_Format_Base:GetThrowableName(rank)
	local grenades = managers.blackmarket:get_sorted_grenades()
	return grenades and grenades[rank] and grenades[rank][1]
end

function BDB_Format_Base:GetUrlFromSkills()
	return 'invalid_format'
end

function BDB_Format_Base:Import(url)
	return false
end
