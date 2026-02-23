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
local Players = game:GetService("Players")

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

SmileUILib.Windows = {}
SmileUILib.ThemeableElements = {}
SmileUILib.ButtonRegistry = {}

local function RegisterElement(windowId, element, property, themeKey)
    if not SmileUILib.ThemeableElements[windowId] then
        SmileUILib.ThemeableElements[windowId] = {}
    end
    table.insert(SmileUILib.ThemeableElements[windowId], {
        Element = element,
        Property = property,
        ThemeKey = themeKey
    })
end

local function RegisterButton(windowId, button, isAccentButton)
    if not SmileUILib.ButtonRegistry[windowId] then
        SmileUILib.ButtonRegistry[windowId] = {}
    end
    table.insert(SmileUILib.ButtonRegistry[windowId], {
        Button = button,
        IsAccentButton = isAccentButton
    })
end

function SmileUILib:SetTheme(newTheme)
    for key, value in pairs(newTheme) do
        self.Theme[key] = value
    end
    
    for windowId, elements in pairs(self.ThemeableElements) do
        for _, data in ipairs(elements) do
            if data.Element and data.Element.Parent then
                local color = self.Theme[data.ThemeKey]
                if color then
                    data.Element[data.Property] = color
                end
            end
        end
    end
    
    for windowId, buttons in pairs(self.ButtonRegistry) do
        for _, data in ipairs(buttons) do
            if data.Button and data.Button.Parent then
                if data.IsAccentButton then
                    data.Button.BackgroundColor3 = self.Theme.AccentDarker
                end
            end
        end
    end
end

local function Color3ToHSV(color)
    local r, g, b = color.R, color.G, color.B
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local delta = max - min
    
    local h, s, v = 0, 0, max
    
    if delta ~= 0 then
        s = delta / max
        if max == r then
            h = (g - b) / delta + (g < b and 6 or 0)
        elseif max == g then
            h = (b - r) / delta + 2
        else
            h = (r - g) / delta + 4
        end
        h = h / 6
    end
    
    return h, s, v
end

