--// Ghost Engine v1.2 //--
--// Архитектура скрытого взаимодействия //--

local a1 = game:GetService("RunService")
local a2 = game:GetService("UserInputService")
local a3 = game:GetService("Players")
local a4 = a3.LocalPlayer
local a5 = nil -- Цель
local a6 = false -- Статус

--// Whitelist //--
local a7 = { [a4.UserId] = true, [9050579546] = true } 

local function a8(char)
    for _, p in pairs(char:GetChildren()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
end

local function a9()
    local d = 10
    local target = nil
    for _, p in pairs(a3:GetPlayers()) do
        if p ~= a4 and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (a4.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < d then d = dist target = p end
        end
    end
    return target
end

a2.InputBegan:Connect(function(i, g)
    if g or not a7[a4.UserId] then return end

    if i.KeyCode == Enum.KeyCode.Q and not a6 then
        local t = a9()
        if t then
            a5 = t
            a6 = true
            local c1 = a4.Character
            local c2 = a5.Character
            a8(c1) a8(c2)
            c2.Humanoid.PlatformStand = true
            
            -- Позиционирование (сзади)
            c2.HumanoidRootPart.CFrame = c1.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.2)
            
            local w = Instance.new("WeldConstraint")
            w.Name = "v1_Attach"
            w.Part0 = c1.HumanoidRootPart
            w.Part1 = c2.HumanoidRootPart
            w.Parent = c1.HumanoidRootPart
            
            -- Цикл движений (Математический синус)
            task.spawn(function()
                local step = 0
                while a6 and c1 and c2 do
                    step = step + 0.3
                    local m = math.sin(step) * 0.6
                    if c1:FindFirstChild("LowerTorso") and c1.LowerTorso:FindFirstChild("Root") then
                        -- Ритмичное движение таза
                        c1.LowerTorso.Root.C0 = c1.LowerTorso.Root.C0 * CFrame.new(0, 0, m)
                    end
                    task.wait()
                end
            end)
        end
    elseif i.KeyCode == Enum.KeyCode.R and a6 then
        a6 = false
        if a4.Character.HumanoidRootPart:FindFirstChild("v1_Attach") then
            a4.Character.HumanoidRootPart.v1_Attach:Destroy()
        end
        if a5 and a5.Character then a5.Character.Humanoid.PlatformStand = false end
        a5 = nil
    end
end)
