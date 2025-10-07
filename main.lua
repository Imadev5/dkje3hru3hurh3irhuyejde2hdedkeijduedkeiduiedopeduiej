-- Services
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Create the main ScreenGui parent
local screengui = Instance.new("ScreenGui")
screengui.Name = "solaris"
screengui.Parent = CoreGui
screengui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Helper tween function
local function tween(instance, props, time, style, dir)
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    local info = TweenService:Create(instance, TweenInfo.new(time, style, dir), props)
    info:Play()
    return info
end

-- Main function to construct the UI
local function createMain()
    local frame = Instance.new("Frame")
    frame.Parent = screengui
    frame.Name = "solaris_hub"
    frame.Size = UDim2.new(0, 560, 0, 480) -- Increased height for new elements
    frame.Position = UDim2.new(0.5, -280, 0.5, -240) -- Centered
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.ZIndex = 1
    frame.BackgroundTransparency = 1

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 12)

    -- Shadow effect
    local shadow = Instance.new("ImageLabel", frame)
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ZIndex = 0

    local header = Instance.new("Frame", frame)
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 42)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    header.BorderSizePixel = 0
    header.BackgroundTransparency = 1
    local headerCorner = Instance.new("UICorner", header)
    headerCorner.CornerRadius = UDim.new(0, 12)

    -- Accent line under header
    local accentLine = Instance.new("Frame", header)
    accentLine.Name = "AccentLine"
    accentLine.Size = UDim2.new(1, 0, 0, 2)
    accentLine.Position = UDim2.new(0, 0, 1, -2)
    accentLine.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    accentLine.BorderSizePixel = 0
    accentLine.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -90, 1, 0)
    title.Position = UDim2.new(0, 16, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ Solaris Hub"
    title.TextColor3 = Color3.fromRGB(240, 240, 245)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 19
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextTransparency = 1

    local closeButton = Instance.new("TextButton", header)
    closeButton.Size = UDim2.new(0, 32, 0, 28)
    closeButton.Position = UDim2.new(1, -42, 0, 7)
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255,255,255)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 16
    closeButton.AutoButtonColor = false
    closeButton.Name = "CloseButton"
    closeButton.BorderSizePixel = 0
    closeButton.TextTransparency = 1
    closeButton.BackgroundTransparency = 1
    local closeCorner = Instance.new("UICorner", closeButton)
    closeCorner.CornerRadius = UDim.new(0, 7)

    -- Close button hover effect
    closeButton.MouseEnter:Connect(function()
        tween(closeButton, {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}, 0.15)
    end)
    closeButton.MouseLeave:Connect(function()
        tween(closeButton, {BackgroundColor3 = Color3.fromRGB(220, 60, 60)}, 0.15)
    end)

    -- Sidebar
    local sidebar = Instance.new("Frame", frame)
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 150, 1, -42)
    sidebar.Position = UDim2.new(0, 0, 0, 42)
    sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    sidebar.BorderSizePixel = 0
    sidebar.BackgroundTransparency = 1

    local sbCorner = Instance.new("UICorner", sidebar)
    sbCorner.CornerRadius = UDim.new(0, 10)

    local sbLayout = Instance.new("UIListLayout", sidebar)
    sbLayout.Padding = UDim.new(0, 8)
    sbLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sbLayout.FillDirection = Enum.FillDirection.Vertical
    sbLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    sbLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local sbPadding = Instance.new("UIPadding", sidebar)
    sbPadding.PaddingTop = UDim.new(0, 12)
    sbPadding.PaddingBottom = UDim.new(0, 12)

    local function makeSidebarButton(text, icon, order)
        local btn = Instance.new("TextButton", sidebar)
        btn.Name = text
        btn.Size = UDim2.new(1, -20, 0, 44)
        btn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Text = icon .. " " .. text
        btn.TextColor3 = Color3.fromRGB(200, 200, 210)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 15
        btn.LayoutOrder = order
        btn.TextTransparency = 1
        btn.ClipsDescendants = true
        local c = Instance.new("UICorner", btn)
        c.CornerRadius = UDim.new(0, 8)

        local glow = Instance.new("Frame", btn)
        glow.Name = "Glow"
        glow.Size = UDim2.new(0, 4, 1, 0)
        glow.Position = UDim2.new(0, 0, 0, 0)
        glow.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        glow.BorderSizePixel = 0
        glow.BackgroundTransparency = 1
        local glowCorner = Instance.new("UICorner", glow)
        glowCorner.CornerRadius = UDim.new(1, 0)

        btn.MouseEnter:Connect(function()
            tween(btn, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
            tween(glow, {BackgroundTransparency = 0}, 0.2)
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, {BackgroundColor3 = Color3.fromRGB(28, 28, 32)}, 0.2)
            tween(glow, {BackgroundTransparency = 1}, 0.2)
        end)

        return btn
    end

    local tabs = {"Ball", "Player", "GK", "Settings"}
    local icons = {"⚽", "👤", "🧤", "⚙️"}
    local buttons = {}
    for i, t in ipairs(tabs) do
        buttons[t] = makeSidebarButton(t, icons[i], i)
    end

    -- Content area
    local content = Instance.new("Frame", frame)
    content.Name = "Content"
    content.Size = UDim2.new(1, -150, 1, -42)
    content.Position = UDim2.new(0, 150, 0, 42)
    content.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
    content.BorderSizePixel = 0
    content.BackgroundTransparency = 1

    local contentCorner = Instance.new("UICorner", content)
    contentCorner.CornerRadius = UDim.new(0, 10)

    local function makeTabFrame(name)
        local f = Instance.new("ScrollingFrame", content)
        f.Name = name .. "_Tab"
        f.Size = UDim2.new(1, -20, 1, -20)
        f.Position = UDim2.new(0, 10, 0, 10)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.ScrollBarThickness = 6
        f.ScrollBarImageColor3 = Color3.fromRGB(88, 101, 242)
        f.CanvasSize = UDim2.new(0, 0, 2, 0) -- Increased canvas size

        local layout = Instance.new("UIListLayout", f)
        layout.Padding = UDim.new(0, 12)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Left

        local padding = Instance.new("UIPadding", f)
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        padding.PaddingTop = UDim.new(0, 8)

        local lbl = Instance.new("TextLabel", f)
        lbl.Text = name .. " Features"
        lbl.Size = UDim2.new(1, -16, 0, 35)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(240, 240, 245)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 18
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextTransparency = 1
        lbl.LayoutOrder = 0

        return f
    end

    local tabFrames = {}
    for _, name in ipairs(tabs) do
        tabFrames[name] = makeTabFrame(name)
        tabFrames[name].Visible = false
    end
    local currentTab = "Ball"
    tabFrames[currentTab].Visible = true

    -- Enhanced toggle creation
    local function createToggle(parent, labelText, descText, initialState, callback)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(1, -16, 0, 68)
        container.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
        container.BorderSizePixel = 0
        container.LayoutOrder = parent:FindFirstChildOfClass("UIListLayout") and #parent:GetChildren() or 1
        local containerCorner = Instance.new("UICorner", container)
        containerCorner.CornerRadius = UDim.new(0, 10)

        local lbl = Instance.new("TextLabel", container)
        lbl.Size = UDim2.new(0.6, 0, 0, 22)
        lbl.Position = UDim2.new(0, 14, 0, 12)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = Color3.fromRGB(240, 240, 245)
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextSize = 16
        lbl.TextTransparency = 1
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local desc = Instance.new("TextLabel", container)
        desc.Size = UDim2.new(0.6, 0, 0, 18)
        desc.Position = UDim2.new(0, 14, 0, 36)
        desc.BackgroundTransparency = 1
        desc.Text = descText
        desc.TextColor3 = Color3.fromRGB(150, 150, 160)
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 13
        desc.TextTransparency = 1
        desc.TextXAlignment = Enum.TextXAlignment.Left

        local toggleBg = Instance.new("Frame", container)
        toggleBg.Size = UDim2.new(0, 54, 0, 28)
        toggleBg.Position = UDim2.new(1, -68, 0.5, -14)
        toggleBg.BackgroundColor3 = initialState and Color3.fromRGB(67, 181, 129) or Color3.fromRGB(120, 120, 130)
        toggleBg.BorderSizePixel = 0
        toggleBg.BackgroundTransparency = 1
        local toggleBgCorner = Instance.new("UICorner", toggleBg)
        toggleBgCorner.CornerRadius = UDim.new(1, 0)

        local toggleCircle = Instance.new("Frame", toggleBg)
        toggleCircle.Size = UDim2.new(0, 22, 0, 22)
        toggleCircle.Position = initialState and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
        toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleCircle.BorderSizePixel = 0
        toggleCircle.BackgroundTransparency = 1
        local circleCorner = Instance.new("UICorner", toggleCircle)
        circleCorner.CornerRadius = UDim.new(1, 0)

        local toggle = Instance.new("TextButton", container)
        toggle.Size = UDim2.new(0, 54, 0, 28)
        toggle.Position = UDim2.new(1, -68, 0.5, -14)
        toggle.BackgroundTransparency = 1
        toggle.Text = ""
        toggle.AutoButtonColor = false

        local state = initialState
        toggle.MouseButton1Click:Connect(function()
            state = not state
            
            if state then
                tween(toggleBg, {BackgroundColor3 = Color3.fromRGB(67, 181, 129)}, 0.25, Enum.EasingStyle.Quad)
                tween(toggleCircle, {Position = UDim2.new(1, -25, 0.5, -11)}, 0.25, Enum.EasingStyle.Back)
            else
                tween(toggleBg, {BackgroundColor3 = Color3.fromRGB(120, 120, 130)}, 0.25, Enum.EasingStyle.Quad)
                tween(toggleCircle, {Position = UDim2.new(0, 3, 0.5, -11)}, 0.25, Enum.EasingStyle.Back)
            end
            
            if callback then
                callback(state)
            end
        end)

        return container
    end

    -- Slider creation function
    local function createSlider(parent, labelText, descText, min, max, initial, callback)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(1, -16, 0, 80)
        container.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
        container.BorderSizePixel = 0
        container.LayoutOrder = parent:FindFirstChildOfClass("UIListLayout") and #parent:GetChildren() or 1
        local containerCorner = Instance.new("UICorner", container)
        containerCorner.CornerRadius = UDim.new(0, 10)

        local lbl = Instance.new("TextLabel", container)
        lbl.Size = UDim2.new(0.6, 0, 0, 22)
        lbl.Position = UDim2.new(0, 14, 0, 12)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = Color3.fromRGB(240, 240, 245)
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextSize = 16
        lbl.TextTransparency = 1
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local desc = Instance.new("TextLabel", container)
        desc.Size = UDim2.new(1, -150, 0, 18)
        desc.Position = UDim2.new(0, 14, 0, 54)
        desc.BackgroundTransparency = 1
        desc.Text = descText
        desc.TextColor3 = Color3.fromRGB(150, 150, 160)
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 13
        desc.TextTransparency = 1
        desc.TextXAlignment = Enum.TextXAlignment.Left

        local valueLabel = Instance.new("TextLabel", container)
        valueLabel.Size = UDim2.new(0, 100, 0, 22)
        valueLabel.Position = UDim2.new(1, -114, 0, 12)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(initial)
        valueLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
        valueLabel.Font = Enum.Font.GothamSemibold
        valueLabel.TextSize = 16
        valueLabel.TextTransparency = 1
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right

        local track = Instance.new("Frame", container)
        track.Size = UDim2.new(1, -28, 0, 6)
        track.Position = UDim2.new(0, 14, 0, 40)
        track.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        track.BorderSizePixel = 0
        local trackCorner = Instance.new("UICorner", track)
        trackCorner.CornerRadius = UDim.new(1, 0)
        
        local fill = Instance.new("Frame", track)
        fill.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        fill.BorderSizePixel = 0
        local fillCorner = Instance.new("UICorner", fill)
        fillCorner.CornerRadius = UDim.new(1, 0)

        local thumb = Instance.new("Frame", track)
        thumb.Size = UDim2.new(0, 18, 0, 18)
        thumb.Position = UDim2.new(0, -9, 0.5, -9)
        thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        thumb.BorderSizePixel = 0
        local thumbCorner = Instance.new("UICorner", thumb)
        thumbCorner.CornerRadius = UDim.new(1, 0)

        local dragger = Instance.new("TextButton", track)
        dragger.Size = UDim2.new(1, 18, 1, 18)
        dragger.Position = UDim2.new(0, -9, 0, -9)
        dragger.BackgroundTransparency = 1
        dragger.Text = ""

        local function updateSlider(value)
            local percentage = (value - min) / (max - min)
            percentage = math.clamp(percentage, 0, 1)
            fill.Size = UDim2.new(percentage, 0, 1, 0)
            thumb.Position = UDim2.new(percentage, -9, 0.5, -9)
            valueLabel.Text = string.format("%.1f", value)
            if callback then
                callback(value)
            end
        end

        local dragging = false
        dragger.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)
        dragger.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local mouseX = input.Position.X
                local trackStart = track.AbsolutePosition.X
                local trackWidth = track.AbsoluteSize.X
                local percentage = (mouseX - trackStart) / trackWidth
                percentage = math.clamp(percentage, 0, 1)
                local value = min + (max - min) * percentage
                updateSlider(value)
            end
        end)
        
        updateSlider(initial)
        return container
    end

    return {
        Root = frame,
        Close = closeButton,
        Buttons = buttons,
        TabFrames = tabFrames,
        CreateToggle = createToggle,
        CreateSlider = createSlider
    }
