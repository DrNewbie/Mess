local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

local pkg_name = 'levels/narratives/vlad/nightclub/world'

local mtga_original_gamesetup_loadpackages = GameSetup.load_packages
function GameSetup:load_packages()
	mtga_original_gamesetup_loadpackages(self)

	if not mtga_level_has_drill(Global.game_settings.level_id) then
		if not PackageManager:loaded(pkg_name) then
			PackageManager:load(pkg_name)
		end
	end
end

local mtga_original_gamesetup_unloadpackages = GameSetup.unload_packages
function GameSetup:unload_packages()
	mtga_original_gamesetup_unloadpackages(self)

	if PackageManager:loaded(pkg_name) then
		PackageManager:unload(pkg_name)
	end
end
