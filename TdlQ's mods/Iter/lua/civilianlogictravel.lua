local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if not Iter.settings.streamline_path then
	return
end

local mvec3_z = mvector3.z

function CivilianLogicTravel._optimize_path(path)
	if #path <= 2 then
		return path
	end

	local function remove_duplicates(path)
		for i = #path, 2, -1 do
			if path[i] == path[i - 1] then
				table.remove(path, i - 1)
			end
		end
	end

	remove_duplicates(path)

	local opt_path = {path[1]}
	local i = 1
	local count = 1

	while i < #path do
		local pos = path[i]
		local pos_z = mvec3_z(pos)
		local next_index = i + 1

		for j = i + 1, #path, 1 do
			local pos_to = path[j]
			if math.abs(mvec3_z(pos_to) - pos_z) < 100 then
				if not managers.navigation:raycast({
					pos_from = pos,
					pos_to = pos_to
				}) then
					next_index = j
				end
			end
		end

		opt_path[count + 1] = path[next_index]
		count = count + 1
		i = next_index
	end

	remove_duplicates(opt_path)

	return opt_path
end