local function HSVToColor3(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    
    i = i % 6
    
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
    
    return Color3.new(r, g, b)
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
    
    local windowId = "Window_" .. math.floor(tick() * 1000)
    local screen = Instance.new("ScreenGui")
    screen.Name = "SmileUI_" .. windowId
    screen.ResetOnSpawn = false
    screen.Parent = CoreGui
    
    self.Windows[windowId] = screen
    
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, width, 0, height)
    main.Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2)
    main.BackgroundColor3 = theme.Background
    main.Active = true
    main.Parent = screen
    
    RegisterElement(windowId, main, "BackgroundColor3", "Background")
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = theme.CornerRadius
    corner.Parent = main
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.StrokeColor
    stroke.Thickness = theme.StrokeThickness
    stroke.Transparency = theme.StrokeTransparency
    stroke.Parent = main
    
    RegisterElement(windowId, stroke, "Color", "StrokeColor")
    
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, theme.WindowHeaderHeight)
    header.BackgroundColor3 = theme.Header
    header.BorderSizePixel = 0
    header.Parent = main
    
    RegisterElement(windowId, header, "BackgroundColor3", "Header")
    
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
    
    RegisterElement(windowId, titleLabel, "TextColor3", "Text")
    
    local minBtn = Instance.new("TextButton")
    minBtn.Size = theme.WindowMinButtonSize
    minBtn.Position = UDim2.new(1, -52, 0, 2)
    minBtn.BackgroundTransparency = 1
    minBtn.Text = "−"
    minBtn.TextColor3 = theme.Text
    minBtn.Font = theme.Font
    minBtn.TextSize = 34
    minBtn.Parent = header
    
    RegisterElement(windowId, minBtn, "TextColor3", "Text")
    
    local icon = Instance.new("Frame")
    icon.Size = theme.WindowIconSize
    icon.BackgroundColor3 = theme.Header
    icon.Visible = false
    icon.Active = true
    icon.Draggable = true
    icon.Parent = screen
    
    RegisterElement(windowId, icon, "BackgroundColor3", "Header")
    
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
    
    RegisterElement(windowId, iconTextBtn, "TextColor3", "Text")
    
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
    window.Id = windowId
    local activePage = nil
    local activeTabBtn = nil
    
    function window:SetTheme(newTheme)
        SmileUILib:SetTheme(newTheme)
    end
    
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
        
        RegisterElement(windowId, tabBtn, "TextColor3", "TextDim")
        
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
        
        RegisterElement(windowId, page, "ScrollBarImageColor3", "AccentDark")
        
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
            activeTabBtn = tabBtn
            
            for _, b in tabs:GetChildren() do
                if b:IsA("TextButton") then
                    local isActive = (b == tabBtn)
                    TweenService:Create(b, TweenInfo.new(theme.AnimationSpeed), {
                        BackgroundColor3 = isActive and theme.AccentDarker or Color3.fromRGB(0, 0, 0),
                        TextColor3 = isActive and theme.Text or theme.TextDim
                    }):Play()
                    
                    if isActive then
                        RegisterElement(windowId, b, "TextColor3", "Text")
                    else
                        RegisterElement(windowId, b, "TextColor3", "TextDim")
                    end
                end
            end
        end)
        
        if not activePage then
            tabBtn.BackgroundColor3 = theme.AccentDarker
            tabBtn.TextColor3 = theme.Text
            page.Visible = true
            activePage = page
            activeTabBtn = tabBtn
            RegisterElement(windowId, tabBtn, "TextColor3", "Text")
        end
        
        local tabAPI = {}
        tabAPI.page = page
        
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
            
            RegisterElement(windowId, lbl, "TextColor3", "Text")
            
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
            
            RegisterElement(windowId, lbl, "TextColor3", "TextDim")
            
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
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -8, 0, height)
            btn.BackgroundColor3 = theme.AccentDarker
            btn.Text = text
            btn.TextColor3 = theme.Text
            btn.Font = theme.Font
            btn.TextSize = 15
            btn.TextTruncate = Enum.TextTruncate.AtEnd
            btn.Parent = page
            
            RegisterElement(windowId, btn, "BackgroundColor3", "AccentDarker")
            RegisterElement(windowId, btn, "TextColor3", "Text")
            RegisterButton(windowId, btn, true)
            
            local c = Instance.new("UICorner")
            c.CornerRadius = theme.ElementCornerRadius
            c.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(theme.AnimationSpeed), {
                    BackgroundColor3 = SmileUILib.Theme.Accent
                }):Play()
            end)
            
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(theme.AnimationSpeed), {
                    BackgroundColor3 = SmileUILib.Theme.AccentDarker
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
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, height)
            frame.BackgroundColor3 = bgColor
            frame.Parent = page
            
            RegisterElement(windowId, frame, "BackgroundColor3", "AccentVeryDark")
            
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
            
            RegisterElement(windowId, lbl, "TextColor3", "Text")
            
            local box = Instance.new("Frame")
            box.Size = UDim2.new(0, 28, 0, 28)
            box.Position = UDim2.new(1, -40, 0.5, -14)
            box.BackgroundColor3 = default and theme.Accent or theme.AccentDarker
            box.Parent = frame
            
            RegisterElement(windowId, box, "BackgroundColor3", default and "Accent" or "AccentDarker")
            
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
                    BackgroundColor3 = state and SmileUILib.Theme.Accent or SmileUILib.Theme.AccentDarker
                }):Play()
                
                RegisterElement(windowId, box, "BackgroundColor3", state and "Accent" or "AccentDarker")
                
                if callback then callback(state) end
            end
            
            box.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    api:SetState(not state)
                end
            end)
            
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
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, height)
            frame.BackgroundColor3 = bgColor
            frame.Parent = page
            
            RegisterElement(windowId, frame, "BackgroundColor3", "AccentVeryDark")
            
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
            
            RegisterElement(windowId, lbl, "TextColor3", "Text")
            
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -24, 0, 8)
            track.Position = UDim2.new(0, 12, 0, 38)
            track.BackgroundColor3 = theme.AccentDarker
            track.Parent = frame
            
            RegisterElement(windowId, track, "BackgroundColor3", "AccentDarker")
            
            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(1, 0)
            tc.Parent = track
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = theme.Accent
            fill.Parent = track
            
            RegisterElement(windowId, fill, "BackgroundColor3", "Accent")
            
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
            
            return api
        end
        
        function tabAPI:AddDropdown(dropOptions)
            local name = dropOptions.name or "Dropdown"
            local options = dropOptions.options or {"Option 1", "Option 2"}
            local default = dropOptions.default or options[1]
            local callback = dropOptions.callback
            local height = dropOptions.height or theme.DropdownHeight
            local bgColor = dropOptions.bgColor or theme.AccentVeryDark
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, height)
            frame.BackgroundColor3 = bgColor
            frame.Parent = page
            
            RegisterElement(windowId, frame, "BackgroundColor3", "AccentVeryDark")
            
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
            
            RegisterElement(windowId, lbl, "TextColor3", "Text")
            
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
            
            RegisterElement(windowId, selected, "BackgroundColor3", "AccentDarker")
            RegisterElement(windowId, selected, "TextColor3", "Text")
            RegisterButton(windowId, selected, true)
            
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
            
            selected.MouseEnter:Connect(function()
                TweenService:Create(selected, TweenInfo.new(theme.AnimationSpeed), {
                    BackgroundColor3 = SmileUILib.Theme.Accent
                }):Play()
            end)
            
            selected.MouseLeave:Connect(function()
                TweenService:Create(selected, TweenInfo.new(theme.AnimationSpeed), {
                    BackgroundColor3 = SmileUILib.Theme.AccentDarker
                }):Play()
            end)
            
            return api
        end
        
        function tabAPI:AddKeybind(keyOptions)
            local name = keyOptions.name or "Keybind"
            local defaultKey = keyOptions.defaultKey or Enum.KeyCode.Unknown
            local callback = keyOptions.callback
            local height = keyOptions.height or theme.KeybindHeight
            local bgColor = keyOptions.bgColor or theme.AccentVeryDark
            local allowMouse = keyOptions.allowMouse or false
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, height)
            frame.BackgroundColor3 = bgColor
            frame.Parent = page
            
            RegisterElement(windowId, frame, "BackgroundColor3", "AccentVeryDark")
            
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
            
            RegisterElement(windowId, lbl, "TextColor3", "Text")
            
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
            
            RegisterElement(windowId, btn, "BackgroundColor3", "AccentDarker")
            RegisterElement(windowId, btn, "TextColor3", "Text")
            RegisterButton(windowId, btn, true)
            
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
            
            btn.MouseEnter:Connect(function()
                if not listening then
                    TweenService:Create(btn, TweenInfo.new(theme.AnimationSpeed), {
                        BackgroundColor3 = SmileUILib.Theme.Accent
                    }):Play()
                end
            end)
            
            btn.MouseLeave:Connect(function()
                if not listening then
                    TweenService:Create(btn, TweenInfo.new(theme.AnimationSpeed), {
                        BackgroundColor3 = SmileUILib.Theme.AccentDarker
                    }):Play()
                end
            end)
            
            frame.Destroying:Connect(function()
                inputConn:Disconnect()
            end)
            
            return api
        end
        
        function tabAPI:AddTextbox(tbOptions)
            local name = tbOptions.name or "Textbox"
            local default = tbOptions.default or ""
            local callback = tbOptions.callback
            local height = tbOptions.height or theme.TextboxHeight
            local bgColor = tbOptions.bgColor or theme.AccentVeryDark
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, height)
            frame.BackgroundColor3 = bgColor
            frame.Parent = page
            
            RegisterElement(windowId, frame, "BackgroundColor3", "AccentVeryDark")
            
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
            
            RegisterElement(windowId, lbl, "TextColor3", "Text")
            
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
            
            RegisterElement(windowId, textbox, "BackgroundColor3", "AccentDarker")
            RegisterElement(windowId, textbox, "TextColor3", "Text")
            
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
            
            return api
        end
        
        function tabAPI:AddProgressBar(pbOptions)
            local name = pbOptions.name or "Progress"
            local max = pbOptions.max or 100
            local value = pbOptions.value or 0
            local height = pbOptions.height or 40
            local bgColor = pbOptions.bgColor or theme.AccentVeryDark
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, height)
            frame.BackgroundColor3 = bgColor
            frame.Parent = page
            
            RegisterElement(windowId, frame, "BackgroundColor3", "AccentVeryDark")
            
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
            
            RegisterElement(windowId, lbl, "TextColor3", "Text")
            
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -24, 0, 8)
            track.Position = UDim2.new(0, 12, 0, 28)
            track.BackgroundColor3 = theme.AccentDarker
            track.Parent = frame
            
            RegisterElement(windowId, track, "BackgroundColor3", "AccentDarker")
            
            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(1, 0)
            tc.Parent = track
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(value / max, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
            fill.Parent = track
            
            local gradient = Instance.new("UIGradient")
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 160, 160)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100))
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
            
            return api
        end
        
        function tabAPI:AddColorPicker(cpOptions)
            local name = cpOptions.name or "Color Picker"
            local default = cpOptions.default or Color3.fromRGB(0, 255, 0)
            local callback = cpOptions.callback
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 40)
            frame.BackgroundColor3 = theme.AccentVeryDark
            frame.Parent = page
            
            RegisterElement(windowId, frame, "BackgroundColor3", "AccentVeryDark")
            
            local c = Instance.new("UICorner")
            c.CornerRadius = theme.ElementCornerRadius
            c.Parent = frame
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -70, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = theme.Text
            lbl.Font = theme.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            
            RegisterElement(windowId, lbl, "TextColor3", "Text")
            
            local colorBox = Instance.new("TextButton")
            colorBox.Size = UDim2.new(0, 50, 0, 28)
            colorBox.Position = UDim2.new(1, -62, 0.5, -14)
            colorBox.BackgroundColor3 = default
            colorBox.Text = ""
            colorBox.AutoButtonColor = false
            colorBox.Parent = frame
            
            local cbc = Instance.new("UICorner")
            cbc.CornerRadius = UDim.new(0, 4)
            cbc.Parent = colorBox
            
            local boxStroke = Instance.new("UIStroke")
            boxStroke.Color = theme.StrokeColor
            boxStroke.Thickness = 2
            boxStroke.Parent = colorBox
            
            RegisterElement(windowId, boxStroke, "Color", "StrokeColor")
            
            colorBox.MouseEnter:Connect(function()
                TweenService:Create(boxStroke, TweenInfo.new(0.2), {
                    Thickness = 3
                }):Play()
            end)
            
            colorBox.MouseLeave:Connect(function()
                TweenService:Create(boxStroke, TweenInfo.new(0.2), {
                    Thickness = 2
                }):Play()
            end)
            
            local modalOpen = false
            local modalFrame = nil
            
            local function closeModal()
                if modalFrame then
                    TweenService:Create(modalFrame, TweenInfo.new(0.2), {
                        Size = UDim2.new(0, 280, 0, 0),
                        BackgroundTransparency = 1
                    }):Play()
                    task.wait(0.2)
                    if modalFrame then
                        modalFrame:Destroy()
                        modalFrame = nil
                    end
                    modalOpen = false
                end
            end
            
            local function openModal()
                if modalOpen then
                    closeModal()
                    return
                end
                
                modalOpen = true
                
                local overlay = Instance.new("Frame")
                overlay.Name = "ColorPickerModal"
                overlay.Size = UDim2.new(0, 280, 0, 320)
                overlay.Position = UDim2.new(0, frame.AbsolutePosition.X + frame.AbsoluteSize.X - 280, 0, frame.AbsolutePosition.Y + 45)
                overlay.BackgroundColor3 = SmileUILib.Theme.Background
                overlay.BorderSizePixel = 0
                overlay.ZIndex = 100
                overlay.Parent = screen
                
                modalFrame = overlay
                
                local oc = Instance.new("UICorner")
                oc.CornerRadius = UDim.new(0, 8)
                oc.Parent = overlay
                
                local os = Instance.new("UIStroke")
                os.Color = SmileUILib.Theme.StrokeColor
                os.Thickness = 2
                os.Parent = overlay
                
                local mHeader = Instance.new("Frame")
                mHeader.Size = UDim2.new(1, 0, 0, 32)
                mHeader.BackgroundColor3 = SmileUILib.Theme.Header
                mHeader.BorderSizePixel = 0
                mHeader.ZIndex = 101
                mHeader.Parent = overlay
                
                local mhc = Instance.new("UICorner")
                mhc.CornerRadius = UDim.new(0, 6)
                mhc.Parent = mHeader
                
                local mTitle = Instance.new("TextLabel")
                mTitle.Size = UDim2.new(1, -40, 1, 0)
                mTitle.Position = UDim2.new(0, 12, 0, 0)
                mTitle.BackgroundTransparency = 1
                mTitle.Text = "Pick a Color"
                mTitle.TextColor3 = SmileUILib.Theme.Text
                mTitle.Font = SmileUILib.Theme.Font
                mTitle.TextSize = 16
                mTitle.TextXAlignment = Enum.TextXAlignment.Left
                mTitle.ZIndex = 102
                mTitle.Parent = mHeader
                
                local closeBtn = Instance.new("TextButton")
                closeBtn.Size = UDim2.new(0, 28, 0, 28)
                closeBtn.Position = UDim2.new(1, -32, 0, 2)
                closeBtn.BackgroundTransparency = 1
                closeBtn.Text = "×"
                closeBtn.TextColor3 = SmileUILib.Theme.Text
                closeBtn.Font = SmileUILib.Theme.Font
                closeBtn.TextSize = 24
                closeBtn.ZIndex = 102
                closeBtn.Parent = mHeader
                
                closeBtn.MouseButton1Click:Connect(closeModal)
                
                local h, s, v = Color3ToHSV(default)
                local currentColor = default
                
                local spectrumFrame = Instance.new("Frame")
                spectrumFrame.Size = UDim2.new(0, 200, 0, 140)
                spectrumFrame.Position = UDim2.new(0, 12, 0, 44)
                spectrumFrame.BackgroundColor3 = Color3.new(1, 1, 1)
                spectrumFrame.BorderSizePixel = 0
                spectrumFrame.ZIndex = 101
                spectrumFrame.Parent = overlay
                
                local sfc = Instance.new("UICorner")
                sfc.CornerRadius = UDim.new(0, 4)
                sfc.Parent = spectrumFrame
                
                local satGradient = Instance.new("UIGradient")
                satGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                    ColorSequenceKeypoint.new(1, HSVToColor3(h, 1, 1))
                })
                satGradient.Parent = spectrumFrame
                
                local valOverlay = Instance.new("Frame")
                valOverlay.Size = UDim2.new(1, 0, 1, 0)
                valOverlay.BackgroundTransparency = 0
                valOverlay.BorderSizePixel = 0
                valOverlay.ZIndex = 102
                valOverlay.Parent = spectrumFrame
                
                local voc = Instance.new("UICorner")
                voc.CornerRadius = UDim.new(0, 4)
                voc.Parent = valOverlay
                
                local valGradient = Instance.new("UIGradient")
                valGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
                    ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
                })
                valGradient.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                })
                valGradient.Rotation = 90
                valGradient.Parent = valOverlay
                
                local cursor = Instance.new("Frame")
                cursor.Size = UDim2.new(0, 10, 0, 10)
                cursor.Position = UDim2.new(s, -5, 1 - v, -5)
                cursor.BackgroundColor3 = Color3.new(1, 1, 1)
                cursor.BorderSizePixel = 2
                cursor.BorderColor3 = Color3.new(0, 0, 0)
                cursor.ZIndex = 103
                cursor.Parent = spectrumFrame
                
                local cc = Instance.new("UICorner")
                cc.CornerRadius = UDim.new(1, 0)
                cc.Parent = cursor
                
                local hueFrame = Instance.new("Frame")
                hueFrame.Size = UDim2.new(0, 200, 0, 16)
                hueFrame.Position = UDim2.new(0, 12, 0, 190)
                hueFrame.BackgroundColor3 = Color3.new(1, 1, 1)
                hueFrame.BorderSizePixel = 0
                hueFrame.ZIndex = 101
                hueFrame.Parent = overlay
                
                local hfc = Instance.new("UICorner")
                hfc.CornerRadius = UDim.new(0, 8)
                hfc.Parent = hueFrame
                
                local hueGradient = Instance.new("UIGradient")
                hueGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                })
                hueGradient.Parent = hueFrame
                
                local hueCursor = Instance.new("Frame")
                hueCursor.Size = UDim2.new(0, 6, 1, 4)
                hueCursor.Position = UDim2.new(h, -3, 0, -2)
                hueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
                hueCursor.BorderSizePixel = 2
                hueCursor.BorderColor3 = Color3.new(0, 0, 0)
                hueCursor.ZIndex = 102
                hueCursor.Parent = hueFrame
                
                local previewSection = Instance.new("Frame")
                previewSection.Size = UDim2.new(0, 50, 0, 140)
                previewSection.Position = UDim2.new(0, 220, 0, 44)
                previewSection.BackgroundTransparency = 1
                previewSection.ZIndex = 101
                previewSection.Parent = overlay
                
                local bigPreview = Instance.new("Frame")
                bigPreview.Size = UDim2.new(1, 0, 0, 50)
                bigPreview.BackgroundColor3 = currentColor
                bigPreview.BorderSizePixel = 2
                bigPreview.BorderColor3 = SmileUILib.Theme.StrokeColor
                bigPreview.ZIndex = 101
                bigPreview.Parent = previewSection
                
                local bpc = Instance.new("UICorner")
                bpc.CornerRadius = UDim.new(0, 6)
                bpc.Parent = bigPreview
                
                local rLabel = Instance.new("TextLabel")
                rLabel.Size = UDim2.new(1, 0, 0, 18)
                rLabel.Position = UDim2.new(0, 0, 0, 58)
                rLabel.BackgroundTransparency = 1
                rLabel.Text = "R: 0"
                rLabel.TextColor3 = SmileUILib.Theme.Text
                rLabel.Font = SmileUILib.Theme.Font
                rLabel.TextSize = 11
                rLabel.TextXAlignment = Enum.TextXAlignment.Left
                rLabel.ZIndex = 101
                rLabel.Parent = previewSection
                
                local gLabel = Instance.new("TextLabel")
                gLabel.Size = UDim2.new(1, 0, 0, 18)
                gLabel.Position = UDim2.new(0, 0, 0, 76)
                gLabel.BackgroundTransparency = 1
                gLabel.Text = "G: 255"
                gLabel.TextColor3 = SmileUILib.Theme.Text
                gLabel.Font = SmileUILib.Theme.Font
                gLabel.TextSize = 11
                gLabel.TextXAlignment = Enum.TextXAlignment.Left
                gLabel.ZIndex = 101
                gLabel.Parent = previewSection
                
                local bLabel = Instance.new("TextLabel")
                bLabel.Size = UDim2.new(1, 0, 0, 18)
                bLabel.Position = UDim2.new(0, 0, 0, 94)
                bLabel.BackgroundTransparency = 1
                bLabel.Text = "B: 0"
                bLabel.TextColor3 = SmileUILib.Theme.Text
                bLabel.Font = SmileUILib.Theme.Font
                bLabel.TextSize = 11
                bLabel.TextXAlignment = Enum.TextXAlignment.Left
                bLabel.ZIndex = 101
                bLabel.Parent = previewSection
                
                local hexLabel = Instance.new("TextLabel")
                hexLabel.Size = UDim2.new(1, 0, 0, 20)
                hexLabel.Position = UDim2.new(0, 0, 0, 118)
                hexLabel.BackgroundTransparency = 1
                hexLabel.Text = "#00FF00"
                hexLabel.TextColor3 = SmileUILib.Theme.TextDim
                hexLabel.Font = SmileUILib.Theme.Font
                hexLabel.TextSize = 10
                hexLabel.TextXAlignment = Enum.TextXAlignment.Center
                hexLabel.ZIndex = 101
                hexLabel.Parent = previewSection
                
                local confirmBtn = Instance.new("TextButton")
                confirmBtn.Size = UDim2.new(0, 120, 0, 32)
                confirmBtn.Position = UDim2.new(0.5, -60, 0, 270)
                confirmBtn.BackgroundColor3 = SmileUILib.Theme.Accent
                confirmBtn.Text = "Apply Color"
                confirmBtn.TextColor3 = Color3.new(0, 0, 0)
                confirmBtn.Font = SmileUILib.Theme.Font
                confirmBtn.TextSize = 14
                confirmBtn.ZIndex = 101
                confirmBtn.Parent = overlay
                
                local cbc = Instance.new("UICorner")
                cbc.CornerRadius = UDim.new(0, 6)
                cbc.Parent = confirmBtn
                
                local function updateColor()
                    currentColor = HSVToColor3(h, s, v)
                    bigPreview.BackgroundColor3 = currentColor
                    colorBox.BackgroundColor3 = currentColor
                    
                    local r = math.floor(currentColor.R * 255)
                    local g = math.floor(currentColor.G * 255)
                    local b = math.floor(currentColor.B * 255)
                    
                    rLabel.Text = "R: " .. r
                    gLabel.Text = "G: " .. g
                    bLabel.Text = "B: " .. b
                    hexLabel.Text = string.format("#%02X%02X%02X", r, g, b)
                end
                
                local spectrumDragging = false
                spectrumFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        spectrumDragging = true
                        local relX = math.clamp((input.Position.X - spectrumFrame.AbsolutePosition.X) / spectrumFrame.AbsoluteSize.X, 0, 1)
                        local relY = math.clamp((input.Position.Y - spectrumFrame.AbsolutePosition.Y) / spectrumFrame.AbsoluteSize.Y, 0, 1)
                        s = relX
                        v = 1 - relY
                        cursor.Position = UDim2.new(s, -5, 1 - v, -5)
                        updateColor()
                    end
                end)
                
                spectrumFrame.InputChanged:Connect(function(input)
                    if spectrumDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local relX = math.clamp((input.Position.X - spectrumFrame.AbsolutePosition.X) / spectrumFrame.AbsoluteSize.X, 0, 1)
                        local relY = math.clamp((input.Position.Y - spectrumFrame.AbsolutePosition.Y) / spectrumFrame.AbsoluteSize.Y, 0, 1)
                        s = relX
                        v = 1 - relY
                        cursor.Position = UDim2.new(s, -5, 1 - v, -5)
                        updateColor()
                    end
                end)
                
                local hueDragging = false
                hueFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        hueDragging = true
                        local relX = math.clamp((input.Position.X - hueFrame.AbsolutePosition.X) / hueFrame.AbsoluteSize.X, 0, 1)
                        h = relX
                        hueCursor.Position = UDim2.new(h, -3, 0, -2)
                        satGradient.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                            ColorSequenceKeypoint.new(1, HSVToColor3(h, 1, 1))
                        })
                        updateColor()
                    end
                end)
                
                hueFrame.InputChanged:Connect(function(input)
                    if hueDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local relX = math.clamp((input.Position.X - hueFrame.AbsolutePosition.X) / hueFrame.AbsoluteSize.X, 0, 1)
                        h = relX
                        hueCursor.Position = UDim2.new(h, -3, 0, -2)
                        satGradient.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                            ColorSequenceKeypoint.new(1, HSVToColor3(h, 1, 1))
                        })
                        updateColor()
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        spectrumDragging = false
                        hueDragging = false
                    end
                end)
                
                confirmBtn.MouseButton1Click:Connect(function()
                    if callback then callback(currentColor) end
                    closeModal()
                    SmileUILib:Notify({
                        title = "Color Applied",
                        message = "New color has been set!",
                        duration = 2
                    })
                end)
                
                confirmBtn.MouseEnter:Connect(function()
                    TweenService:Create(confirmBtn, TweenInfo.new(0.2), {
                        BackgroundColor3 = SmileUILib.Theme.AccentDark
                    }):Play()
                end)
                
                confirmBtn.MouseLeave:Connect(function()
                    TweenService:Create(confirmBtn, TweenInfo.new(0.2), {
                        BackgroundColor3 = SmileUILib.Theme.Accent
                    }):Play()
                end)
                
                overlay.Size = UDim2.new(0, 280, 0, 0)
                overlay.BackgroundTransparency = 1
                TweenService:Create(overlay, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 280, 0, 320),
                    BackgroundTransparency = 0
                }):Play()
            end
            
            colorBox.MouseButton1Click:Connect(openModal)
            
            local api = {}
            local currentColor = default
            
            function api:GetColor()
                return currentColor
            end
            
            function api:SetColor(color)
                currentColor = color
                colorBox.BackgroundColor3 = color
                if callback then callback(color) end
            end
            
            return api
        end
        
        return tabAPI
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
