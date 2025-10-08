--// Services
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

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

-- Main UI
local screengui = Instance.new("ScreenGui")
screengui.Name = "solaris_premium"
screengui.Parent = CoreGui
screengui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function tween(instance, props, time, style, dir)
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    local info = TweenService:Create(instance, TweenInfo.new(time, style, dir), props)
    info:Play()
    return info
end

local function createMain()
    -- Animated background particles
    local particleContainer = Instance.new("Frame", screengui)
    particleContainer.Name = "Particles"
    particleContainer.Size = UDim2.new(1, 0, 1, 0)
    particleContainer.BackgroundTransparency = 1
    particleContainer.ZIndex = 0
    
    for i = 1, 15 do
        local particle = Instance.new("Frame", particleContainer)
        particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
        particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
        particle.BackgroundColor3 = Color3.fromRGB(60 + math.random(20), 65 + math.random(20), 200 + math.random(30))
        particle.BackgroundTransparency = 0.7
        particle.BorderSizePixel = 0
        local corner = Instance.new("UICorner", particle)
        corner.CornerRadius = UDim.new(1, 0)
        
        task.spawn(function()
            while particle.Parent do
                local randomTime = math.random(30, 60) / 10
                tween(particle, {
                    Position = UDim2.new(math.random(), 0, math.random(), 0),
                    BackgroundTransparency = math.random(50, 90) / 100
                }, randomTime, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                wait(randomTime)
            end
        end)
        end

        UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input)
            tween(sliderBtn, {Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(sliderBtn.Position.X.Scale, -13, 0.5, -13)}, 0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            tween(btnInner, {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0.5, -7, 0.5, -7)}, 0.15, Enum.EasingStyle.Back)
            tween(btnStroke, {Transparency = 0.1, Thickness = 4}, 0.15)
            tween(frameStroke, {Color = Color3.fromRGB(100, 105, 255), Transparency = 0.3}, 0.15)
        end
    end)
    
    frame.MouseEnter:Connect(function()
        if not dragging then
            tween(frameStroke, {Color = Color3.fromRGB(100, 105, 255), Transparency = 0.4}, 0.2)
            tween(frame, {BackgroundColor3 = Color3.fromRGB(18, 18, 24)}, 0.2)
        end
    end)
    
    frame.MouseLeave:Connect(function()
        if not dragging then
            tween(frameStroke, {Color = Color3.fromRGB(30, 30, 40), Transparency = 0.6}, 0.2)
            tween(frame, {BackgroundColor3 = Color3.fromRGB(12, 12, 18)}, 0.2)
        end
    end)

    return frame
end

-- SETUP TABS WITH CONTENT
local ballTab = ui.TabFrames["Ball"]
local playerTab = ui.TabFrames["Player"]
local gkTab = ui.TabFrames["GK"]
local settingsTab = ui.TabFrames["Settings"]

if ballTab then
    ui.CreateToggle(ballTab, "Ball Prediction", "Advanced trajectory visualization with landing markers", false, togglePrediction)
    
    -- Add spacing
    local spacer1 = Instance.new("Frame", ballTab)
    spacer1.Size = UDim2.new(1, 0, 0, 4)
    spacer1.BackgroundTransparency = 1
    spacer1.LayoutOrder = #ballTab:GetChildren()
end

if playerTab then
    ui.CreateToggle(playerTab, "Infinite Stamina", "Never run out of stamina - sprint forever", false, function(state)
        staminaEnabled = state
        if state then setupStamina() end
    end)
    
    ui.CreateToggle(playerTab, "Speed Boost", "Double your movement speed instantly", false, toggleSpeed)
    
    local spacer2 = Instance.new("Frame", playerTab)
    spacer2.Size = UDim2.new(1, 0, 0, 8)
    spacer2.BackgroundTransparency = 1
    spacer2.LayoutOrder = #playerTab:GetChildren()
    
    ui.CreateToggle(playerTab, "Ball Reach", "Extend your touch range with no cooldown", false, toggleReach)
    
    makeSlider(playerTab, "Reach Distance", 1, MAX_REACH, reachDist, function(v)
        reachDist = v
        updateReachBox()
    end)
    
    makeSlider(playerTab, "Visual Opacity", 0, 100, reachVis * 100, function(v)
        reachVis = v / 100
        updateReachBox()
    end)
end

if gkTab then
    -- Create info card for GK tab
    local infoCard = Instance.new("Frame", gkTab)
    infoCard.Size = UDim2.new(1, -16, 0, 120)
    infoCard.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    infoCard.BorderSizePixel = 0
    infoCard.LayoutOrder = 1
    local infoCorner = Instance.new("UICorner", infoCard)
    infoCorner.CornerRadius = UDim.new(0, 12)
    
    local infoStroke = Instance.new("UIStroke", infoCard)
    infoStroke.Color = Color3.fromRGB(100, 105, 255)
    infoStroke.Transparency = 0.5
    infoStroke.Thickness = 2
    
    local infoIcon = Instance.new("TextLabel", infoCard)
    infoIcon.Size = UDim2.new(0, 60, 0, 60)
    infoIcon.Position = UDim2.new(0, 20, 0.5, -30)
    infoIcon.BackgroundTransparency = 1
    infoIcon.Text = "🧤"
    infoIcon.TextSize = 36
    infoIcon.Font = Enum.Font.GothamBold
    
    local infoTitle = Instance.new("TextLabel", infoCard)
    infoTitle.Size = UDim2.new(1, -100, 0, 28)
    infoTitle.Position = UDim2.new(0, 90, 0, 20)
    infoTitle.BackgroundTransparency = 1
    infoTitle.Text = "Goalkeeper Features"
    infoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoTitle.Font = Enum.Font.GothamBold
    infoTitle.TextSize = 16
    infoTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local infoDesc = Instance.new("TextLabel", infoCard)
    infoDesc.Size = UDim2.new(1, -100, 0, 60)
    infoDesc.Position = UDim2.new(0, 90, 0, 50)
    infoDesc.BackgroundTransparency = 1
    infoDesc.Text = "Advanced goalkeeper mechanics and features coming soon. Check back for updates!"
    infoDesc.TextColor3 = Color3.fromRGB(150, 155, 200)
    infoDesc.Font = Enum.Font.Gotham
    infoDesc.TextSize = 13
    infoDesc.TextXAlignment = Enum.TextXAlignment.Left
    infoDesc.TextYAlignment = Enum.TextYAlignment.Top
    infoDesc.TextWrapped = true
end

