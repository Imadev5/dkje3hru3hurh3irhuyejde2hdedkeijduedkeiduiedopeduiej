-- ASTATINE PREMIUM V2.0 - ADVANCED REACH SYSTEM
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Astatine Premium V2.0",
    LoadingTitle = "Initializing Advanced Systems...",
    LoadingSubtitle = "Loading Overpowered Features...",
    ConfigurationSaving = {Enabled = true, FolderName = "AstatinePremium"},
    Discord = {Enabled = false}
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer

-- Tabs
local tabReach = Window:CreateTab("Advanced Reach")
local tabPlayer = Window:CreateTab("Player")
local tabBall = Window:CreateTab("Ball Controls")
local tabOP = Window:CreateTab("OP Features")
local tabGK = Window:CreateTab("Goalkeeper")
local tabSettings = Window:CreateTab("Settings")

-- REACH SYSTEM (Using the simpler, more effective version)
local reachOn = false
local reachDist = 5
local maxReach = 8

-- Bypass Reach (overlapCheck + gkCheck hook)
local function bypassReach()
    for _, v in ipairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "overlapCheck") and rawget(v, "gkCheck") then
            hookfunction(v.overlapCheck, function() return true end)
            hookfunction(v.gkCheck, function() return true end)
        end
    end
end

-- Initialize bypass
bypassReach()

-- Reach mechanics (simpler version)
local function fireTouch(ball, limb)
    firetouchinterest(ball, limb, 0)
    task.wait(0.03)
    firetouchinterest(ball, limb, 1)
end

-- Create heartbeat connection for reach
local reachConnection = RunService.Heartbeat:Connect(function()
    if reachOn then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            for _, ball in ipairs(workspace:GetDescendants()) do
                if ball:IsA("Part") and ball:FindFirstChild("network") then
                    if (ball.Position - root.Position).Magnitude <= reachDist then
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

-- ADVANCED REACH TAB
tabReach:CreateToggle({
    Name = "Enable Reach",
    CurrentValue = false,
    Flag = "ReachEnabled",
    Callback = function(v)
        reachOn = v
        Rayfield:Notify({Title = "Reach System", Content = v and "Reach enabled" or "Reach disabled"})
    end
})

tabReach:CreateSlider({
    Name = "Reach Distance",
    Range = {3, maxReach},
    Increment = 0.5,
    CurrentValue = 5,
    Flag = "ReachDistance",
    Callback = function(val)
        reachDist = val
    end
})

tabReach:CreateButton({
    Name = "Refresh Bypass",
    Callback = function()
        bypassReach()
        Rayfield:Notify({Title = "Reach System", Content = "Bypass refreshed"})
    end
})

-- PLAYER TAB
local playerSystem = {
    stamina = false,
    speed = false,
    speedMult = 2,
    originalSpeed = nil,
    jump = false,
    jumpPower = 50,
    noclip = false,
    fly = false,
    flySpeed = 16
}

tabPlayer:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Flag = "InfiniteStamina",
    Callback = function(v)
        playerSystem.stamina = v
        Rayfield:Notify({Title = "Player", Content = v and "Infinite stamina enabled" or "Infinite stamina disabled"})
    end
})

tabPlayer:CreateSlider({
    Name = "Speed Multiplier",
    Range = {1, 10},
    Increment = 0.5,
    CurrentValue = 2,
    Flag = "SpeedMultiplier",
    Callback = function(val)
        playerSystem.speedMult = val
    end
})

tabPlayer:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Flag = "SpeedBoost",
    Callback = function(v)
        playerSystem.speed = v
        Rayfield:Notify({Title = "Player", Content = v and "Speed boost enabled" or "Speed boost disabled"})
    end
})

tabPlayer:CreateSlider({
    Name = "Jump Power",
    Range = {50, 200},
    Increment = 10,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(val)
        playerSystem.jumpPower = val
    end
})

tabPlayer:CreateToggle({
    Name = "Super Jump",
    CurrentValue = false,
    Flag = "SuperJump",
    Callback = function(v)
        playerSystem.jump = v
        Rayfield:Notify({Title = "Player", Content = v and "Super jump enabled" or "Super jump disabled"})
    end
})

tabPlayer:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(v)
        playerSystem.noclip = v
        Rayfield:Notify({Title = "Player", Content = v and "Noclip enabled" or "Noclip disabled"})
    end
})

