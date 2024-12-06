local old_position = nil
local camera_part = Instance.new("Part", workspace.CurrentCamera); camera_part.Anchored = true; camera_part.Transparency = 1; camera_part.CanCollide = false
local local_player = game:GetService("Players").LocalPlayer

local highlight = Instance.new("Highlight"); highlight.FillTransparency = 0.75
local targeted_player = nil

local get_closest_player = function()
	if targeted_player and targeted_player.Character and targeted_player.Character:FindFirstChild("HumanoidRootPart") and targeted_player.Character.Humanoid.Health > 0 then
		return targeted_player
	else
		targeted_player = nil
	end

	local closest_player = nil
	local closest_distance = math.huge
	for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
		if player ~= local_player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local distance = (player.Character.HumanoidRootPart.Position - local_player.Character.HumanoidRootPart.Position).Magnitude
			if distance < 50 and distance < closest_distance and player.Character.Humanoid.Health > 0 then
				closest_player = player
				closest_distance = distance
			end
		end
	end
	return closest_player
end

local update_highlight = function(player)
	if player and player.Character then
		highlight.Parent = player.Character
	else
		highlight.Parent = nil
	end
end

local teleport = function(position : Vector3)
	camera_part.Position = local_player.Character.HumanoidRootPart.Position; workspace.CurrentCamera.CameraSubject = camera_part
	local counter = 0
	local character = local_player.Character
	local humanoidRootPart = character.HumanoidRootPart
	local old_position = humanoidRootPart.Position
	local direction = (position - humanoidRootPart.Position).unit
	local offsetPosition = position - direction * 2

	humanoidRootPart.CFrame = CFrame.lookAt(offsetPosition, position)

	for i = 1, 15 do
		local counter = counter + 1
		task.wait()
		humanoidRootPart.CFrame = CFrame.lookAt(offsetPosition, position)
	end

	humanoidRootPart.CFrame = CFrame.new(old_position)
	workspace.CurrentCamera.CameraSubject = character.Humanoid
end

game:GetService("RunService").Heartbeat:Connect(function()
	update_highlight(get_closest_player())
end)

game:GetService("UserInputService").InputBegan:Connect(function(userInput,gameProcessed)
	if gameProcessed then return end

	if userInput.UserInputType == Enum.UserInputType.MouseButton1 then
		if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
			local mouse = local_player:GetMouse()
			local target = mouse.Target
			if target and target.Parent and target.Parent:FindFirstChild("Humanoid") then
				local player = game:GetService("Players"):GetPlayerFromCharacter(target.Parent)
				if player then
					targeted_player = player
					local humanoid = player.Character:FindFirstChild("Humanoid")
					if humanoid then
						humanoid.Died:Connect(function()
							targeted_player = nil
						end)
					end
				end
			end
		else
			local closest_player = get_closest_player()
			if closest_player then
				teleport(closest_player.Character.HumanoidRootPart.Position)
			end
		end
	end
end)
