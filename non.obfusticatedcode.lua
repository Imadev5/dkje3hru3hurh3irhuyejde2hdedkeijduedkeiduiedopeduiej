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
local tabOP = Window:CreateTab("OP")
local tabGK = Window:CreateTab("Goalkeeper")
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

createSidebarButton("🏃 Player", tabPlayer, 20)
createSidebarButton("⚽ Ball Controls", tabBall, 70)
createSidebarButton("💀 OP", tabOP, 120)
createSidebarButton("🧤 Goalkeeper", tabGK, 170)
createSidebarButton("⚙️ Settings", tabSettings, 220)

-- PLAYER TAB
local staminaEnabled = false
tabPlayer:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Flag = "StaminaToggle",
    Callback = function(v)
        staminaEnabled = v
        Rayfield:Notify({Title = "Player", Content = v and "🟢 Infinite stamina enabled" or "🔴 Infinite stamina disabled"})
    end
})

local staminaConnection
task.spawn(function()
    local ok, stamina = pcall(function()
        return LocalPlayer:WaitForChild("PlayerScripts", 5)
            :WaitForChild("controllers", 5)
            :WaitForChild("movementController", 5)
            :WaitForChild("stamina", 5)
    end)
    if ok and stamina then
        staminaConnection = RunService.Heartbeat:Connect(function()
            if staminaEnabled then
                stamina.Value = 100
            end
        end)
    end
end)

local speedEnabled = false
local speedMultiplier = 2
local originalSpeed = nil

tabPlayer:CreateSlider({
    Name = "Speed Multiplier",
    Range = {1, 5},
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

local speedConnection = RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if not originalSpeed then
            originalSpeed = hum.WalkSpeed
        end
        if speedEnabled then
            hum.WalkSpeed = originalSpeed * speedMultiplier
        else
            hum.WalkSpeed = originalSpeed
        end
    end
end)

-- BALL CONTROLS TAB
local reachOn = false
local reachDist = 5
local maxReach = 50

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
    Increment = 1,
    CurrentValue = 5,
    Flag = "ReachDist",
    Callback = function(val)
        reachDist = val
        Rayfield:Notify({Title = "Reach", Content = "📏 Reach set to " .. tostring(val) .. " studs"})
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
    pcall(function()
        firetouchinterest(ball, limb, 0)
        task.wait()
        firetouchinterest(ball, limb, 1)
    end)
end

local reachConnection = RunService.Heartbeat:Connect(function()
    if not reachOn then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    for _, ball in ipairs(workspace:GetDescendants()) do
        if ball:IsA("Part") and ball:FindFirstChild("network") then
            local dist = (ball.Position - root.Position).Magnitude
            if dist <= reachDist then
                for _, limb in pairs(char:GetDescendants()) do
                    if limb:IsA("BasePart") and limb.Name ~= "HumanoidRootPart" then
                        fireTouch(ball, limb)
                    end
                end
            end
        end
    end
end)

local autoGoal = false
local goalPower = 100
local airPower = 100
local shootCooldown = false

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
    Range = {50, 300},
    Increment = 10,
    CurrentValue = 100,
    Flag = "GoalPower",
    Callback = function(val)
        goalPower = val
    end
})

tabBall:CreateSlider({
    Name = "Air Ball Power",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 100,
    Flag = "AirPower",
    Callback = function(val)
        airPower = val
    end
})

local function shootBall(ball, targetPos, power)
    if shootCooldown then return end
    shootCooldown = true
    
    pcall(function()
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = (targetPos - ball.Position).Unit * power
        bv.Parent = ball
        game:GetService("Debris"):AddItem(bv, 0.1)
        
        ball.AssemblyLinearVelocity = (targetPos - ball.Position).Unit * power
    end)
    
    task.wait(0.5)
    shootCooldown = false
end

local autoGoalConnection = RunService.Heartbeat:Connect(function()
    if not autoGoal then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, ball in ipairs(workspace:GetDescendants()) do
        if ball:IsA("Part") and ball:FindFirstChild("network") then
            local dist = (ball.Position - root.Position).Magnitude
            if dist <= reachDist then
                for _, goal in pairs(workspace:GetDescendants()) do
                    if goal:IsA("Model") and goal.Name:lower():find("goal") then
                        local goalPart = goal:FindFirstChildWhichIsA("BasePart")
                        if goalPart then
                            local isAirBall = ball.Position.Y > 5
                            local power = isAirBall and airPower or goalPower
                            shootBall(ball, goalPart.Position, power)
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- OP TAB
local ballsBroken = false

tabOP:CreateButton({
    Name = "Break React (Ball Frozen)",
    Callback = function()
        for _, ball in ipairs(workspace:GetDescendants()) do
            if ball:IsA("Part") and ball:FindFirstChild("network") then
                pcall(function()
                    ball.Anchored = true
                    ball.CanCollide = false
                    local network = ball:FindFirstChild("network")
                    if network then
                        network:Destroy()
                    end
                end)
            end
        end
        ballsBroken = true
        Rayfield:Notify({Title = "OP", Content = "💀 Ball react broken! Nobody can touch it."})
    end
})

tabOP:CreateButton({
    Name = "Fix React (Ball Normal)",
    Callback = function()
        for _, ball in ipairs(workspace:GetDescendants()) do
            if ball:IsA("Part") and ball.Name:lower():find("ball") then
                pcall(function()
                    ball.Anchored = false
                    ball.CanCollide = true
                end)
            end
        end
        ballsBroken = false
        Rayfield:Notify({Title = "OP", Content = "✅ Ball react fixed! Everyone can touch it."})
    end
})

tabOP:CreateButton({
    Name = "Ragdoll All Players",
    Callback = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                pcall(function()
                    local char = player.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum:ChangeState(Enum.HumanoidStateType.Ragdoll)
                            hum.PlatformStand = true
                        end
                    end
                end)
            end
        end
        Rayfield:Notify({Title = "OP", Content = "💀 All players ragdolled!"})
    end
})

tabOP:CreateButton({
    Name = "Kill All Players",
    Callback = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                pcall(function()
                    local char = player.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum.Health = 0
                        end
                    end
                end)
            end
        end
        Rayfield:Notify({Title = "OP", Content = "💀 All players killed!"})
    end
})

-- SETTINGS TAB
tabSettings:CreateButton({
    Name = "Unload Script",
    Callback = function()
        if staminaConnection then staminaConnection:Disconnect() end
        if speedConnection then speedConnection:Disconnect() end
        if reachConnection then reachConnection:Disconnect() end
        if autoGoalConnection then autoGoalConnection:Disconnect() end
        
        Rayfield:Notify({Title = "System", Content = "🛑 Astatine Premium unloaded."})
        task.wait(1)
        Rayfield:Destroy()
    end
})
