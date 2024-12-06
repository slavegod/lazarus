--[[
	LAZARUS. Client loader v1.
	Should work but if it don't then I'm a retard.
]]

-- constants

local games_list = loadstring(game:HttpGet(""))()

local start_time = tick()

-- helper stuff

local load_script = function(id : number)
	for id, result in next, games_list do
		if id == game.GameId or game.PlaceId then
			loadstring(game:HttpGet(result))
		else
			warn("Invalid game ID.")
		end
	end
end

-- loader

local success, error = pcall(function()
	load_script(game.GameId)
end)

if success then
	print("Script started in " .. tick() - start_time .. " ms.")
else
	warn(error)
end