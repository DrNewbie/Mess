local ThisPackage = "packages/pda9_piggybank"
local ThisUnitName = "units/pd2_dlc_pda9/props/pda9_piggybank/pda9_prop_piggybank_level_1"

if PackageManager:package_exists(ThisPackage) and not PackageManager:loaded(ThisPackage) then
	PackageManager:load(ThisPackage)
end

if MenuSceneManager then
	function MenuSceneManager:SpawnPBiMM()
		if PackageManager:package_exists(ThisPackage) and PackageManager:loaded(ThisPackage) and DB:has("unit", ThisUnitName) then
			local is_PBiMM = type(PBiMM) == "table" and type(PBiMM.Options) == "table" and type(PBiMM.Options.GetValue) == "function"
			if MenuSceneManager.PBiMM and alive(MenuSceneManager.PBiMM) then
				MenuSceneManager.PBiMM:set_slot(0)
				MenuSceneManager.PBiMM = nil
			end
			local __pos = Vector3(30, 25, -100)
			local __rot = Rotation(130, 0, 0)
			local p_unit = World:spawn_unit(Idstring(ThisUnitName), __pos, __rot)
			if p_unit then
				MenuSceneManager.PBiMM = p_unit
			end
			if is_PBiMM then
				PBiMM:OptChanged()
			end
		end
	end
	Hooks:PostHook(MenuSceneManager, "_setup_bg", "SpawnAddonItemsEventNow", function(self) 
		self:SpawnPBiMM()
	end)
end