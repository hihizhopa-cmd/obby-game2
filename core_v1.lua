--// Ghost Engine v1.5 [R6 CONDO PROTOCOL] //--
--// Joint Manipulation System //--
local a3 = game:GetService("Players")
local a4 = game:GetService("RunService")

print("1.5 version")

-- Переменная для хранения оригинального C0 сустава
local originalC0 = nil

local function a8(char)
    -- Проверка на R6 rig (ищем Torso)
    if not char:FindFirstChild("Torso") then warn("R6 rig not found!") return false end
    for _, p in pairs(char:GetChildren()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
    return true
end

a3.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(msg)
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        -- Команда захвата: /e q
        if msg == "/e q" then
            local target = nil
            local dist = 10
            for _, p in pairs(a3:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d target = p end
                end
            end

            if target and not char.HumanoidRootPart:FindFirstChild("v1_Attach") then
                local tChar = target.Character
                if not a8(char) or not a8(tChar) then return end -- Проверка R6

                tChar.Humanoid.PlatformStand = true
                
                -- Позиционирование (R6 Condo): Жертва на четвереньках/наклонена сзади
                tChar.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, -1.2, 1.3) * CFrame.Angles(math.rad(-75), 0, 0)
                
                -- Сцепка (Weld)
                local w = Instance.new("WeldConstraint")
                w.Name = "v1_Attach"
                w.Part0 = char.HumanoidRootPart
                w.Part1 = tChar.HumanoidRootPart
                w.Parent = char.HumanoidRootPart
                
                -- Получаем RootJoint для манипуляции (HRP -> Torso)
                local rootJoint = char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("RootJoint")
                if rootJoint then
                    originalC0 = rootJoint.C0 -- Сохраняем оригинал
                    
                    -- Кондо-анимация через Motor6D (Procedural Joint Movement)
                    task.spawn(function()
                        local s = 0
                        while char.HumanoidRootPart:FindFirstChild("v1_Attach") do
                            s = s + 0.55 -- Скорость (Condo style)
                            local thrustZ = math.sin(s) * 0.95 -- Магнитуда толчка Z
                            local swayX = math.cos(s) * 0.15 -- Легкое покачивание X

                            -- Изменяем C0 сустава (thrust relative to base C0)
                            rootJoint.C0 = originalC0 * CFrame.new(swayX, 0, thrustZ)
                            
                            task.wait()
                        end
                        -- Сброс сустава после остановки
                        rootJoint.C0 = originalC0
                    end)
                end
            end
            
        -- Команда отмены: /e r
        elseif msg == "/e r" then
            local attach = char.HumanoidRootPart:FindFirstChild("v1_Attach")
            if attach then
                if attach.Part1 and attach.Part1.Parent:FindFirstChild("Humanoid") then
                    attach.Part1.Parent.Humanoid.PlatformStand = false
                end
                attach:Destroy()
                
                -- Сброс RootJoint
                local rootJoint = char.HumanoidRootPart:FindFirstChild("RootJoint")
                if rootJoint and originalC0 then
                    rootJoint.C0 = originalC0
                end
            end
        end
    end)
end)
