local CopRandomWeaponTaserTravelEnter = TaserLogicAttack.enter

function TaserLogicAttack.enter(data, new_logic_name, enter_params)
	if data and data.char_tweak and data.char_tweak.weapon and data.unit and data.unit:inventory() and data.unit:inventory():equipped_unit() and data.unit:inventory():equipped_unit():base() then
		if not data.unit:inventory():equipped_unit():base():weapon_tweak_data().usage or not data.char_tweak.weapon[data.unit:inventory():equipped_unit():base():weapon_tweak_data().usage] or not data.char_tweak.weapon[data.unit:inventory():equipped_unit():base():weapon_tweak_data().usage].range then
			for i, d in pairs(data.char_tweak.weapon) do
				if d.range then
					data.unit:inventory():equipped_unit():base():weapon_tweak_data().usage = i
					break
				end
			end
		end		
	end
	CopRandomWeaponTaserTravelEnter(data, new_logic_name, enter_params)
end