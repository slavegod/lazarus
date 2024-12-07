--[[
	LAZARUS. Client loader.

    Scripted entirely by 70467f on discord.
]]

-- constants

local games_list = loadstring(game:HttpGet("https://raw.githubusercontent.com/slavegod/lazarus/refs/heads/main/games.lua"))()

local start_time = tick()
local config = {
    debugging = true, -- debugging, off by default
}

local starter_gui = game:GetService("StarterGui")

-- helper stuff

local send_notification = function(title : string, body : string)
    if config.debugging == true then
        starter_gui:SetCore("SendNotification", {Title = tostring(title), Text = tostring(body)})
    else
        return
    end
end

local load_script = function()
    for script, game_script in next, games_list do
        if game_script == game.GameId or game_script == game.PlaceId then
            loadstring(game:HttpGet(game_script))()
        end
    end
end

-- loader

local success, error = pcall(function()
	load_script()
end)

if success then
	send_notification("[DEBUG]", "Script started in " .. tick() - start_time .. " ms.")
else
    if not error then
        send_notification("[DEBUG]", "Script not found")
    else
	    send_notification("[DEBUG]", tostring(error))
    end
end
