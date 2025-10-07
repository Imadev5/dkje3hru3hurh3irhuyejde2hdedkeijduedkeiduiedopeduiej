--// Services
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Main UI creation
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

for name, btn in pairs(ui.Buttons) do
	btn.MouseButton1Click:Connect(function()
		tween(btn, {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}, 0.15)
		task.delay(0.2, function()
			tween(btn, {BackgroundColor3 = Color3.fromRGB(28, 28, 32)}, 0.2)
		end)
		switchTo(name)
	end)
end

ui.Close.MouseButton1Click:Connect(function()
	fadeDescendants(ui.Root, 1, 0.3)
	tween(ui.Root, {Size = UDim2.new(0, 520, 0, 320)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	task.delay(0.32, function()
		if screengui and screengui.Parent then
			screengui:Destroy()
		end
	end)
end)

-- INFINITE STAMINA (original logic)
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

-- REACH BYPASS HOOK (your logic)
do
	for _, v in ipairs(getgc(true)) do
		if type(v) == "table" and rawget(v, "overlapCheck") and rawget(v, "gkCheck") then
			hookfunction(v.overlapCheck, function() return true end)
			hookfunction(v.gkCheck, function() return true end)
		end
	end
end

-- REACH & UI/Cooldown (lag-free)
local reachOn = false
local reachX, reachY, reachZ = 5, 5, 5
local MAX_REACH = 30
local reachTransparency = 0.5
local lastTouchTime = {}
local TOUCH_COOLDOWN = 1 -- seconds
local SCAN_DISTANCE = 50
local CHECK_RATE = 0.05
local reachHitbox
local reachConn
local lastCheck = 0

local function updateReachVisual()
	if reachHitbox then
		reachHitbox.Size = Vector3.new(reachX, reachY, reachZ)
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
	reachHitbox.Parent = workspace
end

local function enableReach(state)
	reachOn = state
	if reachOn then
		createReachVisual()
		if not reachConn then
			reachConn = RunService.Heartbeat:Connect(function()
				local now = tick()
				
				-- Always update visual position smoothly
				local char = LocalPlayer.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if root and reachHitbox then
					reachHitbox.Position = root.Position
					updateReachVisual()
				end
				
				-- Only run expensive logic every CHECK_RATE seconds
				if now - lastCheck < CHECK_RATE then return end
				lastCheck = now
				
				if not (char and root) then return end
				
				-- Pre-filter: only check balls that are reasonably close
				local nearbyBalls = {}
				for _, ball in ipairs(workspace:GetDescendants()) do
					if ball:IsA("Part") and ball:FindFirstChild("network") then
						local distance = (ball.Position - root.Position).Magnitude
						if distance <= SCAN_DISTANCE then
							table.insert(nearbyBalls, ball)
						end
					end
				end
				
				if #nearbyBalls == 0 then return end
				
				for _, ball in ipairs(nearbyBalls) do
					local ballId = ball:GetDebugId()
					if lastTouchTime[ballId] and (now - lastTouchTime[ballId] < TOUCH_COOLDOWN) then
						continue
					end

					local diff = (ball.Position - root.Position)
					if math.abs(diff.X) <= reachX/2 and math.abs(diff.Y) <= reachY/2 and math.abs(diff.Z) <= reachZ/2 then
						lastTouchTime[ballId] = now
						local limbs = {
							char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm"),
							char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm"), 
							char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg"),
							char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg"),
							char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
						}
						for _, limb in ipairs(limbs) do
							if limb then
								firetouchinterest(ball, limb, 0)
								task.wait(0.01)
								firetouchinterest(ball, limb, 1)
							end
						end
						break
					end
				end
			end)
		end
	else
		if reachHitbox then
			reachHitbox:Destroy()
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
	local frame = Instance.new("Frame", parent)
	frame.Size = UDim2.new(1, -16, 0, 44)
	frame.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
	frame.BorderSizePixel = 0
	local frameCorner = Instance.new("UICorner", frame)
	frameCorner.CornerRadius = UDim.new(0, 8)

	local lbl = Instance.new("TextLabel", frame)
	lbl.Size = UDim2.new(0.4, 0, 1, 0)
	lbl.Position = UDim2.new(0, 14, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = label
	lbl.TextColor3 = Color3.fromRGB(240, 240, 245)
	lbl.Font = Enum.Font.GothamSemibold
	lbl.TextSize = 15
	lbl.TextXAlignment = Enum.TextXAlignment.Left

	local valueLbl = Instance.new("TextLabel", frame)
	valueLbl.Size = UDim2.new(0, 44, 1, 0)
	valueLbl.Position = UDim2.new(1, -74, 0, 0)
	valueLbl.BackgroundTransparency = 1
	valueLbl.Text = tostring(start)
	valueLbl.TextColor3 = Color3.fromRGB(180, 180, 190)
	valueLbl.Font = Enum.Font.Gotham
	valueLbl.TextSize = 13
	valueLbl.TextXAlignment = Enum.TextXAlignment.Right

	local slider = Instance.new("TextButton", frame)
	slider.Size = UDim2.new(0.25, 0, 0.2, 0)
	slider.Position = UDim2.new(0.7, 0, 0.4, 0)
	slider.BackgroundColor3 = Color3.fromRGB(55, 60, 65)
	slider.BorderSizePixel = 0
	slider.AutoButtonColor = false
	slider.Text = ""
	local sliderCorner = Instance.new("UICorner", slider)
	sliderCorner.CornerRadius = UDim.new(1, 0)

	local drag = false
	local function update(x)
		local percent = math.clamp((x - slider.AbsolutePosition.X)/slider.AbsoluteSize.X, 0, 1)
		local val = math.floor(percent*(max-min)+min + 0.5)
		valueLbl.Text = tostring(val)
		callback(val)
	end

	slider.MouseButton1Down:Connect(function()
		drag = true
		update(UserInputService:GetMouseLocation().X)
	end)
	UserInputService.InputEnded:Connect(function(input)
		if drag and input.UserInputType == Enum.UserInputType.MouseButton1 then
			drag = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
			update(input.Position.X)
		end
	end)

	return frame
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
		reachTransparency = math.clamp(val, 0, 1)
		updateReachVisual()
	end)
end
