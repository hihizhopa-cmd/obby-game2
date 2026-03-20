--// Ghost Engine v1.7 [SERVER-SIDE CONDO] //--
local Players = game:GetService("Players")
print("1.7")
local function getClosestPlayer(speaker)
	local char = speaker.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
	
	local target = nil
	local dist = 10
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= speaker and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local d = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
			if d < dist then dist = d target = p end
		end
	end
	return target
end

Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(msg)
		local char = player.Character
		if not char then return end
		
		-- Команда захвата: .q
		if msg == ".q" then
			local target = getClosestPlayer(player)
			if target and not char.HumanoidRootPart:FindFirstChild("v1_Weld") then
				local tChar = target.Character
				tChar.Humanoid.PlatformStand = true
				
				-- Позиционирование R6 (Condo Style)
				tChar.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, -1, 1.2) * CFrame.Angles(math.rad(-70), 0, 0)
				
				local w = Instance.new("WeldConstraint")
				w.Name = "v1_Weld"
				w.Part0 = char.HumanoidRootPart
				w.Part1 = tChar.HumanoidRootPart
				w.Parent = char.HumanoidRootPart
				
				-- Плавная анимация через сустав
				local rootJoint = char.HumanoidRootPart:FindFirstChild("RootJoint")
				if rootJoint then
					local oldC0 = rootJoint.C0
					task.spawn(function()
						local s = 0
						while char.HumanoidRootPart:FindFirstChild("v1_Weld") do
							s = s + 0.5
							rootJoint.C0 = oldC0 * CFrame.new(0, 0, math.sin(s) * 0.8)
							task.wait(0.03)
						end
						rootJoint.C0 = oldC0
					end)
				end
			end
			
		-- Команда стопа: .r
		elseif msg == ".r" then
			local w = char.HumanoidRootPart:FindFirstChild("v1_Weld")
			if w then
				if w.Part1 and w.Part1.Parent:FindFirstChild("Humanoid") then
					w.Part1.Parent.Humanoid.PlatformStand = false
				end
				w:Destroy()
			end
		end
	end)
end)
