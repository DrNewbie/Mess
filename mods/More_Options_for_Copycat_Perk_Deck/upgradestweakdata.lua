local old_mrwi_deck9_options = UpgradesTweakData.mrwi_deck9_options

function UpgradesTweakData.mrwi_deck9_options()
	local deck9_options = old_mrwi_deck9_options()	
	local __tmp = {}	
	for __i, __d in pairs(deck9_options) do
		if type(__d) == "table" then
			if type(__d.tree) == "number" and type(__d.tier) == "number" then
				local __idx = "t_"..__d.tree.."_t_"..__d.tier
				__tmp[__idx] = true
			end
		end
	end
	for __tree = 1, 22 do
		for __tier = 1, 9 do
			if __tier%2 == 1 and not __tmp["t_"..__tree.."_t_"..__tier] then
				__tmp["t_"..__tree.."_t_"..__tier] = true
				table.insert(deck9_options, {
					tree = __tree,
					tier = __tier
				})
			end
		end	
	end
	return deck9_options
end

Hooks:PostHook(UpgradesTweakData, "_init_pd2_values", "mrwi_deck1357_options+desc", function(self, ...)
	self.specialization_descs[23][1] = self.specialization_descs[23][9]
	self.specialization_descs[23][3] = self.specialization_descs[23][9]
	self.specialization_descs[23][5] = self.specialization_descs[23][9]
	self.specialization_descs[23][7] = self.specialization_descs[23][9]
	self.multi_choice_specialization_descs[23][1] = self.multi_choice_specialization_descs[23][9]
	self.multi_choice_specialization_descs[23][3] = self.multi_choice_specialization_descs[23][9]
	self.multi_choice_specialization_descs[23][5] = self.multi_choice_specialization_descs[23][9]
	self.multi_choice_specialization_descs[23][7] = self.multi_choice_specialization_descs[23][9]
end)