local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Astatine Paid",
    LoadingTitle = "booting Astatine...",
    LoadingSubtitle = "Creaming..",
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = false}
})

local tabPlayer = Window:CreateTab("Player")
local tabBall = Window:CreateTab("Ball Controls")
local tabGK = Window:CreateTab("Gk")
local tabSettings = Window:CreateTab("Settings")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local sidebarFrame = Instance.new("Frame")
sidebarFrame.Size = UDim2.new(0, 150, 1, 0)
sidebarFrame.Position = UDim2.new(0, 0, 0, 0)
sidebarFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
sidebarFrame.BorderSizePixel = 0
sidebarFrame.Parent = Window.MainFrame

local function createSidebarButton(name, tab, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextScaled = true
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Parent = sidebarFrame
    btn.MouseButton1Click:Connect(function()
        Window:SelectTab(tab)
        for _, child in pairs(sidebarFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    end)
    return btn
end

createSidebarButton("Player", tabPlayer, 20)
createSidebarButton("Ball Controls", tabBall, 70)
createSidebarButton("Goalkeeper", tabGK, 120)
createSidebarButton("Settings", tabSettings, 170)

local staminaEnabled = false
tabPlayer:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Flag = "StaminaToggle",
    Callback = function(v)
        staminaEnabled = v
        Rayfield:Notify({Title = "Player", Content = v and "🟢 Infinite stamina enabled" or "🔴 Infinite stamina disabled"})
        task.spawn(function()
            local ok, stamina = pcall(function()
                return LocalPlayer:WaitForChild("PlayerScripts", 5)
                    :WaitForChild("controllers", 5)
                    :WaitForChild("movementController", 5)
                    :WaitForChild("stamina", 5)
            end)
            if ok and stamina then
                RunService.Heartbeat:Connect(function()
                    if staminaEnabled then
                        stamina.Value = 100
                    end
                end)
            end
        end)
    end
})

local speedEnabled = false
local speedMultiplier = 2
local defaultSpeed = 16

tabPlayer:CreateSlider({
    Name = "Speed Multiplier",
    Range = {1, 3},
    Increment = 0.5,
    CurrentValue = 2,
    Flag = "SpeedMult",
    Callback = function(val)
        speedMultiplier = val
    end
})

tabPlayer:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(v)
        speedEnabled = v
        Rayfield:Notify({Title = "Player", Content = v and "🏃 Speed boost enabled" or "🏃 Speed boost disabled"})
    end
})

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = speedEnabled and (defaultSpeed * speedMultiplier) or defaultSpeed
    end
end)

local reachOn = false
local reachDist = 5
local maxReach = 20

do
    for _, v in ipairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "overlapCheck") and rawget(v, "gkCheck") then
            hookfunction(v.overlapCheck, function() return true end)
            hookfunction(v.gkCheck, function() return true end)
        end
    end
end

tabBall:CreateSlider({
    Name = "Reach Distance",
    Range = {5, maxReach},
    Increment = 0.5,
    CurrentValue = 5,
    Flag = "ReachDist",
    Callback = function(val)
        reachDist = math.clamp(val, 5, maxReach)
    end
})

tabBall:CreateToggle({
    Name = "Enable Reach",
    CurrentValue = false,
    Flag = "ReachToggle",
    Callback = function(v)
        reachOn = v
        Rayfield:Notify({Title = "Reach", Content = v and "🟢 Reach enabled" or "🔴 Reach disabled"})
    end
})

local function fireTouch(ball, limb)
    firetouchinterest(ball, limb, 0)
    task.wait(0.02)
    firetouchinterest(ball, limb, 1)
end

RunService.Heartbeat:Connect(function()
    if reachOn then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            for _, ball in ipairs(workspace:GetDescendants()) do
                if ball:IsA("Part") and ball:FindFirstChild("network") then
                    local dist = (ball.Position - root.Position).Magnitude
                    if dist <= reachDist then
                        for _, limb in pairs(char:GetDescendants()) do
                            if limb:IsA("BasePart") then
                                task.spawn(fireTouch, ball, limb)
                            end
                        end
                    end
                end
            end
        end
    end
end)

local autoGoal = false
local goalPower = 100
local shootCooldown = false
local maxAirPower = 300

tabBall:CreateToggle({
    Name = "Auto Goal",
    CurrentValue = false,
    Flag = "AutoGoal",
    Callback = function(v)
        autoGoal = v
        Rayfield:Notify({Title = "Auto Goal", Content = v and "⚽ Auto goal enabled" or "⚽ Auto goal disabled"})
    end
})

tabBall:CreateSlider({
    Name = "Goal Power (Ground)",
    Range = {50, 200},
    Increment = 10,
    CurrentValue = 100,
    Flag = "GoalPower",
    Callback = function(val)
        goalPower = val
    end
})

tabBall:CreateSlider({
    Name = "Air Ball Max Power",
    Range = {1, maxAirPower},
    Increment = 5,
    CurrentValue = 100,
    Flag = "AirPower",
    Callback = function(val)
        maxAirPower = val
    end
})

local function shootBall(ball, targetPos, power)
    if shootCooldown then return end
    shootCooldown = true
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
    bodyVelocity.Velocity = (targetPos - ball.Position).Unit * power
    bodyVelocity.Parent = ball
    game.Debris:AddItem(bodyVelocity,0.3)
    task.wait(0.6)
    shootCooldown = false
end

RunService.Heartbeat:Connect(function()
    if autoGoal then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        for _, ball in ipairs(workspace:GetDescendants()) do
            if ball:IsA("Part") and ball:FindFirstChild("network") then
                local dist = (ball.Position - root.Position).Magnitude
                if dist <= reachDist then
                    for _, goal in pairs(workspace:GetDescendants()) do
                        if goal:IsA("Model") and goal.Name:lower():find("goal") then
                            local goalPart = goal:FindFirstChildWhichIsA("BasePart")
                            if goalPart then
                                local ballPower = math.clamp((dist / reachDist) * maxAirPower, 1, maxAirPower)
                                local finalPower = ball.Position.Y > 3 and ballPower or goalPower
                                shootBall(ball, goalPart.Position, finalPower)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end)

tabSettings:CreateButton({
    Name = "Unload Script",
    Callback = function()
        Rayfield:Notify({Title = "System", Content = "🛑 Astatine Premium unloaded."})
        Rayfield:Destroy()
    end
})
