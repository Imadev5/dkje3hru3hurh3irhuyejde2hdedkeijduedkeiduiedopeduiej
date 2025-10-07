-- Services
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Clean up old instances
if CoreGui:FindFirstChild("solaris") then
    CoreGui:FindFirstChild("solaris"):Destroy()
end

local screengui = Instance.new("ScreenGui")
screengui.Name = "solaris"
screengui.ResetOnSpawn = false
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

local function createMain()
    local frame = Instance.new("Frame")
    frame.Parent = screengui
    frame.Name = "solaris_hub"
    frame.Size = UDim2.new(0, 560, 0, 360)
    frame.Position = UDim2.new(0.5, -280, 0.5, -180)
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
    title.Text = "Solaris Hub"
    title.TextColor3 = Color3.fromRGB(240, 240, 245)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 19
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextTransparency = 1

    local closeButton = Instance.new("TextButton", header)
    closeButton.Size = UDim2.new(0, 32, 0, 28)
    closeButton.Position = UDim2.new(1, -42, 0, 7)
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255,255,255)
    closeButton.Font = Enum.Font.SourceSansBold
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
        btn.Name = text.."Btn"
        btn.Size = UDim2.new(1, -20, 0, 44)
        btn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(200, 200, 210)
        btn.Font = Enum.Font.SourceSansSemibold
        btn.TextSize = 15
        btn.LayoutOrder = order
        btn.TextTransparency = 1
        btn.ClipsDescendants = true
        local c = Instance.new("UICorner", btn)
        c.CornerRadius = UDim.new(0, 8)

        -- Hover glow effect
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
    local buttons = {}
    for i, t in ipairs(tabs) do
        buttons[t] = makeSidebarButton(t, "", i)
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
        f.CanvasSize = UDim2.new(0, 0, 0, 400)

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
        lbl.Font = Enum.Font.SourceSansBold
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
        lbl.Font = Enum.Font.SourceSansSemibold
        lbl.TextSize = 16
        lbl.TextTransparency = 1
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local desc = Instance.new("TextLabel", container)
        desc.Size = UDim2.new(0.6, 0, 0, 18)
        desc.Position = UDim2.new(0, 14, 0, 36)
        desc.BackgroundTransparency = 1
        desc.Text = descText
        desc.TextColor3 = Color3.fromRGB(150, 150, 160)
        desc.Font = Enum.Font.SourceSans
        desc.TextSize = 13
        desc.TextTransparency = 1
        desc.TextXAlignment = Enum.TextXAlignment.Left

        -- Toggle switch background
        local toggleBg = Instance.new("Frame", container)
        toggleBg.Size = UDim2.new(0, 54, 0, 28)
        toggleBg.Position = UDim2.new(1, -68, 0.5, -14)
        toggleBg.BackgroundColor3 = initialState and Color3.fromRGB(67, 181, 129) or Color3.fromRGB(120, 120, 130)
        toggleBg.BorderSizePixel = 0
        toggleBg.BackgroundTransparency = 1
        local toggleBgCorner = Instance.new("UICorner", toggleBg)
        toggleBgCorner.CornerRadius = UDim.new(1, 0)

        -- Toggle circle
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
            
            -- Animate toggle
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

    return {
        Root = frame,
        Close = closeButton,
        Buttons = buttons,
        TabFrames = tabFrames,
        Title = title,
        Sidebar = sidebar,
        Content = content,
        AccentLine = accentLine,
        CreateToggle = createToggle
    }
end

local ui = createMain()

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
            tween(obj, {TextTransparency = targetTransparency}, time)
        elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
            tween(obj, {ImageTransparency = targetTransparency}, time)
        elseif obj:IsA("Frame") then
            tween(obj, {BackgroundTransparency = targetTransparency}, time)
        end
    end
end

