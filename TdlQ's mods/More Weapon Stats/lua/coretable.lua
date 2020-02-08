local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

core:module('CoreTable')

function table.sum(t)
	local result = 0
	for _, v in pairs(t) do
		if type(v) == 'number' then
			result = result + v
		end
	end
	return result
end
