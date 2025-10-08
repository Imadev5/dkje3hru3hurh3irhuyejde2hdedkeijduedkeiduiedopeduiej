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
	local frame = Instance.new("Frame")
	frame.Parent = screengui
	frame.Name = "solaris_hub"
	frame.Size = UDim2.new(0, 580, 0, 380)
	frame.Position = UDim2.new(0.5, -290, 0.5, -190)
	frame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.Draggable = true
	frame.ZIndex = 1

	local corner = Instance.new("UICorner", frame)
	corner.CornerRadius = UDim.new(0, 8)

	local header = Instance.new("Frame", frame)
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 38)
	header.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
	header.BorderSizePixel = 0
	local headerCorner = Instance.new("UICorner", header)
	headerCorner.CornerRadius = UDim.new(0, 8)

	local headerBlock = Instance.new("Frame", header)
	headerBlock.Size = UDim2.new(1, 0, 0, 8)
	headerBlock.Position = UDim2.new(0, 0, 1, -8)
	headerBlock.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
	headerBlock.BorderSizePixel = 0

	local accentLine = Instance.new("Frame", header)
	accentLine.Size = UDim2.new(1, 0, 0, 1)
	accentLine.Position = UDim2.new(0, 0, 1, 0)
	accentLine.BackgroundColor3 = Color3.fromRGB(70, 75, 210)
	accentLine.BorderSizePixel = 0

	local title = Instance.new("TextLabel", header)
	title.Size = UDim2.new(1, -90, 1, 0)
	title.Position = UDim2.new(0, 14, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "Solaris"
	title.TextColor3 = Color3.fromRGB(230, 230, 235)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 16
	title.TextXAlignment = Enum.TextXAlignment.Left

	local closeButton = Instance.new("TextButton", header)
	closeButton.Size = UDim2.new(0, 28, 0, 24)
	closeButton.Position = UDim2.new(1, -36, 0.5, -12)
	closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	closeButton.Text = "×"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.Font = Enum.Font.GothamBold
	closeButton.TextSize = 18
	closeButton.AutoButtonColor = false
	closeButton.BorderSizePixel = 0
	local closeCorner = Instance.new("UICorner", closeButton)
	closeCorner.CornerRadius = UDim.new(0, 4)

	closeButton.MouseEnter:Connect(function()
		tween(closeButton, {BackgroundColor3 = Color3.fromRGB(230, 60, 60)}, 0.15)
	end)
	closeButton.MouseLeave:Connect(function()
		tween(closeButton, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.15)
	end)

	local sidebar = Instance.new("Frame", frame)
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, 140, 1, -38)
	sidebar.Position = UDim2.new(0, 0, 0, 38)
	sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
	sidebar.BorderSizePixel = 0

	local sbLayout = Instance.new("UIListLayout", sidebar)
	sbLayout.Padding = UDim.new(0, 6)
	sbLayout.SortOrder = Enum.SortOrder.LayoutOrder
	sbLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local sbPadding = Instance.new("UIPadding", sidebar)
	sbPadding.PaddingTop = UDim.new(0, 10)
	sbPadding.PaddingBottom = UDim.new(0, 10)

	local function makeSidebarButton(text, icon, order)
		local btn = Instance.new("TextButton", sidebar)
		btn.Name = text .. "Btn"
		btn.Size = UDim2.new(1, -16, 0, 36)
		btn.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
		btn.BorderSizePixel = 0
		btn.AutoButtonColor = false
		btn.Text = icon .. "  " .. text
		btn.TextColor3 = Color3.fromRGB(180, 180, 190)
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 14
		btn.LayoutOrder = order
		btn.ClipsDescendants = true
		local c = Instance.new("UICorner", btn)
		c.CornerRadius = UDim.new(0, 6)

		local indicator = Instance.new("Frame", btn)
		indicator.Size = UDim2.new(0, 3, 1, 0)
		indicator.BackgroundColor3 = Color3.fromRGB(70, 75, 210)
		indicator.BorderSizePixel = 0
		indicator.BackgroundTransparency = 1

		btn.MouseEnter:Connect(function()
			tween(btn, {BackgroundColor3 = Color3.fromRGB(28, 28, 32)}, 0.2)
		end)
		btn.MouseLeave:Connect(function()
			tween(btn, {BackgroundColor3 = Color3.fromRGB(22, 22, 24)}, 0.2)
		end)
		return btn
	end

	local tabs = {"Ball", "Player", "GK", "Settings"}
	local icons = {"⚽", "👤", "🧤", "⚙"}
	local buttons = {}
	for i, t in ipairs(tabs) do
		buttons[t] = makeSidebarButton(t, icons[i], i)
	end

	local content = Instance.new("Frame", frame)
	content.Name = "Content"
	content.Size = UDim2.new(1, -140, 1, -38)
	content.Position = UDim2.new(0, 140, 0, 38)
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0

	local function makeTabFrame(name)
		local f = Instance.new("ScrollingFrame", content)
		f.Name = name .. "_Tab"
		f.Size = UDim2.new(1, -16, 1, -16)
		f.Position = UDim2.new(0, 8, 0, 8)
		f.BackgroundTransparency = 1
		f.BorderSizePixel = 0
		f.ScrollBarThickness = 4
		f.ScrollBarImageColor3 = Color3.fromRGB(70, 75, 210)
		f.CanvasSize = UDim2.new(0, 0, 0, 700)

		local layout = Instance.new("UIListLayout", f)
		layout.Padding = UDim.new(0, 10)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Left

		local padding = Instance.new("UIPadding", f)
		padding.PaddingLeft = UDim.new(0, 6)
		padding.PaddingRight = UDim.new(0, 6)
		padding.PaddingTop = UDim.new(0, 6)

		local lbl = Instance.new("TextLabel", f)
		lbl.Text = name
		lbl.Size = UDim2.new(1, -12, 0, 28)
		lbl.BackgroundTransparency = 1
		lbl.TextColor3 = Color3.fromRGB(230, 230, 235)
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

	local function createToggle(parent, labelText, descText, initialState, callback)
		local container = Instance.new("Frame", parent)
		container.Size = UDim2.new(1, -12, 0, 62)
		container.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
		container.BorderSizePixel = 0
		container.LayoutOrder = #parent:GetChildren()
		local containerCorner = Instance.new("UICorner", container)
		containerCorner.CornerRadius = UDim.new(0, 6)

		local lbl = Instance.new("TextLabel", container)
		lbl.Size = UDim2.new(0.65, 0, 0, 18)
		lbl.Position = UDim2.new(0, 12, 0, 10)
		lbl.BackgroundTransparency = 1
		lbl.Text = labelText
		lbl.TextColor3 = Color3.fromRGB(230, 230, 235)
		lbl.Font = Enum.Font.GothamMedium
		lbl.TextSize = 14
		lbl.TextXAlignment = Enum.TextXAlignment.Left

		local desc = Instance.new("TextLabel", container)
		desc.Size = UDim2.new(0.65, 0, 0, 16)
		desc.Position = UDim2.new(0, 12, 0, 32)
		desc.BackgroundTransparency = 1
		desc.Text = descText
		desc.TextColor3 = Color3.fromRGB(140, 140, 150)
		desc.Font = Enum.Font.Gotham
		desc.TextSize = 12
		desc.TextXAlignment = Enum.TextXAlignment.Left

		local toggleBg = Instance.new("Frame", container)
		toggleBg.Size = UDim2.new(0, 48, 0, 24)
		toggleBg.Position = UDim2.new(1, -60, 0.5, -12)
		toggleBg.BackgroundColor3 = initialState and Color3.fromRGB(60, 170, 120) or Color3.fromRGB(100, 100, 110)
		toggleBg.BorderSizePixel = 0
		local toggleBgCorner = Instance.new("UICorner", toggleBg)
		toggleBgCorner.CornerRadius = UDim.new(1, 0)

		local toggleCircle = Instance.new("Frame", toggleBg)
		toggleCircle.Size = UDim2.new(0, 18, 0, 18)
		toggleCircle.Position = initialState and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
		toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		toggleCircle.BorderSizePixel = 0
		local circleCorner = Instance.new("UICorner", toggleCircle)
		circleCorner.CornerRadius = UDim.new(1, 0)

		local toggle = Instance.new("TextButton", container)
		toggle.Size = UDim2.new(0, 48, 0, 24)
		toggle.Position = UDim2.new(1, -60, 0.5, -12)
		toggle.BackgroundTransparency = 1
		toggle.Text = ""

		local state = initialState
		toggle.MouseButton1Click:Connect(function()
			state = not state
			if state then
				tween(toggleBg, {BackgroundColor3 = Color3.fromRGB(60, 170, 120)}, 0.2)
				tween(toggleCircle, {Position = UDim2.new(1, -21, 0.5, -9)}, 0.2, Enum.EasingStyle.Back)
			else
				tween(toggleBg, {BackgroundColor3 = Color3.fromRGB(100, 100, 110)}, 0.2)
				tween(toggleCircle, {Position = UDim2.new(0, 3, 0.5, -9)}, 0.2, Enum.EasingStyle.Back)
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
		CreateToggle = createToggle
	}
