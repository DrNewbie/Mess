if not GoonBase then
	return
end

local verf = "1e2c60f1f"

GoonBase.WeaponCustomization = GoonBase.WeaponCustomization or {}
local WeaponCustomization = GoonBase.WeaponCustomization

if not WeaponCustomization then
	return
end

function WeaponCustomization.copy_skin_callback(self, data)
	_Menu(data, 0)
end

function WeaponCustomization.free_copy_skin_callback(self, data)
	_Menu(data, 1)
end

function WeaponCustomization.send_skin_callback(self, data)
	local _weapon = WeaponCustomization:GetWeaponTableFromInventory( data )
	if not _weapon then
		return
	end
	if not _weapon.visual_blueprint then
		return
	end
	if not _weapon.visual_blueprint then
		WeaponCustomization:BuildDefaultVisualBlueprint( _weapon )
	end
	_Menu_Send(_weapon.visual_blueprint)
end

function WeaponCustomization.output_skin_callback(self, data)

	data = data or managers.blackmarket._customizing_weapon_data

	local weapon_name = data.name 
	local weapon_category = data.category
	local weapon_slot = data.slot
	
	if not weapon_category or not weapon_slot then
		return
	end
	
	local weapon = WeaponCustomization:GetWeaponTableFromInventory( data )

	if not weapon then
		return
	end

	if not weapon.visual_blueprint then
		if weapon_category == "melee_weapons" then
			return
		else
			WeaponCustomization:BuildDefaultVisualBlueprint( weapon )
		end
	end

	local _file_name = ""
	for k, v in pairs( weapon.visual_blueprint ) do		
		_file_name = _file_name .. "-" .. k
		_file_name = _file_name .. "-" .. v["materials"]
		_file_name = _file_name .. "-" .. v["textures"]
		_file_name = _file_name .. "-" .. v["colors"]
	end
	
	_file_name = tostring(weapon.weapon_id) .. "___" .. sha1(_file_name)
	local settings_file = "mods/ShareGoonModWeaponSkin/" .. _file_name .. ".txt"
	local file = io.open(settings_file, "w")
	if file then
		local _bool = false
		local _part_check = {}
		if weapon.blueprint then
			for k, v in pairs( weapon.blueprint ) do
				_part_check[v] = 1
			end
		end
		for k, v in pairs( weapon.visual_blueprint ) do
			if tostring(_part_check[k]) ~= "nil" then
				file:write("" .. k, "\n")
				file:write("" .. v["materials"], "\n")
				file:write("" .. v["textures"], "\n")
				file:write("" .. v["colors"], "\n")
				_bool = true
			end
		end
		if _bool then
			local _dialog_data = { 
				title = "NEW SKIN !!",
				text = _file_name,
				button_list = {{ text = "CANCEL", is_cancel_button = true }},
				id = tostring(math.random(0,0xFFFFFFFF))
			}
			managers.system_menu:show(_dialog_data)
		end
		file:close()
	end
end

Hooks:Add("LocalizationManagerPostInit", "GoodModPlugin_Localization", function(loc)
	LocalizationManager:add_localized_strings({
		["copy_skin_from_other_name"] = "Copy Skin",
		["free_copy_skin_from_other_name"] = "Free Copy Skin",
		["output_skin_name"] = "Output Skin",
		["send_skin_to_someone"] = "Send Skin",
	})
end)

Hooks:Add("BlackMarketGUIModifyWeaponCosmeticsActionList", "BlackMarketGUIModifyWeaponCosmeticsActionList.WeaponCustomization", function(gui, data, new_data)

	if new_data.name == "goonmod_custom_skin" then

		-- Clear actions list
		for k, v in ipairs(new_data) do
			new_data[k] = nil
		end

		-- Custom actions
		local crafted = managers.blackmarket:get_crafted_category(data.category)[data.prev_node_data and data.prev_node_data.slot]
		if crafted and crafted.cosmetics then
			table.insert( new_data, "wcc_goonmod_apply" )
		else
			table.insert( new_data, "wcc_goonmod_edit" )
			table.insert( new_data, "wcc_goonmod_outputskin" )
			table.insert( new_data, "wcc_goonmod_copyskin" )
			table.insert( new_data, "wcc_goonmod_freecopyskin" )
			table.insert( new_data, "wcc_goonmod_sendskin" )
		end

	end

end)

Hooks:Add("BlackMarketGUIPostSetup", "BlackMarketGUIPostSetup.WeaponCustomization", function(gui, is_start_page, component_data)

	-- Create open editor button
	local btn_x = 10
	if gui._btns then

		local BTNS = {
			wcc_goonmod_edit = {
				prio = 1,
				btn = "BTN_A",
				pc_btn = nil,
				name = "bm_menu_btn_edit_goonmod_cosmetic",
				callback = callback(WeaponCustomization, WeaponCustomization, "weapon_visual_customization_callback")
			},
			wcc_goonmod_outputskin = {
				prio = 1,
				btn = "BTN_A",
				pc_btn = nil,
				name = "output_skin_name",
				callback = callback(WeaponCustomization, WeaponCustomization, "output_skin_callback")
			},
			wcc_goonmod_copyskin = {
				prio = 1,
				btn = "BTN_A",
				pc_btn = nil,
				name = "copy_skin_from_other_name",
				callback = callback(WeaponCustomization, WeaponCustomization, "copy_skin_callback")
			},
			wcc_goonmod_sendskin = {
				prio = 1,
				btn = "BTN_A",
				pc_btn = nil,
				name = "send_skin_to_someone",
				callback = callback(WeaponCustomization, WeaponCustomization, "send_skin_callback")
			},
			wcc_goonmod_freecopyskin = {
				prio = 1,
				btn = "BTN_A",
				pc_btn = nil,
				name = "free_copy_skin_from_other_name",
				callback = callback(WeaponCustomization, WeaponCustomization, "free_copy_skin_callback")
			},
			wcc_goonmod_apply = {
				prio = 1,
				btn = "BTN_A",
				pc_btn = nil,
				name = "bm_menu_btn_choose_goonmod_cosmetic",
				callback = nil
			}
		}

		local btn_x = 10
		for btn, btn_data in pairs(BTNS) do
			local new_btn = BlackMarketGuiButtonItem:new(gui._buttons, btn_data, btn_x)
			gui._btns[btn] = new_btn
		end

	end

end)

