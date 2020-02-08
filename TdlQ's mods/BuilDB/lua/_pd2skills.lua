if not BDB_Format_Base then
	dofile(ModPath .. 'lua/_format.lua')
end

_G.BDB_Format_PD2Skills = _G.BDB_Format_PD2Skills or class(BDB_Format_Base)
BDB_Format_PD2Skills._default_url = 'http://pd2skills.com/#/v3/'
BDB_Format_PD2Skills._tag = 'pd2skills'

BuilDB:RegisterUrlFormat(BDB_Format_PD2Skills)

BDB_Format_PD2Skills._infamy_codes = {
	infamy_root = 'a',
	infamy_mastermind = 'b',
	infamy_enforcer = 'c',
	infamy_technician = 'd',
	infamy_ghost = 'e'
}
BDB_Format_PD2Skills._tree_tags = { 'm', 'e', 't', 'g', 'f' }
BDB_Format_PD2Skills._perk_tags = {
	'C', -- Crew chief
	'M', -- Muscle
	'A', -- Armorer
	'R', -- Rogue
	'H', -- Hitman
	'O', -- crOok
	'B', -- Burglar
	'I', -- Infiltrator
	'S', -- Sociopath
	'G', -- Gambler
	'N', -- griNder
	'Y', -- Yakuza
	'E', -- Ex-president
	'1', -- ? maniac
	'T', -- ? anarchisT
	'K', -- ? biKer
	'P', -- ? kingPin
	'2', -- ? sicario
	'3', -- ? stoic
	'4', -- ? tagteam
	'5', -- ? hacker
}

function BDB_Format_PD2Skills:GetUrlPartFromSkillTree(tree, switch_data)
	local itoc = {5, 3, 4, 1, 2, 0}
	local basecharvals = {97, 103, 109}
	local basecharval = basecharvals[(tree - 1) % 3 + 1]
	local result = ''
	local td = tweak_data.skilltree.trees[tree]

	local i = 0
	for _, tier in ipairs(td.tiers) do
		for _, skill_id in ipairs(tier) do
			i = i + 1
			local step = managers.skilltree:skill_step(skill_id)
			if step > 0 then
				local cv = basecharval + itoc[i]
				if step > 1 then
					cv = cv - 32
				end
				result = result .. string.char(cv)
			end
		end
	end
	return result
end

function BDB_Format_PD2Skills:GetBuildUrl()
	local packed_trees = {}
	for tree, data in ipairs(tweak_data.skilltree.trees) do
		packed_trees[tree] = self:GetUrlPartFromSkillTree(tree)
	end

	local result = self._url or self._default_url
	for i = 0, 4 do
		local threetree = ''
		for j = 1, 3 do
			threetree = threetree .. packed_trees[i * 3 + j]
		end
		if threetree ~= '' then
			result = result .. self._tree_tags[i + 1] .. threetree .. ':'
		end
	end

	if managers.infamy:owned('infamy_root') then
		result = result .. 'i'
		for infamy, code in pairs(self._infamy_codes) do
			if managers.infamy:owned(infamy) then
				result = result .. code
			end
		end
		result = result .. ':'
	end

	local current_specialization = managers.skilltree:digest_value(Global.skilltree_manager.specializations.current_specialization, false, 1)
	local tree_data = Global.skilltree_manager.specializations[current_specialization]
	if tree_data and current_specialization <= #self._perk_tags then
		local tier_data = tree_data.tiers
		if tier_data then
			local current_tier = managers.skilltree:digest_value(tier_data.current_tier, false)
			result = result .. 'p' .. self._perk_tags[current_specialization] .. tostring(current_tier - 1) .. ':'
		end
	end

	local level = managers.experience:current_level()
	if level < 100 then
		result = result .. '::l' .. tostring(level)
	end

	return result .. '::'
end

function BDB_Format_PD2Skills:ParseUrl(url)
	local result = {
		skills = {},
		others = {},
	}

	local params = url:match('#/v[0-9]+/(.*)$')
	if not params or params == '' then
		return
	end

	local params1, params2 = params:match('^(.*):?:?(.*)$')
	for _, s in pairs(params1:split(':')) do
		result.skills[s:sub(1, 1)] = s:sub(2) or ''
	end
	for _, s in pairs(params2:split(':')) do
		result.others[s:sub(1, 1)] = s:sub(2) or ''
	end

	return result
end

function BDB_Format_PD2Skills:Import(url)
	local params = self:ParseUrl(url)
	if not params then
		return false, 'parsing url'
	end

	if params.skills.i then
		for infamy, code in pairs(self._infamy_codes) do
			if params.skills.i:find(code) and not managers.infamy:owned(infamy) then
				return false, infamy
			end
		end
	end

	local level = managers.experience:current_level()
	if params.skills.l and level < tonumber(params.skills.l) then
		return false, 'level'
	end

	if params.skills.p then
		local perk_tag = params.skills.p:match('([A-Z])')
		local perk_id = table.index_of(self._perk_tags, perk_tag)
		if perk_id ~= -1 then
			managers.skilltree:set_current_specialization(perk_id)
		end
	end

	self:ResetSkills()

	local numtotier = {4, 3, 3, 2, 2, 1}
	local numtorank = {1, 1, 2, 1, 2, 1}
	for i = 0, 4 do
		local new_skills = params.skills[self._tree_tags[i + 1]] or ''
		for j = #new_skills, 1, -1 do
			local c = new_skills:sub(j, j)
			local num = c:lower():byte(1) - 97
			local skill_num = (num % 6) + 1
			local real_tree = i * 3 + 1 + math.floor(num / 6)
			local tier = numtotier[skill_num]
			local rank = numtorank[skill_num]
			local skill_id = tweak_data.skilltree.trees[real_tree].tiers[tier][rank]

			if not self:Invest(real_tree, skill_id, tier, 1) then
				return false, 'level'
			end
			if c:byte(1) < 97 then
				if not self:Invest(real_tree, skill_id, tier, 2) then
					return false, 'level'
				end
			end
		end
	end

	return true
end
