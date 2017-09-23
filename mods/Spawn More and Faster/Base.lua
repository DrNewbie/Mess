if Announcer then
	Announcer:AddHostMod('Spawn More and Faster, (http://modwork.shop/20649)')
end


-- ID from modworkshop
local mwsID = '20649'

--------------------------------------
local url = {
		-- download, info, notes
		d = 'https://modworkshop.net/mydownloads/downloads/',
		i = 'https://manager.modworkshop.net/GetSingleDownload/'..mwsID..'.json',
		n = 'https://modworkshop.net/mydownloads.php?action=view_down&did='..mwsID..'#changelog'
	}

-- In case BLT changes in the future
if not BLT.Downloads
	or not BLT.Downloads._downloads
	or not BLT.Mods
	or not BLTUpdate
then
	return
end

local caller = string.sub(debug.getinfo(1,'S').source,2)
local thisMod = nil

local inx  -- This is used in the end of the file
for i, mod in pairs(BLT.Mods.mods) do

		-- This cannot find the mod if it has a dash in its folder name
		if string.find(caller:gsub('-',' '), mod:GetPath():gsub('-',' ')) == 1 then
			thisMod = mod
			inx = i
		end
	end
if not thisMod then return end

local update = BLTUpdate:new(thisMod, 
								{
									identifier = mwsID,
									disallow_update = 'upd_mws_clbk'..mwsID
								}
							)

-- If update is saved in blt_data.txt then 
--  we need to take its 'enabled' setting into account
-- That update also has to be in mod.txt for this to work
local oldUpd = thisMod:GetUpdate(mwsID)
if oldUpd then
	if not oldUpd.enabled then return end
	update.enabled = oldUpd.enabled
	update._enabled = oldUpd._enabled
end
oldUpd = nil
							
update._server_hash = '000'

function update:DisallowsUpdate()
	if debug.getinfo(2,'n').name == 'download_all' then
		return false
	end
	return true
end

function update:ViewPatchNotes()
	if Steam:overlay_enabled() then
		Steam:overlay_activate("url", url.n)
	else
		os.execute("cmd /c start " .. url.n)
	end
end

-- This is a copy of BLT's BLTDownloadManager:clbk_download_finished
-- But this one does not verify the integrity of the mod files
if not BLT.Downloads.clbk_dwnld_fin_no_ver then
	function BLT.Downloads:clbk_dwnld_fin_no_ver(data, http_id)
		local download = BLT.Downloads:get_download_from_http_id(http_id)
		log(string.format("[Downloads] Finished download of %s (%s)", download.update:GetName(), download.update:GetParentMod():GetName()))
		BLT.Downloads._coroutine_ws = BLT.Downloads._coroutine_ws or managers.gui_data:create_fullscreen_workspace()
		download.coroutine = BLT.Downloads._coroutine_ws:panel():panel({})
		local save = function()
			local wait = function( x )
				for i = 1, (x or 5) do
					coroutine.yield()
				end
			end
			local temp_dir = Application:nice_path( download.update:GetInstallDirectory() .. "_temp" )
			local file_path = Application:nice_path( BLTModManager.Constants:DownloadsDirectory() .. tostring(download.update:GetId()) .. ".zip" )
			local temp_install_dir = Application:nice_path( temp_dir .. "/" .. download.update:GetInstallFolder() )
			local install_path = Application:nice_path( download.update:GetInstallDirectory() .. download.update:GetInstallFolder() )
			local extract_path = Application:nice_path( temp_install_dir .. "/" .. download.update:GetInstallFolder() )
			local cleanup = function()
				SystemFS:delete_file( temp_install_dir )
			end
			wait()
			SystemFS:make_dir( temp_dir )
			SystemFS:delete_file( file_path )
			cleanup()
			log("[Downloads] Saving to downloads...")
			download.state = "saving"
			wait()
			local f = io.open( file_path, "wb+" )
			if f then
				f:write( data )
				f:close()
			end
			log("[Downloads] Extracting...")
			download.state = "extracting"
			wait()
			unzip(file_path, temp_install_dir)
			wait()
			log("[Downloads] Going on unverified...")
			log("[Downloads] Removing old installation...")
			wait()
			SystemFS:delete_file(install_path)
			local move_success = file.MoveDirectory(extract_path, install_path)
			if not move_success then
				log("[Downloads] Failed to move installation directory!")
				download.state = "failed"
				cleanup()
				return
			end
			log("[Downloads] Complete!")
			download.state = "complete"
			cleanup()
		end
		download.coroutine:animate( save )
		MenuCallbackHandler['upd_mws_clbk'..mwsID] = nil
	end
end

-- Needs to be different for every mod
MenuCallbackHandler['upd_mws_clbk'..mwsID] = function(this)
	local http_id = dohttpreq(url.d,
						callback(BLT.Downloads, BLT.Downloads, "clbk_dwnld_fin_no_ver"),
						callback(BLT.Downloads, BLT.Downloads, "clbk_download_progress")
					)
	local download = {
		update = update,
		http_id = http_id,
		state = "waiting"
	}
	table.insert(BLT.Downloads._downloads, download)
end

local function ParseInfo(text, id, message)
			local req_upd = false
			local success = true
			local data = json.decode(text)
			if data and data[mwsID] and data[mwsID].download
				and thisMod.version and data[mwsID].version
			then
				if thisMod.version ~= data[mwsID].version then
					url.d = url.d..data[mwsID].download
					req_upd = true
					BLT.Mods:clbk_got_update(update, true)
				else
					MenuCallbackHandler['upd_mws_clbk'..mwsID] = nil
				end
			else
				success = false
			end
			
			-- Localization manager refuses to work here so screw it
			if message then
				local dialog = {}
				dialog.title = thisMod.name
				local bOk = {
								text = 'OK',
								cancel_button = true
							}
				dialog.button_list = {bOk}
				if success then
					if req_upd then
						dialog.text = 'An update is available!'
						local bDownload = {
									text = 'Open download manager',
									callback_func = function()
														managers.menu:open_node('blt_download_manager')
													end
									}	
						dialog.button_list = {bDownload, dialog.button_list[1]}
					else
						dialog.text = 'The latest version is installed.'
					end
				else
					dialog.text = 'Unable to check updates. No valid data received.'
				end
				managers.system_menu:show(dialog)
			end
		end

-- Make BLT display 'Check updates' button for this mod
BLT.Mods.mods[inx].GetUpdates = function()
	return {update}
end

-- On clicking 'Check updates'
BLT.Mods.mods[inx].CheckForUpdates = function(clbk)

	if BLT.Mods.mods[inx].upd_checking then return end

	-- This makes the stamina icon rotate
	BLT.Mods.mods[inx].upd_checking = true
	
	dohttpreq(url.i, function(text, id)
						BLT.Mods.mods[inx].upd_checking = nil
						ParseInfo(text, id, true)
					end)
end

BLT.Mods.mods[inx].IsCheckingForUpdates = function()
	return BLT.Mods.mods[inx].upd_checking or false
end

dohttpreq(url.i, function(text, id)
	ParseInfo(text, id)
end)