function _Menu_Send (file_data)
	if managers.network and managers.network:session() then
		local now_peer = { managers.network:session():peer(1) or nil,
			managers.network:session():peer(2) or nil,
			managers.network:session():peer(3) or nil,
			managers.network:session():peer(4) or nil }
		local opts = {}
		optionone = optionone or function(data)
			local Net = _G and _G.LuaNetworking or nil
			local _sendtxt = ""
			local _ptxt = ""
			if Net then
				for k, v in pairs(data.file_data) do
					local _k = WeaponCustomization:parts7id(true, k)
					if _k ~= "0" then
						local _m = WeaponCustomization:materials7id(true, v["materials"])
						local _t = WeaponCustomization:textures7id(true, v["textures"])
						local _c = WeaponCustomization:colors7id(true, v["colors"])
						_ptxt = _k .. "," .. _m .. "," .. _t .. "," .. _c
						_sendtxt = _sendtxt .. "" .. _ptxt .. ","
					end
				end	
				Net:SendToPeer(data.id, verf, _sendtxt)
			end
		end
		for i = 1, 4 do
			if now_peer[i] then
				opts[#opts+1] = { text = "" .. now_peer[i]:name(), data = {id = i, file_name = file_name, file_data = file_data}, callback = optionone }
			end			
		end
		
		opts[#opts+1] = { text = "CANCEL", is_cancel_button = true }
		mymenu = SimpleMenu:new("Skin Sender", "", opts)
		 
		if not managers.hud then
			mymenu:show()
		end
	end
end

function _Menu (data, var)
	local weapon = WeaponCustomization:GetWeaponTableFromInventory( data )
	if not weapon then
		return
	end

	option1 = option1 or function(data)
		if data.weapon and data.file then
			local _weapon = data.weapon
			local settings_file = "mods/ShareGoonModWeaponSkin/" .. data.file
			local file = io.open(settings_file, "r")
			if file then
				local line = file:read()
				local j = 0
				local _var = {}
				while line do
					j = j + 1
					_var[j] = tostring(line)
					line = file:read()
				end
				file:close()
				if not _weapon.visual_blueprint then
					WeaponCustomization:BuildDefaultVisualBlueprint( _weapon )
				end
				local _part_check, _part_check2 = {}, {}
				if weapon.blueprint then
					for k, v in pairs( weapon.blueprint ) do
						_part_check[v] = 1
					end
				end
				if tweak_data.upgrades.definitions[_weapon.weapon_id] then
					if tweak_data.upgrades.definitions[_weapon.weapon_id]["factory_id"] then
						local _factory_id = tweak_data.upgrades.definitions[_weapon.weapon_id]["factory_id"]
						local _uses_parts = tweak_data.weapon.factory[_factory_id]["uses_parts"] or {}
						local _default_blueprint = tweak_data.weapon.factory[_factory_id]["default_blueprint"] or {}
						if _uses_parts then
							for x_k, x_v in pairs( _uses_parts ) do
								_part_check2[x_v] = 1
							end
						end
						if _default_blueprint then
							for x_k, x_v in pairs( _default_blueprint ) do
								_part_check2[x_v] = 1
							end
						end
					end
				end
				j = 1
				local _info, _part, _retry = "", "", false
				while _var[j] do
					local _v = tostring(_var[j])
					if tostring(_part_check[_v]) ~= "nil" then
						if _weapon.visual_blueprint[_v] then
							_weapon.visual_blueprint[_v]["materials"] = _var[j+1]
							_weapon.visual_blueprint[_v]["textures"] = _var[j+2]
							_weapon.visual_blueprint[_v]["colors"] = _var[j+3]
						else
							_weapon.visual_blueprint[_v] =  {
								["materials"] = "no_material",
								["textures"] = "no_color_no_material",
								["colors"] = "white_solid",
							}
							_retry = true
						end
					else
						if tweak_data.weapon.factory.parts[_v] then
							if tostring(_part_check2[_v]) ~= "nil" then
								_part = WeaponCustomization:_GetLocalizedPartName(_v, tweak_data.weapon.factory.parts[_v])
							end
						else
							_part = "??" .. _v
						end
						if _part ~= "" then
							_info = _info .. "[".. _part .."]\n"
							_part = ""
						end
					end
					j = j + 4
				end
				if _info ~= "" then
					local _dialog_data = { 
						title = "Attachments Missing!!",
						text = _info,
						button_list = {{ text = "CANCEL", is_cancel_button = true }},
						id = tostring(math.random(0,0xFFFFFFFF))
					}
					managers.system_menu:show(_dialog_data)
				end
				if _retry then
					local _dialog_data = { 
						title = "Please copy it again.",
						text = "There is nothing done in this step.",
						button_list = {{ text = "CANCEL", is_cancel_button = true }},
						id = tostring(math.random(0,0xFFFFFFFF))
					}
					managers.system_menu:show(_dialog_data)
				end
				WeaponCustomization:LoadWeaponCustomizationFromBlueprint( _weapon.visual_blueprint )
			end
		end
	end
	
	local _weapon_id = weapon.weapon_id .. "___"
	local _data_record = {}
	local _finded = {}
	local i = 0
	for dir in io.popen([[dir "mods/ShareGoonModWeaponSkin/" /b]]):lines() do
		if (dir:find(_weapon_id) and var == 0) or (dir:match("%d+_") and var == 1) then
			i = i + 1
			_data_record[i] = dir
			local new_name = ""
			if var == 0 then
				new_name = dir:gsub(_weapon_id, "")
				new_name = new_name:gsub(".txt", "")
			else
				new_name = dir:gsub(".txt", "")
			end
			_finded[i] = new_name
		end
	end
	local opts = {}
	i = 0
	for finded in pairs(_finded or {}) do
		i = i + 1
		opts[#opts+1] = { text = _finded[i], callback = option1, data = {weapon = weapon, file = _data_record[i]} }
	end
	opts[#opts+1] = { text = "CANCEL", is_cancel_button = true }
	mymenu = SimpleMenu:new("Skin Menu", "Choose what skin you want to use.", opts)
	 
	if not managers.hud then
		mymenu:show()
	end
end

if not SimpleMenu then

	SimpleMenu = class()
	 
	function SimpleMenu:init(title, message, options)
		self.dialog_data = { title = title, text = message, button_list = {},
			id = tostring(math.random(0,0xFFFFFFFF)) }
		self.visible = false
		for _,opt in ipairs(options) do
			local elem = {}
			elem.text = opt.text
			opt.data = opt.data or nil
			opt.callback = opt.callback or nil
			elem.callback_func = callback(self, self, "_do_callback",
				{ data = opt.data,
				callback = opt.callback})
			elem.cancel_button = opt.is_cancel_button or false
			if opt.is_focused_button then
				self.dialog_data.focus_button = #self.dialog_data.button_list+1
			end
			table.insert(self.dialog_data.button_list, elem)
		end
		return self
	end
	 
	function SimpleMenu:_do_callback(info)
		if info.callback then
			if info.data then
				info.callback(info.data)
			else
				info.callback()
			end
		end
		self.visible = false
	end
	 
	function SimpleMenu:show()
		if self.visible then
			return
		end
		self.visible = true
		managers.system_menu:show(self.dialog_data)
	end
	
	function SimpleMenu:hide()
		if self.visible then
			managers.system_menu:close(self.dialog_data.id)
			self.visible = false
			return
		end
	end
end

-- Network Messages
Hooks:Add("NetworkReceivedData", "NetworkReceivedData_ShareGoonModSkin", function(sender, message, data)
	log("verf " .. verf)
	if message == verf and verf then
		local file_get = data
		local file_name = "1_" .. sha1(file_get)
		local file_data = {}
		local _dialog_data = { 
			title = "NEW SKIN !!",
			text = file_name,
			button_list = {{ text = "CANCEL", is_cancel_button = true }},
			id = tostring(math.random(0,0xFFFFFFFF))
		}
		managers.system_menu:show(_dialog_data)

		local settings_file = "mods/ShareGoonModWeaponSkin/" .. file_name .. ".txt"
		local file = io.open(settings_file, "w")
		local j = 1
		file_data = mysplit(file_get, ",")
		if file then
			for k, v in pairs(file_data or {}) do
				local _v = ""
				if j%4 == 1 then
					_v = WeaponCustomization:parts7id(false, v)
				elseif j%4 == 2 then
					_v = WeaponCustomization:materials7id(false, v)
				elseif j%4 == 3 then
					_v = WeaponCustomization:textures7id(false, v)
				else
					_v = WeaponCustomization:colors7id(false, v)
				end
				file:write("" .. _v , "\n")
				j = j + 1
			end
			file:close()
		end

	end
end)

function WeaponCustomization:parts7id (_bool, var)
	local table_parts2id = {
		wpn_fps_smg_sterling_b_long = 1, 
		wpn_fps_pis_usp_fl_adapter = 2, 
		wpn_fps_ass_asval_body_standard = 3, 
		wpn_fps_snp_wa2000_b_suppressed = 4, 
		wpn_fps_pis_deagle_o_standard_front_long = 5, 
		wpn_upg_ak_s_folding_vanilla = 6, 
		wpn_fps_snp_msr_body_wood = 7, 
		wpn_fps_shot_huntsman_s_short = 8, 
		wpn_fps_snp_r93_b_suppressed = 9, 
		wpn_fps_smg_thompson_drummag = 10, 
		wpn_fps_pis_rage_b_comp2 = 11, 
		wpn_fps_pis_sparrow_sl_rpl = 12, 
		wpn_fps_upg_o_t1micro = 13, 
		wpn_fps_upg_m4_s_mk46 = 14, 
		wpn_fps_ass_s552_s_standard = 15, 
		wpn_fps_upg_o_mbus_rear = 16, 
		wpn_fps_smg_polymer_ns_silencer = 17, 
		wpn_fps_upg_o_docter = 18, 
		wpn_fps_upg_m4_m_l5 = 19, 
		wpn_fps_ass_fal_g_standard = 20, 
		wpn_fps_pis_g26_body_stardard = 21, 
		wpn_fps_bow_long_m_standard = 22, 
		wpn_upg_saiga_fg_standard = 23, 
		wpn_fps_pis_rage_b_short = 24, 
		wpn_fps_snp_msr_body_msr = 25, 
		wpn_fps_pis_g17_m_standard = 26, 
		wpn_fps_shot_saiga_b_standard = 27, 
		wpn_upg_ak_g_standard = 28, 
		wpn_fps_upg_a_bow_poison = 29, 
		wpn_fps_smg_thompson_foregrip_discrete = 30, 
		wpn_fps_shot_r870_s_nostock_single = 31, 
		wpn_fps_lmg_m249_upper_reciever = 32, 
		wpn_fps_bow_frankish_g_standard = 33, 
		wpn_fps_saw_body_silent = 34, 
		wpn_fps_pis_usp_m_standard = 35, 
		wpn_fps_snp_r93_body_standard = 36, 
		wpn_fps_sho_ben_b_standard = 37, 
		wpn_fps_pis_c96_m_standard = 38, 
		wpn_fps_ass_s552_o_flipup = 39, 
		wpn_fps_upg_ak_m_quad = 40, 
		wpn_fps_smg_sterling_m_short = 41, 
		wpn_fps_ass_g3_m_mag = 42, 
		wpn_upg_ak_fg_combo1 = 43, 
		wpn_fps_saw_b_normal = 44, 
		wpn_fps_ass_fal_fg_standard = 45, 
		wpn_fps_smg_uzi_s_leather = 46, 
		wpn_fps_sho_body_spas12_standard = 47, 
		wpn_fps_ass_galil_s_sniper = 48, 
		wpn_fps_snp_m95_barrel_standard = 49, 
		wpn_fps_smg_scorpion_g_ergo = 50, 
		wpn_fps_pis_g18c_m_mag_33rnd = 51, 
		wpn_fps_smg_mp9_s_skel = 52, 
		wpn_fps_pis_beretta_body_rail = 53, 
		wpn_fps_sho_ksg_b_short = 54, 
		wpn_fps_snp_m95_magazine = 55, 
		wpn_fps_smg_mp9_m_extended = 56, 
		wpn_fps_smg_p90_b_long = 57, 
		wpn_fps_upg_o_specter = 58, 
		wpn_fps_smg_akmsu_fg_rail = 59, 
		wpn_fps_pis_rage_lock = 60, 
		wpn_fps_ass_famas_b_standard = 61, 
		wpn_fps_ass_fal_s_standard = 62, 
		wpn_fps_smg_uzi_fg_rail = 63, 
		wpn_fps_ass_galil_g_standard = 64, 
		wpn_fps_upg_ak_g_pgrip = 65, 
		wpn_fps_upg_ass_m4_b_beowulf = 66, 
		wpn_fps_smg_mac10_s_fold = 67, 
		wpn_fps_ass_sub2000_fg_gen1 = 68, 
		wpn_fps_upg_m4_g_mgrip = 69, 
		wpn_fps_pis_1911_fl_legendary = 70, 
		wpn_fps_smg_m45_body_green = 71, 
		wpn_fps_sho_ben_b_long = 72, 
		wpn_fps_upg_ns_ass_smg_medium = 73, 
		wpn_fps_smg_scorpion_g_wood = 74, 
		wpn_fps_ass_m14_body_ebr = 75, 
		wpn_fps_shot_shorty_m_extended_short = 76, 
		wpn_fps_gre_m79_sight_up = 77, 
		wpn_fps_upg_bonus_concealment_p1 = 78, 
		wpn_upg_ak_fg_legend = 79, 
		wpn_fps_pis_c96_s_solid = 80, 
		wpn_fps_smg_baka_s_folded = 81, 
		wpn_fps_pis_p226_o_long = 82, 
		wpn_fps_upg_m4_m_straight_vanilla = 83, 
		wpn_fps_sho_aa12_barrel_long = 84, 
		wpn_fps_upg_a_crossbow_explosion = 85, 
		wpn_fps_smg_scorpion_body_standard = 86, 
		wpn_fps_ass_g3_fg_psg = 87, 
		wpn_fps_smg_olympic_s_short = 88, 
		wpn_fps_upg_ns_pis_jungle = 89, 
		wpn_fps_pis_1911_m_extended = 90, 
		wpn_fps_pis_1911_body_standard = 91, 
		wpn_fps_smg_cobray_bolt = 92, 
		wpn_fps_ass_famas_body_standard = 93, 
		wpn_upg_ak_fg_combo3 = 94, 
		wpn_fps_pis_deagle_co_long = 95, 
		wpn_fps_pis_sparrow_g_941 = 96, 
		wpn_fps_pis_g26_g_laser = 97, 
		wpn_fps_upg_fl_pis_laser = 98, 
		wpn_fps_pis_beretta_b_std = 99, 
		wpn_fps_ass_m16_o_handle_sight = 100, 
		wpn_fps_upg_o_rmr = 101, 
		wpn_fps_smg_p90_body_p90 = 102, 
		wpn_fps_ass_ak_body_lowerreceiver = 103, 
		wpn_fps_upg_ak_fg_tapco = 104, 
		wpn_fps_ass_ak5_fg_fnc = 105, 
		wpn_fps_smg_m45_s_folded = 106, 
		wpn_fps_pis_ppk_b_standard = 107, 
		wpn_fps_pis_2006m_g_bling = 108, 
		wpn_fps_ass_fal_fg_wood = 109, 
		wpn_fps_lmg_m249_fg_standard = 110, 
		wpn_fps_ass_s552_body_standard_black = 111, 
		wpn_fps_pis_judge_b_standard = 112, 
		wpn_fps_shot_r870_gadget_rail = 113, 
		wpn_fps_extra_zoom = 114, 
		wpn_fps_upg_m4_m_drum = 115, 
		wpn_fps_pis_deagle_m_standard = 116, 
		wpn_fps_m4_uupg_draghandle_core = 117, 
		wpn_fps_upg_ns_pis_medium = 118, 
		wpn_fps_smg_uzi_b_standard = 119, 
		wpn_fps_smg_m45_g_bling = 120, 
		wpn_fps_bow_hunter_b_standard = 121, 
		wpn_fps_smg_tec9_m_extended = 122, 
		wpn_fps_ass_g36_fg_ksk = 123, 
		wpn_fps_sho_s_spas12_nostock = 124, 
		wpn_fps_pis_g17_body_standard = 125, 
		wpn_fps_upg_m4_g_standard = 126, 
		wpn_fps_saw_body_standard = 127, 
		wpn_fps_upg_ns_pis_large = 128, 
		wpn_fps_ass_sub2000_fg_suppressed = 129, 
		wpn_fps_pis_beretta_m_std = 130, 
		wpn_fps_gre_m79_stock_short = 131, 
		wpn_fps_ass_famas_m_standard = 132, 
		wpn_fps_smg_sterling_s_nostock = 133, 
		wpn_fps_m4_lower_reciever = 134, 
		wpn_fps_upg_bonus_team_exp_money_p3 = 135, 
		wpn_fps_shot_huntsman_body_standard = 136, 
		wpn_fps_upg_bonus_total_ammo_p3 = 137, 
		wpn_fps_upg_bonus_total_ammo_p1 = 138, 
		wpn_fps_upg_bonus_damage_p2 = 139, 
		wpn_fps_pis_c96_body_standard = 140, 
		wpn_fps_upg_bonus_recoil_p1 = 141, 
		wpn_fps_upg_bonus_spread_n1 = 142, 
		wpn_fps_pis_deagle_m_extended = 143, 
		wpn_fps_upg_bonus_concealment_p3 = 144, 
		wpn_fps_snp_r93_b_short = 145, 
		wpn_fps_smg_baka_b_longsupp = 146, 
		wpn_fps_upg_bonus_concealment_p2 = 147, 
		wpn_upg_ak_fg_combo2 = 148, 
		wpn_fps_upg_bp_lmg_lionbipod = 149, 
		wpn_fps_gre_m79_barrelcatch = 150, 
		wpn_fps_amcar_uupg_body_upperreciever = 151, 
		wpn_fps_m4_uupg_b_medium_vanilla = 152, 
		wpn_fps_shot_r870_s_nostock = 153, 
		wpn_fps_upg_a_dragons_breath = 154, 
		wpn_fps_upg_o_eotech = 155, 
		wpn_fps_upg_m4_g_standard_vanilla = 156, 
		wpn_fps_upg_a_explosive = 157, 
		wpn_fps_upg_m4_g_hgrip = 158, 
		wpn_fps_upg_a_custom_free = 159, 
		wpn_fps_smg_sterling_s_folded = 160, 
		wpn_fps_m4_uupg_b_short = 161, 
		wpn_fps_bow_arblast_g_standard = 162, 
		wpn_fps_smg_sterling_o_adapter = 163, 
		wpn_fps_sho_aa12_dh = 164, 
		wpn_fps_smg_mp5_m_drum = 165, 
		wpn_fps_pis_ppk_body_standard = 166, 
		wpn_fps_lmg_mg42_n42 = 167, 
		wpn_fps_sho_b_spas12_short = 168, 
		wpn_fps_shot_b682_body_standard = 169, 
		wpn_fps_snp_model70_iron_sight = 170, 
		wpn_fps_lmg_m249_s_modern = 171, 
		wpn_fps_upg_ns_pis_medium_slim = 172, 
		wpn_fps_snp_model70_o_rail = 173, 
		wpn_fps_upg_o_rx30 = 174, 
		wpn_fps_upg_ns_ass_smg_stubby = 175, 
		wpn_fps_pis_deagle_b_standard = 176, 
		wpn_fps_snp_mosin_body_standard = 177, 
		wpn_fps_snp_model70_body_standard = 178, 
		wpn_fps_snp_model70_s_standard = 179, 
		wpn_fps_upg_m4_s_standard_vanilla = 180, 
		wpn_fps_pis_peacemaker_b_standard = 181, 
		wpn_fps_pis_2006m_b_long = 182, 
		wpn_fps_smg_polymer_o_iron = 183, 
		wpn_fps_pis_sparrow_sl_941 = 184, 
		wpn_fps_smg_sterling_body_standard = 185, 
		wpn_fps_m4_uupg_fg_rail = 186, 
		wpn_fps_snp_mosin_rail = 187, 
		wpn_fps_smg_sterling_b_standard = 188, 
		wpn_fps_shot_r870_b_short = 189, 
		wpn_fps_upg_ak_g_wgrip = 190, 
		wpn_fps_shot_r870_s_folding = 191, 
		wpn_fps_pis_sparrow_g_dummy = 192, 
		wpn_fps_snp_msr_m_standard = 193, 
		wpn_fps_ass_ak5_s_ak5c = 194, 
		wpn_upg_ak_s_skfoldable_vanilla = 195, 
		wpn_fps_pis_1911_g_standard = 196, 
		wpn_fps_bow_plainsrider_body_standard = 197, 
		wpn_fps_ass_l85a2_b_medium = 198, 
		wpn_fps_ass_akm_b_standard = 199, 
		wpn_fps_ass_s552_fg_standard = 200, 
		wpn_fps_pis_1911_g_ergo = 201, 
		wpn_fps_ass_asval_scopemount = 202, 
		wpn_fps_lmg_hk21_body_lower = 203, 
		wpn_fps_ass_fal_m_01 = 204, 
		wpn_fps_pis_g22c_b_standard = 205, 
		wpn_fps_smg_uzi_g_standard = 206, 
		wpn_fps_snp_mosin_ns_bayonet = 207, 
		wpn_fps_pis_beretta_o_std = 208, 
		wpn_fps_upg_o_dd_rear = 209, 
		wpn_fps_upg_ns_pis_small = 210, 
		wpn_fps_upg_ass_m4_fg_moe = 211, 
		wpn_fps_ass_scar_s_standard = 212, 
		wpn_fps_pis_sparrow_b_comp = 213, 
		wpn_fps_m4_uupg_fg_lr300 = 214, 
		wpn_fps_m4_uupg_m_std_vanilla = 215, 
		wpn_fps_pis_sparrow_b_rpl = 216, 
		wpn_fps_ass_m14_b_standard = 217, 
		wpn_fps_pis_sparrow_b_941 = 218, 
		wpn_fps_lmg_par_upper_reciever = 219, 
		wpn_fps_pis_usp_b_tactical = 220, 
		wpn_fps_shot_r870_b_long = 221, 
		wpn_fps_lmg_par_s_standard = 222, 
		wpn_fps_smg_mp9_s_fold = 223, 
		wpn_fps_snp_m95_barrel_suppressed = 224, 
		wpn_fps_ass_s552_b_standard = 225, 
		wpn_fps_pis_g18c_co_1 = 226, 
		wpn_fps_lmg_par_s_plastic = 227, 
		wpn_fps_lmg_par_m_standard = 228, 
		wpn_fps_ass_ak5_s_ak5a = 229, 
		wpn_fps_smg_mp7_m_extended = 230, 
		wpn_fps_lmg_par_body_standard = 231, 
		wpn_fps_upg_ns_ass_pbs1 = 232, 
		wpn_fps_pis_g18c_s_stock = 233, 
		wpn_fps_smg_mp5_s_ring = 234, 
		wpn_fps_lmg_par_b_standard = 235, 
		wpn_fps_bow_arblast_m_standard = 236, 
		wpn_fps_upg_o_cs = 237, 
		wpn_fps_ass_scar_o_flipups_down = 238, 
		wpn_fps_sho_aa12_barrel_silenced = 239, 
		wpn_fps_upg_smg_olympic_fg_lr300 = 240, 
		wpn_fps_bow_arblast_m_explosive = 241, 
		wpn_fps_shot_r870_fg_legendary = 242, 
		wpn_fps_pis_deagle_g_bling = 243, 
		wpn_fps_pis_1911_co_1 = 244, 
		wpn_upg_ak_g_legend = 245, 
		wpn_fps_shot_r870_b_legendary = 246, 
		wpn_fps_pis_g18c_g_ergo = 247, 
		wpn_fps_smg_p90_b_legend = 248, 
		wpn_fps_lmg_m134_barrel_legendary = 249, 
		wpn_fps_pis_c96_g_standard = 250, 
		wpn_fps_lmg_m134_body_upper_spikey = 251, 
		wpn_fps_rpg7_m_grinclown = 252, 
		wpn_fps_smg_thompson_barrel = 253, 
		wpn_fps_pis_rage_g_ergo = 254, 
		wpn_fps_snp_wa2000_m_standard = 255, 
		wpn_fps_ass_ak5_b_std = 256, 
		wpn_fps_gre_m32_lower_reciever = 257, 
		wpn_fps_ass_scar_fg_railext = 258, 
		wpn_fps_pis_1911_b_long = 259, 
		wpn_fps_pis_deagle_b_legend = 260, 
		wpn_fps_bow_arblast_m_poison = 261, 
		wpn_upg_ak_s_legend = 262, 
		wpn_fps_ass_fal_fg_01 = 263, 
		wpn_fps_shot_r870_s_legendary = 264, 
		wpn_fps_sho_ksg_fg_short = 265, 
		wpn_fps_ass_g36_s_kv = 266, 
		wpn_fps_ass_74_b_legend = 267, 
		wpn_fps_ass_s552_b_long = 268, 
		wpn_fps_upg_ak_ns_ak105 = 269, 
		wpn_fps_ass_g36_b_long = 270, 
		wpn_fps_bow_long_m_poison = 271, 
		wpn_fps_pis_ppk_g_laser = 272, 
		wpn_fps_ass_s552_s_standard_green = 273, 
		wpn_fps_bow_long_body_standard = 274, 
		wpn_upg_ak_fl_legend = 275, 
		wpn_fps_smg_mp5_fg_m5k = 276, 
		wpn_fps_shot_r870_s_nostock_big = 277, 
		wpn_fps_snp_r93_m_std = 278, 
		wpn_fps_bow_frankish_m_explosive = 279, 
		wpn_fps_pis_c96_m_extended = 280, 
		wpn_fps_bow_frankish_m_poison = 281, 
		wpn_fps_lmg_rpk_s_wood = 282, 
		wpn_fps_pis_g18c_b_standard = 283, 
		wpn_fps_pis_p226_g_standard = 284, 
		wpn_upg_ak_m_drum = 285, 
		wpn_fps_upg_ass_m4_upper_reciever_core = 286, 
		wpn_fps_pis_beretta_g_std = 287, 
		wpn_fps_bow_frankish_m_standard = 288, 
		wpn_fps_bow_frankish_body_standard = 289, 
		wpn_fps_bow_frankish_b_steel = 290, 
		wpn_fps_sho_striker_b_standard = 291, 
		wpn_fps_smg_m45_g_standard = 292, 
		wpn_fps_bow_long_b_standard = 293, 
		wpn_fps_lmg_par_b_short = 294, 
		wpn_fps_ass_l85a2_ns_standard = 295, 
		wpn_upg_o_marksmansight_front = 296, 
		wpn_fps_pis_p226_o_standard = 297, 
		wpn_fps_upg_a_slug = 298, 
		wpn_fps_m4_upper_reciever_round_vanilla = 299, 
		wpn_fps_ass_famas_b_sniper = 300, 
		wpn_fps_snp_winchester_m_standard = 301, 
		wpn_fps_smg_baka_o_adapter = 302, 
		wpn_fps_addon_ris = 303, 
		wpn_fps_bow_arblast_b_steel = 304, 
		wpn_fps_ammo_type = 305, 
		wpn_fps_snp_mosin_b_standard = 306, 
		wpn_fps_smg_baka_s_unfolded = 307, 
		wpn_upg_ak_s_psl = 308, 
		wpn_fps_upg_ak_fg_krebs = 309, 
		wpn_fps_smg_baka_g_standard = 310, 
		wpn_fps_pis_deagle_lock = 311, 
		wpn_fps_lmg_m249_b_short = 312, 
		wpn_fps_ass_s552_body_standard = 313, 
		wpn_fps_ass_galil_g_sniper = 314, 
		wpn_fps_smg_baka_b_smallsupp = 315, 
		wpn_fps_smg_baka_b_midsupp = 316, 
		wpn_fps_smg_baka_b_standard = 317, 
		wpn_fps_smg_baka_b_comp = 318, 
		wpn_fps_shot_r870_fg_big = 319, 
		wpn_fps_upg_ns_shot_thick = 320, 
		wpn_fps_smg_sterling_s_standard = 321, 
		wpn_fps_upg_ass_ns_surefire = 322, 
		wpn_fps_shot_b682_s_long = 323, 
		wpn_fps_pis_hs2000_m_standard = 324, 
		wpn_fps_upg_a_crossbow_poison = 325, 
		wpn_fps_bow_hunter_o_standard = 326, 
		wpn_fps_pis_usp_b_expert = 327, 
		wpn_fps_bow_hunter_m_standard = 328, 
		wpn_fps_bow_hunter_g_walnut = 329, 
		wpn_fps_sho_striker_b_suppressed = 330, 
		wpn_fps_pis_g26_m_standard = 331, 
		wpn_fps_bow_hunter_g_camo = 332, 
		wpn_fps_pis_judge_fl_adapter = 333, 
		wpn_fps_bow_hunter_body_standard = 334, 
		wpn_fps_bow_hunter_b_skeletal = 335, 
		wpn_fps_bow_hunter_b_carbon = 336, 
		wpn_upg_ak_fg_standard_gold = 337, 
		wpn_fps_upg_ass_ns_jprifles = 338, 
		wpn_fps_pis_usp_co_comp_2 = 339, 
		wpn_fps_pis_deagle_o_standard_front = 340, 
		wpn_fps_smg_polymer_m_standard = 341, 
		wpn_fps_ass_s552_m_standard = 342, 
		wpn_fps_ass_ak5_body_ak5 = 343, 
		wpn_fps_smg_polymer_s_standard = 344, 
		wpn_fps_ass_l85a2_body_standard = 345, 
		wpn_fps_smg_mp5_fg_mp5sd = 346, 
		wpn_fps_smg_polymer_barrel_precision = 347, 
		wpn_fps_sho_aa12_body_rail = 348, 
		wpn_fps_pis_usp_b_match = 349, 
		wpn_fps_shot_r870_s_solid_big = 350, 
		wpn_fps_smg_mp5_s_adjust = 351, 
		wpn_fps_rpg7_body = 352, 
		wpn_fps_smg_polymer_fg_standard = 353, 
		wpn_fps_smg_sterling_s_solid = 354, 
		wpn_fps_smg_uzi_s_solid = 355, 
		wpn_upg_ak_s_adapter = 356, 
		wpn_fps_smg_sterling_m_medium = 357, 
		wpn_fps_snp_model70_b_standard = 358, 
		wpn_fps_m4_upper_reciever_round = 359, 
		wpn_fps_smg_polymer_extra_sling = 360, 
		wpn_fps_upg_bonus_damage_p1 = 361, 
		wpn_fps_ass_s552_s_m4 = 362, 
		wpn_fps_pis_2006m_b_short = 363, 
		wpn_fps_snp_mosin_b_medium = 364, 
		wpn_fps_ass_scar_b_medium = 365, 
		wpn_fps_snp_wa2000_s_standard = 366, 
		wpn_fps_ass_m14_body_lower = 367, 
		wpn_fps_snp_wa2000_g_walnut = 368, 
		wpn_fps_m4_uupg_fg_rail_ext = 369, 
		wpn_fps_snp_wa2000_g_stealth = 370, 
		wpn_fps_ass_l85a2_b_long = 371, 
		wpn_fps_upg_ns_pis_medium_gem = 372, 
		wpn_fps_snp_wa2000_g_standard = 373, 
		wpn_fps_snp_wa2000_b_standard = 374, 
		wpn_fps_pis_1911_o_long = 375, 
		wpn_fps_snp_wa2000_b_long = 376, 
		wpn_fps_fla_mk2_body_fierybeast = 377, 
		wpn_fps_lmg_mg42_b_vg38 = 378, 
		wpn_fps_ass_sub2000_o_adapter = 379, 
		wpn_fps_upg_ass_m4_upper_reciever_ballos = 380, 
		wpn_fps_ass_sub2000_o_front = 381, 
		wpn_fps_ass_sub2000_o_back_down = 382, 
		wpn_fps_ass_sub2000_o_back = 383, 
		wpn_fps_pis_1911_o_standard = 384, 
		wpn_fps_ass_sub2000_m_standard = 385, 
		wpn_fps_pis_beretta_g_ergo = 386, 
		wpn_fps_ass_g36_s_sl8 = 387, 
		wpn_fps_ass_sub2000_fg_gen2 = 388, 
		wpn_fps_ass_sub2000_dh_standard = 389, 
		wpn_fps_smg_m45_b_small = 390, 
		wpn_fps_ass_m14_body_jae = 391, 
		wpn_fps_smg_m45_m_extended = 392, 
		wpn_fps_smg_scorpion_g_standard = 393, 
		wpn_fps_ass_sub2000_body_gen1 = 394, 
		wpn_fps_ass_sub2000_b_std = 395, 
		wpn_fps_pis_sparrow_body_rpl = 396, 
		wpn_fps_snp_model70_m_standard = 397, 
		wpn_fps_upg_m4_m_pmag = 398, 
		wpn_fps_shot_r870_fg_railed_vanilla = 399, 
		wpn_fps_ass_asval_s_solid = 400, 
		wpn_fps_ass_asval_m_standard = 401, 
		wpn_fps_ass_asval_g_standard = 402, 
		wpn_fps_rpg7_sight = 403, 
		wpn_fps_ass_asval_b_standard = 404, 
		wpn_fps_pis_p226_co_comp_2 = 405, 
		wpn_fps_ass_galil_fg_sniper = 406, 
		wpn_upg_o_marksmansight_front_vanilla = 407, 
		wpn_fps_lmg_hk21_s_standard = 408, 
		wpn_fps_smg_mp5_b_mp5sd = 409, 
		wpn_fps_ass_asval_b_proto = 410, 
		wpn_fps_shot_r870_ris_special = 411, 
		wpn_upg_ak_s_skfoldable = 412, 
		wpn_fps_pis_2006m_g_standard = 413, 
		wpn_fps_pis_2006m_fl_adapter = 414, 
		wpn_fps_smg_cobray_ns_barrelextension = 415, 
		wpn_fps_shot_r870_s_solid_vanilla = 416, 
		wpn_fps_ass_g36_fg_k = 417, 
		wpn_fps_m4_uupg_b_medium = 418, 
		wpn_fps_pis_2006m_b_standard = 419, 
		wpn_fps_smg_polymer_bolt_standard = 420, 
		wpn_fps_ass_galil_s_wood = 421, 
		wpn_fps_pis_c96_nozzle = 422, 
		wpn_fps_pis_2006m_b_medium = 423, 
		wpn_fps_pis_c96_sight = 424, 
		wpn_fps_upg_a_bow_explosion = 425, 
		wpn_fps_m4_uupg_b_sd = 426, 
		wpn_fps_pis_beretta_g_engraved = 427, 
		wpn_fps_snp_msr_b_standard = 428, 
		wpn_fps_smg_m45_m_mag = 429, 
		wpn_fps_pis_p226_b_standard = 430, 
		wpn_fps_bow_plainsrider_m_standard = 431, 
		wpn_fps_pis_g17_b_standard = 432, 
		wpn_fps_bow_plainsrider_b_standard = 433, 
		wpn_fps_upg_winchester_o_classic = 434, 
		wpn_fps_snp_winchester_s_standard = 435, 
		wpn_fps_upg_fl_ass_smg_sho_peqbox = 436, 
		wpn_fps_bow_arblast_body_standard = 437, 
		wpn_fps_smg_thompson_ns_standard = 438, 
		wpn_fps_sho_b_spas12_long = 439, 
		wpn_fps_ass_vhs_ns_vhs_no = 440, 
		wpn_fps_snp_winchester_body_standard = 441, 
		wpn_fps_snp_winchester_b_suppressed = 442, 
		wpn_fps_ass_g3_s_sniper = 443, 
		wpn_fps_snp_winchester_b_long = 444, 
		wpn_fps_sho_ben_fg_standard = 445, 
		wpn_fps_m16_fg_standard = 446, 
		wpn_fps_sho_aa12_bolt = 447, 
		wpn_fps_pis_g22c_b_long = 448, 
		wpn_fps_ass_scar_b_long = 449, 
		wpn_fps_pis_peacemaker_s_skeletal = 450, 
		wpn_fps_pis_rage_b_standard = 451, 
		wpn_fps_pis_1911_g_engraved = 452, 
		wpn_fps_ass_galil_fg_mar = 453, 
		wpn_fps_pis_peacemaker_g_bling = 454, 
		wpn_fps_sho_ksg_b_standard = 455, 
		wpn_fps_shot_b682_s_short = 456, 
		wpn_fps_pis_peacemaker_g_standard = 457, 
		wpn_fps_pis_peacemaker_m_standard = 458, 
		wpn_fps_smg_mp7_b_suppressed = 459, 
		wpn_fps_pis_peacemaker_b_short = 460, 
		wpn_fps_pis_peacemaker_b_long = 461, 
		wpn_fps_upg_ns_pis_large_kac = 462, 
		wpn_fps_pis_peacemaker_body_standard = 463, 
		wpn_fps_sho_aa12_mag_straight = 464, 
		wpn_fps_ass_74_m_standard = 465, 
		wpn_fps_upg_o_ak_scopemount = 466, 
		wpn_fps_smg_mp5_m_std = 467, 
		wpn_fps_snp_winchester_b_standard = 468, 
		wpn_fps_sho_striker_body_standard = 469, 
		wpn_fps_sho_aa12_body_rear_sight = 470, 
		wpn_fps_smg_polymer_barrel_standard = 471, 
		wpn_fps_sho_aa12_body = 472, 
		wpn_fps_smg_uzi_m_standard = 473, 
		wpn_fps_sho_aa12_barrel = 474, 
		wpn_fps_ass_galil_s_light = 475, 
		wpn_fps_pis_beretta_sl_brigadier = 476, 
		wpn_fps_smg_mac10_body_ris_special = 477, 
		wpn_fps_lmg_m249_m_standard = 478, 
		wpn_fps_gre_m79_barrel = 479, 
		wpn_fps_smg_mp5_b_mp5a5 = 480, 
		wpn_fps_smg_akmsu_b_standard = 481, 
		wpn_fps_upg_fl_pis_m3x = 482, 
		wpn_fps_gre_m32_no_stock = 483, 
		wpn_fps_gre_m32_stock_adapter = 484, 
		wpn_fps_gre_m32_mag = 485, 
		wpn_upg_saiga_m_20rnd = 486, 
		wpn_fps_smg_tec9_b_long = 487, 
		wpn_fps_ass_scar_s_sniper = 488, 
		wpn_fps_upg_vg_ass_smg_verticalgrip = 489, 
		wpn_fps_pis_hs2000_m_extended = 490, 
		wpn_fps_gre_m32_barrel_short = 491, 
		wpn_fps_gre_m32_barrel = 492, 
		wpn_fps_upg_o_leupold = 493, 
		wpn_fps_upg_fg_smr = 494, 
		wpn_fps_smg_mac10_m_short = 495, 
		wpn_fps_fla_mk2_mag_welldone = 496, 
		wpn_fps_sho_s_spas12_unfolded = 497, 
		wpn_fps_upg_ns_ass_smg_small = 498, 
		wpn_fps_pis_p226_m_extended = 499, 
		wpn_fps_ass_fal_body_standard = 500, 
		wpn_fps_ass_m14_body_dmr = 501, 
		wpn_fps_sho_aa12_mag_drum = 502, 
		wpn_fps_fla_mk2_body = 503, 
		wpn_fps_fla_mk2_empty = 504, 
		wpn_fps_m4_uupg_o_flipup = 505, 
		wpn_fps_upg_ns_sho_salvo_large = 506, 
		wpn_fps_upg_ns_ass_filter = 507, 
		wpn_fps_lmg_hk21_fg_short = 508, 
		wpn_fps_upg_ass_ns_battle = 509, 
		wpn_fps_smg_olympic_fg_railed = 510, 
		wpn_fps_upg_o_acog = 511, 
		wpn_fps_upg_vg_ass_smg_stubby = 512, 
		wpn_fps_upg_o_m14_scopemount = 513, 
		wpn_fps_upg_ass_m16_fg_stag = 514, 
		wpn_fps_m4_uupg_draghandle_ballos = 515, 
		wpn_fps_smg_mp9_b_suppressed = 516, 
		wpn_fps_smg_mp5_m_straight = 517, 
		wpn_fps_pis_g18c_co_comp_2 = 518, 
		wpn_fps_pis_p226_g_ergo = 519, 
		wpn_fps_pis_1911_b_standard = 520, 
		wpn_fps_shot_saiga_m_5rnd = 521, 
		wpn_fps_ass_ak5_b_short = 522, 
		wpn_fps_aug_body_f90 = 523, 
		wpn_fps_sho_ben_s_collapsed = 524, 
		wpn_fps_smg_polymer_s_adapter = 525, 
		wpn_fps_snp_mosin_body_black = 526, 
		wpn_fps_gre_m32_bolt = 527, 
		wpn_fps_upg_ass_m4_fg_lvoa = 528, 
		wpn_fps_ass_g36_m_standard = 529, 
		wpn_fps_lmg_m249_s_para = 530, 
		wpn_fps_shot_b682_b_long = 531, 
		wpn_fps_smg_mp7_s_standard = 532, 
		wpn_fps_shot_b682_b_short = 533, 
		wpn_fps_smg_cobray_o_adapter = 534, 
		wpn_fps_smg_cobray_s_standard = 535, 
		wpn_fps_smg_cobray_s_m4adapter = 536, 
		wpn_fps_ass_galil_s_plastic = 537, 
		wpn_fps_ass_s552_fg_standard_green = 538, 
		wpn_fps_pis_2006m_body_standard = 539, 
		wpn_fps_pis_g26_b_custom = 540, 
		wpn_fps_smg_cobray_m_standard = 541, 
		wpn_fps_smg_thompson_foregrip = 542, 
		wpn_fps_ass_galil_fg_standard = 543, 
		wpn_fps_snp_mosin_m_standard = 544, 
		wpn_fps_smg_cobray_body_upper_jacket = 545, 
		wpn_fps_smg_cobray_body_upper = 546, 
		wpn_fps_smg_cobray_body_lower_jacket = 547, 
		wpn_fps_snp_m95_barrel_short = 548, 
		wpn_fps_sho_s_spas12_folded = 549, 
		wpn_fps_smg_cobray_body_lower = 550, 
		wpn_fps_ass_famas_o_adapter = 551, 
		wpn_fps_smg_scorpion_b_standard = 552, 
		wpn_fps_upg_a_piercing = 553, 
		wpn_fps_pis_ppk_g_standard = 554, 
		wpn_fps_ass_l85a2_g_standard = 555, 
		wpn_fps_ass_asval_fg_standard = 556, 
		wpn_fps_m16_s_solid_vanilla = 557, 
		wpn_fps_lmg_hk21_g_standard = 558, 
		wpn_fps_rpg7_barrel = 559, 
		wpn_fps_rpg7_m_rocket = 560, 
		wpn_fps_smg_cobray_ns_silencer = 561, 
		wpn_fps_lmg_m134_barrel_short = 562, 
		wpn_fps_lmg_m134_barrel = 563, 
		wpn_fps_lmg_m134_body_upper_light = 564, 
		wpn_fps_m4_uupg_m_std = 565, 
		wpn_fps_snp_wa2000_g_light = 566, 
		wpn_fps_smg_mp5_b_mp5a4 = 567, 
		wpn_fps_ass_fal_s_03 = 568, 
		wpn_fps_upg_m4_s_ubr = 569, 
		wpn_fps_upg_ass_m4_lower_reciever_core = 570, 
		wpn_fps_ass_akm_b_standard_gold = 571, 
		wpn_fps_smg_p90_b_civilian = 572, 
		wpn_fps_smg_p90_b_ninja = 573, 
		wpn_fps_shot_r870_body_standard = 574, 
		wpn_fps_saw_m_blade = 575, 
		wpn_fps_smg_p90_m_std = 576, 
		wpn_fps_ass_g36_g_standard = 577, 
		wpn_fps_upg_ak_g_rk3 = 578, 
		wpn_fps_lmg_rpk_body_lowerreceiver = 579, 
		wpn_fps_upg_ak_fg_zenit = 580, 
		wpn_fps_upg_ak_fg_trax = 581, 
		wpn_fps_upg_o_cmore = 582, 
		wpn_fps_smg_scorpion_s_unfolded = 583, 
		wpn_fps_smg_mac10_m_extended = 584, 
		wpn_fps_smg_mac10_b_dummy = 585, 
		wpn_fps_ass_g3_body_lower = 586, 
		wpn_fps_ass_ak5_fg_ak5a = 587, 
		wpn_fps_smg_baka_s_standard = 588, 
		wpn_fps_upg_ak_b_ak105 = 589, 
		wpn_fps_upg_ass_ak_b_zastava = 590, 
		wpn_fps_ass_galil_m_standard = 591, 
		wpn_upg_ak_s_folding_vanilla_gold = 592, 
		wpn_fps_ass_vhs_o_standard = 593, 
		wpn_fps_ass_vhs_b_standard = 594, 
		wpn_fps_ass_vhs_b_sniper = 595, 
		wpn_fps_ass_vhs_b_silenced = 596, 
		wpn_fps_upg_fl_ass_peq15_flashlight = 597, 
		wpn_fps_shot_r870_fg_railed = 598, 
		wpn_fps_ass_vhs_b_short = 599, 
		wpn_fps_pis_rage_b_comp1 = 600, 
		wpn_fps_ass_vhs_ns_vhs = 601, 
		wpn_fps_pis_g22c_body_standard = 602, 
		wpn_fps_ass_vhs_m = 603, 
		wpn_fps_lmg_hk21_b_long = 604, 
		wpn_fps_upg_ak_g_hgrip = 605, 
		wpn_fps_ass_vhs_body = 606, 
		wpn_fps_saw_m_blade_durable = 607, 
		wpn_fps_smg_baka_body_standard = 608, 
		wpn_fps_pis_hs2000_body_standard = 609, 
		wpn_fps_pis_hs2000_sl_long = 610, 
		wpn_fps_pis_hs2000_sl_custom = 611, 
		wpn_fps_lmg_m249_body_standard = 612, 
		wpn_fps_snp_m95_bipod = 613, 
		wpn_fps_pis_hs2000_sl_standard = 614, 
		wpn_fps_m16_fg_vietnam = 615, 
		wpn_fps_smg_thompson_stock = 616, 
		wpn_fps_upg_o_45iron = 617, 
		wpn_fps_ass_l85a2_o_standard = 618, 
		wpn_fps_ass_l85a2_g_worn = 619, 
		wpn_fps_pis_1911_g_bling = 620, 
		wpn_fps_pis_1911_co_2 = 621, 
		wpn_fps_smg_tec9_s_unfolded = 622, 
		wpn_fps_pis_sparrow_g_cowboy = 623, 
		wpn_fps_ass_l85a2_fg_short = 624, 
		wpn_fps_ass_l85a2_fg_medium = 625, 
		wpn_fps_ass_l85a2_m_emag = 626, 
		wpn_fps_smg_thompson_stock_nostock = 627, 
		wpn_fps_aug_fg_a3 = 628, 
		wpn_fps_smg_mp5_b_m5k = 629, 
		wpn_fps_lmg_rpk_fg_wood = 630, 
		wpn_fps_smg_thompson_stock_discrete = 631, 
		wpn_fps_upg_fl_ass_utg = 632, 
		wpn_fps_smg_thompson_grip_discrete = 633, 
		wpn_fps_smg_mp5_body_rail = 634, 
		wpn_fps_smg_akmsu_body_lowerreceiver = 635, 
		wpn_fps_shot_r870_s_m4 = 636, 
		wpn_fps_smg_thompson_grip = 637, 
		wpn_fps_pis_beretta_co_co2 = 638, 
		wpn_fps_lmg_rpk_b_standard = 639, 
		wpn_fps_ass_galil_fg_sar = 640, 
		wpn_upg_ak_s_folding = 641, 
		wpn_fps_ass_scar_ns_short = 642, 
		wpn_fps_pis_sparrow_body_941 = 643, 
		wpn_upg_saiga_fg_lowerrail = 644, 
		wpn_fps_upg_ass_ns_linear = 645, 
		wpn_fps_snp_mosin_iron_sight = 646, 
		wpn_fps_pis_sparrow_m_standard = 647, 
		wpn_fps_snp_m95_lower_reciever = 648, 
		wpn_fps_upg_ns_shot_shark = 649, 
		wpn_fps_pis_sparrow_b_threaded = 650, 
		wpn_fps_smg_m45_g_ergo = 651, 
		wpn_fps_upg_fl_pis_tlr1 = 652, 
		wpn_fps_ass_g3_b_long = 653, 
		wpn_fps_snp_mosin_b_short = 654, 
		wpn_fps_smg_baka_fl_adapter = 655, 
		wpn_fps_upg_o_eotech_xps = 656, 
		wpn_fps_aug_b_short = 657, 
		wpn_fps_pis_1911_b_vented = 658, 
		wpn_fps_sho_ben_s_solid = 659, 
		wpn_fps_smg_mp9_body_mp9 = 660, 
		wpn_fps_smg_polymer_body_standard = 661, 
		wpn_fps_upg_fl_pis_crimson = 662, 
		wpn_fps_upg_a_custom = 663, 
		wpn_fps_smg_sterling_m_long = 664, 
		wpn_fps_smg_sterling_b_e11 = 665, 
		wpn_fps_ass_fal_fg_03 = 666, 
		wpn_fps_ass_74_b_standard = 667, 
		wpn_fps_pis_deagle_g_ergo = 668, 
		wpn_fps_smg_sterling_b_short = 669, 
		wpn_fps_ass_fal_m_standard = 670, 
		wpn_fps_smg_olympic_fg_olympic = 671, 
		wpn_fps_smg_polymer_dh_standard = 672, 
		wpn_fps_pis_c96_b_standard = 673, 
		wpn_fps_ass_famas_g_retro = 674, 
		wpn_fps_pis_c96_rail = 675, 
		wpn_fps_smg_m45_body_standard = 676, 
		wpn_fps_pis_c96_b_long = 677, 
		wpn_fps_pis_g26_fl_adapter = 678, 
		wpn_fps_upg_i_singlefire = 679, 
		wpn_fps_ass_m14_m_standard = 680, 
		wpn_fps_pis_beretta_m_extended = 681, 
		wpn_fps_lmg_mg42_n38 = 682, 
		wpn_fps_lmg_mg42_n34 = 683, 
		wpn_upg_ak_m_akm = 684, 
		wpn_fps_gre_m79_stock = 685, 
		wpn_fps_snp_wa2000_body_standard = 686, 
		wpn_fps_sho_ksg_body_standard = 687, 
		wpn_fps_lmg_mg42_b_mg34 = 688, 
		wpn_fps_lmg_mg42_b_mg42 = 689, 
		wpn_fps_ass_scar_ns_standard = 690, 
		wpn_fps_shot_r870_fg_wood = 691, 
		wpn_fps_ass_g3_fg_retro = 692, 
		wpn_fps_ass_s552_g_standard = 693, 
		wpn_fps_ass_galil_s_skeletal = 694, 
		wpn_fps_upg_fl_ass_smg_sho_surefire = 695, 
		wpn_fps_upg_o_reflex = 696, 
		wpn_fps_upg_ns_pis_ipsccomp = 697, 
		wpn_fps_m4_uupg_draghandle_vanilla = 698, 
		wpn_fps_ass_ak5_body_rail = 699, 
		wpn_fps_lmg_m134_m_standard = 700, 
		wpn_fps_lmg_hk21_g_ergo = 701, 
		wpn_fps_upg_fl_pis_x400v = 702, 
		wpn_fps_bow_hunter_g_standard = 703, 
		wpn_fps_ass_fal_g_01 = 704, 
		wpn_fps_lmg_m249_s_solid = 705, 
		wpn_fps_pis_g26_m_contour = 706, 
		wpn_fps_smg_mp5_s_solid = 707, 
		wpn_fps_ass_ak5_fg_ak5c = 708, 
		wpn_fps_smg_tec9_b_standard = 709, 
		wpn_fps_shot_r870_m_extended = 710, 
		wpn_fps_ass_famas_b_long = 711, 
		wpn_fps_upg_o_rx01 = 712, 
		wpn_fps_shot_r870_s_solid = 713, 
		wpn_fps_pis_g26_body_custom = 714, 
		wpn_fps_pis_g26_b_standard = 715, 
		wpn_fps_smg_tec9_body_standard = 716, 
		wpn_fps_upg_m4_s_standard = 717, 
		wpn_fps_smg_uzi_s_unfolded = 718, 
		wpn_fps_pis_deagle_fg_rail = 719, 
		wpn_fps_smg_thompson_barrel_short = 720, 
		wpn_fps_smg_mac10_body_mac10 = 721, 
		wpn_fps_smg_uzi_b_suppressed = 722, 
		wpn_fps_smg_uzi_body_standard = 723, 
		wpn_fps_lmg_hk21_body_upper = 724, 
		wpn_fps_ass_scar_m_standard = 725, 
		wpn_fps_smg_olympic_s_adjust = 726, 
		wpn_fps_smg_uzi_fg_standard = 727, 
		wpn_fps_smg_tec9_m_standard = 728, 
		wpn_fps_smg_thompson_fl_adapter = 729, 
		wpn_fps_upg_ns_ass_smg_tank = 730, 
		wpn_fps_pis_g26_g_gripforce = 731, 
		wpn_fps_smg_scorpion_extra_rail_gadget = 732, 
		wpn_fps_upg_o_aimpoint_2 = 733, 
		wpn_fps_smg_scorpion_extra_rail = 734, 
		wpn_fps_smg_scorpion_s_standard = 735, 
		wpn_fps_ass_g3_g_retro = 736, 
		wpn_fps_smg_scorpion_m_extended = 737, 
		wpn_fps_gre_m79_barrel_short = 738, 
		wpn_fps_pis_judge_g_standard = 739, 
		wpn_fps_ass_g36_fg_c = 740, 
		wpn_fps_shot_b682_s_ammopouch = 741, 
		wpn_fps_pis_judge_body_standard = 742, 
		wpn_fps_smg_scorpion_b_suppressed = 743, 
		wpn_fps_m4_uupg_b_short_vanilla = 744, 
		wpn_fps_pis_usp_m_extended = 745, 
		wpn_fps_pis_1911_g_legendary = 746, 
		wpn_fps_ass_asval_s_standard = 747, 
		wpn_fps_sho_fg_spas12_standard = 748, 
		wpn_fps_smg_m45_b_green = 749, 
		wpn_fps_m4_uupg_b_long = 750, 
		wpn_fps_aug_body_aug = 751, 
		wpn_fps_upg_fl_ass_laser = 752, 
		wpn_fps_pis_usp_co_comp_1 = 753, 
		wpn_fps_ass_sub2000_fg_railed = 754, 
		wpn_fps_snp_model70_fl_rail = 755, 
		wpn_fps_upg_shot_ns_king = 756, 
		wpn_fps_upg_vg_ass_smg_verticalgrip_vanilla = 757, 
		wpn_fps_ass_fal_fg_04 = 758, 
		wpn_fps_upg_pis_ns_flash = 759, 
		wpn_fps_smg_baka_m_standard = 760, 
		wpn_fps_smg_thompson_barrel_long = 761, 
		wpn_fps_ass_g3_fg_retro_plastic = 762, 
		wpn_fps_pis_usp_body_standard = 763, 
		wpn_fps_smg_mp9_m_short = 764, 
		wpn_upg_ak_fg_standard = 765, 
		wpn_fps_ass_scar_body_standard = 766, 
		wpn_fps_smg_mac10_body_ris = 767, 
		wpn_fps_upg_ak_b_draco = 768, 
		wpn_fps_upg_fg_midwest = 769, 
		wpn_fps_upg_i_autofire = 770, 
		wpn_fps_upg_ak_m_uspalm = 771, 
		wpn_fps_smg_mp7_m_short = 772, 
		wpn_fps_upg_m4_m_quad = 773, 
		wpn_fps_sho_ben_body_standard = 774, 
		wpn_fps_lmg_rpk_fg_standard = 775, 
		wpn_fps_pis_sparrow_fl_rail = 776, 
		wpn_fps_lmg_hk21_fg_long = 777, 
		wpn_fps_ass_ak_body_lowerreceiver_gold = 778, 
		wpn_fps_ak_bolt = 779, 
		wpn_fps_m4_upg_b_sd_smr = 780, 
		wpn_fps_pis_p226_body_standard = 781, 
		wpn_fps_ass_s552_fg_railed = 782, 
		wpn_fps_ass_fal_s_wood = 783, 
		wpn_fps_smg_mp9_b_dummy = 784, 
		wpn_upg_ak_fg_combo4 = 785, 
		wpn_fps_lmg_mg42_reciever = 786, 
		wpn_fps_ass_g3_fg_railed = 787, 
		wpn_fps_upg_m4_g_ergo = 788, 
		wpn_fps_ass_galil_s_fab = 789, 
		wpn_fps_smg_mac10_s_skel = 790, 
		wpn_fps_pis_rage_o_adapter = 791, 
		wpn_fps_shot_r870_s_nostock_vanilla = 792, 
		wpn_lmg_rpk_m_drum = 793, 
		wpn_fps_pis_ppk_b_long = 794, 
		wpn_fps_ass_famas_g_standard = 795, 
		wpn_fps_m16_s_solid = 796, 
		wpn_fps_ass_g3_s_wood = 797, 
		wpn_fps_lmg_m134_body_upper = 798, 
		wpn_fps_upg_bonus_spread_p1 = 799, 
		wpn_fps_lmg_m249_fg_mk46 = 800, 
		wpn_fps_upg_ns_ass_smg_firepig = 801, 
		wpn_fps_pis_deagle_co_short = 802, 
		wpn_fps_ass_famas_b_short = 803, 
		wpn_upg_o_marksmansight_rear_vanilla = 804, 
		wpn_fps_pis_rage_body_standard = 805, 
		wpn_fps_smg_akmsu_fg_standard = 806, 
		wpn_fps_smg_uzi_s_standard = 807, 
		wpn_fps_ass_galil_s_standard = 808, 
		wpn_fps_shot_huntsman_b_short = 809, 
		wpn_fps_pis_ppk_m_standard = 810, 
		wpn_fps_gre_m32_upper_reciever = 811, 
		wpn_fps_snp_m95_upper_reciever = 812, 
		wpn_fps_snp_msr_b_long = 813, 
		wpn_fps_smg_scorpion_s_nostock = 814, 
		wpn_fps_smg_cobray_barrel = 815, 
		wpn_fps_smg_mp7_b_standard = 816, 
		wpn_fps_ass_m14_body_upper = 817, 
		wpn_fps_pis_deagle_o_standard_rear = 818, 
		wpn_fps_smg_thompson_body = 819, 
		wpn_fps_upg_m4_s_crane = 820, 
		wpn_fps_upg_ns_pis_meatgrinder = 821, 
		wpn_fps_sho_ksg_fg_standard = 822, 
		wpn_fps_ass_g3_g_sniper = 823, 
		wpn_fps_pis_deagle_extra = 824, 
		wpn_fps_m16_fg_railed = 825, 
		wpn_fps_pis_beretta_co_co1 = 826, 
		wpn_fps_snp_m95_barrel_long = 827, 
		wpn_fps_upg_ns_ass_smg_large = 828, 
		wpn_fps_ass_akm_body_upperreceiver_gold = 829, 
		wpn_fps_ass_g3_fg_bipod = 830, 
		wpn_fps_m4_upper_reciever_edge = 831, 
		wpn_fps_ass_g3_body_rail = 832, 
		wpn_fps_ak_extra_ris = 833, 
		wpn_fps_shot_shorty_s_solid_short = 834, 
		wpn_fps_pis_beretta_body_beretta = 835, 
		wpn_fps_upg_m4_g_hgrip_vanilla = 836, 
		wpn_fps_smg_m45_b_standard = 837, 
		wpn_fps_aug_ris_special = 838, 
		wpn_fps_upg_o_shortdot = 839, 
		wpn_fps_pis_ppk_fl_mount = 840, 
		wpn_fps_ass_g3_body_upper = 841, 
		wpn_fps_gre_m79_grenade = 842, 
		wpn_fps_smg_mp7_s_long = 843, 
		wpn_fps_ass_g36_body_standard = 844, 
		wpn_fps_upg_a_grenade_launcher_incendiary = 845, 
		wpn_fps_pis_rage_g_standard = 846, 
		wpn_fps_rpg7_sight_adapter = 847, 
		wpn_fps_pis_g18c_m_mag_17rnd = 848, 
		wpn_fps_ass_galil_body_standard = 849, 
		wpn_fps_sho_ksg_b_long = 850, 
		wpn_fps_pis_sparrow_fl_dummy = 851, 
		wpn_fps_pis_1911_m_standard = 852, 
		wpn_fps_m4_uupg_s_fold = 853, 
		wpn_fps_sho_ben_s_collapsable = 854, 
		wpn_fps_upg_o_dd_front = 855, 
		wpn_fps_sho_ben_b_short = 856, 
		wpn_fps_upg_o_aimpoint = 857, 
		wpn_fps_lmg_m134_body = 858, 
		wpn_fps_upg_fg_jp = 859, 
		wpn_fps_shot_shorty_s_nostock_short = 860, 
		wpn_fps_ass_fal_s_01 = 861, 
		wpn_fps_pis_g18c_body_frame = 862, 
		wpn_fps_aug_m_pmag = 863, 
		wpn_fps_smg_m45_s_standard = 864, 
		wpn_fps_saw_body_speed = 865, 
		wpn_fps_shot_r870_body_rack = 866, 
		wpn_fps_pis_deagle_g_standard = 867, 
		wpn_fps_ass_m16_os_frontsight = 868, 
		wpn_fps_pis_p226_co_comp_1 = 869, 
		wpn_upg_o_marksmansight_rear = 870, 
		wpn_fps_pis_rage_b_long = 871, 
		wpn_fps_ass_74_body_upperreceiver = 872, 
		wpn_fps_ass_scar_b_short = 873, 
		wpn_fps_snp_msr_ns_suppressor = 874, 
		wpn_fps_smg_sterling_b_suppressed = 875, 
		wpn_fps_sho_s_spas12_solid = 876, 
		wpn_fps_aug_b_long = 877, 
		wpn_fps_snp_r93_body_wood = 878, 
		wpn_fps_ass_g3_b_short = 879, 
		wpn_fps_snp_r93_b_standard = 880, 
		wpn_fps_pis_deagle_body_standard = 881, 
		wpn_fps_upg_vg_ass_smg_afg = 882, 
		wpn_fps_snp_mosin_b_sniper = 883, 
		wpn_fps_ass_g3_b_sniper = 884, 
		wpn_fps_pis_p226_b_equinox = 885, 
		wpn_fps_upg_m4_m_straight = 886, 
		wpn_fps_pis_beretta_sl_std = 887, 
		wpn_fps_shot_huntsman_b_long = 888, 
		wpn_fps_fla_mk2_mag_rare = 889, 
		wpn_fps_lmg_rpk_s_standard = 890, 
		wpn_fps_smg_p90_b_short = 891, 
		wpn_fps_upg_fl_ass_peq15 = 892, 
		wpn_fps_pis_2006m_m_standard = 893, 
		wpn_fps_ass_famas_b_suppressed = 894, 
		wpn_fps_smg_tec9_ns_ext = 895, 
		wpn_fps_shot_huntsman_s_long = 896, 
		wpn_fps_aug_b_medium = 897, 
		wpn_fps_smg_scorpion_m_standard = 898, 
		wpn_fps_upg_o_mbus_front = 899, 
		wpn_fps_lmg_m249_b_long = 900, 
		wpn_fps_ass_s552_g_standard_green = 901, 
		wpn_fps_pis_deagle_b_long = 902, 
		wpn_fps_lmg_hk21_m_standard = 903, 
		wpn_fps_upg_m4_g_sniper = 904, 
		wpn_fps_ass_akm_body_upperreceiver_vanilla = 905, 
		wpn_fps_lmg_hk21_b_short = 906, 
		wpn_fps_ass_ak5_s_ak5b = 907, 
		wpn_fps_fla_mk2_mag = 908, 
		wpn_fps_sho_striker_b_long = 909, 
		wpn_fps_smg_mac10_ris_dummy = 910, 
		wpn_fps_ass_scar_o_flipups_up = 911, 
		wpn_fps_ass_g36_body_sl8 = 912, 
		wpn_fps_pis_p226_m_standard = 913, 
		wpn_fps_smg_mp5_body_mp5 = 914, 
		wpn_fps_pis_p226_b_long = 915, 
		wpn_fps_shot_r870_fg_small = 916, 
		wpn_fps_pis_rage_body_smooth = 917, 
		wpn_fps_smg_mp7_body_standard = 918, 
		wpn_fps_smg_mp5_fg_mp5a5 = 919, 
		wpn_fps_smg_mp5_fg_mp5a4 = 920, 
		wpn_fps_bow_long_m_explosive = 921, 
		wpn_fps_ass_g36_b_short = 922, 
		wpn_fps_lmg_m134_barrel_extreme = 923, 
		wpn_fps_amcar_uupg_fg_amcar = 924, 
		wpn_fps_smg_thompson_o_adapter = 925, 
		wpn_fps_ass_sub2000_body_gen2 = 926, 
		wpn_fps_upg_m4_s_adapter = 927, 
		wpn_fps_ass_l85a2_b_short = 928, 
		wpn_fps_pis_rage_extra = 929, 
		wpn_fps_upg_ak_s_solidstock = 930, 
		wpn_fps_shot_r870_s_solid_single = 931, 
		wpn_upg_ak_m_akm_gold = 932, 
		wpn_fps_ass_g36_s_standard = 933, 
		wpn_fps_saw_m_blade_sharp = 934, 
		wpn_fps_ass_galil_fg_fab = 935, 
		wpn_fps_ass_akm_body_upperreceiver = 936, 
		wpn_fps_upg_m4_s_pts = 937, 
		wpn_fps_m4_uupg_draghandle = 938
	}
	if _bool == true then
		return table_parts2id[tostring(var)] or 0
	else
		for k, v in pairs(table_parts2id) do
			if tostring(v) == tostring(var) then
				return tostring(k)
			end
		end
		return ""
	end
end

function WeaponCustomization:materials7id (_bool, var)
	local table_materials2id = {
		flow = 1, 
		titanium = 2, 
		chrome_purple = 3, 
		carpet = 4, 
		prehistoric = 5, 
		hatred = 6, 
		hades = 7, 
		gemstone = 8, 
		bandages = 9, 
		haze = 10, 
		heavymetal = 11, 
		sparks = 12, 
		dimblue = 13, 
		rainbow = 14, 
		goldfever = 15, 
		explosive = 16, 
		leather = 17, 
		bionic = 18, 
		patriot = 19, 
		forged = 20, 
		sunset = 21, 
		cosmoline = 22, 
		carbon = 23, 
		sancti = 24, 
		bark2 = 25, 
		carapace = 26, 
		alien_slime = 27, 
		punk = 28, 
		chromescape = 29, 
		stained_glass = 30, 
		oxide_bronze = 31, 
		rock2 = 32, 
		neon = 33, 
		plastic_hood = 34, 
		scorpion = 35, 
		sinister = 36, 
		denim = 37, 
		finewood = 38, 
		matteblack = 39, 
		scales = 40, 
		alligator = 41, 
		carbongrid = 42, 
		wicker1 = 43, 
		radioactive = 44, 
		bananapeel = 45, 
		slime = 46, 
		casino = 47, 
		void = 48, 
		evil = 49, 
		rock_marble = 50, 
		baby = 51, 
		frost = 52, 
		marble = 53, 
		deep_bronze = 54, 
		meat = 55, 
		erdl = 56, 
		pianoblack = 57, 
		burn = 58, 
		redwhiteblue = 59, 
		mud = 60, 
		bark3 = 61, 
		cash = 62, 
		electric = 63, 
		twoblue = 64, 
		hardshell = 65, 
		old = 66, 
		still_waters = 67, 
		armygreen = 68, 
		gunmetal = 69, 
		parchment = 70, 
		origami = 71, 
		bark1 = 72, 
		scale_armor = 73, 
		dark_leather = 74, 
		plywood = 75, 
		fossil = 76, 
		greygloss = 77, 
		wade = 78, 
		glade = 79, 
		chain_armor = 80, 
		rug = 81, 
		whiterock = 82, 
		splinter = 83, 
		skin = 84, 
		blooded = 85, 
		bamboo = 86, 
		bloodred = 87, 
		sakura = 88, 
		blackmetal = 89, 
		diamond = 90, 
		coal = 91, 
		hot_cold = 92, 
		metal1 = 93, 
		candy = 94, 
		leaf = 95, 
		bone = 96, 
		gold_clean = 97, 
		mercury = 98, 
		cactus = 99, 
		electronic = 100, 
		copper = 101, 
		bugshell = 102, 
		concrete1 = 103, 
		gunsmoke = 104, 
		rubber = 105, 
		westernsunset = 106, 
		plush = 107, 
		jade = 108, 
		cushion = 109, 
		enlightment = 110, 
		magma = 111, 
		galvanized = 112, 
		stars = 113, 
		feathers = 114, 
		redsun = 115, 
		oldbronze = 116, 
		toast = 117, 
		candlelight = 118, 
		rust = 119, 
		dawn = 120, 
		rhino_skin = 121, 
		sand = 122, 
		cracks1 = 123, 
		orchish = 124, 
		fur = 125, 
		plastic = 126, 
		oilmetal = 127, 
		rock1 = 128, 
		clay = 129, 
		insectoid = 130, 
		waterblue = 131, 
		arizona = 132, 
		eye = 133, 
		rock3 = 134, 
		error = 135, 
		bismuth = 136,
		no_material = 137
	}
	if _bool == true then
		return table_materials2id[tostring(var)] or table_materials2id["no_material"]
	else
		for k, v in pairs(table_materials2id) do
			if tostring(v) == tostring(var) then
				return tostring(k)
			end
		end
		return "no_material"
	end
end

function WeaponCustomization:textures7id (_bool, var)
	local table_textures2id = {
		toto = 1, 
		magnet = 2, 
		spook = 3, 
		flammable = 4, 
		headshot = 5, 
		kraken = 6, 
		cracker = 7, 
		sidestripe = 8, 
		paint2 = 9, 
		americaneagle = 10, 
		spider = 11, 
		horizon_circle = 12, 
		cro_pattern_2 = 13, 
		hannibalistic = 14, 
		gradient = 15, 
		dinostripes = 16, 
		pattern = 17, 
		solidfirst = 18, 
		webbed = 19, 
		pd2 = 20, 
		celtic1 = 21, 
		hearts = 22, 
		circuit = 23, 
		puzzle = 24, 
		messatsu = 25, 
		dragon_split = 26, 
		digitalcamo = 27, 
		army = 28, 
		digital = 29, 
		girlsandboys = 30, 
		hypnotic = 31, 
		tribal2 = 32, 
		anarchy = 33, 
		spawn = 34, 
		styx = 35, 
		daniel = 36, 
		emblem3 = 37, 
		yinyang = 38, 
		smoke = 39, 
		daft_heart = 40, 
		hunter = 41, 
		hand = 42, 
		runes = 43, 
		ultimaterobber = 44, 
		solidsecond = 45, 
		wtf = 46, 
		tf2 = 47, 
		ornamentalcrown = 48, 
		death = 49, 
		shutupandbleed = 50, 
		tribalwave = 51, 
		japan = 52, 
		cogs = 53, 
		wargod = 54, 
		sunavatar = 55, 
		companioncube = 56, 
		ouro = 57, 
		reaper = 58, 
		poison = 59, 
		med_pat = 60, 
		checkered_out = 61, 
		mason = 62, 
		tcn = 63, 
		biohazard = 64, 
		monstervisor = 65, 
		agatha = 66, 
		koi = 67, 
		bugger = 68, 
		oni = 69, 
		cro_pattern_3 = 70, 
		filthythirteen = 71, 
		zebra = 72, 
		fleur = 73, 
		whiner = 74, 
		ouroboros = 75, 
		striped = 76, 
		shazam = 77, 
		predator = 78, 
		no_color_full_material = 79, 
		starbreeze = 80, 
		evileye = 81, 
		zipper = 82, 
		usa = 83, 
		flames = 84, 
		paint1 = 85, 
		foot = 86, 
		deathdealer = 87, 
		cards = 88, 
		arrow = 89, 
		hellish = 90, 
		hawk = 91, 
		loverboy = 92, 
		racestripes = 93, 
		royale = 94, 
		dices = 95, 
		unionjack = 96, 
		arena_logo = 97, 
		fatman = 98, 
		doomweaver = 99, 
		flag = 100, 
		monkeyskull = 101, 
		nuclear = 102, 
		atom = 103, 
		hotline = 104, 
		totem = 105, 
		vicious = 106, 
		tribal = 107, 
		aperture = 108, 
		ace = 109, 
		big_skull = 110, 
		soundwave = 111, 
		native = 112, 
		trekronor = 113, 
		kabuki1 = 114, 
		hotflames = 115, 
		flamer = 116, 
		fireborn = 117, 
		illuminati = 118, 
		electric = 119, 
		chains = 120, 
		youkai = 121, 
		steampunk = 122, 
		dinoskull = 123, 
		pain = 124, 
		maskedfalcon = 125, 
		dazzle = 126, 
		horus = 127, 
		hieroglyphs = 128, 
		hawkhelm = 129, 
		molecule = 130, 
		compass = 131, 
		ruler = 132, 
		barbarian = 133, 
		commando = 134, 
		emblem2 = 135, 
		origami = 136, 
		captainwar = 137, 
		fingerprint = 138, 
		eightball = 139, 
		uglyrug = 140, 
		leopard = 141, 
		two = 142, 
		palmtrees = 143, 
		hiptobepolygon = 144, 
		doodles = 145, 
		celtic2 = 146, 
		fan = 147, 
		emperor = 148, 
		muerte = 149, 
		terror = 150, 
		chief = 151, 
		bloodsucker = 152, 
		cake = 153, 
		raster = 154, 
		scars = 155, 
		dragon_full = 156, 
		spartan = 157, 
		bite = 158, 
		tribalface = 159, 
		swe_camo = 160, 
		venomous = 161, 
		tribalstroke = 162, 
		luchador = 163, 
		deathcube = 164, 
		wingsofdeath = 165, 
		swirl = 166, 
		diamond = 167, 
		yggdrasil = 168, 
		roman = 169, 
		spidereyes = 170, 
		clown = 171, 
		warrior = 172, 
		fighter = 173, 
		grayson = 174, 
		cro_pattern_4 = 175, 
		cro_pattern_1 = 176, 
		emblem1 = 177, 
		exmachina = 178, 
		starvr = 179, 
		beast = 180, 
		hexagon = 181, 
		imperial = 182, 
		bsomebody = 183, 
		target = 184, 
		skull = 185, 
		pumpgrin = 186, 
		rorschach = 187, 
		forestcamo = 188, 
		portal = 189, 
		stars = 190, 
		fleur2 = 191, 
		circle_raster = 192, 
		pirate = 193, 
		spikes = 194, 
		star = 195, 
		vertical = 196, 
		dinoscars = 197, 
		no_color_no_material = 198, 
		marv = 199, 
		gearhead = 200, 
		mantis = 201, 
		stitches = 202, 
		chips = 203, 
		coyote = 204, 
		ribcage = 205, 
		emblem4 = 206, 
		cat = 207, 
		shout = 208, 
		fingerpaint = 209, 
		overkill = 210, 
		cobrakai = 211, 
		hellsanchor = 212, 
		banana = 213
	}
	if _bool == true then
		return table_textures2id[tostring(var)] or table_textures2id["no_color_no_material"]
	else
		for k, v in pairs(table_textures2id) do
			if tostring(v) == tostring(var) then
				return tostring(k)
			end
		end
		return "no_color_no_material"
	end
end

function WeaponCustomization:colors7id (_bool, var)
	local table_colors2id = {
		warm_yellow_olive_green = 1, 
		cyan_purple = 2, 
		black_coral_red = 3, 
		turquoise_purple = 4, 
		red_black = 5, 
		green_solid = 6, 
		white_purple = 7, 
		light_blue_solid = 8, 
		red_solid = 9, 
		bright_yellow_brown = 10, 
		cobalt_blue_navy_blue = 11, 
		light_brown_navy_blue = 12, 
		coral_red_matte_blue = 13, 
		blue_solid = 14, 
		blood_red_white = 15, 
		dark_red_orange = 16, 
		blue_light_blue = 17, 
		light_brown_matte_blue = 18, 
		orange_solid = 19, 
		leaf_green_blood_red = 20, 
		green_blood_red = 21, 
		black_bright_yellow = 22, 
		bright_yellow_turquoise = 23, 
		dark_green_solid = 24, 
		navy_blue_solid = 25, 
		light_gray_solid = 26, 
		navy_blue_light_blue = 27, 
		black_white = 28, 
		red_white = 29, 
		black_magenta = 30, 
		orange_matte_blue = 31, 
		toxic_green_leaf_green = 32, 
		leaf_green_solid = 33, 
		warm_yellow_bright_yellow = 34, 
		dark_gray_orange = 35, 
		dark_gray_solid = 36, 
		bright_yellow_olive_green = 37, 
		coral_red_gray_blue = 38, 
		magenta_cyan = 39, 
		toxic_green_matte_purple = 40, 
		brown_solid = 41, 
		coral_red_dark_red = 42, 
		white_dark_gray = 43, 
		orange_white = 44, 
		white_solid = 45, 
		pink_matte_purple = 46, 
		yellow_solid = 47, 
		black_orange = 48, 
		warm_yellow_matte_purple = 49, 
		black_cobalt_blue = 50, 
		white_navy_blue = 51, 
		dark_red_solid = 52, 
		cobalt_blue_white = 53, 
		bone_white_magenta = 54, 
		coral_red_lime_green = 55, 
		gray_black = 56, 
		cyan_blue = 57, 
		orange_gray_blue = 58, 
		white_magenta = 59, 
		orange_purple = 60, 
		cyan_orange = 61, 
		white_matte_blue = 62, 
		light_gray_dark_gray = 63, 
		light_gray_blood_red = 64, 
		magenta_solid = 65, 
		gray_solid = 66, 
		white_black = 67, 
		light_blue_brown = 68, 
		bright_yellow_dark_gray = 69, 
		warm_yellow_navy_blue = 70, 
		purple_solid = 71, 
		green_red = 72, 
		yellow_orange = 73, 
		red_dark_red = 74, 
		pink_solid = 75, 
		black_leaf_green = 76, 
		warm_yellow_white = 77, 
		toxic_green_dark_green = 78, 
		white_brown = 79, 
		turquoise_pink = 80, 
		bone_white_light_blue = 81, 
		cobalt_blue_pink = 82, 
		blood_red_solid = 83, 
		light_blue_cobalt_blue = 84, 
		green_olive_green = 85, 
		bone_white_purple = 86, 
		red_blue = 87, 
		nothing = 88, 
		leaf_green_white = 89, 
		orange_blue = 90, 
		light_blue_gray_blue = 91, 
		yellow_blue = 92, 
		bone_white_navy_blue = 93, 
		light_brown_solid = 94, 
		light_brown_brown = 95, 
		black_solid = 96, 
		warm_yellow_solid = 97, 
		cyan_solid = 98
	}
	if _bool == true then
		return table_colors2id[tostring(var)] or table_colors2id["white_solid"]
	else
		for k, v in pairs(table_colors2id) do
			if tostring(v) == tostring(var) then
				return tostring(k)
			end
		end
		return "white_solid"
	end
end

function mysplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end