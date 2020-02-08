if not BDB_Format_Base then
	dofile(ModPath .. 'lua/_format.lua')
end

_G.BDB_Format_PD2Builder = _G.BDB_Format_PD2Builder or class(BDB_Format_Base)
BDB_Format_PD2Builder._default_url = 'https://pd2builder.netlify.com/'
BDB_Format_PD2Builder._tag = 'pd2builder'

BuilDB:RegisterUrlFormat(BDB_Format_PD2Builder, true)

BDB_Format_PD2Builder.charString = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.,@'

function BDB_Format_PD2Builder:EncodeByte(i)
	return self.charString:sub(i + 1, i + 1)
end

function BDB_Format_PD2Builder:DecodeByte(c)
	local result = self.charString:find(c)
	return result and (result - 1) or -1
end

function BDB_Format_PD2Builder:CompressData(data)
	local count = 1
	local thing = data:sub(1, 1)
	local compressed = ''
	for i = 2, data:len() + 1 do
		local value = data:sub(i, i)
		if value == thing then
			if count > 8 then
				compressed = compressed .. thing .. '-' .. count
				count = 0
			end
			count = count + 1
			goto continue
		end
		if count > 3 then
			compressed = compressed .. thing .. '-' .. count
		else
			compressed = compressed .. thing:rep(count)
		end
		thing = value
		count = 1
		::continue::
	end
	return compressed
end

function BDB_Format_PD2Builder:DecompressData(data)
	local decompressed = ''
	local i = 1
	while i <= data:len() do
		local c = data:sub(i, i)
		if data:sub(i + 1, i + 1) == '-' then
			i = i + 2
			decompressed = decompressed .. c:rep(tonumber(data:sub(i, i)))
		else
			decompressed = decompressed .. c
		end
		i = i + 1
	end
	return decompressed
end

function BDB_Format_PD2Builder:GetBuildUrl()
	local skills = ''
	for tree, data in ipairs(tweak_data.skilltree.trees) do
		local subtreeBasicChar = 0
		local subtreeAcedChar = 0
		for i = #data.tiers, 1, -1 do
			local tier = data.tiers[i]
			for _, skill_id in ipairs(tier) do
				local step = managers.skilltree:skill_step(skill_id)
				if step == 1 then
					subtreeBasicChar = bit.bor(subtreeBasicChar, 1)
				elseif step == 2 then
					subtreeAcedChar = bit.bor(subtreeAcedChar, 1)
				end
				subtreeBasicChar = bit.lshift(subtreeBasicChar, 1)
				subtreeAcedChar = bit.lshift(subtreeAcedChar, 1)
			end
		end
		subtreeBasicChar = bit.rshift(subtreeBasicChar, 1) -- undo the last lshift
		subtreeAcedChar = bit.rshift(subtreeAcedChar, 1)
		skills = skills .. self:EncodeByte(subtreeBasicChar) .. self:EncodeByte(subtreeAcedChar)
	end

	local throwable = self:GetThrowableRank()
	throwable = throwable and ('&t=' .. self:EncodeByte(throwable - 1)) or ''

	local deployable = self:GetDeployableRank()
	if not deployable then
		deployable = ''
	else
		deployable = '&d=' .. self:EncodeByte(deployable - 1)
		local deployable2 = self:GetSecondDeployableRank()
		if deployable2 then
			deployable = deployable .. self:EncodeByte(deployable2 - 1)
		end
	end

	local result = (self._url or self._default_url)
		.. '?s=' .. self:CompressData(skills)
		.. '&p=' .. self:EncodeByte(managers.skilltree:digest_value(Global.skilltree_manager.specializations.current_specialization, false, 1) - 1)
		.. '&a=' .. self:EncodeByte(managers.blackmarket:equipped_armor():sub(-1) - 1)
		.. throwable
		.. deployable

	return result
end

function BDB_Format_PD2Builder:ParseUrl(url)
	local result = {}
	for k, v in url:gmatch('(%w)=([^&]+)') do
		if k == 's' then
			result[k] = self:DecompressData(v)
		elseif k == 'd' then
			result[k] = v
		else
			result[k] = self:DecodeByte(v) + 1
		end
	end
	return result
end

function BDB_Format_PD2Builder:Import(url)
	local params = self:ParseUrl(url)

	if params.s then
		self:ResetSkills()

		local skills = {}
		for v in params.s:gmatch('.') do
			table.insert(skills, self:DecodeByte(v))
		end
		if #skills ~= #tweak_data.skilltree.trees * 2 then
			return false, 'number of skill trees mismatch'
		end

		for tree_id, tree in ipairs(tweak_data.skilltree.trees) do
			local subtreeBasicChar = skills[tree_id * 2 - 1]
			local subtreeAcedChar = skills[tree_id * 2]
			for tier_id, tier in ipairs(tree.tiers) do
				for j = #tier, 1, -1 do
					local skill = tier[j]
					local level = bit.band(subtreeAcedChar, 1) == 1 and 2 or bit.band(subtreeBasicChar, 1) == 1 and 1 or 0
					for i = 1, level do
						if not self:Invest(tree_id, skill, tier_id, i) then
							return false, 'cannot aquire ' .. skill
						end
					end
					subtreeBasicChar = bit.rshift(subtreeBasicChar, 1)
					subtreeAcedChar = bit.rshift(subtreeAcedChar, 1)
				end
			end
		end
	end

	if params.p then
		managers.skilltree:set_current_specialization(tonumber(params.p))
	end

	if params.a then
		managers.blackmarket:equip_armor('level_' .. tonumber(params.a))
	end

	if params.t then
		managers.blackmarket:equip_grenade(self:GetThrowableName(tonumber(params.t)))
	end

	if params.d then
		for i = 1, params.d:len() do
			local d = self:DecodeByte(params.d:sub(i, i)) + 1
			local deployable = d and self:GetDeployableName(tonumber(d))
			if deployable then
				managers.blackmarket:equip_deployable({
					name = deployable,
					target_slot = i
				})
			end
		end
	end

	return true
end