if settingsTab then
    -- Create settings info
    local settingsCard = Instance.new("Frame", settingsTab)
    settingsCard.Size = UDim2.new(1, -16, 0, 140)
    settingsCard.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    settingsCard.BorderSizePixel = 0
    settingsCard.LayoutOrder = 1
    local settingsCorner = Instance.new("UICorner", settingsCard)
    settingsCorner.CornerRadius = UDim.new(0, 12)
    
    local settingsStroke = Instance.new("UIStroke", settingsCard)
    settingsStroke.Color = Color3.fromRGB(30, 30, 40)
    settingsStroke.Transparency = 0.6
    settingsStroke.Thickness = 1
    
    local settingsTitle = Instance.new("TextLabel", settingsCard)
    settingsTitle.Size = UDim2.new(1, -32, 0, 32)
    settingsTitle.Position = UDim2.new(0, 16, 0, 16)
    settingsTitle.BackgroundTransparency = 1
    settingsTitle.Text = "⚙ Hub Information"
    settingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    settingsTitle.Font = Enum.Font.GothamBold
    settingsTitle.TextSize = 18
    settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local versionLabel = Instance.new("TextLabel", settingsCard)
    versionLabel.Size = UDim2.new(1, -32, 0, 22)
    versionLabel.Position = UDim2.new(0, 16, 0, 54)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "Version: 2.0 Premium"
    versionLabel.TextColor3 = Color3.fromRGB(180, 185, 220)
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.TextSize = 13
    versionLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local statusLabel2 = Instance.new("TextLabel", settingsCard)
    statusLabel2.Size = UDim2.new(1, -32, 0, 22)
    statusLabel2.Position = UDim2.new(0, 16, 0, 78)
    statusLabel2.BackgroundTransparency = 1
    statusLabel2.Text = "Status: ✓ All Systems Operational"
    statusLabel2.TextColor3 = Color3.fromRGB(50, 255, 100)
    statusLabel2.Font = Enum.Font.GothamSemibold
    statusLabel2.TextSize = 13
    statusLabel2.TextXAlignment = Enum.TextXAlignment.Left
    
    local footerLabel = Instance.new("TextLabel", settingsCard)
    footerLabel.Size = UDim2.new(1, -32, 0, 22)
    footerLabel.Position = UDim2.new(0, 16, 0, 104)
    footerLabel.BackgroundTransparency = 1
    footerLabel.Text = "Designed for peak performance"
    footerLabel.TextColor3 = Color3.fromRGB(130, 135, 180)
    footerLabel.Font = Enum.Font.GothamItalic
    footerLabel.TextSize = 12
    footerLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Add keybind button
    local spacer3 = Instance.new("Frame", settingsTab)
    spacer3.Size = UDim2.new(1, 0, 0, 12)
    spacer3.BackgroundTransparency = 1
    spacer3.LayoutOrder = #settingsTab:GetChildren()
    
    local keybindCard = Instance.new("Frame", settingsTab)
    keybindCard.Size = UDim2.new(1, -16, 0, 80)
    keybindCard.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    keybindCard.BorderSizePixel = 0
    keybindCard.LayoutOrder = #settingsTab:GetChildren()
    local keybindCorner = Instance.new("UICorner", keybindCard)
    keybindCorner.CornerRadius = UDim.new(0, 12)
    
    local keybindStroke = Instance.new("UIStroke", keybindCard)
    keybindStroke.Color = Color3.fromRGB(30, 30, 40)
    keybindStroke.Transparency = 0.6
    keybindStroke.Thickness = 1
    
    local keybindLabel = Instance.new("TextLabel", keybindCard)
    keybindLabel.Size = UDim2.new(0.6, 0, 0, 26)
    keybindLabel.Position = UDim2.new(0, 16, 0, 12)
    keybindLabel.BackgroundTransparency = 1
    keybindLabel.Text = "Toggle UI Keybind"
    keybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    keybindLabel.Font = Enum.Font.GothamBold
    keybindLabel.TextSize = 15
    keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local keybindDesc = Instance.new("TextLabel", keybindCard)
    keybindDesc.Size = UDim2.new(1, -32, 0, 20)
    keybindDesc.Position = UDim2.new(0, 16, 0, 40)
    keybindDesc.BackgroundTransparency = 1
    keybindDesc.Text = "Press RIGHT CTRL to toggle the UI"
    keybindDesc.TextColor3 = Color3.fromRGB(130, 135, 180)
    keybindDesc.Font = Enum.Font.Gotham
    keybindDesc.TextSize = 13
    keybindDesc.TextXAlignment = Enum.TextXAlignment.Left
    
    local keybindButton = Instance.new("TextButton", keybindCard)
    keybindButton.Size = UDim2.new(0, 100, 0, 36)
    keybindButton.Position = UDim2.new(1, -116, 0.5, -18)
    keybindButton.BackgroundColor3 = Color3.fromRGB(100, 105, 255)
    keybindButton.Text = "RIGHT CTRL"
    keybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    keybindButton.Font = Enum.Font.GothamBold
    keybindButton.TextSize = 12
    keybindButton.AutoButtonColor = false
    keybindButton.BorderSizePixel = 0
    local keybindBtnCorner = Instance.new("UICorner", keybindButton)
    keybindBtnCorner.CornerRadius = UDim.new(0, 8)
    
    local keybindBtnStroke = Instance.new("UIStroke", keybindButton)
    keybindBtnStroke.Color = Color3.fromRGB(120, 125, 255)
    keybindBtnStroke.Transparency = 0.5
    keybindBtnStroke.Thickness = 2
end

