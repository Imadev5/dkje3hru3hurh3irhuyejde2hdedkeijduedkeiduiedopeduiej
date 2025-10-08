--// Services
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Main UI
local screengui = Instance.new("ScreenGui")
screengui.Name = "solaris"
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
    -- Drop shadow behind the window
    local shadow = Instance.new("Frame", screengui)
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Size = UDim2.new(0, 600, 0, 400)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 1  -- Start invisible for animation
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    local shadowCorner = Instance.new("UICorner", shadow)
    shadowCorner.CornerRadius = UDim.new(0, 12)

    -- Main frame (starts compact for an opening animation)
    local frame = Instance.new("Frame")
    frame.Parent = screengui
    frame.Name = "solaris_hub"
    frame.Size = UDim2.new(0, 10, 0, 10) -- tiny, will animate open
    frame.Position = UDim2.new(0.5, -5, 0.5, -5)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.ZIndex = 1

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    -- subtle border glow
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(60, 65, 200)
    stroke.Transparency = 0.85
    stroke.Thickness = 1

    -- Interior container to provide inset content and soft background gradient
    local inner = Instance.new("Frame", frame)
    inner.Name = "Inner"
    inner.Size = UDim2.new(1, -12, 1, -12)
    inner.Position = UDim2.new(0, 6, 0, 6)
    inner.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    inner.BorderSizePixel = 0
    inner.ZIndex = 2
    local innerCorner = Instance.new("UICorner", inner)
    innerCorner.CornerRadius = UDim.new(0, 8)

    local innerGrad = Instance.new("UIGradient", inner)
    innerGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 24))
    }
    innerGrad.Rotation = 90

    -- Header
    local header = Instance.new("Frame", inner)
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 48)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundTransparency = 1
    header.BorderSizePixel = 0

    -- Left badge / logo
    local logoBg = Instance.new("Frame", header)
    logoBg.Size = UDim2.new(0, 36, 0, 36)
    logoBg.Position = UDim2.new(0, 12, 0, 6)
    logoBg.BackgroundColor3 = Color3.fromRGB(60, 65, 200)
    logoBg.BorderSizePixel = 0
    local logoCorner = Instance.new("UICorner", logoBg)
    logoCorner.CornerRadius = UDim.new(1, 0)
    local logoImg = Instance.new("ImageLabel", logoBg)
    logoImg.BackgroundTransparency = 1
    logoImg.Size = UDim2.new(1, 0, 1, 0)
    logoImg.Image = "rbxassetid://0" -- placeholder (keeps it generic)
    logoImg.ImageColor3 = Color3.fromRGB(235, 235, 240)
    logoImg.ScaleType = Enum.ScaleType.Fit
    logoImg.ZIndex = 3

    -- Title
    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -120, 1, 0)
    title.Position = UDim2.new(0, 60, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Solaris"
    title.TextColor3 = Color3.fromRGB(240, 240, 245)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3

    local subtitle = Instance.new("TextLabel", header)
    subtitle.Size = UDim2.new(1, -120, 1, 0)
    subtitle.Position = UDim2.new(0, 60, 0, 20)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Compact · fast · elegant"
    subtitle.TextColor3 = Color3.fromRGB(170, 170, 180)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 12
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex = 3

    -- Accent line under header
    local accentLine = Instance.new("Frame", inner)
    accentLine.Size = UDim2.new(1, -12, 0, 3)
    accentLine.Position = UDim2.new(0, 6, 0, 48)
    accentLine.BackgroundColor3 = Color3.fromRGB(70, 75, 210)
    accentLine.BorderSizePixel = 0
    accentLine.ZIndex = 2
    local accentGrad = Instance.new("UIGradient", accentLine)
    accentGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 95, 230)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 45, 180))
    }

    -- Close button (refined)
    local closeButton = Instance.new("TextButton", header)
    closeButton.Size = UDim2.new(0, 34, 0, 34)
    closeButton.Position = UDim2.new(1, -46, 0.5, -17)
    closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 44)
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(240, 240, 240)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 20
    closeButton.AutoButtonColor = false
    closeButton.BorderSizePixel = 0
    closeButton.ZIndex = 4
    local closeCorner = Instance.new("UICorner", closeButton)
    closeCorner.CornerRadius = UDim.new(0, 8)
    local closeStroke = Instance.new("UIStroke", closeButton)
    closeStroke.Color = Color3.fromRGB(60, 60, 65)
    closeStroke.Transparency = 0.85

    closeButton.MouseEnter:Connect(function()
        tween(closeButton, {BackgroundColor3 = Color3.fromRGB(200, 60, 60); TextSize = 22}, 0.12, Enum.EasingStyle.Quad)
    end)
    closeButton.MouseLeave:Connect(function()
        tween(closeButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 44); TextSize = 20}, 0.12, Enum.EasingStyle.Quad)
    end)

    -- Sidebar
    local sidebar = Instance.new("Frame", inner)
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 160, 1, -93)  -- Adjusted for footer
    sidebar.Position = UDim2.new(0, 0, 0, 63)
    sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 2
    local sbCorner = Instance.new("UICorner", sidebar)
    sbCorner.CornerRadius = UDim.new(0, 8)

    local sbGrad = Instance.new("UIGradient", sidebar)
    sbGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(16,16,19)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(14,14,17))
    }
    sbGrad.Rotation = 90

    local sbLayout = Instance.new("UIListLayout", sidebar)
    sbLayout.Padding = UDim.new(0, 8)
    sbLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sbLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local sbPadding = Instance.new("UIPadding", sidebar)
    sbPadding.PaddingTop = UDim.new(0, 16)
    sbPadding.PaddingBottom = UDim.new(0, 14)

    local function makeSidebarButton(text, icon, order)
        local btn = Instance.new("TextButton", sidebar)
        btn.Name = text .. "Btn"
        btn.Size = UDim2.new(1, -22, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(26, 26, 30)
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Text = ""
        btn.LayoutOrder = order
        btn.ClipsDescendants = true
        btn.ZIndex = 3

        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 8)

        local iconBg = Instance.new("Frame", btn)
        iconBg.Size = UDim2.new(0, 36, 0, 36)
        iconBg.Position = UDim2.new(0, 6, 0.5, -18)
        iconBg.BackgroundColor3 = Color3.fromRGB(40, 40, 44)
        iconBg.BorderSizePixel = 0
        local iconCorner = Instance.new("UICorner", iconBg)
        iconCorner.CornerRadius = UDim.new(1, 0)

        local iconLabel = Instance.new("TextLabel", iconBg)
        iconLabel.Size = UDim2.new(1, 0, 1, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.TextSize = 16

        local textLabel = Instance.new("TextLabel", btn)
        textLabel.Size = UDim2.new(1, -52, 1, 0)
        textLabel.Position = UDim2.new(0, 50, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = text
        textLabel.TextColor3 = Color3.fromRGB(210, 210, 220)
        textLabel.Font = Enum.Font.Gotham
        textLabel.TextSize = 14
        textLabel.TextXAlignment = Enum.TextXAlignment.Left

        local indicator = Instance.new("Frame", btn)
        indicator.Size = UDim2.new(0, 4, 1, 0)
        indicator.Position = UDim2.new(0, 0, 0, 0)
        indicator.BackgroundColor3 = Color3.fromRGB(70, 75, 210)
        indicator.BorderSizePixel = 0
        indicator.BackgroundTransparency = 1

        btn.MouseEnter:Connect(function()
            tween(btn, {BackgroundColor3 = Color3.fromRGB(30, 30, 34)}, 0.15)
            tween(iconBg, {BackgroundColor3 = Color3.fromRGB(70, 75, 210)}, 0.18)
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, {BackgroundColor3 = Color3.fromRGB(26, 26, 30)}, 0.15)
            tween(iconBg, {BackgroundColor3 = Color3.fromRGB(40, 40, 44)}, 0.18)
        end)
        return btn
    end

    local tabs = {"Ball", "Player", "GK", "Settings"}
    local icons = {"⚽", "👤", "🧤", "⚙"}
    local buttons = {}
    for i, t in ipairs(tabs) do
        buttons[t] = makeSidebarButton(t, icons[i], i)
    end

    -- Content area
    local content = Instance.new("Frame", inner)
    content.Name = "Content"
    content.Size = UDim2.new(1, -170, 1, -93)  -- Adjusted for footer
    content.Position = UDim2.new(0, 170, 0, 63)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ZIndex = 2

    local function makeTabFrame(name)
        local f = Instance.new("ScrollingFrame", content)
        f.Name = name .. "_Tab"
        f.Size = UDim2.new(1, -16, 1, -16)
        f.Position = UDim2.new(0, 8, 0, 8)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.ScrollBarThickness = 6
        f.ScrollBarImageColor3 = Color3.fromRGB(70, 75, 210)
        f.CanvasSize = UDim2.new(0, 0, 0, 700)
        f.ZIndex = 3

        local layout = Instance.new("UIListLayout", f)
        layout.Padding = UDim.new(0, 12)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Left

        local padding = Instance.new("UIPadding", f)
        padding.PaddingLeft = UDim.new(0, 6)
        padding.PaddingRight = UDim.new(0, 6)
        padding.PaddingTop = UDim.new(0, 6)

        local sectionBg = Instance.new("Frame", f)
        sectionBg.Name = "SectionBackground"
        sectionBg.Size = UDim2.new(1, 0, 0, 60)
        sectionBg.Position = UDim2.new(0, 0, 0, 0)
        sectionBg.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
        sectionBg.BorderSizePixel = 0
        local sectionCorner = Instance.new("UICorner", sectionBg)
        sectionCorner.CornerRadius = UDim.new(0, 8)
        sectionBg.LayoutOrder = 0

        local lbl = Instance.new("TextLabel", f)
        lbl.Text = name
        lbl.Size = UDim2.new(1, -12, 0, 28)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(235, 235, 240)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 16
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LayoutOrder = 0

        return f
    end

    local tabFrames = {}
    for _, name in ipairs(tabs) do
        tabFrames[name] = makeTabFrame(name)
        tabFrames[name].Visible = false
    end
    tabFrames["Ball"].Visible = true

    -- Footer with credits
    local footer = Instance.new("Frame", inner)
    footer.Name = "Footer"
    footer.Size = UDim2.new(1, 0, 0, 30)
    footer.Position = UDim2.new(0, 0, 1, -30)
    footer.BackgroundTransparency = 1
    footer.BorderSizePixel = 0

    local credits = Instance.new("TextLabel", footer)
    credits.Size = UDim2.new(1, 0, 1, 0)
    credits.BackgroundTransparency = 1
    credits.Text = "Made by justice"
    credits.TextColor3 = Color3.fromRGB(150, 150, 160)
    credits.Font = Enum.Font.Gotham
    credits.TextSize = 12
    credits.TextXAlignment = Enum.TextXAlignment.Center
    credits.ZIndex = 3

    -- Toggle component (refined appearance)
    local function createToggle(parent, labelText, descText, initialState, callback)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(1, -12, 0, 70)
        container.BackgroundColor3 = Color3.fromRGB(23, 23, 25)
        container.BorderSizePixel = 0
        container.LayoutOrder = #parent:GetChildren()
        local containerCorner = Instance.new("UICorner", container)
        containerCorner.CornerRadius = UDim.new(0, 10)

        local left = Instance.new("Frame", container)
        left.Size = UDim2.new(0.72, 0, 1, 0)
        left.BackgroundTransparency = 1

        local lbl = Instance.new("TextLabel", left)
        lbl.Size = UDim2.new(1, 0, 0, 22)
        lbl.Position = UDim2.new(0, 12, 0, 8)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = Color3.fromRGB(235, 235, 240)
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextSize = 14
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local desc = Instance.new("TextLabel", left)
        desc.Size = UDim2.new(1, -12, 0, 18)
        desc.Position = UDim2.new(0, 12, 0, 30)
        desc.BackgroundTransparency = 1
        desc.Text = descText
        desc.TextColor3 = Color3.fromRGB(150, 150, 160)
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 12
        desc.TextXAlignment = Enum.TextXAlignment.Left

        local toggleBg = Instance.new("Frame", container)
        toggleBg.Size = UDim2.new(0, 56, 0, 28)
        toggleBg.Position = UDim2.new(1, -76, 0.5, -14)
        toggleBg.BackgroundColor3 = initialState and Color3.fromRGB(80, 180, 130) or Color3.fromRGB(90, 90, 100)
        toggleBg.BorderSizePixel = 0
        local toggleBgCorner = Instance.new("UICorner", toggleBg)
        toggleBgCorner.CornerRadius = UDim.new(1, 0)
        local toggleStroke = Instance.new("UIStroke", toggleBg)
        toggleStroke.Color = Color3.fromRGB(40, 40, 44)
        toggleStroke.Transparency = 0.8

        local toggleCircle = Instance.new("Frame", toggleBg)
        toggleCircle.Size = UDim2.new(0, 24, 0, 24)
        toggleCircle.Position = initialState and UDim2.new(1, -28, 0.5, -12) or UDim2.new(0, 4, 0.5, -12)
        toggleCircle.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
        toggleCircle.BorderSizePixel = 0
        local circleCorner = Instance.new("UICorner", toggleCircle)
        circleCorner.CornerRadius = UDim.new(1, 0)
        local circleShadow = Instance.new("UIStroke", toggleCircle)
        circleShadow.Color = Color3.fromRGB(200, 200, 200)
        circleShadow.Transparency = 0.9

        local toggle = Instance.new("TextButton", container)
        toggle.Size = UDim2.new(0, 56, 0, 28)
        toggle.Position = UDim2.new(1, -76, 0.5, -14)
        toggle.BackgroundTransparency = 1
        toggle.Text = ""

        local state = initialState
        toggle.MouseButton1Click:Connect(function()
            state = not state
            if state then
                tween(toggleBg, {BackgroundColor3 = Color3.fromRGB(80, 180, 130)}, 0.18)
                tween(toggleCircle, {Position = UDim2.new(1, -28, 0.5, -12)}, 0.18, Enum.EasingStyle.Back)
            else
                tween(toggleBg, {BackgroundColor3 = Color3.fromRGB(90, 90, 100)}, 0.18)
                tween(toggleCircle, {Position = UDim2.new(0, 4, 0.5, -12)}, 0.18, Enum.EasingStyle.Back)
            end
            if callback then
                callback(state)
            end
        end)
        return container
    end

    return {
        Root = frame,
        Shadow = shadow,
        Close = closeButton,
        Buttons = buttons,
        TabFrames = tabFrames,
        CreateToggle = createToggle
    }
end

local ui = createMain()

-- Opening animation
tween(ui.Shadow, {BackgroundTransparency = 0.85}, 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
tween(ui.Root, {Size = UDim2.new(0, 580, 0, 380), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local currentTab = "Ball"

local function switchTo(tabName)
    if tabName == currentTab then return end
    if not ui.TabFrames[tabName] then return end

    local oldFrame = ui.TabFrames[currentTab]
    local newFrame = ui.TabFrames[tabName]

    newFrame.Position = UDim2.new(1, 0, 0, 8)
    newFrame.Visible = true

    tween(newFrame, {Position = UDim2.new(0, 8, 0, 8)}, 0.25, Enum.EasingStyle.Quad)
    local oldTween = tween(oldFrame, {Position = UDim2.new(-1, 0, 0, 8)}, 0.25, Enum.EasingStyle.Quad)
    oldTween.Completed:Connect(function()
        oldFrame.Visible = false
        oldFrame.Position = UDim2.new(0, 8, 0, 8)
    end)

    -- Highlight active button
    for name, btn in pairs(ui.Buttons) do
        local indicator = btn:FindFirstChild("Frame")
        if indicator then
            if name == tabName then
                tween(indicator, {BackgroundTransparency = 0}, 0.2)
            else
                tween(indicator, {BackgroundTransparency = 1}, 0.2)
            end
        end
    end

    currentTab = tabName
end

for name, btn in pairs(ui.Buttons) do
    btn.MouseButton1Click:Connect(function()
        switchTo(name)
    end)
end

ui.Close.MouseButton1Click:Connect(function()
    -- Closing animation
    local closeTween = tween(ui.Root, {Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0.5, -5, 0.5, -5)}, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    tween(ui.Shadow, {BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    closeTween.Completed:Connect(function()
        if screengui and screengui.Parent then
            screengui:Destroy()
        end
    end)
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

-- REACH SYSTEM
local reachEnabled = false
local reachDist = 8
local MAX_REACH = 50
local reachVis = 0.6
local balls = {}  -- Cache balls

local reachBox
local reachConn
local lastBallScan = 0
local BALL_SCAN_RATE = 0.05  -- Increased frequency for better responsiveness

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
    reachBox.Color = Color3.fromRGB(70, 75, 210)
    reachBox.Material = Enum.Material.ForceField
    reachBox.Parent = workspace
end

local function fireTouch(ball, limb)
    pcall(function()
        firetouchinterest(ball, limb, 0)
        task.wait(0.01)  -- Adjusted wait for better reliability
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
                
                local now = tick()
                if now - lastBallScan < BALL_SCAN_RATE then return end
                lastBallScan = now
                
                -- Update ball cache
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj:IsA("Part") and obj:FindFirstChild("network") and not table.find(balls, obj) then
                        table.insert(balls, obj)
                    end
                end
                
                for i = #balls, 1, -1 do
                    local ball = balls[i]
                    if not ball or not ball.Parent then
                        table.remove(balls, i)
                    else
                        local dist = (ball.Position - root.Position).Magnitude
                        if dist <= reachDist then
                            for _, limb in ipairs(char:GetChildren()) do
                                if limb:IsA("BasePart") and (limb.Name:find("Arm") or limb.Name:find("Leg") or limb.Name:find("Torso")) then
                                    task.spawn(fireTouch, ball, limb)
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
        balls = {}
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
    trail.Color = ColorSequence.new(Color3.fromRGB(70, 75, 210))
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })
    trail.Lifetime = 2
    trail.MinLength = 0
    trail.WidthScale = NumberSequence.new(1)
    trail.Enabled = true
    
    table.insert(predictionParts, trail)
    table.insert(predictionParts, predictionAttachment)
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

local function createLandingMarker(position)
    local marker = Instance.new("Part")
    marker.Size = Vector3.new(2, 0.1, 2)
    marker.Position = position + Vector3.new(0, 0.1, 0)
    marker.Anchored = true
    marker.CanCollide = false
    marker.Transparency = 0.4
    marker.Color = Color3.fromRGB(255, 200, 50)
    marker.Material = Enum.Material.Neon
    marker.Parent = workspace
    
    local billboard = Instance.new("BillboardGui", marker)
    billboard.Size = UDim2.new(4, 0, 4, 0)
    billboard.Adornee = marker
    billboard.AlwaysOnTop = true
    
    local circle = Instance.new("ImageLabel", billboard)
    circle.Size = UDim2.new(1, 0, 1, 0)
    circle.BackgroundTransparency = 1
    circle.Image = "rbxassetid://12272370792"
    circle.ImageColor3 = Color3.fromRGB(255, 200, 50)
    circle.ImageTransparency = 0.3
    
    table.insert(predictionParts, marker)
    
    task.delay(2, function()
        if marker and marker.Parent then
            marker:Destroy()
        end
    end)
end

local function togglePrediction(state)
    predictionEnabled = state
    
    if predictionEnabled then
        if not predictionConn then
            predictionConn = RunService.Heartbeat:Connect(function()
                if not predictionEnabled then return end
                
                clearPrediction()
                
                for _, obj in ipairs(workspace:GetChildren()) do
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

-- SLIDER COMPONENT
local function makeSlider(parent, label, min, max, start, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -12, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    frame.BorderSizePixel = 0
    frame.LayoutOrder = #parent:GetChildren()
    local frameCorner = Instance.new("UICorner", frame)
    frameCorner.CornerRadius = UDim.new(0, 10)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.6, 0, 0, 22)
    lbl.Position = UDim2.new(0, 12, 0, 8)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(230, 230, 235)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local valueLbl = Instance.new("TextLabel", frame)
    valueLbl.Size = UDim2.new(0, 56, 0, 22)
    valueLbl.Position = UDim2.new(1, -68, 0, 8)
    valueLbl.BackgroundTransparency = 1
    valueLbl.Text = tostring(start)
    valueLbl.TextColor3 = Color3.fromRGB(70, 75, 210)
    valueLbl.Font = Enum.Font.GothamBold
    valueLbl.TextSize = 13
    valueLbl.TextXAlignment = Enum.TextXAlignment.Right

    local sliderBg = Instance.new("Frame", frame)
    sliderBg.Size = UDim2.new(1, -24, 0, 8)
    sliderBg.Position = UDim2.new(0, 12, 1, -20)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    sliderBg.BorderSizePixel = 0
    local sliderBgCorner = Instance.new("UICorner", sliderBg)
    sliderBgCorner.CornerRadius = UDim.new(1, 0)

    local sliderFill = Instance.new("Frame", sliderBg)
    sliderFill.Size = UDim2.new((start - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(70, 75, 210)
    sliderFill.BorderSizePixel = 0
    local fillCorner = Instance.new("UICorner", sliderFill)
    fillCorner.CornerRadius = UDim.new(1, 0)
    local fillGrad = Instance.new("UIGradient", sliderFill)
    fillGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 95, 230)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 45, 180))
    }

    local sliderBtn = Instance.new("TextButton", sliderBg)
    sliderBtn.Size = UDim2.new(0, 18, 0, 18)
    sliderBtn.Position = UDim2.new((start - min) / (max - min), -9, 0.5, -9)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
    sliderBtn.Text = ""
    sliderBtn.AutoButtonColor = false
    sliderBtn.BorderSizePixel = 0
    local btnCorner = Instance.new("UICorner", sliderBtn)
    btnCorner.CornerRadius = UDim.new(1, 0)
    local btnStroke = Instance.new("UIStroke", sliderBtn)
    btnStroke.Color = Color3.fromRGB(200, 200, 200)
    btnStroke.Transparency = 0.9

    local dragging = false
    local current = start

    local function update(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (pos * (max - min)) + 0.5)
        
        if value ~= current then
            current = value
            valueLbl.Text = tostring(value)
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            sliderBtn.Position = UDim2.new(pos, -9, 0.5, -9)
            if callback then callback(value) end
        end
    end

    sliderBtn.MouseButton1Down:Connect(function()
        dragging = true
        tween(sliderBtn, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(sliderBtn.Position.X.Scale, -10, 0.5, -10)}, 0.1)
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            tween(sliderBtn, {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(sliderBtn.Position.X.Scale, -9, 0.5, -9)}, 0.1)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input)
            tween(sliderBtn, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(sliderBtn.Position.X.Scale, -10, 0.5, -10)}, 0.1)
        end
    end)

    return frame
end

-- SETUP TABS
local ballTab = ui.TabFrames["Ball"]
local playerTab = ui.TabFrames["Player"]

if ballTab then
    ui.CreateToggle(ballTab, "Ball Prediction", "Shows trajectory and landing spot", false, togglePrediction)
end

if playerTab then
    ui.CreateToggle(playerTab, "Stamina", "Unlimited sprint", false, function(state)
        staminaEnabled = state
        if state then setupStamina() end
    end)
    
    ui.CreateToggle(playerTab, "Speed", "2x faster movement", false, toggleSpeed)
    
    ui.CreateToggle(playerTab, "Reach", "Extend touch range", false, toggleReach)
    
    makeSlider(playerTab, "Distance", 1, MAX_REACH, reachDist, function(v)
        reachDist = v
        updateReachBox()
    end)
    
    makeSlider(playerTab, "Visibility", 0, 100, reachVis * 100, function(v)
        reachVis = v / 100
        updateReachBox()
    end)
end

setupStamina()

-- Initial button highlight
switchTo("Ball")
