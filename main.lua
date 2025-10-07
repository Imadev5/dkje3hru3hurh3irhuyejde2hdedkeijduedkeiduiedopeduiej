--// Services
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Main UI creation
local screengui = Instance.new("ScreenGui")
screengui.Name = "solaris"
screengui.Parent = CoreGui
screengui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screengui.ResetOnSpawn = false

local function tween(instance, props, time, style, dir)
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    local info = TweenService:Create(instance, TweenInfo.new(time, style, dir), props)
    info:Play()
    return info
end

local function createMain()
    -- ... (UI creation logic unchanged; copy-paste from your original)
    -- ... (All code up to `return` section unchanged)
    -- ... (This block stays exactly as your logic)
end

local ui = createMain()

-- safe fade helper (only affects the properties we animate)
local function fadeDescendants(root, targetTransparency, time)
    local objects = {}
    if root:IsA("Frame") or root:IsA("ImageLabel") or root:IsA("ImageButton") then
        table.insert(objects, root)
    end
    for _, v in pairs(root:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
            table.insert(objects, v)
        elseif v:IsA("Frame") or v:IsA("ImageLabel") or v:IsA("ImageButton") then
            table.insert(objects, v)
        end
    end
    for _, obj in ipairs(objects) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            pcall(function() tween(obj, {TextTransparency = targetTransparency}, time) end)
        elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
            pcall(function() tween(obj, {ImageTransparency = targetTransparency}, time) end)
        elseif obj:IsA("Frame") then
            pcall(function() tween(obj, {BackgroundTransparency = targetTransparency}, time) end)
        end
    end
end

-- start hidden then animate in
fadeDescendants(ui.Root, 1, 0)
tween(ui.Root, {Size = UDim2.new(0, 520, 0, 320)}, 0)
task.delay(0.05, function()
    fadeDescendants(ui.Root, 0, 0.4)
    tween(ui.Root, {Size = UDim2.new(0, 560, 0, 360)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)

local function switchTo(tabName)
    if not ui.TabFrames[tabName] then return end
    local current
    for name, frame in pairs(ui.TabFrames) do
        if frame.Visible then current = name break end
    end
    if current == tabName then return end
    local outFrame = ui.TabFrames[current]
    local inFrame = ui.TabFrames[tabName]
    if outFrame then
        for _, v in pairs(outFrame:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextButton") then
                pcall(function() tween(v, {TextTransparency = 1}, 0.18) end)
            elseif v:IsA("Frame") then
                pcall(function() tween(v, {BackgroundTransparency = 1}, 0.18) end)
            end
        end
        task.delay(0.18, function()
            outFrame.Visible = false
            inFrame.Visible = true
            fadeDescendants(inFrame, 1, 0)
            task.delay(0.02, function()
                fadeDescendants(inFrame, 0, 0.25)
            end)
        end)
    else
        inFrame.Visible = true
        fadeDescendants(inFrame, 1, 0)
        task.delay(0.02, function()
            fadeDescendants(inFrame, 0, 0.25)
        end)
    end
end

for name, btn in pairs(ui.Buttons) do
    btn.MouseButton1Click:Connect(function()
        tween(btn, {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}, 0.12)
        task.delay(0.2, function()
            tween(btn, {BackgroundColor3 = Color3.fromRGB(28, 28, 32)}, 0.18)
        end)
        switchTo(name)
    end)
end

ui.Close.MouseButton1Click:Connect(function()
    fadeDescendants(ui.Root, 1, 0.25)
    tween(ui.Root, {Size = UDim2.new(0, 520, 0, 320)}, 0.28, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.delay(0.32, function()
        if screengui and screengui.Parent then
            screengui:Destroy()
        end
    end)
end)

-- INFINITE STAMINA (improved safety)
local staminaConn
local staminaOn = false

-- More robust stamina hooker
local function hookStamina()
    if staminaConn then
        staminaConn:Disconnect()
        staminaConn = nil
    end
    local function getStamina()
        local ps = LocalPlayer and LocalPlayer:FindFirstChild("PlayerScripts")
        if not ps then return nil end
        local controllers = ps:FindFirstChild("controllers")
        if not controllers then return nil end
        local movement = controllers:FindFirstChild("movementController")
        if not movement then return nil end
        return movement:FindFirstChild("stamina")
    end
    local stamina = nil
    -- Wait for up to two seconds for all objects to appear, checking repeatedly
    for i = 1, 40 do
        stamina = getStamina()
        if stamina then break end
        task.wait(0.05)
    end
    if stamina then
        staminaConn = RunService.Heartbeat:Connect(function()
            if staminaOn then
                pcall(function() stamina.Value = 100 end)
            end
        end)
    end
end

local playerTab = ui.TabFrames["Player"]
if playerTab then
    ui.CreateToggle(
        playerTab,
        "Infinite Stamina",
        "Never run out of stamina while playing",
        false,
        function(state)
            staminaOn = state
            if staminaOn then
                hookStamina()
            else
                if staminaConn then
                    staminaConn:Disconnect()
                    staminaConn = nil
                end
            end
        end
    )
end

hookStamina()

-- REACH BYPASS HOOK (best-effort; skipping errors)
do
    pcall(function()
        for _, v in ipairs(getgc and getgc(true) or {}) do
            if type(v) == "table" and rawget(v, "overlapCheck") and rawget(v, "gkCheck") then
                pcall(function()
                    hookfunction(v.overlapCheck, function() return true end)
                    hookfunction(v.gkCheck, function() return true end)
                end)
            end
        end
    end)
end

-- REACH & UI/Cooldown (improved reliability)
local reachOn = false
local reachX, reachY, reachZ = 5, 5, 5
local MAX_REACH = 1000 -- increased max reach
local reachTransparency = 0.5
local lastTouchTime = {}
local TOUCH_COOLDOWN = 1 -- seconds
local SCAN_DISTANCE = 50
local CHECK_RATE = 0.06
local reachHitbox
local reachConn
local lastCheck = 0

local function updateReachVisual()
    if reachHitbox then
        reachHitbox.Size = Vector3.new(math.max(0.1, reachX), math.max(0.1, reachY), math.max(0.1, reachZ))
        reachHitbox.Transparency = reachTransparency
    end
end

local function createReachVisual()
    if reachHitbox then reachHitbox:Destroy() end
    reachHitbox = Instance.new("Part")
    reachHitbox.Name = "ReachHitbox"
    reachHitbox.Anchored = true
    reachHitbox.CanCollide = false
    reachHitbox.Transparency = reachTransparency
    reachHitbox.Size = Vector3.new(reachX, reachY, reachZ)
    reachHitbox.Color = Color3.fromRGB(88, 101, 242)
    reachHitbox.Material = Enum.Material.ForceField
    reachHitbox.CanTouch = false
    reachHitbox.CastShadow = false
    reachHitbox.Parent = Workspace
    pcall(function() reachHitbox:SetNetworkOwner(nil) end)
end

local hasFireTouch = type(firetouchinterest) == "function"

local function enableReach(state)
    reachOn = state
    if reachOn then
        createReachVisual()
        if not reachConn then
            reachConn = RunService.Heartbeat:Connect(function()
                local now = tick()
                local char = LocalPlayer and LocalPlayer.Character
                local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("HumanoidRoot"))
                if root and reachHitbox then
                    local target = root.CFrame
                    reachHitbox.CFrame = reachHitbox.CFrame and reachHitbox.CFrame:Lerp(target, 0.45) or target
                    updateReachVisual()
                end
                if now - lastCheck < CHECK_RATE then return end
                lastCheck = now
                if not (char and root) then return end
                local nearbyBalls = {}
                local ok, parts = pcall(function()
                    if Workspace.GetPartBoundsInRadius then
                        return Workspace:GetPartBoundsInRadius(root.Position, math.max(SCAN_DISTANCE, reachX, reachY, reachZ))
                    end
                    return nil
                end)
                if ok and parts and type(parts) == "table" then
                    for _, part in ipairs(parts) do
                        if part and part:IsA("BasePart") and part:FindFirstChild("network") then
                            table.insert(nearbyBalls, part)
                        end
                    end
                else
                    for _, obj in ipairs(Workspace:GetChildren()) do
                        if obj:IsA("Model") then
                            for _, part in ipairs(obj:GetChildren()) do
                                if part:IsA("BasePart") and part:FindFirstChild("network") then
                                    local distance = (part.Position - root.Position).Magnitude
                                    if distance <= math.max(SCAN_DISTANCE, reachX, reachY, reachZ) then
                                        table.insert(nearbyBalls, part)
                                    end
                                end
                            end
                        else
                            if obj:IsA("BasePart") and obj:FindFirstChild("network") then
                                local distance = (obj.Position - root.Position).Magnitude
                                if distance <= math.max(SCAN_DISTANCE, reachX, reachY, reachZ) then
                                    table.insert(nearbyBalls, obj)
                                end
                            end
                        end
                    end
                end
                if #nearbyBalls == 0 then return end
                for _, ball in ipairs(nearbyBalls) do
                    if not ball or not ball:IsA("BasePart") then goto continue_ball end
                    local ballId
                    pcall(function()
                        if type(ball.GetDebugId) == "function" then
                            ballId = "id:" .. tostring(ball:GetDebugId())
                        else
                            ballId = "name:" .. ball:GetFullName()
                        end
                    end)
                    ballId = ballId or tostring(ball)
                    if lastTouchTime[ballId] and (now - lastTouchTime[ballId] < TOUCH_COOLDOWN) then goto continue_ball end
                    local diff = (ball.Position - root.Position)
                    if math.abs(diff.X) <= reachX/2 and math.abs(diff.Y) <= reachY/2 and math.abs(diff.Z) <= reachZ/2 then
                        lastTouchTime[ballId] = now
                        local limbs = {
                            char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm"),
                            char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm"),
                            char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg"),
                            char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg"),
                            char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
                        }
                        for _, limb in ipairs(limbs) do
                            if limb then
                                task.spawn(function()
                                    if not hasFireTouch then return end
                                    if ball and limb then
                                        pcall(function()
                                            firetouchinterest(ball, limb, 0)
                                            task.wait(0.01)
                                            firetouchinterest(ball, limb, 1)
                                        end)
                                    end
                                end)
                            end
                        end
                        break
                    end
                    ::continue_ball::
                end
            end)
        end
    else
        if reachHitbox then
            pcall(function() reachHitbox:Destroy() end)
            reachHitbox = nil
        end
        if reachConn then
            reachConn:Disconnect()
            reachConn = nil
        end
        lastTouchTime = {}
    end
end

local function makeSlider(parent, label, min, max, start, callback)
    -- ... (Slider logic unchanged, copy-paste from your original)
end

if playerTab then
    local reachToggle = ui.CreateToggle(
        playerTab,
        "Reach",
        "Enable reach mechanics; customize hitbox XYZ & transparency.",
        false,
        enableReach
    )
    local reachXSlider = makeSlider(playerTab, "Reach X", 1, MAX_REACH, reachX, function(val)
        reachX = val
        updateReachVisual()
    end)
    local reachYSlider = makeSlider(playerTab, "Reach Y", 1, MAX_REACH, reachY, function(val)
        reachY = val
        updateReachVisual()
    end)
    local reachZSlider = makeSlider(playerTab, "Reach Z", 1, MAX_REACH, reachZ, function(val)
        reachZ = val
        updateReachVisual()
    end)
    local transparencySlider = makeSlider(playerTab, "Transparency", 0, 1, reachTransparency, function(val)
        reachTransparency = math.clamp(tonumber(val) or 0, 0, 1)
        updateReachVisual()
    end)
end
