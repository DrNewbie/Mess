if Announcer then
	Announcer:AddHostMod('Spawn More and Faster, (http://modwork.shop/20649)')
end

if UpdateThisMod then
	UpdateThisMod:Add({
		mod_id = 'Spawn More and Faster',
		data = {
			modworkshop_id = 20649
		}
	})
	UpdateThisMod:Loop()
end