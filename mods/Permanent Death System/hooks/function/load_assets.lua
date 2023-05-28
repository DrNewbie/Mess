local DeadManSysMain = _G.DeadManSysMain

if DeadManSysMain._hooks.load_assets then
	return
else
	DeadManSysMain._hooks.load_assets = true
end

pcall(function()
	BLTAssetManager:CreateEntry( 
		Idstring("dmsm/texture/dmsm_skull"), 
		Idstring("texture"), 
		DeadManSysMain.ThisModPath.."/assets/dmsm_skull.texture", 
		nil 
	)
end)