--[[

  _________       .__.__             ___ ___      ___.     
 /   _____/ _____ |__|  |   ____    /   |   \ __ _\_ |__   
 \_____  \ /     \|  |  | _/ __ \  /    ~    \  |  \ __ \  
 /        \  Y Y  \  |  |_\  ___/  \    Y    /  |  / \_\ \ 
/_______  /__|_|  /__|____/\___  >  \___|_  /|____/|___  / 
        \/      \/             \/         \/           \/  

]]

local SmileUILib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
SmileUILib.Theme = {
    Background = Color3.fromRGB(0, 0, 0),
    Header = Color3.fromRGB(0, 20, 0),
    Accent = Color3.fromRGB(0, 255, 0),
    AccentDark = Color3.fromRGB(0, 120, 0),
    AccentDarker = Color3.fromRGB(0, 60, 0),
    AccentVeryDark = Color3.fromRGB(0, 12, 0),
    Text = Color3.fromRGB(0, 255, 0),
    TextDim = Color3.fromRGB(0, 200, 0),
    StrokeColor = Color3.fromRGB(0, 100, 0),
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 1.8,
    StrokeTransparency = 0.28,
    Font = Enum.Font.Arcade,
    NotificationCornerRadius = UDim.new(0, 10),
    NotificationHeaderHeight = 34,
    NotificationStrokeThickness = 2.2,
    WindowHeaderHeight = 44,
    WindowMinButtonSize = UDim2.new(0, 40, 0, 40),
    WindowIconSize = UDim2.new(0, 56, 0, 56),
    TabButtonHeight = 38,
    TabButtonCornerRadius = UDim.new(0, 6),
    ElementCornerRadius = UDim.new(0, 5),
    ButtonHeight = 40,
    ToggleHeight = 36,
    SliderHeight = 58,
    DropdownHeight = 40,
    KeybindHeight = 38,
    TextboxHeight = 40,
    SpacerDefaultHeight = 8,
    AnimationSpeed = 0.18,
    NotificationInSpeed = 0.58,
    NotificationOutSpeed = 0.52,
    WindowOpenSpeed = 0.7
}
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
    notifContainer.Size = UDim2.new(1, 0, 0, 320)
    notifContainer.Position = UDim2.new(0, 0, 1, -340)
    notifContainer.BackgroundTransparency = 1
    notifContainer.Parent = screen
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 12)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.Parent = notifContainer
end
function SmileUILib:Notify(options)
    local title = options.title or "INFO"
    local message = options.message or ""
    local duration = options.duration or 3.7
    local width = options.width or 400
    local theme = options.theme or SmileUILib.Theme
    initNotifications()
    local notif = Instance.new("Frame")
    notif.BackgroundColor3 = theme.Background
    notif.BorderSizePixel = 0
    notif.ZIndex = 999999
    notif.Parent = notifContainer
    local corner = Instance.new("UICorner")
    corner.CornerRadius = theme.NotificationCornerRadius
    corner.Parent = notif
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.StrokeColor
    stroke.Thickness = theme.NotificationStrokeThickness
    stroke.Transparency = theme.StrokeTransparency
    stroke.Parent = notif
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, theme.NotificationHeaderHeight)
    header.BackgroundColor3 = theme.Header
    header.BorderSizePixel = 0
    header.Parent = notif
    local hcorner = Instance.new("UICorner")
    hcorner.CornerRadius = theme.CornerRadius
    hcorner.Parent = header
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 1, 0)
    titleLbl.Position = UDim2.new(0, 14, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "> " .. title:upper()
    titleLbl.TextColor3 = theme.Text
    titleLbl.Font = theme.Font
    titleLbl.TextSize = 17
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    titleLbl.Parent = header
    local content = Instance.new("TextLabel")
    content.Position = UDim2.new(0, 10, 0, theme.NotificationHeaderHeight + 2)
    content.BackgroundTransparency = 1
    content.Text = message
    content.TextColor3 = theme.Text
    content.Font = theme.Font
    content.TextSize = 14
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.TextYAlignment.Top
    content.TextWrapped = true
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.Size = UDim2.new(1, -20, 0, 0)
    content.Parent = notif
    task.wait()
    local textHeight = content.TextBounds.Y
    local notifHeight = theme.NotificationHeaderHeight + textHeight + 10
    notif.Size = UDim2.new(0, 0, 0, notifHeight)
    notif.BackgroundTransparency = 1
    TweenService:Create(notif, TweenInfo.new(theme.NotificationInSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, width, 0, notifHeight),
        BackgroundTransparency = 0
    }):Play()
    task.delay(duration, function()
        local out = TweenService:Create(notif, TweenInfo.new(theme.NotificationOutSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, notifHeight),
            BackgroundTransparency = 1
        })
        out:Play()
        out.Completed:Connect(function() notif:Destroy() end)
    end)
