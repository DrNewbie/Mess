if core then
	core:module('CoreTable')
end

function table.icontains(v, e)
	local nr = #v

	for i = 1, nr do
		if v[i] == e then
			return true
		end
	end

	return false
end
