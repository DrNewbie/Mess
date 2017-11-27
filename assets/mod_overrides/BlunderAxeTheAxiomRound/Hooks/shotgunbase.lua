local BlunderAxeTheAxiomRound_ShotgunBase_fire = ShotgunBase.fire
local BlunderAxeTheAxiomRound_AxeList = {}
function ShotgunBase:fire(from_pos, direction, ...)
	if alive(self._unit) and self._unit:base()._blueprint and table.contains(self._unit:base()._blueprint, "wpn_fps_axebullet") then
		local _unit = ProjectileBase.throw_projectile("wpn_prj_hur", from_pos, direction, managers.network:session():local_peer():id())
		table.insert(BlunderAxeTheAxiomRound_AxeList, _unit)
		if table.size(BlunderAxeTheAxiomRound_AxeList) > 10 then
			if alive(BlunderAxeTheAxiomRound_AxeList[1]) then
				managers.network:session():send_to_peers("remove_unit", BlunderAxeTheAxiomRound_AxeList[1])
				BlunderAxeTheAxiomRound_AxeList[1]:set_slot(0)
			end
			BlunderAxeTheAxiomRound_AxeList[1] = BlunderAxeTheAxiomRound_AxeList[2]
			BlunderAxeTheAxiomRound_AxeList[2] = BlunderAxeTheAxiomRound_AxeList[3]
			BlunderAxeTheAxiomRound_AxeList[3] = BlunderAxeTheAxiomRound_AxeList[4]
			BlunderAxeTheAxiomRound_AxeList[4] = BlunderAxeTheAxiomRound_AxeList[5]
			BlunderAxeTheAxiomRound_AxeList[5] = BlunderAxeTheAxiomRound_AxeList[6]
			BlunderAxeTheAxiomRound_AxeList[6] = BlunderAxeTheAxiomRound_AxeList[7]
			BlunderAxeTheAxiomRound_AxeList[7] = BlunderAxeTheAxiomRound_AxeList[8]
			BlunderAxeTheAxiomRound_AxeList[8] = BlunderAxeTheAxiomRound_AxeList[9]
			BlunderAxeTheAxiomRound_AxeList[9] = BlunderAxeTheAxiomRound_AxeList[10]
			BlunderAxeTheAxiomRound_AxeList[10] = BlunderAxeTheAxiomRound_AxeList[11]
			BlunderAxeTheAxiomRound_AxeList[11] = nil
		end
	end
	return BlunderAxeTheAxiomRound_ShotgunBase_fire(self, from_pos, direction, ...)
end