-- Toggle UI with keybind
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightControl then
        if ui.Root.Visible then
            tween(ui.Root, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            for i, shadow in ipairs(ui.Shadows) do
                tween(shadow, {BackgroundTransparency = 1}, 0.3)
            end
            task.wait(0.3)
            ui.Root.Visible = false
        else
            ui.Root.Visible = true
            ui.Root.Size = UDim2.new(0, 0, 0, 0)
            ui.Root.Position = UDim2.new(0.5, 0, 0.5, 0)
            tween(ui.Root, {Size = UDim2.new(0, 620, 0, 420)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            for i, shadow in ipairs(ui.Shadows) do
                task.spawn(function()
                    wait(i * 0.05)
                    tween(shadow, {BackgroundTransparency = 0.92 - (i * 0.02)}, 0.4)
                end)
            end
        end
    end
end)

setupStamina()

-- Notification system
local function showNotification(title, message, duration)
    local notif = Instance.new("Frame", screengui)
    notif.Size = UDim2.new(0, 0, 0, 80)
    notif.Position = UDim2.new(1, -20, 0, 20)
    notif.AnchorPoint = Vector2.new(1, 0)
    notif.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    notif.BorderSizePixel = 0
    notif.ZIndex = 100
    
    local notifCorner = Instance.new("UICorner", notif)
    notifCorner.CornerRadius = UDim.new(0, 12)
    
    local notifStroke = Instance.new("UIStroke", notif)
    notifStroke.Color = Color3.fromRGB(100, 105, 255)
    notifStroke.Transparency = 0.4
    notifStroke.Thickness = 2
    
    local notifTitle = Instance.new("TextLabel", notif)
    notifTitle.Size = UDim2.new(1, -20, 0, 26)
    notifTitle.Position = UDim2.new(0, 14, 0, 10)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = title
    notifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.TextSize = 14
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local notifMsg = Instance.new("TextLabel", notif)
    notifMsg.Size = UDim2.new(1, -20, 0, 36)
    notifMsg.Position = UDim2.new(0, 14, 0, 36)
    notifMsg.BackgroundTransparency = 1
    notifMsg.Text = message
    notifMsg.TextColor3 = Color3.fromRGB(180, 185, 220)
    notifMsg.Font = Enum.Font.Gotham
    notifMsg.TextSize = 12
    notifMsg.TextXAlignment = Enum.TextXAlignment.Left
    notifMsg.TextWrapped = true
    
    tween(notif, {Size = UDim2.new(0, 320, 0, 80)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    task.delay(duration or 3, function()
        tween(notif, {Position = UDim2.new(1, 20, 0, 20)}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        tween(notifStroke, {Transparency = 1}, 0.3)
        task.wait(0.3)
        notif:Destroy()
    end)
end

-- Show welcome notification
task.delay(1, function()
    showNotification("Solaris Premium Loaded", "All features active and ready to use!", 4)
end)
    end

    -- Multi-layer shadow system
    local shadowLayers = {}
    for i = 1, 3 do
        local shadow = Instance.new("Frame", screengui)
        shadow.Name = "Shadow" .. i
        shadow.AnchorPoint = Vector2.new(0.5, 0.5)
        shadow.Size = UDim2.new(0, 620 + (i * 8), 0, 420 + (i * 8))
        shadow.Position = UDim2.new(0.5, 0, 0.5, i * 2)
        shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        shadow.BackgroundTransparency = 0.92 - (i * 0.02)
        shadow.BorderSizePixel = 0
        shadow.ZIndex = 0
        local shadowCorner = Instance.new("UICorner", shadow)
        shadowCorner.CornerRadius = UDim.new(0, 16)
        table.insert(shadowLayers, shadow)
    end

    -- Main frame with initial animation state
    local frame = Instance.new("Frame")
    frame.Parent = screengui
    frame.Name = "solaris_premium_hub"
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.ZIndex = 1
    frame.ClipsDescendants = true

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 14)

    -- Animated border glow
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(100, 105, 255)
    stroke.Transparency = 0.3
    stroke.Thickness = 2
    
    task.spawn(function()
        while stroke.Parent do
            tween(stroke, {Transparency = 0.1, Thickness = 3}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            wait(1.5)
            tween(stroke, {Transparency = 0.4, Thickness = 2}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            wait(1.5)
        end
    end)

    -- Inner gradient background
    local inner = Instance.new("Frame", frame)
    inner.Name = "Inner"
    inner.Size = UDim2.new(1, -4, 1, -4)
    inner.Position = UDim2.new(0, 2, 0, 2)
    inner.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
    inner.BorderSizePixel = 0
    inner.ZIndex = 2
    local innerCorner = Instance.new("UICorner", inner)
    innerCorner.CornerRadius = UDim.new(0, 12)

    local innerGrad = Instance.new("UIGradient", inner)
    innerGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 8, 12)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(5, 5, 8)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 18))
    }
    innerGrad.Rotation = 135

    -- Animated gradient rotation
    task.spawn(function()
        while innerGrad.Parent do
            for i = 0, 360, 2 do
                innerGrad.Rotation = i
                wait(0.05)
            end
        end
    end)

    -- Header with glassmorphic effect
    local header = Instance.new("Frame", inner)
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 70)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    header.BackgroundTransparency = 0.3
    header.BorderSizePixel = 0
    local headerCorner = Instance.new("UICorner", header)
    headerCorner.CornerRadius = UDim.new(0, 12)

    local headerStroke = Instance.new("UIStroke", header)
    headerStroke.Color = Color3.fromRGB(40, 40, 50)
    headerStroke.Transparency = 0.7
    headerStroke.Thickness = 1

    -- Animated logo badge
    local logoBg = Instance.new("Frame", header)
    logoBg.Size = UDim2.new(0, 48, 0, 48)
    logoBg.Position = UDim2.new(0, 16, 0.5, -24)
    logoBg.BackgroundColor3 = Color3.fromRGB(100, 105, 255)
    logoBg.BorderSizePixel = 0
    local logoCorner = Instance.new("UICorner", logoBg)
    logoCorner.CornerRadius = UDim.new(0, 12)
    
    local logoGrad = Instance.new("UIGradient", logoBg)
    logoGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 125, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 65, 200))
    }
    logoGrad.Rotation = 45

    local logoStroke = Instance.new("UIStroke", logoBg)
    logoStroke.Color = Color3.fromRGB(150, 155, 255)
    logoStroke.Transparency = 0.5
    logoStroke.Thickness = 2

    -- Logo pulse animation
    task.spawn(function()
        while logoBg.Parent do
            tween(logoBg, {Size = UDim2.new(0, 52, 0, 52), Position = UDim2.new(0, 14, 0.5, -26)}, 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            tween(logoStroke, {Transparency = 0.2}, 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            wait(0.8)
            tween(logoBg, {Size = UDim2.new(0, 48, 0, 48), Position = UDim2.new(0, 16, 0.5, -24)}, 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            tween(logoStroke, {Transparency = 0.5}, 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            wait(0.8)
        end
    end)

    local logoText = Instance.new("TextLabel", logoBg)
    logoText.Size = UDim2.new(1, 0, 1, 0)
    logoText.BackgroundTransparency = 1
    logoText.Text = "S"
    logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    logoText.Font = Enum.Font.GothamBold
    logoText.TextSize = 28
    logoText.ZIndex = 4

    -- Title with typewriter effect
    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -160, 0, 28)
    title.Position = UDim2.new(0, 76, 0, 12)
    title.BackgroundTransparency = 1
    title.Text = ""
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3

    local titleGrad = Instance.new("UIGradient", title)
    titleGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 155, 255))
    }

    local subtitle = Instance.new("TextLabel", header)
    subtitle.Size = UDim2.new(1, -160, 0, 20)
    subtitle.Position = UDim2.new(0, 76, 0, 42)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = ""
    subtitle.TextColor3 = Color3.fromRGB(140, 145, 200)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 13
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex = 3

    -- Typewriter animation
    task.spawn(function()
        local titleText = "SOLARIS PREMIUM"
        local subText = "Advanced • Powerful • Undetected"
        
        for i = 1, #titleText do
            title.Text = titleText:sub(1, i)
            wait(0.05)
        end
        
        wait(0.2)
        
        for i = 1, #subText do
            subtitle.Text = subText:sub(1, i)
            wait(0.03)
        end
    end)

    -- Status indicator with pulse
    local statusDot = Instance.new("Frame", header)
    statusDot.Size = UDim2.new(0, 10, 0, 10)
    statusDot.Position = UDim2.new(1, -120, 0.5, -5)
    statusDot.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
    statusDot.BorderSizePixel = 0
    local dotCorner = Instance.new("UICorner", statusDot)
    dotCorner.CornerRadius = UDim.new(1, 0)

    task.spawn(function()
        while statusDot.Parent do
            tween(statusDot, {BackgroundColor3 = Color3.fromRGB(100, 255, 150), Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -121, 0.5, -6)}, 0.6, Enum.EasingStyle.Quad)
            wait(0.6)
            tween(statusDot, {BackgroundColor3 = Color3.fromRGB(50, 255, 100), Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(1, -120, 0.5, -5)}, 0.6, Enum.EasingStyle.Quad)
            wait(0.6)
        end
    end)

    local statusLabel = Instance.new("TextLabel", header)
    statusLabel.Size = UDim2.new(0, 80, 0, 20)
    statusLabel.Position = UDim2.new(1, -105, 0.5, -10)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "ACTIVE"
    statusLabel.TextColor3 = Color3.fromRGB(50, 255, 100)
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 11
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.ZIndex = 3

    -- Enhanced close button
    local closeButton = Instance.new("TextButton", header)
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -52, 0.5, -20)
    closeButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 24
    closeButton.AutoButtonColor = false
    closeButton.BorderSizePixel = 0
    closeButton.ZIndex = 4
    local closeCorner = Instance.new("UICorner", closeButton)
    closeCorner.CornerRadius = UDim.new(0, 10)
    
    local closeStroke = Instance.new("UIStroke", closeButton)
    closeStroke.Color = Color3.fromRGB(80, 80, 90)
    closeStroke.Transparency = 0.5
    closeStroke.Thickness = 1

    closeButton.MouseEnter:Connect(function()
        tween(closeButton, {BackgroundColor3 = Color3.fromRGB(255, 50, 80), Size = UDim2.new(0, 42, 0, 42), Position = UDim2.new(1, -53, 0.5, -21)}, 0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        tween(closeButton, {TextSize = 26}, 0.15)
        tween(closeStroke, {Color = Color3.fromRGB(255, 100, 130), Transparency = 0.2}, 0.15)
    end)
    closeButton.MouseLeave:Connect(function()
        tween(closeButton, {BackgroundColor3 = Color3.fromRGB(20, 20, 25), Size = UDim2.new(0, 40, 0, 40), Position = UDim2.new(1, -52, 0.5, -20)}, 0.15, Enum.EasingStyle.Quad)
        tween(closeButton, {TextSize = 24}, 0.15)
        tween(closeStroke, {Color = Color3.fromRGB(80, 80, 90), Transparency = 0.5}, 0.15)
    end)

    -- Animated accent line
    local accentLine = Instance.new("Frame", inner)
    accentLine.Size = UDim2.new(1, -24, 0, 2)
    accentLine.Position = UDim2.new(0, 12, 0, 76)
    accentLine.BackgroundColor3 = Color3.fromRGB(100, 105, 255)
    accentLine.BorderSizePixel = 0
    accentLine.ZIndex = 2
    
    local accentGrad = Instance.new("UIGradient", accentLine)
    accentGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 105, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 155, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 105, 255))
    }
    accentGrad.Offset = Vector2.new(-1, 0)

    task.spawn(function()
        while accentGrad.Parent do
            tween(accentGrad, {Offset = Vector2.new(1, 0)}, 2, Enum.EasingStyle.Linear)
            wait(2)
            accentGrad.Offset = Vector2.new(-1, 0)
        end
    end)

    -- Enhanced sidebar
    local sidebar = Instance.new("Frame", inner)
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 180, 1, -94)
    sidebar.Position = UDim2.new(0, 8, 0, 86)
    sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 2
    local sbCorner = Instance.new("UICorner", sidebar)
    sbCorner.CornerRadius = UDim.new(0, 12)

    local sbStroke = Instance.new("UIStroke", sidebar)
    sbStroke.Color = Color3.fromRGB(30, 30, 40)
    sbStroke.Transparency = 0.6
    sbStroke.Thickness = 1

    local sbLayout = Instance.new("UIListLayout", sidebar)
    sbLayout.Padding = UDim.new(0, 10)
    sbLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sbLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local sbPadding = Instance.new("UIPadding", sidebar)
    sbPadding.PaddingTop = UDim.new(0, 20)
    sbPadding.PaddingBottom = UDim.new(0, 18)

    local function makeSidebarButton(text, icon, order)
        local btn = Instance.new("TextButton", sidebar)
        btn.Name = text .. "Btn"
        btn.Size = UDim2.new(1, -24, 0, 52)
        btn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Text = ""
        btn.LayoutOrder = order
        btn.ClipsDescendants = true
        btn.ZIndex = 3

        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 10)

        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = Color3.fromRGB(40, 40, 50)
        btnStroke.Transparency = 0.7
        btnStroke.Thickness = 1

        -- Hover glow effect
        local glow = Instance.new("Frame", btn)
        glow.Size = UDim2.new(0, 4, 1, 0)
        glow.Position = UDim2.new(0, -4, 0, 0)
        glow.BackgroundColor3 = Color3.fromRGB(100, 105, 255)
        glow.BorderSizePixel = 0
        glow.BackgroundTransparency = 1
        local glowCorner = Instance.new("UICorner", glow)
        glowCorner.CornerRadius = UDim.new(1, 0)

        local iconBg = Instance.new("Frame", btn)
        iconBg.Size = UDim2.new(0, 42, 0, 42)
        iconBg.Position = UDim2.new(0, 8, 0.5, -21)
        iconBg.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
        iconBg.BorderSizePixel = 0
        local iconCorner = Instance.new("UICorner", iconBg)
        iconCorner.CornerRadius = UDim.new(0, 10)

        local iconGrad = Instance.new("UIGradient", iconBg)
        iconGrad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 38)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 26))
        }
        iconGrad.Rotation = 45

        local iconLabel = Instance.new("TextLabel", iconBg)
        iconLabel.Size = UDim2.new(1, 0, 1, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.TextColor3 = Color3.fromRGB(200, 205, 255)
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.TextSize = 20

        local textLabel = Instance.new("TextLabel", btn)
        textLabel.Size = UDim2.new(1, -64, 1, 0)
        textLabel.Position = UDim2.new(0, 60, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = text
        textLabel.TextColor3 = Color3.fromRGB(180, 185, 220)
        textLabel.Font = Enum.Font.GothamSemibold
        textLabel.TextSize = 15
        textLabel.TextXAlignment = Enum.TextXAlignment.Left

        btn.MouseEnter:Connect(function()
            tween(btn, {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}, 0.2, Enum.EasingStyle.Quad)
            tween(iconBg, {BackgroundColor3 = Color3.fromRGB(100, 105, 255), Size = UDim2.new(0, 44, 0, 44), Position = UDim2.new(0, 7, 0.5, -22)}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            tween(iconLabel, {TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 22}, 0.2)
            tween(textLabel, {TextColor3 = Color3.fromRGB(255, 255, 255), Position = UDim2.new(0, 64, 0, 0)}, 0.2)
            tween(btnStroke, {Color = Color3.fromRGB(100, 105, 255), Transparency = 0.3}, 0.2)
            tween(glow, {BackgroundTransparency = 0.3, Position = UDim2.new(0, 0, 0, 0)}, 0.2)
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, {BackgroundColor3 = Color3.fromRGB(15, 15, 20)}, 0.2, Enum.EasingStyle.Quad)
            tween(iconBg, {BackgroundColor3 = Color3.fromRGB(25, 25, 32), Size = UDim2.new(0, 42, 0, 42), Position = UDim2.new(0, 8, 0.5, -21)}, 0.2, Enum.EasingStyle.Quad)
            tween(iconLabel, {TextColor3 = Color3.fromRGB(200, 205, 255), TextSize = 20}, 0.2)
            tween(textLabel, {TextColor3 = Color3.fromRGB(180, 185, 220), Position = UDim2.new(0, 60, 0, 0)}, 0.2)
            tween(btnStroke, {Color = Color3.fromRGB(40, 40, 50), Transparency = 0.7}, 0.2)
            tween(glow, {BackgroundTransparency = 1, Position = UDim2.new(0, -4, 0, 0)}, 0.2)
        end)
        return btn
    end

    local tabs = {"Ball", "Player", "GK", "Settings"}
    local icons = {"⚽", "👤", "🧤", "⚙"}
    local buttons = {}
    for i, t in ipairs(tabs) do
        buttons[t] = makeSidebarButton(t, icons[i], i)
    end

    -- Content area with smooth animations
    local content = Instance.new("Frame", inner)
    content.Name = "Content"
    content.Size = UDim2.new(1, -204, 1, -94)
    content.Position = UDim2.new(0, 196, 0, 86)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ZIndex = 2

    local function makeTabFrame(name)
        local f = Instance.new("ScrollingFrame", content)
        f.Name = name .. "_Tab"
        f.Size = UDim2.new(1, -16, 1, -8)
        f.Position = UDim2.new(0, 8, 0, 4)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.ScrollBarThickness = 8
        f.ScrollBarImageColor3 = Color3.fromRGB(100, 105, 255)
        f.CanvasSize = UDim2.new(0, 0, 0, 800)
        f.ZIndex = 3
        f.ScrollingEnabled = true

        local layout = Instance.new("UIListLayout", f)
        layout.Padding = UDim.new(0, 14)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Left

        local padding = Instance.new("UIPadding", f)
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        padding.PaddingTop = UDim.new(0, 8)

        return f
    end

    local tabFrames = {}
    for _, name in ipairs(tabs) do
        tabFrames[name] = makeTabFrame(name)
        tabFrames[name].Visible = false
    end
    tabFrames["Ball"].Visible = true

    -- Enhanced toggle with satisfying animations
    local function createToggle(parent, labelText, descText, initialState, callback)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(1, -16, 0, 80)
        container.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
        container.BorderSizePixel = 0
        container.LayoutOrder = #parent:GetChildren()
        local containerCorner = Instance.new("UICorner", container)
        containerCorner.CornerRadius = UDim.new(0, 12)

        local containerStroke = Instance.new("UIStroke", container)
        containerStroke.Color = Color3.fromRGB(30, 30, 40)
        containerStroke.Transparency = 0.6
        containerStroke.Thickness = 1

        local left = Instance.new("Frame", container)
        left.Size = UDim2.new(0.7, 0, 1, 0)
        left.BackgroundTransparency = 1

        local lbl = Instance.new("TextLabel", left)
        lbl.Size = UDim2.new(1, 0, 0, 26)
        lbl.Position = UDim2.new(0, 16, 0, 12)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 16
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local desc = Instance.new("TextLabel", left)
        desc.Size = UDim2.new(1, -16, 0, 20)
        desc.Position = UDim2.new(0, 16, 0, 40)
        desc.BackgroundTransparency = 1
        desc.Text = descText
        desc.TextColor3 = Color3.fromRGB(130, 135, 180)
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 13
        desc.TextXAlignment = Enum.TextXAlignment.Left

        local toggleBg = Instance.new("Frame", container)
        toggleBg.Size = UDim2.new(0, 64, 0, 32)
        toggleBg.Position = UDim2.new(1, -80, 0.5, -16)
        toggleBg.BackgroundColor3 = initialState and Color3.fromRGB(50, 200, 120) or Color3.fromRGB(40, 40, 50)
        toggleBg.BorderSizePixel = 0
        local toggleBgCorner = Instance.new("UICorner", toggleBg)
        toggleBgCorner.CornerRadius = UDim.new(1, 0)
        
        local toggleStroke = Instance.new("UIStroke", toggleBg)
        toggleStroke.Color = initialState and Color3.fromRGB(80, 220, 150) or Color3.fromRGB(60, 60, 70)
        toggleStroke.Transparency = 0.4
        toggleStroke.Thickness = 2

        local toggleGlow = Instance.new("Frame", toggleBg)
        toggleGlow.Size = UDim2.new(1, 8, 1, 8)
        toggleGlow.Position = UDim2.new(0.5, -4, 0.5, -4)
        toggleGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        toggleGlow.BackgroundColor3 = initialState and Color3.fromRGB(50, 200, 120) or Color3.fromRGB(40, 40, 50)
        toggleGlow.BackgroundTransparency = 0.9
        toggleGlow.BorderSizePixel = 0
        toggleGlow.ZIndex = 0
        local glowCorner = Instance.new("UICorner", toggleGlow)
        glowCorner.CornerRadius = UDim.new(1, 0)

        local toggleCircle = Instance.new("Frame", toggleBg)
        toggleCircle.Size = UDim2.new(0, 28, 0, 28)
        toggleCircle.Position = initialState and UDim2.new(1, -32, 0.5, -14) or UDim2.new(0, 4, 0.5, -14)
        toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleCircle.BorderSizePixel = 0
        local circleCorner = Instance.new("UICorner", toggleCircle)
        circleCorner.CornerRadius = UDim.new(1, 0)
        
        local circleShadow = Instance.new("UIStroke", toggleCircle)
        circleShadow.Color = Color3.fromRGB(0, 0, 0)
        circleShadow.Transparency = 0.8
        circleShadow.Thickness = 2

        local circleInner = Instance.new("Frame", toggleCircle)
        circleInner.Size = UDim2.new(0, 16, 0, 16)
        circleInner.Position = UDim2.new(0.5, -8, 0.5, -8)
        circleInner.BackgroundColor3 = initialState and Color3.fromRGB(50, 200, 120) or Color3.fromRGB(60, 60, 70)
        circleInner.BorderSizePixel = 0
        local innerCorner = Instance.new("UICorner", circleInner)
        innerCorner.CornerRadius = UDim.new(1, 0)

        local toggle = Instance.new("TextButton", container)
        toggle.Size = UDim2.new(0, 64, 0, 32)
        toggle.Position = UDim2.new(1, -80, 0.5, -16)
        toggle.BackgroundTransparency = 1
        toggle.Text = ""
        toggle.ZIndex = 5

        local state = initialState
        
        toggle.MouseEnter:Connect(function()
            tween(containerStroke, {Color = Color3.fromRGB(100, 105, 255), Transparency = 0.3}, 0.2)
            tween(container, {BackgroundColor3 = Color3.fromRGB(18, 18, 24)}, 0.2)
        end)
        
        toggle.MouseLeave:Connect(function()
            tween(containerStroke, {Color = Color3.fromRGB(30, 30, 40), Transparency = 0.6}, 0.2)
            tween(container, {BackgroundColor3 = Color3.fromRGB(12, 12, 18)}, 0.2)
        end)
        
        toggle.MouseButton1Click:Connect(function()
            state = not state
            
            if state then
                tween(toggleBg, {BackgroundColor3 = Color3.fromRGB(50, 200, 120)}, 0.25, Enum.EasingStyle.Quad)
                tween(toggleStroke, {Color = Color3.fromRGB(80, 220, 150)}, 0.25)
                tween(toggleGlow, {BackgroundColor3 = Color3.fromRGB(50, 200, 120), BackgroundTransparency = 0.7, Size = UDim2.new(1, 16, 1, 16)}, 0.3, Enum.EasingStyle.Quad)
                tween(toggleCircle, {Position = UDim2.new(1, -32, 0.5, -14), Size = UDim2.new(0, 28, 0, 28)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                tween(circleInner, {BackgroundColor3 = Color3.fromRGB(50, 200, 120), Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0.5, -9, 0.5, -9)}, 0.3, Enum.EasingStyle.Back)
                
                task.wait(0.15)
                tween(toggleGlow, {Size = UDim2.new(1, 8, 1, 8), BackgroundTransparency = 0.9}, 0.2)
                tween(circleInner, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0.5, -8, 0.5, -8)}, 0.2)
            else
                tween(toggleBg, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}, 0.25, Enum.EasingStyle.Quad)
                tween(toggleStroke, {Color = Color3.fromRGB(60, 60, 70)}, 0.25)
                tween(toggleGlow, {BackgroundColor3 = Color3.fromRGB(40, 40, 50), BackgroundTransparency = 0.7, Size = UDim2.new(1, 16, 1, 16)}, 0.3, Enum.EasingStyle.Quad)
                tween(toggleCircle, {Position = UDim2.new(0, 4, 0.5, -14), Size = UDim2.new(0, 28, 0, 28)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                tween(circleInner, {BackgroundColor3 = Color3.fromRGB(60, 60, 70), Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0.5, -9, 0.5, -9)}, 0.3, Enum.EasingStyle.Back)
                
                task.wait(0.15)
                tween(toggleGlow, {Size = UDim2.new(1, 8, 1, 8), BackgroundTransparency = 0.9}, 0.2)
                tween(circleInner, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0.5, -8, 0.5, -8)}, 0.2)
            end
            
            if callback then
                callback(state)
            end
        end)
        return container
    end

    return {
        Root = frame,
        Close = closeButton,
        Buttons = buttons,
        TabFrames = tabFrames,
        CreateToggle = createToggle,
        Shadows = shadowLayers
    }