-- Player system handler
local playerConnection = RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    
    if hum then
        -- Speed
        if not playerSystem.originalSpeed then
            playerSystem.originalSpeed = hum.WalkSpeed
        end
        if playerSystem.speed then
            hum.WalkSpeed = playerSystem.originalSpeed * playerSystem.speedMult
        else
            hum.WalkSpeed = playerSystem.originalSpeed
        end
        
        -- Jump
        if playerSystem.jump then
            hum.JumpPower = playerSystem.jumpPower
        else
            hum.JumpPower = 50
        end
    end
    
    -- Stamina
    if playerSystem.stamina then
        local stamina = LocalPlayer:FindFirstChild("PlayerScripts")
        if stamina then
            stamina = stamina:FindFirstChild("controllers")
            if stamina then
                stamina = stamina:FindFirstChild("movementController")
                if stamina then
                    stamina = stamina:FindFirstChild("stamina")
                    if stamina then
                        stamina.Value = 100
                    end
                end
            end
        end
    end
    
    -- Noclip
    if playerSystem.noclip and char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- BALL CONTROLS TAB
local ballSystem = {
    autoGoal = false,
    goalPower = 150,
    airPower = 200,
    ballMagnet = false,
    magnetStrength = 50,
    ballFreeze = false,
    ballTeleport = false,
    shootCooldown = false,
    lastShot = 0,
    shieldBall = false,
    shieldConnections = {}
}

tabBall:CreateToggle({
    Name = "Auto Goal",
    CurrentValue = false,
    Flag = "AutoGoal",
    Callback = function(v)
        ballSystem.autoGoal = v
        Rayfield:Notify({Title = "Ball Control", Content = v and "Auto goal enabled" or "Auto goal disabled"})
    end
})

tabBall:CreateSlider({
    Name = "Goal Power",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 150,
    Flag = "GoalPower",
    Callback = function(val)
        ballSystem.goalPower = val
    end
})

tabBall:CreateSlider({
    Name = "Air Shot Power",
    Range = {100, 800},
    Increment = 20,
    CurrentValue = 200,
    Flag = "AirPower",
    Callback = function(val)
        ballSystem.airPower = val
    end
})

tabBall:CreateToggle({
    Name = "Ball Magnet",
    CurrentValue = false,
    Flag = "BallMagnet",
    Callback = function(v)
        ballSystem.ballMagnet = v
        Rayfield:Notify({Title = "Ball Control", Content = v and "Ball magnet enabled" or "Ball magnet disabled"})
    end
})

tabBall:CreateSlider({
    Name = "Magnet Strength",
    Range = {10, 100},
    Increment = 5,
    CurrentValue = 50,
    Flag = "MagnetStrength",
    Callback = function(val)
        ballSystem.magnetStrength = val
    end
})

tabBall:CreateToggle({
    Name = "Ball Freeze",
    CurrentValue = false,
    Flag = "BallFreeze",
    Callback = function(v)
        ballSystem.ballFreeze = v
        Rayfield:Notify({Title = "Ball Control", Content = v and "Ball freeze enabled" or "Ball freeze disabled"})
    end
})

-- FIXED: Shield Ball feature - Only local player can touch
tabBall:CreateToggle({
    Name = "Shield Ball (Exclusive Touch)",
    CurrentValue = false,
    Flag = "ShieldBall",
    Callback = function(v)
        ballSystem.shieldBall = v
        if v then
            startShieldBall()
        else
            stopShieldBall()
        end
        Rayfield:Notify({Title = "Ball Control", Content = v and "Shield ball enabled - Only you can touch the ball!" or "Shield ball disabled"})
    end
})

tabBall:CreateButton({
    Name = "Teleport Ball to Me",
    Callback = function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        for _, ball in pairs(workspace:GetDescendants()) do
            if ball:IsA("Part") and ball:FindFirstChild("network") then
                ball.CFrame = root.CFrame + root.CFrame.LookVector * 3
                ball.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                Rayfield:Notify({Title = "Ball Control", Content = "Ball teleported to you"})
                break
            end
        end
    end
})

