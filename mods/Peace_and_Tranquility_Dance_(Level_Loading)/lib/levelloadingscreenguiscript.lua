Hooks:PostHook(LevelLoadingScreenGuiScript, "init", "LevelLoadHatinTimeSmugDanceInit", function(self)
	self._smug_dance_panel = self._back_drop_gui:get_new_base_layer()
	self._smug_dance_panel:set_size(155, 201)
	self._smug_dance_img = self._smug_dance_panel:bitmap({
		name = "smug_dance",
		texture = "textures/hat_in_time/smug_dance",
		color = Color.white:with_alpha(1),
		layer = 1000
	})
	self._hat_kid_smug_dance_it = self._hat_kid_smug_dance_it or 1
end)

Hooks:PostHook(LevelLoadingScreenGuiScript, "update", "LevelLoadHatinTimeSmugDanceLoop", function(self)
	if self._smug_dance_panel and self._smug_dance_img then
		local x_new = 155
		local y_new = 201
		if self._hat_kid_smug_dance_it >= 1 and self._hat_kid_smug_dance_it <= 10 then
			y_new = y_new * 3
		elseif self._hat_kid_smug_dance_it >= 11 and self._hat_kid_smug_dance_it <= 20 then
			y_new = y_new * 2
		elseif self._hat_kid_smug_dance_it >= 21 and self._hat_kid_smug_dance_it <= 30 then
			y_new = y_new * 1
		elseif self._hat_kid_smug_dance_it >= 31 and self._hat_kid_smug_dance_it <= 40 then
			y_new = y_new * 0
		elseif self._hat_kid_smug_dance_it >= 41 and self._hat_kid_smug_dance_it <= 50 then
			y_new = y_new * -1
		elseif self._hat_kid_smug_dance_it >= 51 and self._hat_kid_smug_dance_it <= 58 then
			y_new = y_new * -2
		end
		local x_fix = {-4, 5, 4, 3, 2, 1, 0, -1, -2, -3}
		x_new = x_new * x_fix[(self._hat_kid_smug_dance_it % 10 + 1)]
		self._smug_dance_img:set_center(x_new, y_new)
		self._hat_kid_smug_dance_it = self._hat_kid_smug_dance_it + 1
		if self._hat_kid_smug_dance_it > 58 then
			self._hat_kid_smug_dance_it = 1
		end
	end
end)