end

local ui = createMain()

local function fadeDescendants(root, targetTransparency, time)
    for _, v in pairs(root:GetDescendants()) do
        if v:IsA("GuiObject") then
            local prop = nil
            if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                prop = "TextTransparency"
            elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
                prop = "ImageTransparency"
            elseif v:IsA("Frame") or v:IsA("ScrollingFrame") then
                prop = "BackgroundTransparency"
            end
            if prop then
                tween(v, {[prop] = targetTransparency}, time)
            end
        end
    end
    if root:IsA("Frame") then
        tween(root, {BackgroundTransparency = targetTransparency}, time)
    end
end

-- Fade in with smooth animation
fadeDescendants(ui.Root, 1, 0)
tween(ui.Root, {Size = UDim2.new(0, 520, 0, 440)}, 0)
task.delay(0.05, function()
    fadeDescendants(ui.Root, 0, 0.4)
    tween(ui.Root, {Size = UDim2.new(0, 560, 0, 480)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)

-- Tab switching
local currentTabName = "Ball"
local function switchTo(tabName)
    if not ui.TabFrames[tabName] or currentTabName == tabName then return end

    local outFrame = ui.TabFrames[currentTabName]
    local inFrame = ui.TabFrames[tabName]

    fadeDescendants(outFrame, 1, 0.2)
    task.delay(0.2, function()
        outFrame.Visible = false
        inFrame.Visible = true
        fadeDescendants(inFrame, 1, 0) -- Set to transparent instantly
        task.delay(0.02, function()
            fadeDescendants(inFrame, 0, 0.25) -- Fade in
        end)
    end)
    currentTabName = tabName
end

-- Hook up sidebar buttons
for name, btn in pairs(ui.Buttons) do
    btn.MouseButton1Click:Connect(function()
        switchTo(btn.Name)
    end)
end

-- Close with animation
ui.Close.MouseButton1Click:Connect(function()
    fadeDescendants(ui.Root, 1, 0.3)
    tween(ui.Root, {Size = UDim2.new(0, 520, 0, 440)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.delay(0.32, function()
        if screengui and screengui.Parent then
            screengui:Destroy()
        end
    end)
end)

-- ===============================================
-- SCRIPT LOGIC AND FEATURES
-- ===============================================

local playerTab = ui.TabFrames["Player"]
if not playerTab then
    warn("Player tab not found! Cannot add features.")
    return
end

-- =========================
-- Infinite Stamina Logic
-- =========================
local staminaConn
local staminaOn = false

local function hookStamina()
    if staminaConn then
        staminaConn:Disconnect()
        staminaConn = nil
    end
    local ok, stamina = pcall(function()
        return LocalPlayer:WaitForChild("PlayerScripts")
            :WaitForChild("controllers"):WaitForChild("movementController")
            :WaitForChild("stamina")
    end)
    if ok and stamina then
        staminaConn = RunService.Heartbeat:Connect(function()
            if staminaOn then
                pcall(function() stamina.Value = 100 end)
            end
        end)
    end
end

ui.CreateToggle(playerTab, "Infinite Stamina", "Never run out of stamina while playing", false, function(state)
    staminaOn = state
    if staminaOn then
        hookStamina()
    else
        if staminaConn then
            staminaConn:Disconnect()
            staminaConn = nil
        end
    end
end)

-- [[ THE FIX IS HERE ]]
-- The original script froze because it was waiting for the stamina object to load.
-- By wrapping hookStamina() in task.spawn, we run it in a separate thread.
-- This allows the UI animations to run immediately without getting the script stuck.
task.spawn(hookStamina)


-- =========================
-- Reach Feature Logic
-- =========================
local reachOn = false
local reachDist = 5.0
local reachVisual = nil
local reachConn = nil
local currentBall = nil

pcall(function()
    if getgc and hookfunction then
        for _, v in ipairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "overlapCheck") and rawget(v, "gkCheck") and isfunction(v.overlapCheck) and isfunction(v.gkCheck) then
                hookfunction(v.overlapCheck, function() return true end)
                hookfunction(v.gkCheck, function() return true end)
            end
        end
    end
end)

local function fireTouch(ball, limb)
    if firetouchinterest then
        pcall(firetouchinterest, ball, limb, 0)
        task.wait(0.03)
        pcall(firetouchinterest, ball, limb, 1)
    end
end

local function startReachLoop()
    if reachConn then return end
    reachConn = RunService.Heartbeat:Connect(function()
        if not reachOn then return end
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        if not currentBall or not currentBall.Parent then
            currentBall = nil
            for _, v in ipairs(workspace:GetChildren()) do
                if v:IsA("Part") and v:FindFirstChild("network") then
                    currentBall = v
                    break
                end
            end
        end
        if not currentBall then return end
        if (currentBall.Position - root.Position).Magnitude <= reachDist then
            for _, limb in ipairs(char:GetChildren()) do
                if limb:IsA("BasePart") then
                    task.spawn(fireTouch, currentBall, limb)
                end
            end
        end
    end)
end

local function manageReachVisual()
    local char = LocalPlayer.Character
    if not char then return end
    if not reachVisual or not reachVisual.Parent then
        reachVisual = Instance.new("Part")
        reachVisual.Name = "ReachVisualizer"
        reachVisual.Shape = Enum.PartType.Ball
        reachVisual.Material = Enum.Material.ForceField
        reachVisual.Color = Color3.fromRGB(88, 101, 242)
        reachVisual.Anchored = false
        reachVisual.CanCollide = false
        reachVisual.CanTouch = false
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = char:WaitForChild("HumanoidRootPart")
        weld.Part1 = reachVisual
        weld.Parent = reachVisual
        reachVisual.Parent = char
    end
    reachVisual.Size = Vector3.new(reachDist * 2, reachDist * 2, reachDist * 2)
end

ui.CreateToggle(playerTab, "Enable Reach", "Automatically touch the ball from a distance", false, function(state)
    reachOn = state
    if reachOn then
        manageReachVisual()
        startReachLoop()
        if reachVisual then
             reachVisual.Transparency = 0.5
        end 
    else
        if reachVisual then reachVisual.Transparency = 1 end
    end
end)

ui.CreateSlider(playerTab, "Reach Distance", "How far the reach extends (in studs)", 1, 30, 5, function(value)
    reachDist = value
    if reachOn and reachVisual then
        reachVisual.Size = Vector3.new(reachDist * 2, reachDist * 2, reachDist * 2)
    end
end)

ui.CreateSlider(playerTab, "Visualizer Transparency", "Controls the visibility of the reach sphere", 0, 1, 0.5, function(value)
    if reachVisual then
        reachVisual.Transparency = 1 - value
    end
end)