-- Fade in with smooth animation
fadeDescendants(ui.Root, 1, 0)
tween(ui.Root, {Size = UDim2.new(0, 520, 0, 320)}, 0)
task.delay(0.05, function()
    fadeDescendants(ui.Root, 0, 0.4)
    tween(ui.Root, {Size = UDim2.new(0, 560, 0, 360)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)

-- Tab switching
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
                tween(v, {TextTransparency = 1}, 0.2)
            elseif v:IsA("Frame") then
                tween(v, {BackgroundTransparency = 1}, 0.2)
            end
        end
        task.delay(0.2, function()
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

-- Hook up sidebar buttons
for name, btn in pairs(ui.Buttons) do
    btn.MouseButton1Click:Connect(function()
        tween(btn, {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}, 0.15)
        task.delay(0.2, function()
            tween(btn, {BackgroundColor3 = Color3.fromRGB(28, 28, 32)}, 0.2)
        end)
        switchTo(name)
    end)
end

-- Close with animation
ui.Close.MouseButton1Click:Connect(function()
    fadeDescendants(ui.Root, 1, 0.3)
    tween(ui.Root, {Size = UDim2.new(0, 520, 0, 320)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.delay(0.32, function()
        if screengui and screengui.Parent then
            screengui:Destroy()
        end
    end)
end)

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

-- Create toggle in Player tab
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

-- Initialize stamina hook
hookStamina()

-- =========================
-- Ball Tab - External Script Loader
-- =========================
local ballTab = ui.TabFrames["Ball"]
if ballTab then
    -- Create button to load external script
    local loadScriptContainer = Instance.new("Frame", ballTab)
    loadScriptContainer.Size = UDim2.new(1, -16, 0, 85)
    loadScriptContainer.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
    loadScriptContainer.BorderSizePixel = 0
    loadScriptContainer.LayoutOrder = 1
    local loadScriptCorner = Instance.new("UICorner", loadScriptContainer)
    loadScriptCorner.CornerRadius = UDim.new(0, 10)

    local loadScriptTitle = Instance.new("TextLabel", loadScriptContainer)
    loadScriptTitle.Size = UDim2.new(1, -20, 0, 22)
    loadScriptTitle.Position = UDim2.new(0, 14, 0, 12)
    loadScriptTitle.BackgroundTransparency = 1
    loadScriptTitle.Text = "Ball Script Loader"
    loadScriptTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
    loadScriptTitle.Font = Enum.Font.SourceSansSemibold
    loadScriptTitle.TextSize = 16
    loadScriptTitle.TextXAlignment = Enum.TextXAlignment.Left

    local loadScriptDesc = Instance.new("TextLabel", loadScriptContainer)
    loadScriptDesc.Size = UDim2.new(1, -20, 0, 18)
    loadScriptDesc.Position = UDim2.new(0, 14, 0, 36)
    loadScriptDesc.BackgroundTransparency = 1
    loadScriptDesc.Text = "Load external ball modification script"
    loadScriptDesc.TextColor3 = Color3.fromRGB(150, 150, 160)
    loadScriptDesc.Font = Enum.Font.SourceSans
    loadScriptDesc.TextSize = 13
    loadScriptDesc.TextXAlignment = Enum.TextXAlignment.Left

    local loadButton = Instance.new("TextButton", loadScriptContainer)
    loadButton.Size = UDim2.new(0, 100, 0, 32)
    loadButton.Position = UDim2.new(0, 14, 1, -42)
    loadButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    loadButton.Text = "Load Script"
    loadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadButton.Font = Enum.Font.SourceSansBold
    loadButton.TextSize = 14
    loadButton.BorderSizePixel = 0
    loadButton.AutoButtonColor = false
    local loadButtonCorner = Instance.new("UICorner", loadButton)
    loadButtonCorner.CornerRadius = UDim.new(0, 8)

    -- Status indicator
    local statusLabel = Instance.new("TextLabel", loadScriptContainer)
    statusLabel.Size = UDim2.new(1, -130, 0, 32)
    statusLabel.Position = UDim2.new(0, 120, 1, -42)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Ready to load"
    statusLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.TextSize = 13
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Button hover effect
    loadButton.MouseEnter:Connect(function()
        tween(loadButton, {BackgroundColor3 = Color3.fromRGB(98, 111, 252)}, 0.2)
    end)
    loadButton.MouseLeave:Connect(function()
        tween(loadButton, {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}, 0.2)
    end)

    -- Load script when clicked
    loadButton.MouseButton1Click:Connect(function()
        -- Button press effect
        tween(loadButton, {BackgroundColor3 = Color3.fromRGB(78, 91, 232)}, 0.1)
        task.delay(0.15, function()
            tween(loadButton, {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}, 0.15)
        end)

        statusLabel.Text = "Loading script..."
        statusLabel.TextColor3 = Color3.fromRGB(88, 101, 242)

        -- Load the external script
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Imadev5/dkje3hru3hurh3irhuyejde2hdedkeijduedkeiduiedopeduiej/refs/heads/main/main.lua"))()
        end)

        if success then
            statusLabel.Text = "Script loaded successfully!"
            statusLabel.TextColor3 = Color3.fromRGB(67, 181, 129)
            task.delay(3, function()
                statusLabel.Text = "Ready to load"
                statusLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
            end)
        else
            statusLabel.Text = "Failed to load script"
            statusLabel.TextColor3 = Color3.fromRGB(220, 60, 60)
            warn("Script loading error:", err)
            task.delay(3, function()
                statusLabel.Text = "Ready to load"
                statusLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
            end)
        end
    end)
end
