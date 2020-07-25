Hooks:PostHook(HUDInteraction, "show_interaction_bar", "F_"..Idstring("HUDInteraction:show_interaction_bar:CircleSpin"):key(), function(self, current, total)
	if self._interact_circle._circle and self._interact_circle._circle.animate and type(current) == "number" and type(total) == "number" then
		local function spin_anim(o)
			local dt = nil
			while true do
				dt = coroutine.yield()
				o:rotate(360 * dt)
			end
		end
		self._interact_circle._circle:animate(spin_anim)
	end
end)