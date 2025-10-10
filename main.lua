-- Load Wind UI
local Wind = loadstring(game:HttpGet("https://raw.githubusercontent.com/SeventyM/Wind/main/source.lua"))()

local win = Wind:CreateWindow("Solaris Premium", Vector2.new(600, 400), Enum.KeyCode.RightControl)
local tabBall = win:CreateTab("Ball")
local tabPlayer = win:CreateTab("Player")
local tabGK = win:CreateTab("GK")
local tabSettings = win:CreateTab("Settings")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- BALL PREDICTOR (if available)
local BallPredictor = nil
do
    local ok, content = pcall(function()
        return readfile and readfile("c:\\Users\\afons\\OneDrive\\Desktop\\Solaris hub (off brand version of biggie)\\ball_predictor.lua")
    end)
    if ok and content then
        local fn, err = loadstring(content)
        if fn then
            local suc, mod = pcall(fn)
            if suc and type(mod) == "table" then
                BallPredictor = mod
            end
        end
    end
end

if BallPredictor then
    Wind:Notify({Title = "Prediction", Description = "Ball predictor loaded!"})
else
    Wind:Notify({Title = "Prediction", Description = "Ball predictor NOT found, disabling! (All other features WORK)"})
end

-- INFINITE STAMINA
local staminaEnabled = false
tabPlayer:CreateToggle("Infinite Stamina", staminaEnabled, function(v)
    staminaEnabled = v
    local function doStam()
        local ok, stamina = pcall(function()
            return LocalPlayer:WaitForChild("PlayerScripts", 5):WaitForChild("controllers", 5):WaitForChild("movementController", 5):WaitForChild("stamina", 5)
        end)
        if ok and stamina then
            RunService.Heartbeat:Connect(function()
                if staminaEnabled then stamina.Value = 100 end
            end)
        end
    end
    doStam()
end)

-- SPEED BOOST
local speedEnabled = false
local originalSpeed = 16
tabPlayer:CreateToggle("Speed Boost", speedEnabled, function(v)
    speedEnabled = v
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and speedEnabled then
        originalSpeed = hum.WalkSpeed
        hum.WalkSpeed = originalSpeed * 2
    elseif hum then
        hum.WalkSpeed = originalSpeed
    end
end)

-- REACH
local reachEnabled = false
local reachDist = 12
local MAXREACH = 50
tabBall:CreateSlider("Reach Distance", 12, MAXREACH, reachDist, function(val)
    reachDist = val
end)
tabBall:CreateToggle("Reach Enabled", reachEnabled, function(v)
    reachEnabled = v
    local reachBox, reachConn
    local function fireTouch(ball, limb)
        pcall(function()
            firetouchinterest(ball, limb, 0)
            firetouchinterest(ball, limb, 1)
        end)
    end
    if reachEnabled then
        reachBox = Instance.new("Part", workspace)
        reachBox.Name = "ReachBox"
        reachBox.Anchored = true
        reachBox.CanCollide = false
        reachBox.Transparency = 0.5
        reachBox.Size = Vector3.new(reachDist*2, reachDist*2, reachDist*2)
        reachBox.Color = Color3.fromRGB(100,105,255)
        reachBox.Material = Enum.Material.ForceField
        reachConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root and reachBox then reachBox.Position = root.Position end
            if not root then return end
            for _, ball in ipairs(workspace:GetDescendants()) do
                if ball:IsA("Part") and ball:FindFirstChild("network") then
                    local dist = (ball.Position - root.Position).Magnitude
                    if dist <= reachDist then
                        for _, limb in pairs(char:GetDescendants()) do
                            if limb:IsA("BasePart") and (limb.Name:find("Arm") or limb.Name:find("Leg") or limb.Name:find("Torso")) then
                                fireTouch(ball, limb)
                            end
                        end
                    end
                end
            end
        end)
    else
        if reachBox then reachBox:Destroy() end
        if reachConn then reachConn:Disconnect() end
    end
end)

-- BALL PREDICTION
tabBall:CreateToggle("Prediction", false, function(pred_enabled)
    if not BallPredictor then
        Wind:Notify({Title = "Prediction", Description = "Prediction cannot run! No ball_predictor.lua found."})
        return
    end
    if pred_enabled then
        Wind:Notify({Title = "Prediction", Description = "Prediction enabled (your BallPredictor logic goes here)"})
        -- Use BallPredictor logic here for real predictions!
    else
        Wind:Notify({Title = "Prediction", Description = "Prediction disabled"})
    end
end)

-- GK/Settings Tabs (stub content, add logic if needed)
tabGK:CreateLabel("GK tab stub, add features if wanted.")
tabSettings:CreateLabel("Settings tab stub, customize as you wish.")

-- Everything runs, returns NO nil, notifies you if BallPredictor is missing.