end

local ui = createMain()

local function switchTo(tabName)
	if not ui.TabFrames[tabName] then return end
	for name, frame in pairs(ui.TabFrames) do
		if name == tabName then
			frame.Visible = true
		else
			frame.Visible = false
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

-- REACH SYSTEM
local reachEnabled = false
local reachDist = 8
local MAX_REACH = 50
local reachVis = 0.6

local reachBox
local reachConn
local lastBallScan = 0
local BALL_SCAN_RATE = 0.5

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
		task.wait(0.03)
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
				
				for _, ball in ipairs(workspace:GetDescendants()) do
					if ball:IsA("Part") and ball:FindFirstChild("network") then
						local dist = (ball.Position - root.Position).Magnitude
						if dist <= reachDist then
							for _, limb in pairs(char:GetDescendants()) do
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

-- SLIDER COMPONENT
local function makeSlider(parent, label, min, max, start, callback)
	local frame = Instance.new("Frame", parent)
	frame.Size = UDim2.new(1, -12, 0, 50)
	frame.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
	frame.BorderSizePixel = 0
	frame.LayoutOrder = #parent:GetChildren()
	local frameCorner = Instance.new("UICorner", frame)
	frameCorner.CornerRadius = UDim.new(0, 6)

	local lbl = Instance.new("TextLabel", frame)
	lbl.Size = UDim2.new(0.5, 0, 0, 18)
	lbl.Position = UDim2.new(0, 12, 0, 8)
	lbl.BackgroundTransparency = 1
	lbl.Text = label
	lbl.TextColor3 = Color3.fromRGB(230, 230, 235)
	lbl.Font = Enum.Font.GothamMedium
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left

	local valueLbl = Instance.new("TextLabel", frame)
	valueLbl.Size = UDim2.new(0, 45, 0, 18)
	valueLbl.Position = UDim2.new(1, -57, 0, 8)
	valueLbl.BackgroundTransparency = 1
	valueLbl.Text = tostring(start)
	valueLbl.TextColor3 = Color3.fromRGB(70, 75, 210)
	valueLbl.Font = Enum.Font.GothamBold
	valueLbl.TextSize = 13
	valueLbl.TextXAlignment = Enum.TextXAlignment.Right

	local sliderBg = Instance.new("Frame", frame)
	sliderBg.Size = UDim2.new(1, -24, 0, 4)
	sliderBg.Position = UDim2.new(0, 12, 1, -14)
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

	local sliderBtn = Instance.new("TextButton", sliderBg)
	sliderBtn.Size = UDim2.new(0, 14, 0, 14)
	sliderBtn.Position = UDim2.new((start - min) / (max - min), -7, 0.5, -7)
	sliderBtn.BackgroundColor3 = Color3.fromRGB(230, 230, 235)
	sliderBtn.Text = ""
	sliderBtn.AutoButtonColor = false
	sliderBtn.BorderSizePixel = 0
	local btnCorner = Instance.new("UICorner", sliderBtn)
	btnCorner.CornerRadius = UDim.new(1, 0)

	local dragging = false
	local current = start

	local function update(input)
		local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
		local value = math.floor(min + (pos * (max - min)) + 0.5)
		
		if value ~= current then
			current = value
			valueLbl.Text = tostring(value)
			sliderFill.Size = UDim2.new(pos, 0, 1, 0)
			sliderBtn.Position = UDim2.new(pos, -7, 0.5, -7)
			if callback then callback(value) end
		end
	end

	sliderBtn.MouseButton1Down:Connect(function()
		dragging = true
		sliderBtn.Size = UDim2.new(0, 16, 0, 16)
		sliderBtn.Position = UDim2.new(sliderBtn.Position.X.Scale, -8, 0.5, -8)
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
			dragging = false
			sliderBtn.Size = UDim2.new(0, 14, 0, 14)
			sliderBtn.Position = UDim2.new(sliderBtn.Position.X.Scale, -7, 0.5, -7)
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
			sliderBtn.Size = UDim2.new(0, 16, 0, 16)
			sliderBtn.Position = UDim2.new(sliderBtn.Position.X.Scale, -8, 0.5, -8)
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
