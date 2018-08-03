IDWSTOPSPAM = IDWSTOPSPAM or {}

local function fucking_play(self)
	IDWSTOPSPAM[self] = TimerManager:game():time() + 10
	return "2f62378425adc765_"..table.random({
		"001",
		"002",
		"003",
		"004",
		"005",
		"006",
		"007",
		"008",
		"009",
		"010",
		"013",
		"014",
		"015",
		"021",
		"022",
		"023",
		"024",
		"025",
		"026",
		"027",
		"028",
		"029",
		"030",
		"032",
		"033",
		"035",
		"036"
	})
end

Hooks:Add("GameSetupUpdate", "IDWSTOPSPAM_Loop", function(t, dt)
	for sound, spam in pairs(IDWSTOPSPAM) do
		if spam <= t then
			if alive(sound._unit) then
				sound:stop()
			end
			IDWSTOPSPAM[sound] = nil
		end
	end
end)

PlayerSound._orig_play = PlayerSound._orig_play or PlayerSound._play
function PlayerSound:_play(dallas, ...)
    dallas = fucking_play(self)
    return self:_orig_play(dallas, nil, ...)
end

CopSound._orig_play = CopSound._orig_play or CopSound._play
function CopSound:_play(dallas, ...)
    dallas = fucking_play(self)
    return self:_orig_play(dallas, nil, ...)
end

CivilianHeisterSound._orig_play = CivilianHeisterSound._orig_play or CivilianHeisterSound._play
function CivilianHeisterSound:_play(dallas, ...)
    dallas = fucking_play(self)
    return self:_orig_play(dallas, nil, ...)
end

DramaExt.stop = DramaExt.stop_cue
DramaExt._orig_play_sound = DramaExt._orig_play_sound or DramaExt.play_sound
function DramaExt:play_sound(dallas, ...)
    dallas = fucking_play(self)
    return self:_orig_play_sound(dallas, ...)
end