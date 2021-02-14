Hooks:PreHook(FirstAidKitBase, 'take', 'F_'..Idstring('take:Gura say My Goddess [FAK Sound]'):key(), function(self, unit)
	if not self._empty and unit and unit:sound_source() then
		unit:sound_source():post_event("ogg_c5253800f7a9b337")
	end
end)