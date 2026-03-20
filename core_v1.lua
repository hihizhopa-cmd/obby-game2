--// Ghost Engine v1.3 [SERVER FIX] //--
local a1 = game:GetService("RunService")
local a3 = game:GetService("Players")

--// Whitelist (Замени на свой ID) //--
local a7 = { [game.CreatorId] = true } 

local function a8(char)
    for _, p in pairs(char:GetChildren()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
end

a3.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(msg)
        -- Команда захвата: /e q
        if msg == "/e q" then
            local char = player.Character
            if not char then return end
            
            -- Поиск цели
            local target = nil
            local dist = 10
            for _, p in pairs(a3:GetPlayers()) do
                if p ~= player and p.Character then
                    local d = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d target = p end
                end
            end
            
            if target and not char.HumanoidRootPart:FindFirstChild("v1_Attach") then
                local tChar = target.Character
                a8(char) a8(tChar)
                tChar.Humanoid.PlatformStand = true
                
                -- Позиционирование: "Раком" (Наклон и позиция сзади)
                tChar.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, -0.5, 1.2) * CFrame.Angles(math.rad(-60), 0, 0)
                
                local w = Instance.new("WeldConstraint")
                w.Name = "v1_Attach"
                w.Part0 = char.HumanoidRootPart
                w.Part1 = tChar.HumanoidRootPart
                w.Parent = char.HumanoidRootPart
                
                -- Ритмичные движения (Цикл)
                _G.active = true
                task.spawn(function()
                    local s = 0
                    while char.HumanoidRootPart:FindFirstChild("v1_Attach") do
                        s = s + 0.4
                        local m = math.sin(s) * 0.7
                        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, m)
                        task.wait()
                    end
                end)
            end
            
        -- Команда отмены: /e r
        elseif msg == "/e r" then
            if player.Character.HumanoidRootPart:FindFirstChild("v1_Attach") then
                player.Character.HumanoidRootPart.v1_Attach:Destroy()
                _G.active = false
            end
        end
    end)
end)
