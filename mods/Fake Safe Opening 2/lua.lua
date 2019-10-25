_G.FakeOpenSafeF = _G.FakeOpenSafeF or {}

local ids_unit = Idstring("unit")

function FakeOpenSafeF:Ans_Ids()
	return {
		"units/menu/menu_scene/infamy_card"
	}
end

function FakeOpenSafeF:Get_Ans_Ids()
	return self:Ans_Ids()[self._ans] or "units/menu/menu_scene/infamy_card"
end

function FakeOpenSafeF:Get_Ans_from_Safe()
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	self._ans = 1
	return
end

function FakeOpenSafeF:Check_Unit_Loaded()
	local dummy_unit = self:Get_Ans_Ids()
	if managers.dyn_resource:is_resource_ready(ids_unit, Idstring(dummy_unit), managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
		return
	end
	if not PackageManager:unit_data(Idstring(dummy_unit)) then
		return
	end
	return dummy_unit
end

local target_pos_vector = Vector3()

function FakeOpenSafeF:HijackSafeAnsSpawn(them, w_unit)
	local _fake_safe_ids = them._fake_safe_ids
	them._fake_safe_ids = nil
	them._item_pos = w_unit:position()
	them._item_rot = w_unit:rotation()
	them._item_yaw = 90
	them._item_pitch = 0
	them._item_roll = 0
	local s_unit = World:spawn_unit(_fake_safe_ids, them._item_pos, them._item_rot)
	them:remove_item()
	them._item_unit = {
		unit = s_unit,
		name = s_unit:name()
	}
	return them
end

function FakeOpenSafeF:Generate_Safe()
	managers.menu:on_leave_lobby()
	
	if not self._ans then
		self:Get_Ans_from_Safe()
	end
	local dummy_unit = self:Check_Unit_Loaded()
	if not dummy_unit then
		managers.dyn_resource:load(ids_unit, Idstring(dummy_unit), managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, "Generate_Safe"))
		return
	end
	local choose_item = function(safe)
		local data = {amount = 1, category = safe._type}
		data.bonus = math.random(100) > 10
		local weap_index = tweak_data.economy.contents[safe.content].contains[safe._type]
		data.entry = table.random(weap_index)
		data.quality = table.random({"poor", "fair", "good", "fine", "mint"})
		data.def_id = 101
		local i = 1
		while managers.blackmarket._global.inventory_tradable[tostring(i)] ~= nil do
			i = i + 1
		end
		data.instance_id = tostring(i)
		return data
	end
	local safe_entry = "fake_safe_1"
	local safe_tweak = tweak_data.economy.safes[safe_entry]
	local safe_retry = 50
	safe_tweak._type = "weapon_skins"
	local function ready_clbk()
		managers.menu:back()
		managers.system_menu:force_close_all()
		managers.menu_component:set_blackmarket_enabled(false)
		managers.menu:open_node("open_steam_safe", {safe_tweak.content})
	end
	managers.menu_component:set_blackmarket_disable_fetching(true)
	managers.menu_component:set_blackmarket_enabled(false)
	
	managers.menu_scene._fake_safe_ids = Idstring(dummy_unit)
	
	managers.menu_scene:create_economy_safe_scene(safe_entry, ready_clbk)
	local item = choose_item(safe_tweak)
	MenuCallbackHandler:_safe_result_recieved(nil, {item}, {})
end

FakeOpenSafeF:Generate_Safe()