end

local ui = createMain()

-- Opening animation sequence
task.spawn(function()
    wait(0.1)
    
    -- Expand main frame
    tween(ui.Root, {Size = UDim2.new(0, 620, 0, 420)}, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- Expand shadows
    for i, shadow in ipairs(ui.Shadows) do
        task.spawn(function()
            wait(i * 0.05)
            tween(shadow, {BackgroundTransparency = 0.92 - (i * 0.02)}, 0.4)
        end)
    end
end)

local function switchTo(tabName)
    if not ui.TabFrames[tabName] then return end
    for name, frame in pairs(ui.TabFrames) do
        if name == tabName then
            frame.Visible = false
            frame.Position = UDim2.new(0, 20, 0, 4)
            frame.Size = UDim2.new(1, -36, 1, -8)
            frame.Visible = true
            tween(frame, {Position = UDim2.new(0, 8, 0, 4), Size = UDim2.new(1, -16, 1, -8)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            if frame.Visible then
                tween(frame, {Position = UDim2.new(0, -20, 0, 4)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                task.wait(0.2)
                frame.Visible = false
            end
        end
    end
end

for name, btn in pairs(ui.Buttons) do
    btn.MouseButton1Click:Connect(function()
        switchTo(name)
    end)
end

ui.Close.MouseButton1Click:Connect(function()
    if screengui and screengui.Parent then
        tween(ui.Root, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        for i, shadow in ipairs(ui.Shadows) do
            tween(shadow, {BackgroundTransparency = 1}, 0.3)
        end
        task.wait(0.35)
        screengui:Destroy()
    end
end)

-- INFINITE STAMINA
local staminaConn
local staminaEnabled = false

local function setupStamina()
    if staminaConn then
        staminaConn:Disconnect()
    end
    
    task.spawn(function()
        local ok, stamina = pcall(function()
            return LocalPlayer:WaitForChild("PlayerScripts", 5)
                :WaitForChild("controllers", 5)
                :WaitForChild("movementController", 5)
                :WaitForChild("stamina", 5)
        end)
        
        if ok and stamina then
            staminaConn = RunService.Heartbeat:Connect(function()
                if staminaEnabled then
                    stamina.Value = 100
                end
            end)
        end
    end)
end

-- SPEED BOOST
local speedEnabled = false
local speedConn
local originalSpeed = 16

local function toggleSpeed(state)
    speedEnabled = state
    
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if speedEnabled then
        if hum then
            originalSpeed = hum.WalkSpeed
            hum.WalkSpeed = originalSpeed * 2
        end
        
        if not speedConn then
            speedConn = RunService.Heartbeat:Connect(function()
                local c = LocalPlayer.Character
                local h = c and c:FindFirstChildOfClass("Humanoid")
                if h and speedEnabled then
                    if h.WalkSpeed ~= originalSpeed * 2 then
                        h.WalkSpeed = originalSpeed * 2
                    end
                end
            end)
        end
    else
        if hum then
            hum.WalkSpeed = originalSpeed
        end
        if speedConn then
            speedConn:Disconnect()
            speedConn = nil
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    if speedEnabled then
        task.wait(0.5)
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then
            originalSpeed = h.WalkSpeed
            h.WalkSpeed = originalSpeed * 2
        end
    end
end)

-- REACH BYPASS
do
    for _, v in ipairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "overlapCheck") and rawget(v, "gkCheck") then
            hookfunction(v.overlapCheck, function() return true end)
            hookfunction(v.gkCheck, function() return true end)
        end
    end
end

-- IMPROVED REACH SYSTEM (NO COOLDOWN)
local reachEnabled = false
local reachDist = 12
local MAX_REACH = 50
local reachVis = 0.5

local reachBox
local reachConn

local function updateReachBox()
    if reachBox then
        reachBox.Size = Vector3.new(reachDist * 2, reachDist * 2, reachDist * 2)
        reachBox.Transparency = reachVis
    end
end

local function createReachBox()
    if reachBox then reachBox:Destroy() end
    reachBox = Instance.new("Part")
    reachBox.Name = "ReachBox"
    reachBox.Anchored = true
    reachBox.CanCollide = false
    reachBox.Transparency = reachVis
    reachBox.Size = Vector3.new(reachDist * 2, reachDist * 2, reachDist * 2)
    reachBox.Color = Color3.fromRGB(100, 105, 255)
    reachBox.Material = Enum.Material.ForceField
    reachBox.Parent = workspace
    
    local particles = Instance.new("ParticleEmitter", reachBox)
    particles.Color = ColorSequence.new(Color3.fromRGB(100, 105, 255))
    particles.Size = NumberSequence.new(0.2)
    particles.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    })
    particles.Lifetime = NumberRange.new(1, 2)
    particles.Rate = 20
    particles.Speed = NumberRange.new(2, 4)
    particles.SpreadAngle = Vector2.new(360, 360)
end

local function fireTouch(ball, limb)
    pcall(function()
        firetouchinterest(ball, limb, 0)
        firetouchinterest(ball, limb, 1)
    end)
end

local function toggleReach(state)
    reachEnabled = state
    
    if reachEnabled then
        createReachBox()
        
        if not reachConn then
            reachConn = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                
                if root and reachBox then
                    reachBox.Position = root.Position
                end
                
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
        end
    else
        if reachBox then
            reachBox:Destroy()
            reachBox = nil
        end
        if reachConn then
            reachConn:Disconnect()
            reachConn = nil
        end
    end
end

-- BALL PREDICTION
local predictionEnabled = false
local predictionConn
local predictionParts = {}
local predictionAttachment = nil

local function clearPrediction()
    for _, part in ipairs(predictionParts) do
        pcall(function()
            if part and part.Parent then
                part:Destroy()
            end
        end)
    end
    predictionParts = {}
    
    if predictionAttachment and predictionAttachment.Parent then
        predictionAttachment:Destroy()
    end
    predictionAttachment = nil
end

local function createPredictionTrail(ball)
    if predictionAttachment then
        predictionAttachment:Destroy()
    end
    
    predictionAttachment = Instance.new("Attachment", ball)
    
    local trail = Instance.new("Trail", ball)
    trail.Attachment0 = predictionAttachment
    trail.Attachment1 = predictionAttachment
    trail.FaceCamera = true
    trail.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 105, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 155, 255))
    }
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    trail.Lifetime = 2
    trail.MinLength = 0
    trail.WidthScale = NumberSequence.new(1.5)
    trail.Enabled = true
    
    table.insert(predictionParts, trail)
    table.insert(predictionParts, predictionAttachment)
