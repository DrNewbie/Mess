if not tweak_data then
	return
end
local cost_new = Application:digest_value(0, true)
table.insert(tweak_data.infamy.ranks, cost_new)