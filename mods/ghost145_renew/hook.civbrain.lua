Hooks:PostHook(CivilianBrain, "on_intimidated", "Ghost145Plus_CivilianBrain_on_intimidated", function(self, amount, aggressor_unit)
	if Network:is_server() and m_ghost:mode() > 1 then
		managers.groupai:state():propagate_alert({
			"vo_distress",
			aggressor_unit:movement():m_head_pos(),
			1000,
			managers.groupai:state():get_unit_type_filter("civilians_enemies"),
			aggressor_unit
		})
	end
end)