--// Ghost Engine v1.6 [R6 CONDO PROTOCOL V2] //--
--// Joint Axis Manipulation //--
local a1 = game:GetService("RunService")
local a2 = game:GetService("UserInputService")
local a3 = game:GetService("Players")
local a4 = a3.LocalPlayer
local a5 = nil -- Цель
print("1.6 version")
local function a8(char)
    -- Проверка на R6 rig (ищем Torso)
    if not char:FindFirstChild("Torso") then warn("R6 rig not found!") return false end
    for _, p in pairs(char:GetChildren()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
    return true
end

a2.InputBegan:Connect(function(i, g)
    if g then return end

    if i.KeyCode == Enum.KeyCode.Q then -- Захват
        local t = nil
        local d = 10
        for _, p in pairs(a3:GetPlayers()) do
            if p ~= a4 and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (a4.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist < d then d = dist t = p end
            end
        end

        if t and not a4.Character.HumanoidRootPart:FindFirstChild("v1_Attach") then
            local c1 = a4.Character
            local c2 = t.Character
            if not a8(c1) or not a8(c2) then return end -- R6 check

            c2.Humanoid.PlatformStand = true
            
            -- Позиционирование (R6 Condo V2): Фикс позиции и угла
            c2.HumanoidRootPart.CFrame = c1.HumanoidRootPart.CFrame * CFrame.new(0, -0.7, 1.3) * CFrame.Angles(math.rad(-75), 0, 0)
            
            local w = Instance.new("WeldConstraint")
            w.Name = "v1_Attach"
            w.Part0 = c1.HumanoidRootPart
            w.Part1 = c2.HumanoidRootPart
            w.Parent = c1.HumanoidRootPart
            
            -- Плавная Кондо-анимация через RootJoint
            local rootJoint = c1.HumanoidRootPart:FindFirstChild("RootJoint")
            if rootJoint then
                local originalC0 = rootJoint.C0
                _G.condoActive = true
                task.spawn(function()
                    local s = 0
                    while _G.condoActive and c1:FindFirstChild("v1_Attach") do
                        s = s + 0.45 -- Скорость Кондо
                        local thrustZ = math.sin(s) * 0.95 -- Магнитуда толчка
                        
                        -- Изменяем C0 сустава (thrust relative to base C0)
                        rootJoint.C0 = originalC0 * CFrame.new(0, 0, thrustZ)
                        
                        task.wait()
                    end
                    -- Сброс сустава
                    rootJoint.C0 = originalC0
                end)
            end
        end
    elseif i.KeyCode == Enum.KeyCode.R then -- Отмена
        local attach = a4.Character.HumanoidRootPart:FindFirstChild("v1_Attach")
        if attach then
            if attach.Part1 and attach.Part1.Parent:FindFirstChild("Humanoid") then
                attach.Part1.Parent.Humanoid.PlatformStand = false
            end
            attach:Destroy()
            _G.condoActive = false -- Остановить цикл
        end
    end
end)
