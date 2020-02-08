local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

if Monkeepers.disabled then
	return
end

if Network:is_server() then
	local mkp_original_teamaimovement_setcarryingbag = TeamAIMovement.set_carrying_bag
	function TeamAIMovement:set_carrying_bag(unit)
		local previous_carry_unit = self._carry_unit

		mkp_original_teamaimovement_setcarryingbag(self, unit)

		if alive(unit) and unit == previous_carry_unit then -- characteristic of bag thrown to bot: set_carrying_bag() gets called twice
			local carry_data = unit:carry_data()
			carry_data.mkp_callback = nil
			self.mkp_autopicked = false
			if not self._ext_base.kpr_is_keeper then
				local lv = Monkeepers:FindLootbagVector(self._unit:position())
				if lv then
					local drop_objective = carry_data:mkp_make_drop_objective(lv)
					self._unit:brain():set_objective(drop_objective)
				end
			end
		else
			self.mkp_autopicked = true
		end
	end
end