-- FIXED: Shield Ball System - Only local player can touch
function startShieldBall()
    -- Clear any existing connections
    stopShieldBall()
    
    -- Find all balls with network
    local balls = {}
    for _, ball in pairs(workspace:GetDescendants()) do
        if ball:IsA("Part") and ball:FindFirstChild("network") then
            table.insert(balls, ball)
        end
    end
    
    -- Hook the overlapCheck and gkCheck functions to only allow the local player
    for _, v in ipairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "overlapCheck") and rawget(v, "gkCheck") then
            local originalOverlapCheck = v.overlapCheck
            local originalGkCheck = v.gkCheck
            
            -- Store original functions for restoration
            table.insert(ballSystem.shieldConnections, {
                object = v,
                overlapCheck = originalOverlapCheck,
                gkCheck = originalGkCheck
            })
            
            -- Override functions to only allow local player
            v.overlapCheck = function(...)
                local args = {...}
                -- Check if the first argument is the local player
                if #args > 0 and args[1] == LocalPlayer then
                    return true
                end
                return false
            end
            
            v.gkCheck = function(...)
                local args = {...}
                -- Check if the first argument is the local player
                if #args > 0 and args[1] == LocalPlayer then
                    return true
                end
                return false
            end
        end
    end
    
    -- Create visual shield effect
    for _, ball in pairs(balls) do
        local shieldVisual = Instance.new("Part")
        shieldVisual.Name = "BallShieldVisual"
        shieldVisual.Anchored = true
        shieldVisual.CanCollide = false
        shieldVisual.Material = Enum.Material.ForceField
        shieldVisual.Shape = Enum.PartType.Ball
        shieldVisual.Color = Color3.fromRGB(255, 215, 0)
        shieldVisual.Transparency = 0.7
        shieldVisual.Parent = workspace
        
        local updateShieldVisual = RunService.Heartbeat:Connect(function()
            if ball and ball.Parent then
                shieldVisual.Size = Vector3.new(ball.Size.X + 2, ball.Size.Y + 2, ball.Size.Z + 2)
                shieldVisual.CFrame = ball.CFrame
                shieldVisual.Transparency = 0.7 + math.sin(tick() * 2) * 0.2
            else
                shieldVisual:Destroy()
            end
        end)
        
        table.insert(ballSystem.shieldConnections, updateShieldVisual)
        table.insert(ballSystem.shieldConnections, shieldVisual)
    end
end

function stopShieldBall()
    -- Restore original functions
    for _, connection in pairs(ballSystem.shieldConnections) do
        if type(connection) == "table" and connection.object then
            if connection.overlapCheck then
                connection.object.overlapCheck = connection.overlapCheck
            end
            if connection.gkCheck then
                connection.object.gkCheck = connection.gkCheck
            end
        elseif connection.Disconnect then
            connection:Disconnect()
        elseif connection.Destroy then
            connection:Destroy()
        end
    end
    
    ballSystem.shieldConnections = {}
end

-- Ball system handler
local ballConnection = RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    for _, ball in pairs(workspace:GetDescendants()) do
        if ball:IsA("Part") and ball:FindFirstChild("network") then
            local distance = (ball.Position - root.Position).Magnitude
            
            -- Ball magnet
            if ballSystem.ballMagnet and distance <= 20 then
                local direction = (root.Position - ball.Position).Unit
                ball.AssemblyLinearVelocity = direction * ballSystem.magnetStrength
            end
            
            -- Ball freeze
            if ballSystem.ballFreeze then
                ball.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                ball.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
            
            -- Auto goal
            if ballSystem.autoGoal and distance <= reachDist then
                for _, goal in pairs(workspace:GetDescendants()) do
                    if goal:IsA("Model") and (goal.Name:lower():find("goal") or goal.Name:lower():find("net")) then
                        local goalPart = goal:FindFirstChildWhichIsA("BasePart")
                        if goalPart then
                            local isAirBall = ball.Position.Y > 8
                            local power = isAirBall and ballSystem.airPower or ballSystem.goalPower
                            
                            -- Shoot the ball
                            local direction = (goalPart.Position - ball.Position).Unit
                            ball.AssemblyLinearVelocity = direction * power
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- OP FEATURES TAB
local opSystem = {
    ballsBroken = false,
    playersLagged = false,
    serverCrash = false
}

