local mod_ids = Idstring("「Hinaomi」 — Today at 6:45 PM @Dr_Newbie Can you do the mod that let you sell masks that in Mask Stash that are not for sell (like Jiro Begin)"):key()

Hooks:PostHook(BlackMarketGui, "populate_buy_mask", "F_"..Idstring("func1::"..mod_ids):key(), function(self, data)
	for __k, __v in pairs(data) do
		if type(__v) == "table" and type(data[__k].unlocked) == "number" and data[__k].unlocked > 0 and managers.money:get_mask_sell_value(data[__k].name, data[__k].global_value) <= 0 then
			if tostring(json.encode(__v)):find("bm_sell") then
			
			else
				table.insert(data[__k], "bm_sell")
			end
		end
	end
end)