end

local function createLandingMarker(position)
    local marker = Instance.new("Part")
    marker.Size = Vector3.new(3, 0.2, 3)
    marker.Position = position + Vector3.new(0, 0.1, 0)
    marker.Anchored = true
    marker.CanCollide = false
    marker.Transparency = 0.3
    marker.Color = Color3.fromRGB(255, 200, 50)
    marker.Material = Enum.Material.Neon
    marker.Parent = workspace
    
    local particles = Instance.new("ParticleEmitter", marker)
    particles.Color = ColorSequence.new(Color3.fromRGB(255, 200, 50))
    particles.Size = NumberSequence.new(0.5)
    particles.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })
    particles.Lifetime = NumberRange.new(0.5, 1)
    particles.Rate = 50
    particles.Speed = NumberRange.new(3, 6)
    particles.EmissionDirection = Enum.NormalId.Top
    
    local billboard = Instance.new("BillboardGui", marker)
    billboard.Size = UDim2.new(5, 0, 5, 0)
    billboard.Adornee = marker
    billboard.AlwaysOnTop = true
    
    local circle = Instance.new("ImageLabel", billboard)
    circle.Size = UDim2.new(1, 0, 1, 0)
    circle.BackgroundTransparency = 1
    circle.Image = "rbxassetid://12272370792"
    circle.ImageColor3 = Color3.fromRGB(255, 200, 50)
    circle.ImageTransparency = 0.2
    
    task.spawn(function()
        for i = 1, 20 do
            circle.Rotation = circle.Rotation + 3
            wait(0.05)
        end
    end)
    
    table.insert(predictionParts, marker)
    
    task.delay(2, function()
        if marker and marker.Parent then
            tween(marker, {Transparency = 1}, 0.3)
            tween(circle, {ImageTransparency = 1}, 0.3)
            task.wait(0.3)
            marker:Destroy()
        end
    end)
