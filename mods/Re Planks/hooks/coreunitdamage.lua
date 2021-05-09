core:import("CoreSequenceManager")

function CoreUnitDamage:__special_req_re_this_planks()
	local unit_key = self._unit:key()
	for _, body_element in pairs(self._unit_element._bodies) do
		if type(body_element) == "table" and type(body_element._name) == "string" and body_element._name == "planks_body" then
			local body = self._unit:body(body_element._name)
			if body then
				body:set_extension(body:extension() or {})
				local body_ext = CoreBodyDamage:new(self._unit, self, body, body_element)
				body:extension().damage = body_ext
				local body_key = nil
				for damage_type, _ in pairs(body_ext:get_endurance_map()) do
					body_key = body_key or body:key()
					managers.sequence:add_inflict_updator_body(damage_type, unit_key, body_key, body_ext)
				end
			end
		end
	end
end