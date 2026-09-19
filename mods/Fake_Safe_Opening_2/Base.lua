_G.FakeOpenSafeF = _G.FakeOpenSafeF or {}

local ids_unit = Idstring("unit")

if FakeOpenSafeF.Base_Function_Init then
	return
end

FakeOpenSafeF.Base_Function_Init = true

FakeOpenSafeF.ModPath = FakeOpenSafeF.ModPath or ModPath

function FakeOpenSafeF:Load_Safes()
	self.Safes = {}
	local _files = file.GetFiles(self.ModPath.."/safes_tweak/safe_json/") or {}
	for _, file_name in pairs(_files) do
		local _file = io.open(self.ModPath.."/safes_tweak/safe_json/"..file_name, "r")
		if _file then
			local _data = json.decode(_file:read("*all"))
			_file:close()
			if _data.addon_safe_id then
				self.Safes[_data.addon_safe_id] = _data
			end
			log("[FakeOpenSafeF]: Load_Safes \t safe_json \t "..file_name)
		end
	end
	_files = file.GetFiles(self.ModPath.."/safes_tweak/safe_reward/") or {}
	for _, file_name in pairs(_files) do
		dofile(self.ModPath.."/safes_tweak/safe_reward/"..file_name)
		log("[FakeOpenSafeF]: Load_Safes \t safe_reward \t "..file_name)
	end
end

FakeOpenSafeF:Load_Safes()

function FakeOpenSafeF:Ans_Ids()
	return {
		["fake_safe_1"] = "units/pd2_dlc_help/pickups/gen_pku_spooky_bag/gen_pku_spooky_bag"
	}
end

function FakeOpenSafeF:Get_Ans_Ids()
	return self:Ans_Ids()[self._safe_entry] or "units/menu/menu_scene/infamy_card"
end

function FakeOpenSafeF:Get_Ans_from_Safe()
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	self._safe_entry = "fake_safe_1"
	local safe_tweak = tweak_data.economy.safes[self._safe_entry]
	
	self._MenuNodeEconomySafe_Ready = true
	self._MenuSceneManager_Ready = true
	self._RewardFunction_Ready = {
		safe_tweak = safe_tweak
	}
	if safe_tweak.addon_safe_id and self.Safes[safe_tweak.addon_safe_id] then
		local _data = self.Safes[safe_tweak.addon_safe_id]
		self._RewardFunction_Ready.All_Safe_Addon_Data = _data
		if _data.addon_safe_ans then
			local total_rate = 0
			for i, d in pairs(_data.addon_safe_ans) do
				if d.rate then
					total_rate = total_rate + d.rate
				end
			end
			local count_last = 0
			local count_next = 0
			local rnd_pick = math.random(total_rate)
			for i, d in pairs(_data.addon_safe_ans) do
				if d.rate then
					count_last = count_next
					count_next = count_next + d.rate
					if count_last <= rnd_pick and rnd_pick <= count_next then
						self._RewardFunction_Ready.Ans_Data_Key = i
						break
					end
				end
			end
		end
	end
	return
end

function FakeOpenSafeF:Get_Ans_Data()
	local _data = self._RewardFunction_Ready.All_Safe_Addon_Data
	local _data_key = self._RewardFunction_Ready.Ans_Data_Key
	
	if _data and _data.addon_safe_ans and _data_key then
		return _data.addon_safe_ans[_data_key]
	end
	return nil
end

function FakeOpenSafeF:Check_Unit_Loaded()
	local dummy_unit = self:Get_Ans_Ids()
	--[[
	if managers.dyn_resource:is_resource_ready(ids_unit, Idstring(dummy_unit), managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
		return
	end
	if not PackageManager:unit_data(Idstring(dummy_unit)) then
		return
	end
	]]
	return dummy_unit
end

local target_pos_vector = Vector3()

function FakeOpenSafeF:HijackSafeAnsSpawn(them, w_unit)
	local _fake_safe_ids = Idstring(self:Get_Ans_Ids())
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
	self:Get_Ans_from_Safe()
	local dummy_unit = self:Check_Unit_Loaded()
	if not dummy_unit then
		--managers.dyn_resource:load(ids_unit, Idstring(dummy_unit), managers.dyn_resource.DYN_RESOURCES_PACKAGE, callback(self, self, "Generate_Safe"))
		return
	end
	local fake_choose_item = function(safe)
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
	local safe_entry = self._safe_entry
	local safe_tweak = self._RewardFunction_Ready.safe_tweak
	safe_tweak._type = "weapon_skins"
	local function ready_clbk()
		managers.menu:back()
		managers.system_menu:force_close_all()
		managers.menu_component:set_blackmarket_enabled(false)
		managers.menu:open_node("open_steam_safe", {safe_tweak.content})
	end
	managers.menu_component:set_blackmarket_disable_fetching(true)
	managers.menu_component:set_blackmarket_enabled(false)	
	managers.menu_scene:create_economy_safe_scene(safe_entry, ready_clbk)
	local item = fake_choose_item(safe_tweak)
	MenuCallbackHandler:_safe_result_recieved(nil, {item}, {})
end