end

local function predictBallLanding(ball)
    if not ball or not ball.Parent then return end
    
    local velocity = ball.AssemblyLinearVelocity
    if velocity.Magnitude < 5 then return end
    
    local position = ball.Position
    local vel = velocity
    local gravity = Vector3.new(0, -workspace.Gravity, 0)
    local dt = 0.1
    
    for i = 1, 50 do
        vel = vel + (gravity * dt)
        position = position + (vel * dt)
        
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character, ball}
        
        local result = workspace:Raycast(position, Vector3.new(0, -5, 0), rayParams)
        if result then
            createLandingMarker(result.Position)
            break
        end
    end
end

local function togglePrediction(state)
    predictionEnabled = state

    if BallPredictor then
        BallPredictor.SetEnabled(state)
        return
    end

    if predictionEnabled then
        if not predictionConn then
            predictionConn = RunService.Heartbeat:Connect(function()
                if not predictionEnabled then return end

                clearPrediction()

                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Part") and obj:FindFirstChild("network") then
                        createPredictionTrail(obj)
                        predictBallLanding(obj)
                        break
                    end
                end
            end)
        end
    else
        if predictionConn then
            predictionConn:Disconnect()
            predictionConn = nil
        end
        clearPrediction()
    end
end

-- ENHANCED SLIDER COMPONENT
local function makeSlider(parent, label, min, max, start, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -16, 0, 70)
    frame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    frame.BorderSizePixel = 0
    frame.LayoutOrder = #parent:GetChildren()
    local frameCorner = Instance.new("UICorner", frame)
    frameCorner.CornerRadius = UDim.new(0, 12)

    local frameStroke = Instance.new("UIStroke", frame)
    frameStroke.Color = Color3.fromRGB(30, 30, 40)
    frameStroke.Transparency = 0.6
    frameStroke.Thickness = 1

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.6, 0, 0, 24)
    lbl.Position = UDim2.new(0, 16, 0, 10)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 15
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local valueLbl = Instance.new("TextLabel", frame)
    valueLbl.Size = UDim2.new(0, 70, 0, 24)
    valueLbl.Position = UDim2.new(1, -86, 0, 10)
    valueLbl.BackgroundTransparency = 1
    valueLbl.Text = tostring(start)
    valueLbl.TextColor3 = Color3.fromRGB(100, 105, 255)
    valueLbl.Font = Enum.Font.GothamBold
    valueLbl.TextSize = 15
    valueLbl.TextXAlignment = Enum.TextXAlignment.Right

    local sliderBg = Instance.new("Frame", frame)
    sliderBg.Size = UDim2.new(1, -32, 0, 10)
    sliderBg.Position = UDim2.new(0, 16, 1, -24)
    sliderBg.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    sliderBg.BorderSizePixel = 0
    local sliderBgCorner = Instance.new("UICorner", sliderBg)
    sliderBgCorner.CornerRadius = UDim.new(1, 0)

    local sliderBgStroke = Instance.new("UIStroke", sliderBg)
    sliderBgStroke.Color = Color3.fromRGB(40, 40, 50)
    sliderBgStroke.Transparency = 0.6

    local sliderFill = Instance.new("Frame", sliderBg)
    sliderFill.Size = UDim2.new((start - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 105, 255)
    sliderFill.BorderSizePixel = 0
    local fillCorner = Instance.new("UICorner", sliderFill)
    fillCorner.CornerRadius = UDim.new(1, 0)
    
    local fillGrad = Instance.new("UIGradient", sliderFill)
    fillGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 125, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 85, 220))
    }

    local sliderBtn = Instance.new("TextButton", sliderBg)
    sliderBtn.Size = UDim2.new(0, 22, 0, 22)
    sliderBtn.Position = UDim2.new((start - min) / (max - min), -11, 0.5, -11)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.Text = ""
    sliderBtn.AutoButtonColor = false
    sliderBtn.BorderSizePixel = 0
    sliderBtn.ZIndex = 5
    local btnCorner = Instance.new("UICorner", sliderBtn)
    btnCorner.CornerRadius = UDim.new(1, 0)
    
    local btnStroke = Instance.new("UIStroke", sliderBtn)
    btnStroke.Color = Color3.fromRGB(100, 105, 255)
    btnStroke.Transparency = 0.3
    btnStroke.Thickness = 3

    local btnInner = Instance.new("Frame", sliderBtn)
    btnInner.Size = UDim2.new(0, 12, 0, 12)
    btnInner.Position = UDim2.new(0.5, -6, 0.5, -6)
    btnInner.BackgroundColor3 = Color3.fromRGB(100, 105, 255)
    btnInner.BorderSizePixel = 0
    local innerCorner = Instance.new("UICorner", btnInner)
    innerCorner.CornerRadius = UDim.new(1, 0)

    local dragging = false
    local current = start

    local function update(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (pos * (max - min)) + 0.5)
        
        if value ~= current then
            current = value
            valueLbl.Text = tostring(value)
            tween(sliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1, Enum.EasingStyle.Quad)
            tween(sliderBtn, {Position = UDim2.new(pos, -11, 0.5, -11)}, 0.1, Enum.EasingStyle.Quad)
            if callback then callback(value) end
        end
    end

    sliderBtn.MouseButton1Down:Connect(function()
        dragging = true
        tween(sliderBtn, {Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(sliderBtn.Position.X.Scale, -13, 0.5, -13)}, 0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        tween(btnInner, {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0.5, -7, 0.5, -7)}, 0.15, Enum.EasingStyle.Back)
        tween(btnStroke, {Transparency = 0.1, Thickness = 4}, 0.15)
        tween(frameStroke, {Color = Color3.fromRGB(100, 105, 255), Transparency = 0.3}, 0.15)
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            tween(sliderBtn, {Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(sliderBtn.Position.X.Scale, -11, 0.5, -11)}, 0.15, Enum.EasingStyle.Quad)
            tween(btnInner, {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0.5, -6, 0.5, -6)}, 0.15, Enum.EasingStyle.Quad)
            tween(btnStroke, {Transparency = 0.3, Thickness = 3}, 0.15)
            tween(frameStroke, {Color = Color3.fromRGB(30, 30, 40), Transparency = 0.6}, 0.15)
        end
