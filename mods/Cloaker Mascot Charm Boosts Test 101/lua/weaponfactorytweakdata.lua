local ThisModPath = ModPath
local mod_ids = Idstring(ThisModPath):key()
local hook2 = "F"..Idstring("hook2::"..mod_ids):key()

Hooks:Add("LocalizationManagerPostInit", hook2, function(loc)
	loc:add_localized_strings({
		["bm_wp_upg_charm_cloaker"] = loc:text("bm_wp_upg_charm_cloaker").."\n\n".."[+] 15% chance to stun the enemy.".."\n",
	})
end)