if Announcer then
	Announcer:AddHostMod('Symmetra, (http://modwork.shop/21086)')
end

if UpdateThisMod then
	UpdateThisMod:Add({
		mod_id = 'Symmetra',
		data = {
			modworkshop_id = 21086
		}
	})
	UpdateThisMod:Loop()
end