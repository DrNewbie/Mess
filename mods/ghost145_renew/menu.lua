m_ghost=m_ghost or {
	_path=ModPath,
	_data_path=SavePath.."ghost145.txt",
	_data={mode=1},
	_qualify=false
	}

function m_ghost:save()
	local file=io.open(m_ghost._data_path, "w+")
	if file then
		file:write(json.encode(self._data))
		file:close()
		end
	end

function m_ghost:load()
	local file=io.open(m_ghost._data_path, "r")
	if file then
		self._data=json.decode(file:read("*all"))
		file:close()
		end
	end

function m_ghost:mode()
	return self._data.mode
	end

function m_ghost:in_stealth()
	return managers.groupai:state():whisper_mode()
	end

Hooks:Add("LocalizationManagerPostInit", "LocManPosIni:g145Menu", function(loc)
	local lang, path=SystemInfo and SystemInfo:language(), "loc.en.txt"
	--[[if lang==Idstring("french") then
		path="loc.fr.txt"
		end]]
	loc:load_localization_file(m_ghost._path..path)
	end)

Hooks:Add("MenuManagerInitialize", "MenManIni:g145Menu", function(menu_manager)
	function MenuCallbackHandler:m_ghost_save()
		m_ghost:save()
		end
	function MenuCallbackHandler:m_ghost_set(item)
		m_ghost._qualify=1
		m_ghost._data.mode=item:value()
		end
	m_ghost:load()
	MenuHelper:LoadFromJsonFile(m_ghost._path.."menu.txt", m_ghost, m_ghost._data)
	end)