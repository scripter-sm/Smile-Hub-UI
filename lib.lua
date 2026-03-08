local SmileUILib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

SmileUILib.Theme = {
	Background     = Color3.fromRGB(15,  15,  20 ),
	Surface        = Color3.fromRGB(20,  20,  27 ),
	SurfaceLight   = Color3.fromRGB(27,  27,  36 ),
	SurfaceLighter = Color3.fromRGB(33,  33,  44 ),
	Header         = Color3.fromRGB(20,  20,  27 ),

	Accent         = Color3.fromRGB(120, 80,  220),
	AccentDark     = Color3.fromRGB(90,  55,  170),
	AccentDarker   = Color3.fromRGB(55,  35,  110),
	AccentHover    = Color3.fromRGB(140, 100, 240),

	Text           = Color3.fromRGB(240, 240, 255),
	TextDim        = Color3.fromRGB(140, 140, 165),
	TextDisabled   = Color3.fromRGB(75,  75,  95 ),

	Border         = Color3.fromRGB(45,  45,  60 ),
	BorderAccent   = Color3.fromRGB(80,  55,  160),

	ToggleOff      = Color3.fromRGB(50,  50,  68 ),
	ToggleOn       = Color3.fromRGB(120, 80,  220),
	SliderFill     = Color3.fromRGB(120, 80,  220),
	SliderTrack    = Color3.fromRGB(40,  40,  55 ),

	CornerRadius              = UDim.new(0, 4),
	CornerRadiusLarge         = UDim.new(0, 6),
	StrokeThickness           = 1,

	Font           = Enum.Font.GothamSemibold,
	FontRegular    = Enum.Font.Gotham,

	WindowHeaderHeight       = 36,
	TabButtonHeight          = 28,
	ElementHeight            = 28,
	SliderHeight             = 50,
	NotificationHeaderHeight = 30,

	AnimationSpeed       = 0.15,
	NotificationInSpeed  = 0.5,
	NotificationOutSpeed = 0.4,
	WindowOpenSpeed      = 0.5,
}

SmileUILib.Windows           = {}
SmileUILib.ThemeableElements = {}
SmileUILib.ButtonRegistry    = {}

local T = SmileUILib.Theme

local function mkCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = radius or T.CornerRadius
	c.Parent = parent
	return c
end

local function mkStroke(parent, color, thick, trans)
	local s = Instance.new("UIStroke")
	s.Color = color or T.Border
	s.Thickness = thick or T.StrokeThickness
	s.Transparency = trans or 0
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = parent
	return s
end

local function mkPadding(parent, top, bottom, left, right)
	local p = Instance.new("UIPadding")
	p.PaddingTop    = UDim.new(0, top    or 0)
	p.PaddingBottom = UDim.new(0, bottom or 0)
	p.PaddingLeft   = UDim.new(0, left   or 0)
	p.PaddingRight  = UDim.new(0, right  or 0)
	p.Parent = parent
	return p
end

