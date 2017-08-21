if Network:is_client() then
	return
end

_G.CivsCarryBags = _G.CivsCarryBags or {}

if not CivsCarryBags then
	return
end

local _Civs_CivilianBrain_set_logic = CivilianBrain.set_logic

function CivilianBrain:set_logic(name, ...)
	_Civs_CivilianBrain_set_logic(self, name, ...)
	if self._current_logic_name == "disabled" and self:Get_Carray_Data() then
		self:Drop_Carray()
	end
end

function CivilianBrain:Set_Carray_Data(carry_unit)
	if self:Get_Carray_Data() then
		self:Drop_Carray()
	end
	if not carry_unit or not alive(carry_unit) or not carry_unit:carry_data() then
		return
	end
	self._carry_unit = carry_unit or nil
	carry_unit:carry_data():link_to(self._unit)
	carry_unit:carry_data()._steal_SO_data = {thief = self._unit}
end

function CivilianBrain:Get_Carray_Data()
	return self._carry_unit or nil
end

function CivilianBrain:Drop_Carray()
	if self._carry_unit and alive(self._carry_unit) then
		self._carry_unit:carry_data():unlink()
		self._carry_unit:carry_data()._steal_SO_data = {thief = nil}
		self._carry_unit:push(100, Vector3(0, 0, 600))
	end
	self._carry_unit = nil
end