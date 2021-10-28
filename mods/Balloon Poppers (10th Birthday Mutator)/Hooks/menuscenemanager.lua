local ThisModPath = ModPath
local ThisModIds = Idstring(ThisModPath):key()
local Hook0 = "F_"..Idstring("MenuSceneManager:_setup_mm10_event_units:"..ThisModIds):key()

function MenuSceneManager:_setup_mm10_event_units()
	local positions = {
		Vector3(100, 100, -75),
		Vector3(100, 175, -75),
		Vector3(25, 125, -75),
		Vector3(125, 125, -125),
		Vector3(75, 200, -125),
		Vector3(50, 100, -125),
		Vector3(0, 150, -125),
		Vector3(-25, 75, -75),
		Vector3(0, 50, -125),
		Vector3(-50, 100, -125)
	}
	local unit_names = {
		Idstring("units/pd2_dlc_a10th/props/a10th_gifts/a10th_gifts_diamonds"),
		Idstring("units/pd2_dlc_a10th/props/a10th_gifts/a10th_gifts_diamonds"),
		Idstring("units/pd2_dlc_a10th/props/a10th_gifts/a10th_gifts_polkal"),
		Idstring("units/pd2_dlc_a10th/props/a10th_gifts/a10th_gifts_polkal"),
		Idstring("units/pd2_dlc_a10th/props/a10th_gifts/a10th_gifts_polkas"),
		Idstring("units/pd2_dlc_a10th/props/a10th_gifts/a10th_gifts_polkas"),
		Idstring("units/pd2_dlc_a10th/props/a10th_gifts/a10th_gifts_stars"),
		Idstring("units/pd2_dlc_a10th/props/a10th_gifts/a10th_gifts_stars"),
		Idstring("units/pd2_dlc_a10th/props/a10th_gifts/a10th_gifts_stripes"),
		Idstring("units/pd2_dlc_a10th/props/a10th_gifts/a10th_gifts_stripes"),
		Idstring("units/pd2_dlc_a10th/props/a10th_gifts/a10th_gifts_zigzag"),
		Idstring("units/pd2_dlc_a10th/props/a10th_gifts/a10th_gifts_zigzag")
	}
	if self._mm10_event_units then
		for _, unit in ipairs(self._mm10_event_units) do
			unit:set_slot(0)
		end
	end
	self._mm10_event_units = {}
	local rotation, unit_index = nil
	for i, position in ipairs(positions) do
		rotation = Rotation((math.random(2) - 1) * 25, 0, 0)
		unit_index = math.random(#unit_names)
		self._mm10_event_units[i] = World:spawn_unit(unit_names[unit_index], position, rotation)
		table.remove(unit_names, unit_index)
	end
	local e_money = self._bg_unit:effect_spawner(Idstring("e_money"))
	if e_money then
		e_money:set_enabled(false)
	end
	if self._confetti_effect then
		World:effect_manager():kill(self._confetti_effect)

		self._confetti_effect = nil
	end
	self._confetti_effect = World:effect_manager():spawn({
		effect = Idstring("effects/payday2/environment/confetti_menu"),
		position = Vector3(0, 0, 0),
		rotation = Rotation()
	})
end

Hooks:PostHook(MenuSceneManager, "_setup_bg", Hook0, function(self)
	--self:_setup_mm10_event_units()
end)