local function tween(inst, props, speed)
	TweenService:Create(inst,
		TweenInfo.new(speed or T.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		props
	):Play()
end

local notifContainer
local function initNotifications()
	if notifContainer then return end
	local screen = Instance.new("ScreenGui")
	screen.Name = "SmileNotifications"
	screen.ResetOnSpawn = false
	screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screen.DisplayOrder = 999999
	screen.Parent = CoreGui

	notifContainer = Instance.new("Frame")
	notifContainer.Size = UDim2.new(0, 320, 1, -20)
	notifContainer.Position = UDim2.new(1, -330, 0, 10)
	notifContainer.BackgroundTransparency = 1
	notifContainer.Parent = screen

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = notifContainer
end

function SmileUILib:Notify(options)
	local title    = options.title    or "Notification"
	local message  = options.message  or ""
	local duration = options.duration or 4
	initNotifications()

	local card = Instance.new("Frame")
	card.Name = "Notification"
	card.Size = UDim2.new(1, 0, 0, 0)
	card.BackgroundColor3 = T.SurfaceLight
	card.BorderSizePixel = 0
	card.ClipsDescendants = true
	card.Parent = notifContainer
	mkCorner(card, T.CornerRadiusLarge)
	mkStroke(card, T.Border)

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(0, 3, 1, 0)
	bar.BackgroundColor3 = T.Accent
	bar.BorderSizePixel = 0
	bar.Parent = card
	mkCorner(bar, UDim.new(0, 3))

	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, -3, 0, T.NotificationHeaderHeight)
	header.Position = UDim2.new(0, 3, 0, 0)
	header.BackgroundColor3 = T.Surface
	header.BorderSizePixel = 0
	header.Parent = card

	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1, -14, 1, 0)
	titleLbl.Position = UDim2.new(0, 10, 0, 0)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title
	titleLbl.TextColor3 = T.Text
	titleLbl.Font = T.Font
	titleLbl.TextSize = 13
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.Parent = header

	local body = Instance.new("TextLabel")
	body.Position = UDim2.new(0, 13, 0, T.NotificationHeaderHeight + 6)
	body.Size = UDim2.new(1, -22, 0, 0)
	body.AutomaticSize = Enum.AutomaticSize.Y
	body.BackgroundTransparency = 1
	body.Text = message
	body.TextColor3 = T.TextDim
	body.Font = T.FontRegular
	body.TextSize = 12
	body.TextXAlignment = Enum.TextXAlignment.Left
	body.TextYAlignment = Enum.TextYAlignment.Top
	body.TextWrapped = true
	body.Parent = card

	task.wait()
	local totalH = T.NotificationHeaderHeight + body.TextBounds.Y + 18
	card.Size = UDim2.new(1, 0, 0, 0)
	tween(card, { Size = UDim2.new(1, 0, 0, totalH) }, T.NotificationInSpeed)

	task.delay(duration, function()
		tween(card, { Size = UDim2.new(1, 0, 0, 0) }, T.NotificationOutSpeed)
		task.wait(T.NotificationOutSpeed + 0.05)
		card:Destroy()
	end)
end

