-- Services
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")


local LocalPlayer = Players.LocalPlayer


local screengui = Instance.new("ScreenGui")
screengui.Name = "solaris"
screengui.Parent = CoreGui
screengui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling


-- Global state variables for features
local staminaConn = nil
local staminaOn = false
local currentReach = 0 -- Default reach value


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
        btn.Name = text.."Btn"
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


    -- New enhanced slider creation
    local function createSlider(parent, labelText, descText, minValue, maxValue, initialValue, step, callback)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(1, -16, 0, 95)
        container.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
        container.BorderSizePixel = 0
        container.LayoutOrder = parent:FindFirstChildOfClass("UIListLayout") and #parent:GetChildren() or 1
        local containerCorner = Instance.new("UICorner", container)
        containerCorner.CornerRadius = UDim.new(0, 10)


        local current = initialValue
        
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


        local valueLabel = Instance.new("TextLabel", container)
        valueLabel.Size = UDim2.new(0.3, 0, 0, 22)
        valueLabel.Position = UDim2.new(1, -14 - valueLabel.Size.X.Offset, 0, 12)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = string.format("%.0f", current)
        valueLabel.TextColor3 = Color3.fromRGB(88, 101, 242)
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 16
        valueLabel.TextTransparency = 1
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right


        local sliderFrame = Instance.new("Frame", container)
        sliderFrame.Name = "SliderFrame"
        sliderFrame.Size = UDim2.new(1, -28, 0, 20)
        sliderFrame.Position = UDim2.new(0, 14, 0, 65)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
        sliderFrame.BorderSizePixel = 0
        local sliderCorner = Instance.new("UICorner", sliderFrame)
        sliderCorner.CornerRadius = UDim.new(1, 0)
        sliderFrame.BackgroundTransparency = 1
        
        local fill = Instance.new("Frame", sliderFrame)
        fill.Name = "Fill"
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        fill.BorderSizePixel = 0
        local fillCorner = Instance.new("UICorner", fill)
        fillCorner.CornerRadius = UDim.new(1, 0)
        fill.BackgroundTransparency = 1


        local button = Instance.new("ImageButton", sliderFrame)
        button.Name = "Handle"
        button.Size = UDim2.new(0, 20, 0, 20)
        button.BackgroundTransparency = 1
        button.Image = "rbxassetid://6283737568" -- A simple white circle, or any asset ID for a dot
        button.ImageColor3 = Color3.fromRGB(255, 255, 255)
        button.ZIndex = 2
        
        -- Initial fill and button position
        local initialPercent = (initialValue - minValue) / (maxValue - minValue)
        fill.Size = UDim2.new(initialPercent, 0, 1, 0)
        button.Position = UDim2.new(initialPercent, -10, 0, 0)

        local isDragging = false
        local maxRange = sliderFrame.AbsoluteSize.X
        
        local function updateSlider(input)
            local mouseX = input.Position.X
            local x = math.min(math.max(mouseX - sliderFrame.AbsolutePosition.X, 0), maxRange)
            local percent = x / maxRange
            
            local rawValue = (percent * (maxValue - minValue)) + minValue
            
            -- Snapping to step
            local snappedValue = math.round(rawValue / step) * step
            snappedValue = math.min(math.max(snappedValue, minValue), maxValue)
            
            current = snappedValue
            local currentPercent = (current - minValue) / (maxValue - minValue)

            -- Update UI
            fill.Size = UDim2.new(currentPercent, 0, 1, 0)
            button.Position = UDim2.new(currentPercent, -10, 0, 0)
            valueLabel.Text = string.format("%.0f", current)

            if callback then
                callback(current)
            end
        end

        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = true
                updateSlider(input)
            end
        end)

        button.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = false
            end
        end)
        
        local mouse = LocalPlayer:GetMouse()
        mouse.Move:Connect(function()
            if isDragging then
                updateSlider({Position = mouse.X, Y = mouse.Y})
            end
        end)
        
        -- Handle mouse down on slider frame directly
        sliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = true
                updateSlider(input)
            end
        end)

        -- Initial fade in for slider elements
        tween(sliderFrame, {BackgroundTransparency = 0}, 0.25)
        tween(fill, {BackgroundTransparency = 0}, 0.25)
        tween(button, {BackgroundTransparency = 0}, 0.25)
        
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
        CreateToggle = createToggle,
        CreateSlider = createSlider -- New slider creator
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


-- =========================
-- Reach Logic
-- =========================
local reachConn = nil
local originalReachValue = nil
local REACH_MAX = 1000


local function hookReach(newReachValue)
    local ok, reachScript = pcall(function()
        -- Attempt to find a common or game-specific "Reach" value/script, 
        -- often within PlayerScripts or the Character. 
        -- This path is speculative and depends heavily on the specific game.
        local scriptContainer = LocalPlayer:FindFirstChild("PlayerScripts") or LocalPlayer.Character
        if scriptContainer then
            -- Common name for a configuration or value object that controls reach
            return scriptContainer:FindFirstChild("ReachValue") or scriptContainer:FindFirstChild("Config"):FindFirstChild("Reach")
        end
    end)
    
    if ok and reachScript and (reachScript:IsA("NumberValue") or reachScript:IsA("IntValue")) then
        if not originalReachValue then
            originalReachValue = reachScript.Value -- Save the original value only once
        end

        if newReachValue > 0 then
            -- Apply the new reach value
            reachScript.Value = newReachValue
        else
            -- Reset to original value when feature is 'disabled' or set to 0
            if originalReachValue then
                reachScript.Value = originalReachValue
            end
            originalReachValue = nil -- Clear the saved original value
        end
    elseif newReachValue > 0 then
        -- Fallback or more "invasive" way if the value object isn't found, 
        -- but this is highly game-dependent and less likely to be effective.
        -- For a true exploit, one would hook remote function calls, 
        -- but that is outside the scope of simple property modification.
        warn("Could not find a standard 'ReachValue' object. Reach modification may fail.")
    end
    
    currentReach = newReachValue
end


-- Create Slider in Ball tab
local ballTab = ui.TabFrames["Ball"]
if ballTab then
    ui.CreateSlider(
        ballTab,
        "Ball Reach",
        string.format("Set the max range for ball interaction (0-%d)", REACH_MAX),
        0, -- Min Value
        REACH_MAX, -- Max Value (1000)
        0, -- Initial Value (0)
        5, -- Step (adjusts in increments of 5)
        function(value)
            hookReach(value)
        end
    )
end


-- Initialize hooks
hookStamina()
-- Note: The Reach hook is initialized by the slider's initial value (0)
-- but for robust initialization, we call it here to ensure the original value is saved if possible.
hookReach(currentReach)