tabOP:CreateButton({
    Name = "Ultimate Ball Break",
    Callback = function()
        for _, ball in pairs(workspace:GetDescendants()) do
            if ball:IsA("Part") and ball:FindFirstChild("network") then
                task.spawn(function()
                    pcall(function()
                        ball.Anchored = true
                        ball.CanCollide = false
                        ball.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        ball.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        
                        -- Destroy network components
                        for _, child in pairs(ball:GetChildren()) do
                            if child.Name:lower():find("network") or child.Name:lower():find("script") then
                                child:Destroy()
                            end
                        end
                        
                        -- Make ball invisible to others
                        ball.Transparency = 0.9
                        ball.Material = Enum.Material.ForceField
                    end)
                end)
            end
        end
        opSystem.ballsBroken = true
        Rayfield:Notify({Title = "OP Features", Content = "Ultimate ball break activated!"})
    end
})

tabOP:CreateButton({
    Name = "Restore Ball Physics",
    Callback = function()
        for _, ball in pairs(workspace:GetDescendants()) do
            if ball:IsA("Part") and (ball.Name:lower():find("ball") or ball.Name:lower():find("football")) then
                task.spawn(function()
                    pcall(function()
                        ball.Anchored = false
                        ball.CanCollide = true
                        ball.Transparency = 0
                        ball.Material = Enum.Material.Plastic
                    end)
                end)
            end
        end
        opSystem.ballsBroken = false
        Rayfield:Notify({Title = "OP Features", Content = "Ball physics restored!"})
    end
})

tabOP:CreateButton({
    Name = "Chaos Mode (Ragdoll All)",
    Callback = function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                task.spawn(function()
                    pcall(function()
                        local char = player.Character
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        local root = char:FindFirstChild("HumanoidRootPart")
                        
                        if hum and root then
                            -- Multiple ragdoll methods
                            hum:ChangeState(Enum.HumanoidStateType.Ragdoll)
                            hum.PlatformStand = true
                            hum.Sit = true
                            
                            -- Add spinning effect
                            local spin = Instance.new("BodyAngularVelocity")
                            spin.AngularVelocity = Vector3.new(0, 50, 0)
                            spin.MaxTorque = Vector3.new(0, math.huge, 0)
                            spin.Parent = root
                            Debris:AddItem(spin, 3)
                            
                            -- Launch them
                            local launch = Instance.new("BodyVelocity")
                            launch.Velocity = Vector3.new(math.random(-50, 50), 50, math.random(-50, 50))
                            launch.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            launch.Parent = root
                            Debris:AddItem(launch, 0.5)
                        end
                    end)
                end)
            end
        end
        Rayfield:Notify({Title = "OP Features", Content = "Chaos mode activated!"})
    end
})

tabOP:CreateButton({
    Name = "Server Lag Bomb",
    Callback = function()
        for i = 1, 100 do
            task.spawn(function()
                local part = Instance.new("Part")
                part.Size = Vector3.new(0.1, 0.1, 0.1)
                part.Material = Enum.Material.Neon
                part.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
                part.Position = Vector3.new(math.random(-100, 100), math.random(10, 50), math.random(-100, 100))
                part.Parent = workspace
                
                local spin = Instance.new("BodyAngularVelocity")
                spin.AngularVelocity = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
                spin.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                spin.Parent = part
                
                Debris:AddItem(part, 10)
            end)
        end
        Rayfield:Notify({Title = "OP Features", Content = "Server lag bomb deployed!"})
    end
})

tabOP:CreateButton({
    Name = "Invisible Mode",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 1
                elseif part:IsA("Accessory") then
                    part.Handle.Transparency = 1
                end
            end
            Rayfield:Notify({Title = "OP Features", Content = "You are now invisible!"})
        end
    end
})

tabOP:CreateButton({
    Name = "Visible Mode",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 0
                elseif part:IsA("Accessory") then
                    part.Handle.Transparency = 0
                end
            end
            Rayfield:Notify({Title = "OP Features", Content = "You are now visible!"})
        end
    end
})

-- GOALKEEPER TAB
local gkSystem = {
    autoSave = false,
    saveDistance = 15,
    divePower = 100,
    reflexMode = false
}

tabGK:CreateToggle({
    Name = "Auto Save",
    CurrentValue = false,
    Flag = "AutoSave",
    Callback = function(v)
        gkSystem.autoSave = v
        Rayfield:Notify({Title = "Goalkeeper", Content = v and "Auto save enabled" or "Auto save disabled"})
    end
})

tabGK:CreateSlider({
    Name = "Save Distance",
    Range = {5, 30},
    Increment = 1,
    CurrentValue = 15,
    Flag = "SaveDistance",
    Callback = function(val)
        gkSystem.saveDistance = val
    end
})