function SmileUILib:CreateWindow(options)
	local title         = options.title         or "SmileUI"
	local width         = options.width         or 560
	local height        = options.height        or 400
	local tabsWidth     = options.tabsWidth     or 130
	local contentOffset = options.contentOffset or 146

	local windowId = "Win_" .. math.floor(tick() * 1000)

	local screen = Instance.new("ScreenGui")
	screen.Name = "SmileUI_" .. windowId
	screen.ResetOnSpawn = false
	screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screen.Parent = CoreGui
	self.Windows[windowId] = screen

	local main = Instance.new("Frame")
	main.Name = "Main"
	main.Size = UDim2.new(0, width, 0, height)
	main.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
	main.BackgroundColor3 = T.Surface
	main.BorderSizePixel = 0
	main.Active = true
	main.Parent = screen
	mkCorner(main, T.CornerRadiusLarge)
	mkStroke(main, T.Border)

	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.BackgroundTransparency = 1
	shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
	shadow.Size = UDim2.new(1, 30, 1, 30)
	shadow.Image = "rbxassetid://5028857084"
	shadow.ImageColor3 = Color3.new(0, 0, 0)
	shadow.ImageTransparency = 0.6
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(24, 24, 276, 276)
	shadow.ZIndex = 0
	shadow.Parent = main

	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, T.WindowHeaderHeight)
	titleBar.BackgroundColor3 = T.Header
	titleBar.BorderSizePixel = 0
	titleBar.ZIndex = 2
	titleBar.Parent = main
	mkCorner(titleBar, T.CornerRadiusLarge)

	local tbFix = Instance.new("Frame")
	tbFix.Size = UDim2.new(1, 0, 0, T.CornerRadiusLarge.Offset)
	tbFix.Position = UDim2.new(0, 0, 1, -T.CornerRadiusLarge.Offset)
	tbFix.BackgroundColor3 = T.Header
	tbFix.BorderSizePixel = 0
	tbFix.ZIndex = 2
	tbFix.Parent = titleBar

	local accentLine = Instance.new("Frame")
	accentLine.Size = UDim2.new(1, 0, 0, 1)
	accentLine.Position = UDim2.new(0, 0, 1, -1)
	accentLine.BackgroundColor3 = T.Accent
	accentLine.BorderSizePixel = 0
	accentLine.ZIndex = 3
	accentLine.Parent = titleBar

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -80, 1, 0)
	titleLabel.Position = UDim2.new(0, 12, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.TextColor3 = T.Text
	titleLabel.Font = T.Font
	titleLabel.TextSize = 13
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 3
	titleLabel.Parent = titleBar

	local minBtn = Instance.new("TextButton")
	minBtn.Size = UDim2.new(0, 26, 0, 20)
	minBtn.Position = UDim2.new(1, -32, 0.5, -10)
	minBtn.BackgroundColor3 = T.SurfaceLighter
	minBtn.Text = "−"
	minBtn.TextColor3 = T.TextDim
	minBtn.Font = T.Font
	minBtn.TextSize = 16
	minBtn.ZIndex = 4
	minBtn.AutoButtonColor = false
	minBtn.Parent = titleBar
	mkCorner(minBtn)
	minBtn.MouseEnter:Connect(function() tween(minBtn, {BackgroundColor3 = T.Accent, TextColor3 = T.Text}) end)
	minBtn.MouseLeave:Connect(function() tween(minBtn, {BackgroundColor3 = T.SurfaceLighter, TextColor3 = T.TextDim}) end)

	local bodyFrame = Instance.new("Frame")
	bodyFrame.Name = "Body"
	bodyFrame.Size = UDim2.new(1, 0, 1, -T.WindowHeaderHeight)
	bodyFrame.Position = UDim2.new(0, 0, 0, T.WindowHeaderHeight)
	bodyFrame.BackgroundColor3 = T.Background
	bodyFrame.BorderSizePixel = 0
	bodyFrame.ClipsDescendants = true
	bodyFrame.ZIndex = 1
	bodyFrame.Parent = main

	local bodyFix = Instance.new("Frame")
	bodyFix.Size = UDim2.new(1, 0, 0, T.CornerRadiusLarge.Offset)
	bodyFix.BackgroundColor3 = T.Background
	bodyFix.BorderSizePixel = 0
	bodyFix.ZIndex = 1
	bodyFix.Parent = bodyFrame

	mkCorner(bodyFrame, T.CornerRadiusLarge)

	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, tabsWidth, 1, -16)
	sidebar.Position = UDim2.new(0, 8, 0, 8)
	sidebar.BackgroundColor3 = T.SurfaceLight
	sidebar.BorderSizePixel = 0
	sidebar.ZIndex = 2
	sidebar.Parent = bodyFrame
	mkCorner(sidebar, T.CornerRadius)
	mkStroke(sidebar, T.Border)

	local tabLayout = Instance.new("UIListLayout")
	tabLayout.Padding = UDim.new(0, 3)
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabLayout.Parent = sidebar
	mkPadding(sidebar, 6, 6, 6, 6)

	local contentArea = Instance.new("Frame")
	contentArea.Name = "Content"
	contentArea.Size = UDim2.new(1, -(contentOffset), 1, -16)
	contentArea.Position = UDim2.new(0, contentOffset - 6, 0, 8)
	contentArea.BackgroundTransparency = 1
	contentArea.ZIndex = 1
	contentArea.Parent = bodyFrame

	local icon = Instance.new("Frame")
	icon.Size = UDim2.new(0, 36, 0, 36)
	icon.BackgroundColor3 = T.SurfaceLight
	icon.Visible = false
	icon.Active = true
	icon.Draggable = true
	icon.ZIndex = 10
	icon.Parent = screen
	mkCorner(icon, T.CornerRadius)
	mkStroke(icon, T.Border)

	local iconBtn = Instance.new("TextButton")
	iconBtn.Size = UDim2.new(1, 0, 1, 0)
	iconBtn.BackgroundTransparency = 1
	iconBtn.Text = "☰"
	iconBtn.TextColor3 = T.Accent
	iconBtn.Font = T.Font
	iconBtn.TextSize = 18
	iconBtn.ZIndex = 11
	iconBtn.Parent = icon

	minBtn.MouseButton1Click:Connect(function()
		main.Visible = false
		icon.Position = UDim2.new(0, main.AbsolutePosition.X + 8, 0, main.AbsolutePosition.Y + 8)
		icon.Visible = true
	end)
	iconBtn.MouseButton1Click:Connect(function()
		icon.Visible = false
		main.Visible = true
	end)

	do
		local dragging, dragStart, startPos = false, nil, nil
		titleBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dragStart = input.Position
				startPos = main.Position
				local dc, ec
				dc = UserInputService.InputChanged:Connect(function(i)
					if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
						local d = i.Position - dragStart
						main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
					end
				end)
				ec = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
						dc:Disconnect()
						ec:Disconnect()
					end
				end)
			end
		end)
	end

	main.Size = UDim2.new(0, width, 0, 0)
	main.BackgroundTransparency = 1
	tween(main, {Size = UDim2.new(0, width, 0, height), BackgroundTransparency = 0}, T.WindowOpenSpeed)

	local window = {}
	window.Id = windowId
	local activePage = nil

	function window:AddTab(tabOptions)
		local tabName = tabOptions.name or "Tab"

		local tabBtn = Instance.new("TextButton")
		tabBtn.Size = UDim2.new(1, 0, 0, T.TabButtonHeight)
		tabBtn.BackgroundColor3 = T.Background
		tabBtn.Text = tabName
		tabBtn.TextColor3 = T.TextDim
		tabBtn.Font = T.FontRegular
		tabBtn.TextSize = 12
		tabBtn.AutoButtonColor = false
		tabBtn.BorderSizePixel = 0
		tabBtn.ZIndex = 3
		tabBtn.Parent = sidebar
		mkCorner(tabBtn, T.CornerRadius)

		local page = Instance.new("ScrollingFrame")
		page.Size = UDim2.new(1, 0, 1, 0)
		page.BackgroundTransparency = 1
		page.BorderSizePixel = 0
		page.ScrollBarThickness = 2
		page.ScrollBarImageColor3 = T.Accent
		page.Visible = false
		page.CanvasSize = UDim2.new(0, 0, 0, 0)
		page.ZIndex = 2
		page.Parent = contentArea

		local pageLayout = Instance.new("UIListLayout")
		pageLayout.Padding = UDim.new(0, 6)
		pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		pageLayout.Parent = page
		mkPadding(page, 0, 8, 0, 4)

		pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
		end)

		tabBtn.MouseEnter:Connect(function()
			if activePage ~= page then
				tween(tabBtn, {BackgroundColor3 = T.SurfaceLighter, TextColor3 = T.Text})
			end
		end)
		tabBtn.MouseLeave:Connect(function()
			if activePage ~= page then
				tween(tabBtn, {BackgroundColor3 = T.Background, TextColor3 = T.TextDim})
			end
		end)
		tabBtn.MouseButton1Click:Connect(function()
			if activePage then activePage.Visible = false end
			page.Visible = true
			activePage = page
			for _, b in sidebar:GetChildren() do
				if b:IsA("TextButton") then
					local active = (b == tabBtn)
					tween(b, {
						BackgroundColor3 = active and T.AccentDarker or T.Background,
						TextColor3       = active and T.Accent or T.TextDim,
					})
				end
			end
		end)

		if not activePage then
			tabBtn.BackgroundColor3 = T.AccentDarker
			tabBtn.TextColor3 = T.Accent
			page.Visible = true
			activePage = page
		end

		local tabAPI = {}
		tabAPI.page = page

		local function makeElemFrame(h)
			local f = Instance.new("Frame")
			f.Size = UDim2.new(1, -4, 0, h or T.ElementHeight)
			f.BackgroundColor3 = T.SurfaceLight
			f.BorderSizePixel = 0
			f.Parent = page
			mkCorner(f, T.CornerRadius)
			mkStroke(f, T.Border)
			return f
		end

		local function makeLabel(parent, text, xOff, color, size)
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, -(xOff or 0) - 10, 1, 0)
			lbl.Position = UDim2.new(0, xOff or 8, 0, 0)
			lbl.BackgroundTransparency = 1
			lbl.Text = text
			lbl.TextColor3 = color or T.Text
			lbl.Font = T.FontRegular
			lbl.TextSize = size or 12
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.TextTruncate = Enum.TextTruncate.AtEnd
			lbl.Parent = parent
			return lbl
		end

		function tabAPI:AddSection(opts)
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, -4, 0, 20)
			lbl.BackgroundTransparency = 1
			lbl.Text = (opts.title or "Section"):upper()
			lbl.TextColor3 = T.Accent
			lbl.Font = T.Font
			lbl.TextSize = 10
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = page
			mkPadding(lbl, 0, 0, 6, 0)
			return lbl
		end

		function tabAPI:AddLabel(opts)
			local f = Instance.new("Frame")
			f.Size = UDim2.new(1, -4, 0, 0)
			f.AutomaticSize = Enum.AutomaticSize.Y
			f.BackgroundTransparency = 1
			f.Parent = page
			local lbl = makeLabel(f, opts.text or "Label", 6, opts.textColor or T.TextDim, 12)
			lbl.TextWrapped = true
			lbl.Size = UDim2.new(1, -12, 0, 0)
			lbl.AutomaticSize = Enum.AutomaticSize.Y
			return lbl
		end

		function tabAPI:AddSpacer(opts)
			local f = Instance.new("Frame")
			f.Size = UDim2.new(1, -4, 0, opts and opts.height or 4)
			f.BackgroundTransparency = 1
			f.Parent = page
			return f
		end

		function tabAPI:AddButton(opts)
			local text = opts.text or "Button"
			local cb = opts.callback

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -4, 0, T.ElementHeight)
			btn.BackgroundColor3 = T.SurfaceLight
			btn.Text = ""
			btn.AutoButtonColor = false
			btn.BorderSizePixel = 0
			btn.Parent = page
			mkCorner(btn, T.CornerRadius)
			mkStroke(btn, T.Border)

			local lbl = makeLabel(btn, text, 10, T.Text, 12)
			lbl.Font = T.Font

			local tick = Instance.new("Frame")
			tick.Size = UDim2.new(0, 2, 0.6, 0)
			tick.AnchorPoint = Vector2.new(0, 0.5)
			tick.Position = UDim2.new(0, 3, 0.5, 0)
			tick.BackgroundColor3 = T.Accent
			tick.BorderSizePixel = 0
			tick.Parent = btn
			mkCorner(tick)

			btn.MouseEnter:Connect(function()
				tween(btn, {BackgroundColor3 = T.SurfaceLighter})
				tween(tick, {BackgroundColor3 = T.AccentHover})
			end)
			btn.MouseLeave:Connect(function()
				tween(btn, {BackgroundColor3 = T.SurfaceLight})
				tween(tick, {BackgroundColor3 = T.Accent})
			end)
			btn.MouseButton1Click:Connect(function()
				if cb then cb() end
			end)
			return btn
		end

		function tabAPI:AddToggle(opts)
			local name  = opts.name    or "Toggle"
			local state = opts.default or false
			local cb    = opts.callback

			local frame = makeElemFrame(T.ElementHeight)
			makeLabel(frame, name, 10, T.Text, 12)

			local pillW, pillH = 34, 18
			local pill = Instance.new("Frame")
			pill.Size = UDim2.new(0, pillW, 0, pillH)
			pill.AnchorPoint = Vector2.new(1, 0.5)
			pill.Position = UDim2.new(1, -8, 0.5, 0)
			pill.BackgroundColor3 = state and T.ToggleOn or T.ToggleOff
			pill.BorderSizePixel = 0
			pill.Parent = frame
			mkCorner(pill, UDim.new(1, 0))

			local knob = Instance.new("Frame")
			knob.Size = UDim2.new(0, pillH - 6, 0, pillH - 6)
			knob.AnchorPoint = Vector2.new(0, 0.5)
			knob.Position = UDim2.new(0, state and (pillW - pillH + 3) or 3, 0.5, 0)
			knob.BackgroundColor3 = T.Text
			knob.BorderSizePixel = 0
			knob.Parent = pill
			mkCorner(knob, UDim.new(1, 0))

			local api = {}
			function api:GetState() return state end
			function api:SetState(bool)
				state = bool
				tween(pill, {BackgroundColor3 = state and T.ToggleOn or T.ToggleOff})
				tween(knob, {Position = UDim2.new(0, state and (pillW - pillH + 3) or 3, 0.5, 0)})
				if cb then cb(state) end
			end

			frame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					api:SetState(not state)
				end
			end)
			frame.MouseEnter:Connect(function() tween(frame, {BackgroundColor3 = T.SurfaceLighter}) end)
			frame.MouseLeave:Connect(function() tween(frame, {BackgroundColor3 = T.SurfaceLight}) end)

			return api
		end

		function tabAPI:AddSlider(opts)
			local name    = opts.name    or "Slider"
			local min     = opts.min     or 0
			local max     = opts.max     or 100
			local default = math.clamp(opts.default or min, min, max)
			local step    = opts.step    or 1
			local cb      = opts.callback

			local frame = makeElemFrame(T.SliderHeight)

			local topRow = Instance.new("Frame")
			topRow.Size = UDim2.new(1, -16, 0, 20)
			topRow.Position = UDim2.new(0, 8, 0, 6)
			topRow.BackgroundTransparency = 1
			topRow.Parent = frame

			local nameLbl = Instance.new("TextLabel")
			nameLbl.Size = UDim2.new(0.7, 0, 1, 0)
			nameLbl.BackgroundTransparency = 1
			nameLbl.Text = name
			nameLbl.TextColor3 = T.Text
			nameLbl.Font = T.FontRegular
			nameLbl.TextSize = 12
			nameLbl.TextXAlignment = Enum.TextXAlignment.Left
			nameLbl.Parent = topRow

			local valLbl = Instance.new("TextLabel")
			valLbl.Size = UDim2.new(0.3, 0, 1, 0)
			valLbl.Position = UDim2.new(0.7, 0, 0, 0)
			valLbl.BackgroundTransparency = 1
			valLbl.Text = tostring(default)
			valLbl.TextColor3 = T.Accent
			valLbl.Font = T.Font
			valLbl.TextSize = 12
			valLbl.TextXAlignment = Enum.TextXAlignment.Right
			valLbl.Parent = topRow

			local track = Instance.new("Frame")
			track.Size = UDim2.new(1, -16, 0, 6)
			track.Position = UDim2.new(0, 8, 0, 34)
			track.BackgroundColor3 = T.SliderTrack
			track.BorderSizePixel = 0
			track.Parent = frame
			mkCorner(track, UDim.new(1, 0))

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			fill.BackgroundColor3 = T.SliderFill
			fill.BorderSizePixel = 0
			fill.Parent = track
			mkCorner(fill, UDim.new(1, 0))

			local knobSz = 12
			local knobF = Instance.new("Frame")
			knobF.Size = UDim2.new(0, knobSz, 0, knobSz)
			knobF.AnchorPoint = Vector2.new(0.5, 0.5)
			knobF.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
			knobF.BackgroundColor3 = T.Text
			knobF.BorderSizePixel = 0
			knobF.ZIndex = 2
			knobF.Parent = track
			mkCorner(knobF, UDim.new(1, 0))
			mkStroke(knobF, T.Accent, 2)

			local value = default
			local api = {}

			function api:GetValue() return value end
			function api:SetValue(v)
				v = math.clamp(math.floor((v / step) + 0.5) * step, min, max)
				value = v
				local t = (v - min) / (max - min)
				fill.Size = UDim2.new(t, 0, 1, 0)
				knobF.Position = UDim2.new(t, 0, 0.5, 0)
				valLbl.Text = tostring(v)
				if cb then cb(v) end
			end

			local dragging = false
			local function updateFromX(x)
				local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
				api:SetValue(min + (max - min) * rel)
			end

			track.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					updateFromX(input.Position.X)
					local c1, c2
					c1 = UserInputService.InputChanged:Connect(function(i)
						if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
							updateFromX(i.Position.X)
						end
					end)
					c2 = UserInputService.InputEnded:Connect(function(i)
						if i.UserInputType == Enum.UserInputType.MouseButton1 then
							dragging = false
							c1:Disconnect()
							c2:Disconnect()
						end
					end)
				end
			end)

			return api
		end

		function tabAPI:AddDropdown(opts)
			local name         = opts.name    or "Dropdown"
			local options_list = opts.options  or {"Option 1", "Option 2"}
			local default      = opts.default  or options_list[1]
			local cb           = opts.callback

			local frame = makeElemFrame(T.ElementHeight)
			makeLabel(frame, name, 10, T.Text, 12)

			local selBtn = Instance.new("TextButton")
			selBtn.Size = UDim2.new(0, 110, 0, T.ElementHeight - 8)
			selBtn.AnchorPoint = Vector2.new(1, 0.5)
			selBtn.Position = UDim2.new(1, -6, 0.5, 0)
			selBtn.BackgroundColor3 = T.Background
			selBtn.Text = default
			selBtn.TextColor3 = T.Accent
			selBtn.Font = T.Font
			selBtn.TextSize = 11
			selBtn.TextTruncate = Enum.TextTruncate.AtEnd
			selBtn.BorderSizePixel = 0
			selBtn.AutoButtonColor = false
			selBtn.Parent = frame
			mkCorner(selBtn, T.CornerRadius)
			mkStroke(selBtn, T.BorderAccent)

			local arrow = Instance.new("TextLabel")
			arrow.Size = UDim2.new(0, 14, 1, 0)
			arrow.AnchorPoint = Vector2.new(1, 0.5)
			arrow.Position = UDim2.new(1, -4, 0.5, 0)
			arrow.BackgroundTransparency = 1
			arrow.Text = "▾"
			arrow.TextColor3 = T.Accent
			arrow.Font = T.Font
			arrow.TextSize = 10
			arrow.Parent = selBtn

			local current = 1
			for i, v in ipairs(options_list) do
				if v == default then current = i; break end
			end
			local selection = options_list[current]

			local api = {}
			function api:GetSelection() return selection end
			function api:SetSelection(choice)
				for i, v in ipairs(options_list) do
					if v == choice then
						current = i
						selection = choice
						selBtn.Text = choice
						if cb then cb(selection) end
						return
					end
				end
			end

			selBtn.MouseButton1Click:Connect(function()
				current = (current % #options_list) + 1
				selection = options_list[current]
				selBtn.Text = selection
				if cb then cb(selection) end
			end)
			frame.MouseEnter:Connect(function() tween(frame, {BackgroundColor3 = T.SurfaceLighter}) end)
			frame.MouseLeave:Connect(function() tween(frame, {BackgroundColor3 = T.SurfaceLight}) end)

			return api
		end

		function tabAPI:AddKeybind(opts)
			local name       = opts.name       or "Keybind"
			local defaultKey = opts.defaultKey  or Enum.KeyCode.Unknown
			local cb         = opts.callback
			local allowMouse = opts.allowMouse  or false

			local frame = makeElemFrame(T.ElementHeight)
			makeLabel(frame, name, 10, T.Text, 12)

			local kBtn = Instance.new("TextButton")
			kBtn.Size = UDim2.new(0, 80, 0, T.ElementHeight - 8)
			kBtn.AnchorPoint = Vector2.new(1, 0.5)
			kBtn.Position = UDim2.new(1, -6, 0.5, 0)
			kBtn.BackgroundColor3 = T.Background
			kBtn.Text = defaultKey.Name
			kBtn.TextColor3 = T.Accent
			kBtn.Font = T.Font
			kBtn.TextSize = 11
			kBtn.BorderSizePixel = 0
			kBtn.AutoButtonColor = false
			kBtn.Parent = frame
			mkCorner(kBtn, T.CornerRadius)
			mkStroke(kBtn, T.BorderAccent)

			local listening = false
			local currentKey = defaultKey
			local api = {}

			function api:GetKey() return currentKey end
			function api:SetKey(key)
				currentKey = key
				kBtn.Text = (type(key) == "userdata" and key.Name) or tostring(key)
				if cb then cb(currentKey) end
			end

			kBtn.MouseButton1Click:Connect(function()
				listening = true
				kBtn.Text = "..."
				kBtn.TextColor3 = T.TextDim
			end)

			local ic = UserInputService.InputBegan:Connect(function(input, processed)
				if processed or not listening then return end
				listening = false
				kBtn.TextColor3 = T.Accent
				if input.UserInputType == Enum.UserInputType.Keyboard then
					api:SetKey(input.KeyCode)
				elseif allowMouse then
					api:SetKey(input.UserInputType)
				else
					kBtn.Text = currentKey.Name
				end
			end)

			frame.Destroying:Connect(function() ic:Disconnect() end)
			frame.MouseEnter:Connect(function() tween(frame, {BackgroundColor3 = T.SurfaceLighter}) end)
			frame.MouseLeave:Connect(function() tween(frame, {BackgroundColor3 = T.SurfaceLight}) end)

			return api
		end

		function tabAPI:AddTextbox(opts)
			local name    = opts.name    or "Textbox"
			local default = opts.default or ""
			local cb      = opts.callback

			local frame = makeElemFrame(T.ElementHeight)
			makeLabel(frame, name, 10, T.Text, 12)

			local tb = Instance.new("TextBox")
			tb.Size = UDim2.new(0, 110, 0, T.ElementHeight - 8)
			tb.AnchorPoint = Vector2.new(1, 0.5)
			tb.Position = UDim2.new(1, -6, 0.5, 0)
			tb.BackgroundColor3 = T.Background
			tb.Text = default
			tb.TextColor3 = T.Text
			tb.PlaceholderColor3 = T.TextDisabled
			tb.Font = T.FontRegular
			tb.TextSize = 12
			tb.BorderSizePixel = 0
			tb.ClearTextOnFocus = false
			tb.Parent = frame
			mkCorner(tb, T.CornerRadius)
			mkStroke(tb, T.BorderAccent)
			mkPadding(tb, 0, 0, 6, 6)

			local text = default
			local api = {}

			function api:GetText() return text end
			function api:SetText(v)
				text = v
				tb.Text = v
				if cb then cb(text) end
			end

			tb.FocusLost:Connect(function(enter)
				if enter then api:SetText(tb.Text) else tb.Text = text end
			end)
			tb.Focused:Connect(function() tween(tb, {BackgroundColor3 = T.SurfaceLighter}) end)
			tb.FocusLost:Connect(function() tween(tb, {BackgroundColor3 = T.Background}) end)

			return api
		end

		function tabAPI:AddProgressBar(opts)
			local name  = opts.name  or "Progress"
			local max   = opts.max   or 100
			local value = opts.value or 0

			local frame = makeElemFrame(T.SliderHeight)

			local topRow = Instance.new("Frame")
			topRow.Size = UDim2.new(1, -16, 0, 20)
			topRow.Position = UDim2.new(0, 8, 0, 6)
			topRow.BackgroundTransparency = 1
			topRow.Parent = frame

			local nameLbl = Instance.new("TextLabel")
			nameLbl.Size = UDim2.new(0.7, 0, 1, 0)
			nameLbl.BackgroundTransparency = 1
			nameLbl.Text = name
			nameLbl.TextColor3 = T.Text
			nameLbl.Font = T.FontRegular
			nameLbl.TextSize = 12
			nameLbl.TextXAlignment = Enum.TextXAlignment.Left
			nameLbl.Parent = topRow

			local pctLbl = Instance.new("TextLabel")
			pctLbl.Size = UDim2.new(0.3, 0, 1, 0)
			pctLbl.Position = UDim2.new(0.7, 0, 0, 0)
			pctLbl.BackgroundTransparency = 1
			pctLbl.Text = math.floor((value / max) * 100) .. "%"
			pctLbl.TextColor3 = T.Accent
			pctLbl.Font = T.Font
			pctLbl.TextSize = 12
			pctLbl.TextXAlignment = Enum.TextXAlignment.Right
			pctLbl.Parent = topRow

			local track = Instance.new("Frame")
			track.Size = UDim2.new(1, -16, 0, 6)
			track.Position = UDim2.new(0, 8, 0, 34)
			track.BackgroundColor3 = T.SliderTrack
			track.BorderSizePixel = 0
			track.Parent = frame
			mkCorner(track, UDim.new(1, 0))

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new(value / max, 0, 1, 0)
			fill.BackgroundColor3 = T.Accent
			fill.BorderSizePixel = 0
			fill.Parent = track
			mkCorner(fill, UDim.new(1, 0))

			local curVal = value
			local api = {}

			function api:GetValue() return curVal end
			function api:SetValue(v)
				v = math.clamp(v, 0, max)
				curVal = v
				tween(fill, {Size = UDim2.new(v / max, 0, 1, 0)})
				pctLbl.Text = math.floor((v / max) * 100) .. "%"
			end

			return api
		end

		return tabAPI
	end

	return window
end

return SmileUILib
