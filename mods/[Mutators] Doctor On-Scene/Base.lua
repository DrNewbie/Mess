_G.TMP_mutator_saving = _G.TMP_mutator_saving or {}

	TMP_mutator_saving.ModPath = ModPath
	TMP_mutator_saving.SaveFile = TMP_mutator_saving.SaveFile or SavePath .. "tmp_mutator_saving.txt"
	TMP_mutator_saving.data = TMP_mutator_saving.data or {}

	function TMP_mutator_saving:Load()
		local _file = io.open(self.SaveFile, "r")
		if _file then
			self.data = json.decode(_file:read("*all"))
			_file:close()
		end
	end

	TMP_mutator_saving:Load()

	function TMP_mutator_saving:Save()
		local _file = io.open(self.SaveFile, "w+")
		if _file then
			_file:write(json.encode(self.data))
			_file:close()
		end
	end
	
	function TMP_mutator_saving:Is_This_Enable(mutator_id, mm)
		local _MM = nil
		if mm then
			_MM = mm
		elseif managers.mutators then
			_MM = managers.mutators:get_mutator_from_id(mutator_id) or nil
		end
		if _MM then
			if TMP_mutator_saving.data and TMP_mutator_saving.data[mutator_id] then
				return true
			elseif managers.mutators and managers.mutators:is_mutator_active(_MM) then
				return true
			end
		end
		return false
	end
	
	function TMP_mutator_saving:Pre_Save()
		local mm = managers.mutators:mutators() or {}
		for _, _mutator in ipairs(mm) do
			TMP_mutator_saving.data[tostring(_mutator:id())] = _mutator:is_enabled()
		end
		self:Save()
	end
	
	function TMP_mutator_saving:New_Mutators_Init(mm)
		if Global.mutators and Global.mutators.active_on_load then
			for id, data in pairs(Global.mutators.active_on_load) do
				local mutator = mm:get_mutator_from_id(id)
				if mutator and not mm:is_mutator_active(mutator) then
					table.insert(mm:active_mutators(), {mutator = mutator})
				end
				for key, value in pairs(data) do
					if Network:is_client() then
						mutator:set_host_value(key, value)
					end
				end
			end
		end
		local setup_mutators = {}
		for _, active_mutator in pairs(mm:active_mutators()) do
			table.insert(setup_mutators, active_mutator.mutator)
		end
		table.sort(setup_mutators, function(a, b)
			return a.load_priority > b.load_priority
		end)
		for _, mutator in pairs(setup_mutators) do
			mutator:setup(mm)
		end
	end

	Hooks:PostHook(MutatorsManager, "set_enabled", "TMP_mutator_saving_set_enabled", function()
		TMP_mutator_saving:Pre_Save()
	end)
	
	Hooks:PostHook(MutatorsManager, "reset_to_default", "TMP_mutator_saving_reset_to_default", function()
		TMP_mutator_saving:Pre_Save()
	end)

	Hooks:Add("MenuManagerOnOpenMenu", "TMP_mutator_saving_MenuManagerOnOpenMenu", function(menu_manager, menu, ...)
		if menu == "menu_main" or menu == "crime_spree_lobby" or menu == "lobby" then
			TMP_mutator_saving:Pre_Save()
		end
	end)