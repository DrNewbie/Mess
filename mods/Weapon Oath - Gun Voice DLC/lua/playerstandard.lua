local ThisModPath = ModPath or tostring(math.random())
local ThisModIds = Idstring(ThisModPath):key()
local __Name = function(__id)
	return "TDOLLVO_"..Idstring(tostring(__id).."::"..ThisModIds):key()
end
local Hook1 = __Name("init")
local Hook2 = __Name("_update_check_actions")
local Bool1 = __Name("Bool1")
local Var01 = __Name("Var01")
local XAudioBuffer = __Name("XAudioBuffer")
local XAudioSource = __Name("XAudioSource")

Hooks:PostHook(PlayerStandard, "init", Hook1, function(self, ...)
	self[Bool1] = false
	self[Var01] = " "
end)

local function __ply_ogg(them, __path)
	__path = tostring(__path)
	if file.DirectoryExists(__path) then
		local __oggs = file.GetFiles(__path)
		if type(__oggs) == "table" and not table.empty(__oggs) then
			local __p_oggs = {}
			for _, __filename in pairs(__oggs) do
				if __filename and type(__filename) == "string" and string.match(__filename, "%.ogg") then
					__p_oggs[__Name(__filename)] = __path..__filename
				end
			end
			local __this_ogg = tostring(__p_oggs[table.random_key(__p_oggs)])
			if io.file_is_readable(__this_ogg) then
				local this_buffer = XAudio.Buffer:new(__this_ogg)
				local this_source = XAudio.UnitSource:new(XAudio.PLAYER)
				this_source:set_buffer(this_buffer)
				this_source:play()
				them[XAudioBuffer] = this_buffer
				them[XAudioSource] = this_source
			end
		end
	end
	return them
end

local function __end_ogg(them)
	if them[XAudioSource] then
		them[XAudioSource]:close(true)
		them[XAudioSource] = nil
	end
	if them[XAudioBuffer] then
		them[XAudioBuffer]:close(true)
		them[XAudioBuffer] = nil
	end
	return them
end

Hooks:PostHook(PlayerStandard, "_update_check_actions", Hook2, function(self, ...)
	if self._camera_unit and alive(self._camera_unit) and self._camera_unit:base() and self._equipped_unit and alive(self._equipped_unit) and self._equipped_unit:base() then
		local __weap_base = self._equipped_unit:base()
		local __weapon_id = __weap_base:get_name_id()
		local __weapon_tweak_data = tweak_data.weapon[__weapon_id]
		if __weapon_tweak_data and type(__weapon_tweak_data.__oath_data) == "table" and type(__weapon_tweak_data.__oath_data.__oath_dlc1_ogg_folder) == "string" then
			if self[Var01] ~= __weapon_id then
				self = __end_ogg(self)
			end
			if self:_is_cash_inspecting() ~= self[Bool1] then
				self[Var01] = __weapon_id
				self[Bool1] = self:_is_cash_inspecting()
				if self[Bool1] then
					self = __ply_ogg(self, __weapon_tweak_data.__oath_data.__oath_dlc1_ogg_folder)
				end
			end
		end
	end
end)