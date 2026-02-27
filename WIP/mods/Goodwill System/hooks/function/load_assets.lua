_G.GoodWillSysMain = _G.GoodWillSysMain or {}

if _G.GoodWillSysMain._hooks.load_assets then
	return
else
	_G.GoodWillSysMain._hooks.load_assets = true
end

pcall(function()
	BLTAssetManager:CreateEntry( 
		Idstring("goodwill/texture/heart"), 
		Idstring("texture"), 
		_G.GoodWillSysMain.ThisModPath.."/assets/heart.dds", 
		nil 
	)
end)