end
function SmileUILib:CreateWindow(options)
    local title = options.title or "SMILE UI"
    local width = options.width or 580
    local height = options.height or 420
    local theme = options.theme or SmileUILib.Theme
    local iconText = options.iconText or "$"
    local tabsWidth = options.tabsWidth or 152
    local contentOffset = options.contentOffset or 176
    local screen = Instance.new("ScreenGui")
    screen.Name = "SmileUI_" .. math.floor(tick() * 1000)
    screen.ResetOnSpawn = false
    screen.Parent = CoreGui
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, width, 0, height)
    main.Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2)
    main.BackgroundColor3 = theme.Background
    main.Active = true
    main.Parent = screen
    local corner = Instance.new("UICorner")
    corner.CornerRadius = theme.CornerRadius
    corner.Parent = main
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.StrokeColor
    stroke.Thickness = theme.StrokeThickness
    stroke.Transparency = theme.StrokeTransparency
    stroke.Parent = main
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, theme.WindowHeaderHeight)
    header.BackgroundColor3 = theme.Header
    header.BorderSizePixel = 0
    header.Parent = main
    local hcorner = Instance.new("UICorner")
    hcorner.CornerRadius = theme.CornerRadius
    hcorner.Parent = header
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -70, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.Text
    titleLabel.Font = theme.Font
    titleLabel.TextSize = 21
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = header
    local minBtn = Instance.new("TextButton")
    minBtn.Size = theme.WindowMinButtonSize
    minBtn.Position = UDim2.new(1, -52, 0, 2)
    minBtn.BackgroundTransparency = 1
    minBtn.Text = "−"
    minBtn.TextColor3 = theme.Text
    minBtn.Font = theme.Font
    minBtn.TextSize = 34
    minBtn.Parent = header
    local icon = Instance.new("Frame")
    icon.Size = theme.WindowIconSize
    icon.BackgroundColor3 = theme.Header
    icon.Visible = false
    icon.Active = true
    icon.Draggable = true
    icon.Parent = screen
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = icon
    local iconTextBtn = Instance.new("TextButton")
    iconTextBtn.Size = UDim2.new(1, 0, 1, 0)
    iconTextBtn.BackgroundTransparency = 1
    iconTextBtn.Text = iconText
    iconTextBtn.TextColor3 = theme.Text
    iconTextBtn.Font = theme.Font
    iconTextBtn.TextSize = 36
    iconTextBtn.Parent = icon
    minBtn.MouseButton1Click:Connect(function()
        main.Visible = false
        icon.Position = UDim2.new(0, main.AbsolutePosition.X + main.AbsoluteSize.X - icon.AbsoluteSize.X, 0, main.AbsolutePosition.Y)
        icon.Visible = true
    end)
    iconTextBtn.MouseButton1Click:Connect(function()
        icon.Visible = false
        main.Visible = true
    end)
    local tabs = Instance.new("Frame")
    tabs.Size = UDim2.new(0, tabsWidth, 1, -theme.WindowHeaderHeight - 8)
    tabs.Position = UDim2.new(0, 12, 0, theme.WindowHeaderHeight)
    tabs.BackgroundTransparency = 1
    tabs.Parent = main
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 7)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabs
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -contentOffset, 1, -theme.WindowHeaderHeight - 8)
    content.Position = UDim2.new(0, contentOffset - 12, 0, theme.WindowHeaderHeight)
    content.BackgroundTransparency = 1
    content.Parent = main
    local dragging = false
    local dragStartPos
    local startGuiPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStartPos = input.Position
            startGuiPos = main.Position
            local dragConn
            local endConn
            dragConn = UserInputService.InputChanged:Connect(function(input2)
                if dragging and (input2.UserInputType == Enum.UserInputType.MouseMovement or input2.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input2.Position - dragStartPos
                    main.Position = UDim2.new(startGuiPos.X.Scale, startGuiPos.X.Offset + delta.X, startGuiPos.Y.Scale, startGuiPos.Y.Offset + delta.Y)
                end
            end)
            endConn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    dragConn:Disconnect()
                    endConn:Disconnect()
                end
            end)
        end
    end)
    local window = {}
    window.Elements = {}
    local activePage = nil
    function window:AddTab(tabOptions)
        local tabName = tabOptions.name or "Tab"
        local theme = tabOptions.theme or SmileUILib.Theme
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, -12, 0, theme.TabButtonHeight)
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        tabBtn.Text = tabName
        tabBtn.TextColor3 = theme.TextDim
        tabBtn.Font = theme.Font
        tabBtn.TextSize = 15
        tabBtn.AutoButtonColor = false
        tabBtn.TextTruncate = Enum.TextTruncate.AtEnd
        tabBtn.Parent = tabs
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = theme.TabButtonCornerRadius
        btnCorner.Parent = tabBtn
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = theme.AccentDark
        page.Visible = false
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Parent = content
        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, 10)
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Parent = page
        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 30)
        end)
        tabBtn.MouseEnter:Connect(function()
            if activePage ~= page then
                TweenService:Create(tabBtn, TweenInfo.new(theme.AnimationSpeed), {
                    BackgroundColor3 = theme.AccentVeryDark
                }):Play()
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if activePage ~= page then
                TweenService:Create(tabBtn, TweenInfo.new(theme.AnimationSpeed), {
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                }):Play()
            end
        end)
        tabBtn.MouseButton1Click:Connect(function()
            if activePage then
                activePage.Visible = false
            end
            page.Visible = true
            activePage = page
            for _, b in tabs:GetChildren() do
                if b:IsA("TextButton") then
                    TweenService:Create(b, TweenInfo.new(theme.AnimationSpeed), {
                        BackgroundColor3 = (b == tabBtn) and theme.AccentDarker or Color3.fromRGB(0, 0, 0),
                        TextColor3 = (b == tabBtn) and theme.Text or theme.TextDim
                    }):Play()
                end
            end
        end)
        if not activePage then
            tabBtn.BackgroundColor3 = theme.AccentDarker
            tabBtn.TextColor3 = theme.Text
            page.Visible = true
            activePage = page
        end
        local tabAPI = {}
        function tabAPI:AddSection(secOptions)
            local title = secOptions.title or "Section"
            local textSize = secOptions.textSize or 16
            local textColor = secOptions.textColor or theme.Text
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 0)
            lbl.AutomaticSize = Enum.AutomaticSize.Y
            lbl.BackgroundTransparency = 1
            lbl.Text = title
            lbl.TextColor3 = textColor
            lbl.Font = theme.Font
            lbl.TextSize = textSize
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextWrapped = true
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = page
            return lbl
        end
        function tabAPI:AddLabel(lblOptions)
            local text = lblOptions.text or "Label"
            local textSize = lblOptions.textSize or 14
            local textColor = lblOptions.textColor or theme.TextDim
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 0)
            lbl.AutomaticSize = Enum.AutomaticSize.Y
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = textColor
            lbl.Font = theme.Font
            lbl.TextSize = textSize
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextWrapped = true
            lbl.Parent = page
            return lbl
        end
        function tabAPI:AddSpacer(spacerOptions)
            local height = spacerOptions.height or theme.SpacerDefaultHeight
            local spacer = Instance.new("Frame")
            spacer.Size = UDim2.new(1, 0, 0, height)
            spacer.BackgroundTransparency = 1
            spacer.Parent = page
            return spacer
        end
        function tabAPI:AddButton(btnOptions)
            local text = btnOptions.text or "Button"
            local callback = btnOptions.callback
            local height = btnOptions.height or theme.ButtonHeight
            local bgColor = btnOptions.bgColor or theme.AccentDarker
            local hoverColor = btnOptions.hoverColor or theme.Accent
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -8, 0, height)
            btn.BackgroundColor3 = bgColor
            btn.Text = text
            btn.TextColor3 = theme.Text
            btn.Font = theme.Font
            btn.TextSize = 15
            btn.TextTruncate = Enum.TextTruncate.AtEnd
            btn.Parent = page
            local c = Instance.new("UICorner")
            c.CornerRadius = theme.ElementCornerRadius
            c.Parent = btn
            btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(theme.AnimationSpeed), {
                    BackgroundColor3 = hoverColor
                }):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(theme.AnimationSpeed), {
                    BackgroundColor3 = bgColor
                }):Play()
            end)
            return btn
        end
        function tabAPI:AddToggle(togOptions)
            local name = togOptions.name or "Toggle"
            local default = togOptions.default or false
            local callback = togOptions.callback
            local height = togOptions.height or theme.ToggleHeight
            local bgColor = togOptions.bgColor or theme.AccentVeryDark
            local configKey = togOptions.configKey
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, height)
            frame.BackgroundColor3 = bgColor
            frame.Parent = page
            local c = Instance.new("UICorner")
            c.CornerRadius = theme.ElementCornerRadius
            c.Parent = frame
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.68, 0, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = theme.Text
            lbl.Font = theme.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            local box = Instance.new("Frame")
            box.Size = UDim2.new(0, 28, 0, 28)
            box.Position = UDim2.new(1, -40, 0.5, -14)
            box.BackgroundColor3 = default and theme.Accent or theme.AccentDarker
            box.Parent = frame
            local bc = Instance.new("UICorner")
            bc.CornerRadius = theme.ElementCornerRadius
            bc.Parent = box
            local state = default
            local api = {}
            function api:GetState()
                return state
            end
            function api:SetState(bool)
                state = bool
                TweenService:Create(box, TweenInfo.new(theme.AnimationSpeed), {
                    BackgroundColor3 = state and theme.Accent or theme.AccentDarker
                }):Play()
                if callback then callback(state) end
            end
            box.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    api:SetState(not state)
                end
            end)
            if configKey then
                window.Elements[configKey] = {type = "toggle", api = api}
            end
            return api
        end
        function tabAPI:AddSlider(sliderOptions)
            local name = sliderOptions.name or "Slider"
            local min = sliderOptions.min or 0
            local max = sliderOptions.max or 100
            local default = math.clamp(sliderOptions.default or min, min, max)
            local callback = sliderOptions.callback
            local height = sliderOptions.height or theme.SliderHeight
            local bgColor = sliderOptions.bgColor or theme.AccentVeryDark
            local step = sliderOptions.step or 1
            local configKey = sliderOptions.configKey
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, height)
            frame.BackgroundColor3 = bgColor
            frame.Parent = page
            local c = Instance.new("UICorner")
            c.CornerRadius = theme.ElementCornerRadius
            c.Parent = frame
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -20, 0, 24)
            lbl.Position = UDim2.new(0, 12, 0, 6)
            lbl.BackgroundTransparency = 1
            lbl.Text = name .. ": " .. default
            lbl.TextColor3 = theme.Text
            lbl.Font = theme.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -24, 0, 8)
            track.Position = UDim2.new(0, 12, 0, 38)
            track.BackgroundColor3 = theme.AccentDarker
            track.Parent = frame
            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(1, 0)
            tc.Parent = track
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = theme.Accent
            fill.Parent = track
            local fc = Instance.new("UICorner")
            fc.CornerRadius = UDim.new(1, 0)
            fc.Parent = fill
            local value = default
            local api = {}
            function api:GetValue()
                return value
            end
            function api:SetValue(newVal)
                newVal = math.clamp(newVal, min, max)
                newVal = math.floor((newVal / step) + 0.5) * step
                value = newVal
                fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                lbl.Text = name .. ": " .. value
                if callback then callback(value) end
            end
            local dragging = false
            local dragInputConn
            local dragEndConn
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragInputConn = UserInputService.InputChanged:Connect(function(input2)
                        if not dragging then return end
                        if input2.UserInputType == Enum.UserInputType.MouseMovement or input2.UserInputType == Enum.UserInputType.Touch then
                            local rel = math.clamp((input2.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                            local rawValue = min + (max - min) * rel
                            api:SetValue(rawValue)
                        end
                    end)
                    dragEndConn = UserInputService.InputEnded:Connect(function(input2)
                        if input2.UserInputType == Enum.UserInputType.MouseButton1 or input2.UserInputType == Enum.UserInputType.Touch then
                            dragging = false
                            if dragInputConn then dragInputConn:Disconnect() end
                            if dragEndConn then dragEndConn:Disconnect() end
                        end
                    end)
                end
            end)
            frame.Destroying:Connect(function()
                if dragInputConn then dragInputConn:Disconnect() end
                if dragEndConn then dragEndConn:Disconnect() end
            end)
            if configKey then
                window.Elements[configKey] = {type = "slider", api = api}
            end
            return api
        end
        function tabAPI:AddDropdown(dropOptions)
            local name = dropOptions.name or "Dropdown"
            local options = dropOptions.options or {"Option 1", "Option 2"}
            local default = dropOptions.default or options[1]
            local callback = dropOptions.callback
            local height = dropOptions.height or theme.DropdownHeight
            local bgColor = dropOptions.bgColor or theme.AccentVeryDark
            local configKey = dropOptions.configKey
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, height)
            frame.BackgroundColor3 = bgColor
            frame.Parent = page
            local c = Instance.new("UICorner")
            c.CornerRadius = theme.ElementCornerRadius
            c.Parent = frame
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.45, 0, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = theme.Text
            lbl.Font = theme.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            local selected = Instance.new("TextButton")
            selected.Size = UDim2.new(0.48, 0, 0, 32)
            selected.Position = UDim2.new(0.5, 0, 0, 4)
            selected.BackgroundColor3 = theme.AccentDarker
            selected.Text = default
            selected.TextColor3 = theme.Text
            selected.Font = theme.Font
            selected.TextSize = 14
            selected.TextTruncate = Enum.TextTruncate.AtEnd
            selected.Parent = frame
            local sc = Instance.new("UICorner")
            sc.CornerRadius = theme.ElementCornerRadius
            sc.Parent = selected
            local current = 1
            for i, v in ipairs(options) do
                if v == default then
                    current = i
                    break
                end
            end
            local selection = options[current]
            local api = {}
            function api:GetSelection()
                return selection
            end
            function api:SetSelection(choice)
                for i, v in ipairs(options) do
                    if v == choice then
                        current = i
                        selection = choice
                        selected.Text = choice
                        if callback then callback(selection) end
                        return
                    end
                end
            end
            selected.MouseButton1Click:Connect(function()
                current = (current % #options) + 1
                selection = options[current]
                selected.Text = selection
                if callback then callback(selection) end
            end)
            if configKey then
                window.Elements[configKey] = {type = "dropdown", api = api}
            end
            return api
        end
        function tabAPI:AddKeybind(keyOptions)
            local name = keyOptions.name or "Keybind"
            local defaultKey = keyOptions.defaultKey or Enum.KeyCode.Unknown
            local callback = keyOptions.callback
            local height = keyOptions.height or theme.KeybindHeight
            local bgColor = keyOptions.bgColor or theme.AccentVeryDark
            local allowMouse = keyOptions.allowMouse or false
            local configKey = keyOptions.configKey
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, height)
            frame.BackgroundColor3 = bgColor
            frame.Parent = page
            local c = Instance.new("UICorner")
            c.CornerRadius = theme.ElementCornerRadius
            c.Parent = frame
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.62, 0, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = theme.Text
            lbl.Font = theme.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 100, 0, 28)
            btn.Position = UDim2.new(1, -112, 0.5, -14)
            btn.BackgroundColor3 = theme.AccentDarker
            btn.Text = defaultKey.Name
            btn.TextColor3 = theme.Text
            btn.Font = theme.Font
            btn.TextSize = 14
            btn.TextTruncate = Enum.TextTruncate.AtEnd
            btn.Parent = frame
            local bc = Instance.new("UICorner")
            bc.CornerRadius = theme.ElementCornerRadius
            bc.Parent = btn
            local listening = false
            local currentKey = defaultKey
            local api = {}
            function api:GetKey()
                return currentKey
            end
            function api:SetKey(key)
                currentKey = key
                btn.Text = currentKey.Name
                if callback then callback(currentKey) end
            end
            btn.MouseButton1Click:Connect(function()
                listening = true
                btn.Text = "..."
            end)
            local inputConn = UserInputService.InputBegan:Connect(function(input, processed)
                if processed or not listening then return end
                listening = false
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    api:SetKey(input.KeyCode)
                elseif allowMouse and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3) then
                    api:SetKey(input.UserInputType)
                else
                    btn.Text = currentKey.Name
                    return
                end
            end)
            frame.Destroying:Connect(function()
                inputConn:Disconnect()
            end)
            if configKey then
                window.Elements[configKey] = {type = "keybind", api = api}
            end
            return api
        end
        function tabAPI:AddTextbox(tbOptions)
            local name = tbOptions.name or "Textbox"
            local default = tbOptions.default or ""
            local callback = tbOptions.callback
            local height = tbOptions.height or theme.TextboxHeight
            local bgColor = tbOptions.bgColor or theme.AccentVeryDark
            local configKey = tbOptions.configKey
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, height)
            frame.BackgroundColor3 = bgColor
            frame.Parent = page
            local c = Instance.new("UICorner")
            c.CornerRadius = theme.ElementCornerRadius
            c.Parent = frame
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.45, 0, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = theme.Text
            lbl.Font = theme.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            local textbox = Instance.new("TextBox")
            textbox.Size = UDim2.new(0.48, 0, 0, 32)
            textbox.Position = UDim2.new(0.5, 0, 0, 4)
            textbox.BackgroundColor3 = theme.AccentDarker
            textbox.Text = default
            textbox.TextColor3 = theme.Text
            textbox.Font = theme.Font
            textbox.TextSize = 14
            textbox.TextTruncate = Enum.TextTruncate.AtEnd
            textbox.Parent = frame
            local tbc = Instance.new("UICorner")
            tbc.CornerRadius = theme.ElementCornerRadius
            tbc.Parent = textbox
            local text = default
            local api = {}
            function api:GetText()
                return text
            end
            function api:SetText(newText)
                text = newText
                textbox.Text = newText
                if callback then callback(text) end
            end
            textbox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    api:SetText(textbox.Text)
                else
                    textbox.Text = text
                end
            end)
            if configKey then
                window.Elements[configKey] = {type = "textbox", api = api}
            end
            return api
        end
        function tabAPI:AddProgressBar(pbOptions)
            local name = pbOptions.name or "Progress"
            local max = pbOptions.max or 100
            local value = pbOptions.value or 0
            local height = pbOptions.height or 40
            local bgColor = pbOptions.bgColor or theme.AccentVeryDark
            local configKey = pbOptions.configKey
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, height)
            frame.BackgroundColor3 = bgColor
            frame.Parent = page
            local c = Instance.new("UICorner")
            c.CornerRadius = theme.ElementCornerRadius
            c.Parent = frame
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -20, 0, 20)
            lbl.Position = UDim2.new(0, 12, 0, 4)
            lbl.BackgroundTransparency = 1
            lbl.Text = name .. ": " .. math.floor((value / max) * 100) .. "%"
            lbl.TextColor3 = theme.Text
            lbl.Font = theme.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -24, 0, 8)
            track.Position = UDim2.new(0, 12, 0, 28)
            track.BackgroundColor3 = theme.AccentDarker
            track.Parent = frame
            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(1, 0)
            tc.Parent = track
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(value / max, 0, 1, 0)
            fill.BackgroundColor3 = theme.Accent
            fill.Parent = track
            local gradient = Instance.new("UIGradient")
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, theme.Accent),
                ColorSequenceKeypoint.new(1, theme.AccentDark)
            })
            gradient.Rotation = 0
            gradient.Parent = fill
            local fc = Instance.new("UICorner")
            fc.CornerRadius = UDim.new(1, 0)
            fc.Parent = fill
            local curValue = value
            local api = {}
            function api:GetValue()
                return curValue
            end
            function api:SetValue(newValue)
                newValue = math.clamp(newValue, 0, max)
                curValue = newValue
                TweenService:Create(fill, TweenInfo.new(theme.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(newValue / max, 0, 1, 0)
                }):Play()
                lbl.Text = name .. ": " .. math.floor((newValue / max) * 100) .. "%"
            end
            if configKey then
                window.Elements[configKey] = {type = "progress", api = api}
            end
            return api
        end
        return tabAPI
    end
    function window:SaveConfig(name)
        if not isfolder("Smile Hub GUI") then
            makefolder("Smile Hub GUI")
        end
        local cfg = {}
        for key, el in pairs(self.Elements) do
            if el.type == "toggle" then
                cfg[key] = el.api:GetState()
            elseif el.type == "slider" then
                cfg[key] = el.api:GetValue()
            elseif el.type == "dropdown" then
                cfg[key] = el.api:GetSelection()
            elseif el.type == "keybind" then
                cfg[key] = {EnumType = el.api:GetKey().EnumType.Name, Name = el.api:GetKey().Name}
            elseif el.type == "textbox" then
                cfg[key] = el.api:GetText()
            elseif el.type == "progress" then
                cfg[key] = el.api:GetValue()
            end
        end
        local json = HttpService:JSONEncode(cfg)
        writefile("Smile Hub GUI/" .. name .. ".json", json)
    end
    function window:LoadConfig(name)
        if not isfile("Smile Hub GUI/" .. name .. ".json") then return end
        local json = readfile("Smile Hub GUI/" .. name .. ".json")
        local cfg = HttpService:JSONDecode(json)
        for key, val in pairs(cfg) do
            local el = self.Elements[key]
            if el then
                if el.type == "toggle" then
                    el.api:SetState(val)
                elseif el.type == "slider" then
                    el.api:SetValue(val)
                elseif el.type == "dropdown" then
                    el.api:SetSelection(val)
                elseif el.type == "keybind" then
                    local enum = Enum[val.EnumType][val.Name]
                    el.api:SetKey(enum)
                elseif el.type == "textbox" then
                    el.api:SetText(val)
                elseif el.type == "progress" then
                    el.api:SetValue(val)
                end
            end
        end
    end
    main.Size = UDim2.new(0, 0, 0, 0)
    main.BackgroundTransparency = 1
    TweenService:Create(main, TweenInfo.new(theme.WindowOpenSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, width, 0, height),
        BackgroundTransparency = 0
    }):Play()
    return window
end
return SmileUILib
