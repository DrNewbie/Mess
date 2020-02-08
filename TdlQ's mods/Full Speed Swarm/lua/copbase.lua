local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

CopBase.fs_lod_stage_1 = CopBase.lod_stage

function CopBase:fs_lod_stage_2()
	return self._lod_stage == 3 and 2 or self._lod_stage
end

function CopBase:fs_lod_stage_3()
	return self._lod_stage and 1
end

FullSpeedSwarm:UpdateWalkingQuality()