tabGK:CreateSlider({
    Name = "Dive Power",
    Range = {50, 200},
    Increment = 10,
    CurrentValue = 100,
    Flag = "DivePower",
    Callback = function(val)
        gkSystem.divePower = val
    end
})

tabGK:CreateToggle({
    Name = "Reflex Mode",
    CurrentValue = false,
    Flag = "ReflexMode",
    Callback = function(v)
        gkSystem.reflexMode = v
        Rayfield:Notify({Title = "Goalkeeper", Content = v and "Reflex mode enabled" or "Reflex mode disabled"})
    end
})

-- Goalkeeper system
local gkConnection = RunService.Heartbeat:Connect(function()
    if not gkSystem.autoSave then return end
    
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    for _, ball in pairs(workspace:GetDescendants()) do
        if ball:IsA("Part") and ball:FindFirstChild("network") then
            local distance = (ball.Position - root.Position).Magnitude
            local ballVelocity = ball.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
            
            if distance <= gkSystem.saveDistance and ballVelocity.Magnitude > 10 then
                -- Predict where ball will be
                local timeToReach = distance / ballVelocity.Magnitude
                local predictedPos = ball.Position + (ballVelocity * timeToReach)
                
                -- Move to intercept
                if gkSystem.reflexMode then
                    root.CFrame = CFrame.new(predictedPos)
                else
                    local direction = (predictedPos - root.Position).Unit
                    root.AssemblyLinearVelocity = direction * gkSystem.divePower
                end
                
                -- Touch the ball
                task.spawn(function()
                    for _, limb in pairs(char:GetDescendants()) do
                        if limb:IsA("BasePart") then
                            fireTouch(ball, limb)
                        end
                    end
                end)
            end
        end
    end
end)

-- SETTINGS TAB
tabSettings:CreateButton({
    Name = "Performance Stats",
    Callback = function()
        local stats = {
            "Reach Status: " .. (reachOn and "Enabled" or "Disabled"),
            "Reach Distance: " .. reachDist,
            "Shield Ball: " .. (ballSystem.shieldBall and "Enabled" or "Disabled"),
            "Auto Goal: " .. (ballSystem.autoGoal and "Enabled" or "Disabled"),
            "Ball Magnet: " .. (ballSystem.ballMagnet and "Enabled" or "Disabled")
        }
        
        local message = table.concat(stats, "\n")
        Rayfield:Notify({Title = "Performance Stats", Content = message, Duration = 5})
    end
})

tabSettings:CreateButton({
    Name = "Reset All Settings",
    Callback = function()
        reachDist = 5
        playerSystem.speedMult = 2
        ballSystem.goalPower = 150
        
        Rayfield:Notify({Title = "Settings", Content = "All settings reset to default"})
    end
})

tabSettings:CreateButton({
    Name = "Clean Workspace",
    Callback = function()
        local cleaned = 0
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and obj.Name:find("BallShieldVisual") then
                obj:Destroy()
                cleaned = cleaned + 1
            end
        end
        Rayfield:Notify({Title = "Cleanup", Content = "Cleaned " .. cleaned .. " objects"})
    end
})

tabSettings:CreateButton({
    Name = "Emergency Stop",
    Callback = function()
        reachOn = false
        
        playerSystem.speed = false
        playerSystem.noclip = false
        ballSystem.autoGoal = false
        ballSystem.ballMagnet = false
        ballSystem.shieldBall = false
        stopShieldBall()
        gkSystem.autoSave = false
        
        Rayfield:Notify({Title = "Emergency", Content = "All features disabled!"})
    end
})

tabSettings:CreateButton({
    Name = "Unload Script",
    Callback = function()
        -- Disconnect all connections
        if playerConnection then playerConnection:Disconnect() end
        if ballConnection then ballConnection:Disconnect() end
        if gkConnection then gkConnection:Disconnect() end
        if reachConnection then reachConnection:Disconnect() end
        
        stopShieldBall()
        
        Rayfield:Notify({Title = "System", Content = "Astatine Premium V2.0 unloaded successfully!"})
        task.wait(2)
        Rayfield:Destroy()
    end
})

-- Initialize notification
Rayfield:Notify({
    Title = "Astatine Premium V2.0",
    Content = "Advanced systems loaded successfully!\nSimple and effective reach system\nBall shield feature ready!",
    Duration = 5
})
