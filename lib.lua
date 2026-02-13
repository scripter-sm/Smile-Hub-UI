--[[
  _________ .__.__ ___ ___ ___.
 / _____/ _____ |__| | ____ / | \ __ _\_ |__
 \_____ \ / \| | | _/ __ \ / ~ \ | \ __ \
 / \ Y Y \ | |_\ ___/ \ Y / | / \_\ \
/_______ /__|_| /__|____/\___ > \___|_ /|____/|___ /
        \/ \/ \/ \/ \/
--]]
local SmileUILib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local DEFAULT_THEME = {
    Background = Color3.fromRGB(25, 25, 25),
    Header = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(0, 200, 0),
    AccentDark = Color3.fromRGB(0, 150, 0),
    AccentDarker = Color3.fromRGB(0, 100, 0),
    AccentVeryDark = Color3.fromRGB(15, 15, 15),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(200, 200, 200),
    StrokeColor = Color3.fromRGB(255, 255, 255),
    CornerRadius = UDim.new(0, 8),
    StrokeThickness = 1,
    StrokeTransparency = 0.8,
    Font = Enum.Font.Gotham,
    BackgroundTransparency = 0.6,
    HeaderTransparency = 0.5,
    ElementTransparency = 0.4
}
local blurEffect
local function initBlur()
    if not blurEffect then
        blurEffect = Instance.new("BlurEffect")
        blurEffect.Size = 24
        blurEffect.Parent = Lighting
    end
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
    notifContainer.Size = UDim2.new(0, 420, 0.8, 0)
    notifContainer.Position = UDim2.new(1, 0, 0, 20)
    notifContainer.AnchorPoint = Vector2.new(1, 0)
    notifContainer.BackgroundTransparency = 1
    notifContainer.ClipsDescendants = true
    notifContainer.Parent = screen
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = notifContainer
end
function SmileUILib:Notify(title, message, duration)
    initNotifications()
    initBlur()
    duration = duration or 3.7
    local notif = Instance.new("Frame")
    notif.BackgroundColor3 = DEFAULT_THEME.Background
    notif.BackgroundTransparency = 1
    notif.BorderSizePixel = 0
    notif.ZIndex = 999999
    notif.Parent = notifContainer
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif
    local stroke = Instance.new("UIStroke")
    stroke.Color = DEFAULT_THEME.StrokeColor
    stroke.Thickness = 1
    stroke.Transparency = 1
    stroke.Parent = notif
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 34)
    header.BackgroundColor3 = DEFAULT_THEME.Header
    header.BackgroundTransparency = 1
    header.BorderSizePixel = 0
    header.Parent = notif
    local hcorner = Instance.new("UICorner")
    hcorner.CornerRadius = UDim.new(0, 8)
    hcorner.Parent = header
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 1, 0)
    titleLbl.Position = UDim2.new(0, 14, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "> " .. (title or "INFO"):upper()
    titleLbl.TextTransparency = 1
    titleLbl.TextColor3 = DEFAULT_THEME.Text
    titleLbl.Font = DEFAULT_THEME.Font
    titleLbl.TextSize = 17
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    titleLbl.Parent = header
    local content = Instance.new("TextLabel")
    content.Position = UDim2.new(0, 10, 0, 36)
    content.BackgroundTransparency = 1
    content.Text = message or ""
    content.TextTransparency = 1
    content.TextColor3 = DEFAULT_THEME.Text
    content.Font = DEFAULT_THEME.Font
    content.TextSize = 14
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.VerticalAlignment.Top
    content.TextWrapped = true
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.Size = UDim2.new(1, -20, 0, 0)
    content.Parent = notif
    local textHeight = content.TextBounds.Y
    local notifHeight = 36 + textHeight + 10
    notif.Size = UDim2.new(0, 0, 0, notifHeight)
    local ti = TweenInfo.new(0.5, Enum.EasingStyle.Expo, Enum.EasingDirection.Out)
    TweenService:Create(notif, ti, {Size = UDim2.new(0, 400, 0, notifHeight), BackgroundTransparency = DEFAULT_THEME.BackgroundTransparency}):Play()
    TweenService:Create(header, ti, {BackgroundTransparency = DEFAULT_THEME.HeaderTransparency}):Play()
    TweenService:Create(titleLbl, ti, {TextTransparency = 0}):Play()
    TweenService:Create(content, ti, {TextTransparency = 0}):Play()
    TweenService:Create(stroke, ti, {Transparency = DEFAULT_THEME.StrokeTransparency}):Play()
    task.delay(duration, function()
        local out_ti = TweenInfo.new(0.4, Enum.EasingStyle.Expo, Enum.EasingDirection.In)
        TweenService:Create(notif, out_ti, {Size = UDim2.new(0, 0, 0, notifHeight), BackgroundTransparency = 1}):Play()
        TweenService:Create(header, out_ti, {BackgroundTransparency = 1}):Play()
        TweenService:Create(titleLbl, out_ti, {TextTransparency = 1}):Play()
        TweenService:Create(content, out_ti, {TextTransparency = 1}):Play()
        local out = TweenService:Create(stroke, out_ti, {Transparency = 1})
        out:Play()
        out.Completed:Connect(function() notif:Destroy() end)
    end)
end
function SmileUILib:CreateWindow(title, width, height)
    initBlur()
    width = width or 580
    height = height or 420
    local screen = Instance.new("ScreenGui")
    screen.Name = "SmileUI_" .. math.floor(tick()*1000)
    screen.ResetOnSpawn = false
    screen.Parent = CoreGui
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 0, 0, 0)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.BackgroundColor3 = DEFAULT_THEME.Background
    main.BackgroundTransparency = 1
    main.Active = true
    main.Draggable = true
    main.Parent = screen
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = main
    local stroke = Instance.new("UIStroke")
    stroke.Color = DEFAULT_THEME.StrokeColor
    stroke.Thickness = DEFAULT_THEME.StrokeThickness
    stroke.Transparency = DEFAULT_THEME.StrokeTransparency
    stroke.Parent = main
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 44)
    header.BackgroundColor3 = DEFAULT_THEME.Header
    header.BackgroundTransparency = DEFAULT_THEME.HeaderTransparency
    header.BorderSizePixel = 0
    header.Parent = main
    local hcorner = Instance.new("UICorner")
    hcorner.CornerRadius = UDim.new(0, 10)
    hcorner.Parent = header
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -120, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "SMILE UI"
    titleLabel.TextColor3 = DEFAULT_THEME.Text
    titleLabel.Font = DEFAULT_THEME.Font
    titleLabel.TextSize = 21
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = header
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -44, 0, 2)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.TextColor3 = DEFAULT_THEME.Text
    closeBtn.Font = DEFAULT_THEME.Font
    closeBtn.TextSize = 28
    closeBtn.Parent = header
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 40, 0, 40)
    minBtn.Position = UDim2.new(1, -88, 0, 2)
    minBtn.BackgroundTransparency = 1
    minBtn.Text = "−"
    minBtn.TextColor3 = DEFAULT_THEME.Text
    minBtn.Font = DEFAULT_THEME.Font
    minBtn.TextSize = 34
    minBtn.Parent = header
    closeBtn.MouseButton1Click:Connect(function()
        screen:Destroy()
        if blurEffect then blurEffect:Destroy() end
    end)
    local icon = Instance.new("Frame")
    icon.Size = UDim2.new(0, 56, 0, 56)
    icon.BackgroundColor3 = DEFAULT_THEME.Header
    icon.BackgroundTransparency = DEFAULT_THEME.HeaderTransparency
    icon.Visible = false
    icon.Draggable = true
    icon.Parent = screen
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = icon
    local iconText = Instance.new("TextButton")
    iconText.Size = UDim2.new(1, 0, 1, 0)
    iconText.BackgroundTransparency = 1
    iconText.Text = "$"
    iconText.TextColor3 = DEFAULT_THEME.Text
    iconText.Font = DEFAULT_THEME.Font
    iconText.TextSize = 36
    iconText.Parent = icon
    minBtn.MouseButton1Click:Connect(function()
        main.Visible = false
        icon.Position = UDim2.new(0, main.AbsolutePosition.X + main.AbsoluteSize.X - 56, 0, main.AbsolutePosition.Y)
        icon.Visible = true
    end)
    iconText.MouseButton1Click:Connect(function()
        icon.Visible = false
        main.Visible = true
    end)
    local tabs = Instance.new("Frame")
    tabs.Size = UDim2.new(0, 152, 1, -52)
    tabs.Position = UDim2.new(0, 12, 0, 48)
    tabs.BackgroundTransparency = 1
    tabs.Parent = main
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 7)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabs
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -176, 1, -52)
    content.Position = UDim2.new(0, 164, 0, 48)
    content.BackgroundTransparency = 1
    content.Parent = main
    local window = {}
    local activePage = nil
    function window:AddTab(tabName)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, -12, 0, 38)
        tabBtn.BackgroundColor3 = DEFAULT_THEME.AccentVeryDark
        tabBtn.BackgroundTransparency = DEFAULT_THEME.ElementTransparency
        tabBtn.Text = tabName
        tabBtn.TextColor3 = DEFAULT_THEME.TextDim
        tabBtn.Font = DEFAULT_THEME.Font
        tabBtn.TextSize = 15
        tabBtn.AutoButtonColor = false
        tabBtn.TextTruncate = Enum.TextTruncate.AtEnd
        tabBtn.Parent = tabs
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = tabBtn
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = DEFAULT_THEME.StrokeColor
        btnStroke.Thickness = 0.5
        btnStroke.Transparency = 0.9
        btnStroke.Parent = tabBtn
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = DEFAULT_THEME.AccentDark
        page.ScrollBarImageTransparency = 0.5
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
                TweenService:Create(tabBtn, TweenInfo.new(0.25, Enum.EasingStyle.Expo), {
                    BackgroundColor3 = DEFAULT_THEME.AccentDarker
                }):Play()
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if activePage ~= page then
                TweenService:Create(tabBtn, TweenInfo.new(0.25, Enum.EasingStyle.Expo), {
                    BackgroundColor3 = DEFAULT_THEME.AccentVeryDark
                }):Play()
            end
        end)
        tabBtn.MouseButton1Click:Connect(function()
            if activePage then
                TweenService:Create(activePage, TweenInfo.new(0.3, Enum.EasingStyle.Expo), {CanvasPosition = Vector2.new(0, 0)}):Play()
                activePage.Visible = false
            end
            page.Visible = true
            activePage = page
            for _, b in tabs:GetChildren() do
                if b:IsA("TextButton") then
                    TweenService:Create(b, TweenInfo.new(0.25, Enum.EasingStyle.Expo), {
                        BackgroundColor3 = (b == tabBtn) and DEFAULT_THEME.AccentDark or DEFAULT_THEME.AccentVeryDark,
                        TextColor3 = (b == tabBtn) and DEFAULT_THEME.Text or DEFAULT_THEME.TextDim
                    }):Play()
                end
            end
        end)
        if not activePage then
            tabBtn.BackgroundColor3 = DEFAULT_THEME.AccentDark
            tabBtn.TextColor3 = DEFAULT_THEME.Text
            page.Visible = true
            activePage = page
        end
        local tabAPI = {}
        function tabAPI:AddSection(title)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 0)
            lbl.AutomaticSize = Enum.AutomaticSize.Y
            lbl.BackgroundTransparency = 1
            lbl.Text = title
            lbl.TextColor3 = DEFAULT_THEME.Text
            lbl.Font = DEFAULT_THEME.Font
            lbl.TextSize = 16
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextWrapped = true
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = page
            return lbl
        end
        function tabAPI:AddLabel(text)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 0)
            lbl.AutomaticSize = Enum.AutomaticSize.Y
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = DEFAULT_THEME.TextDim
            lbl.Font = DEFAULT_THEME.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextWrapped = true
            lbl.Parent = page
            return lbl
        end
        function tabAPI:AddSpacer(height)
            local spacer = Instance.new("Frame")
            spacer.Size = UDim2.new(1, 0, 0, height or 8)
            spacer.BackgroundTransparency = 1
            spacer.Parent = page
            return spacer
        end
        function tabAPI:AddToggle(name, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 36)
            frame.BackgroundColor3 = DEFAULT_THEME.AccentVeryDark
            frame.BackgroundTransparency = DEFAULT_THEME.ElementTransparency
            frame.Parent = page
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 5)
            c.Parent = frame
            local frameStroke = Instance.new("UIStroke")
            frameStroke.Color = DEFAULT_THEME.StrokeColor
            frameStroke.Thickness = 0.5
            frameStroke.Transparency = 0.9
            frameStroke.Parent = frame
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.68, 0, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = DEFAULT_THEME.Text
            lbl.Font = DEFAULT_THEME.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            local track = Instance.new("Frame")
            track.Size = UDim2.new(0, 50, 0, 24)
            track.Position = UDim2.new(1, -62, 0.5, -12)
            track.BackgroundColor3 = DEFAULT_THEME.AccentDarker
            track.BackgroundTransparency = 0.6
            track.Parent = frame
            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(1, 0)
            tc.Parent = track
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 24, 0, 24)
            knob.Position = UDim2.new(default and 0.5 or 0, 0, 0, 0)
            knob.BackgroundColor3 = default and DEFAULT_THEME.Accent or DEFAULT_THEME.TextDim
            knob.Parent = track
            local kc = Instance.new("UICorner")
            kc.CornerRadius = UDim.new(1, 0)
            kc.Parent = knob
            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    default = not default
                    TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Expo), {Position = UDim2.new(default and 0.5 or 0, 0, 0, 0), BackgroundColor3 = default and DEFAULT_THEME.Accent or DEFAULT_THEME.TextDim}):Play()
                    if callback then callback(default) end
                end
            end)
            return frame
        end
        function tabAPI:AddButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -8, 0, 40)
            btn.BackgroundColor3 = DEFAULT_THEME.AccentDarker
            btn.BackgroundTransparency = DEFAULT_THEME.ElementTransparency
            btn.Text = text
            btn.TextColor3 = DEFAULT_THEME.Text
            btn.Font = DEFAULT_THEME.Font
            btn.TextSize = 15
            btn.TextTruncate = Enum.TextTruncate.AtEnd
            btn.Parent = page
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 7)
            c.Parent = btn
            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = DEFAULT_THEME.StrokeColor
            btnStroke.Thickness = 0.5
            btnStroke.Transparency = 0.9
            btnStroke.Parent = btn
            btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.25, Enum.EasingStyle.Expo), {
                    BackgroundColor3 = DEFAULT_THEME.Accent
                }):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.25, Enum.EasingStyle.Expo), {
                    BackgroundColor3 = DEFAULT_THEME.AccentDarker
                }):Play()
            end)
            return btn
        end
        function tabAPI:AddSlider(name, min, max, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 58)
            frame.BackgroundColor3 = DEFAULT_THEME.AccentVeryDark
            frame.BackgroundTransparency = DEFAULT_THEME.ElementTransparency
            frame.Parent = page
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 5)
            c.Parent = frame
            local frameStroke = Instance.new("UIStroke")
            frameStroke.Color = DEFAULT_THEME.StrokeColor
            frameStroke.Thickness = 0.5
            frameStroke.Transparency = 0.9
            frameStroke.Parent = frame
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -20, 0, 24)
            lbl.Position = UDim2.new(0, 12, 0, 6)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = DEFAULT_THEME.Text
            lbl.Font = DEFAULT_THEME.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            local valueLbl = Instance.new("TextLabel")
            valueLbl.Size = UDim2.new(0, 40, 0, 24)
            valueLbl.Position = UDim2.new(1, -52, 0, 6)
            valueLbl.BackgroundTransparency = 1
            valueLbl.Text = tostring(default)
            valueLbl.TextColor3 = DEFAULT_THEME.TextDim
            valueLbl.Font = DEFAULT_THEME.Font
            valueLbl.TextSize = 14
            valueLbl.TextXAlignment = Enum.TextXAlignment.Right
            valueLbl.Parent = frame
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -24, 0, 8)
            track.Position = UDim2.new(0, 12, 0, 38)
            track.BackgroundColor3 = DEFAULT_THEME.AccentDarker
            track.BackgroundTransparency = 0.6
            track.Parent = frame
            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(1, 0)
            tc.Parent = track
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = DEFAULT_THEME.Accent
            fill.Parent = track
            local fc = Instance.new("UICorner")
            fc.CornerRadius = UDim.new(1, 0)
            fc.Parent = fill
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = UDim2.new(1, -8, 0.5, -8)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.Parent = fill
            local kc = Instance.new("UICorner")
            kc.CornerRadius = UDim.new(1, 0)
            kc.Parent = knob
            local dragging = false
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if not dragging or input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
                local rel = math.clamp(
                    (UserInputService:GetMouseLocation().X - track.AbsolutePosition.X) / track.AbsoluteSize.X,
                    0, 1
                )
                TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(rel, 0, 1, 0)}):Play()
                local value = math.round(min + (max - min) * rel)
                valueLbl.Text = tostring(value)
                if callback then callback(value) end
            end)
            return frame
        end
        function tabAPI:AddDropdown(name, options, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 40)
            frame.BackgroundColor3 = DEFAULT_THEME.AccentVeryDark
            frame.BackgroundTransparency = DEFAULT_THEME.ElementTransparency
            frame.Parent = page
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 5)
            c.Parent = frame
            local frameStroke = Instance.new("UIStroke")
            frameStroke.Color = DEFAULT_THEME.StrokeColor
            frameStroke.Thickness = 0.5
            frameStroke.Transparency = 0.9
            frameStroke.Parent = frame
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.45, 0, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = DEFAULT_THEME.Text
            lbl.Font = DEFAULT_THEME.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            local selected = Instance.new("TextButton")
            selected.Size = UDim2.new(0.48, 0, 0, 32)
            selected.Position = UDim2.new(0.5, 0, 0, 4)
            selected.BackgroundColor3 = DEFAULT_THEME.AccentDarker
            selected.BackgroundTransparency = 0.6
            selected.Text = default or options[1]
            selected.TextColor3 = DEFAULT_THEME.Text
            selected.Font = DEFAULT_THEME.Font
            selected.TextSize = 14
            selected.TextTruncate = Enum.TextTruncate.AtEnd
            selected.Parent = frame
            local sc = Instance.new("UICorner")
            sc.CornerRadius = UDim.new(0, 5)
            sc.Parent = selected
            local dropFrame = Instance.new("Frame")
            dropFrame.BackgroundColor3 = DEFAULT_THEME.Background
            dropFrame.BackgroundTransparency = DEFAULT_THEME.BackgroundTransparency
            dropFrame.Visible = false
            dropFrame.ZIndex = 2
            dropFrame.Parent = screen
            local dropCorner = Instance.new("UICorner")
            dropCorner.CornerRadius = UDim.new(0, 5)
            dropCorner.Parent = dropFrame
            local dropStroke = Instance.new("UIStroke")
            dropStroke.Color = DEFAULT_THEME.StrokeColor
            dropStroke.Thickness = 1
            dropStroke.Transparency = 0.8
            dropStroke.Parent = dropFrame
            local dropLayout = Instance.new("UIListLayout")
            dropLayout.Padding = UDim.new(0, 4)
            dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dropLayout.Parent = dropFrame
            for _, v in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 28)
                optBtn.BackgroundColor3 = DEFAULT_THEME.AccentDarker
                optBtn.BackgroundTransparency = 0.6
                optBtn.Text = v
                optBtn.TextColor3 = DEFAULT_THEME.Text
                optBtn.Font = DEFAULT_THEME.Font
                optBtn.TextSize = 14
                optBtn.Parent = dropFrame
                local optC = Instance.new("UICorner")
                optC.CornerRadius = UDim.new(0, 5)
                optC.Parent = optBtn
                optBtn.MouseButton1Click:Connect(function()
                    selected.Text = v
                    dropFrame.Visible = false
                    if callback then callback(v) end
                end)
                optBtn.MouseEnter:Connect(function()
                    TweenService:Create(optBtn, TweenInfo.new(0.25, Enum.EasingStyle.Expo), {BackgroundColor3 = DEFAULT_THEME.Accent}):Play()
                end)
                optBtn.MouseLeave:Connect(function()
                    TweenService:Create(optBtn, TweenInfo.new(0.25, Enum.EasingStyle.Expo), {BackgroundColor3 = DEFAULT_THEME.AccentDarker}):Play()
                end)
            end
            dropLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                dropFrame.Size = UDim2.new(0, selected.AbsoluteSize.X, 0, dropLayout.AbsoluteContentSize.Y + 8)
            end)
            selected:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
                dropFrame.Position = UDim2.new(0, selected.AbsolutePosition.X, 0, selected.AbsolutePosition.Y + selected.AbsoluteSize.Y + 4)
            end)
            dropFrame.Size = UDim2.new(0, selected.AbsoluteSize.X, 0, dropLayout.AbsoluteContentSize.Y + 8)
            dropFrame.Position = UDim2.new(0, selected.AbsolutePosition.X, 0, selected.AbsolutePosition.Y + selected.AbsoluteSize.Y + 4)
            selected.MouseButton1Click:Connect(function()
                dropFrame.Visible = not dropFrame.Visible
            end)
            return frame
        end
        function tabAPI:AddKeybind(name, defaultKey, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 38)
            frame.BackgroundColor3 = DEFAULT_THEME.AccentVeryDark
            frame.BackgroundTransparency = DEFAULT_THEME.ElementTransparency
            frame.Parent = page
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 5)
            c.Parent = frame
            local frameStroke = Instance.new("UIStroke")
            frameStroke.Color = DEFAULT_THEME.StrokeColor
            frameStroke.Thickness = 0.5
            frameStroke.Transparency = 0.9
            frameStroke.Parent = frame
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.62, 0, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = DEFAULT_THEME.Text
            lbl.Font = DEFAULT_THEME.Font
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 100, 0, 28)
            btn.Position = UDim2.new(1, -112, 0.5, -14)
            btn.BackgroundColor3 = DEFAULT_THEME.AccentDarker
            btn.BackgroundTransparency = 0.6
            btn.Text = defaultKey.Name
            btn.TextColor3 = DEFAULT_THEME.Text
            btn.Font = DEFAULT_THEME.Font
            btn.TextSize = 14
            btn.TextTruncate = Enum.TextTruncate.AtEnd
            btn.Parent = frame
            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0, 5)
            bc.Parent = btn
            local listening = false
            btn.MouseButton1Click:Connect(function()
                listening = true
                btn.Text = "..."
            end)
            local conn = UserInputService.InputBegan:Connect(function(input)
                if not listening then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    btn.Text = input.KeyCode.Name
                    if callback then callback(input.KeyCode) end
                end
            end)
            return frame
        end
        return tabAPI
    end
    local openTi = TweenInfo.new(0.8, Enum.EasingStyle.Expo, Enum.EasingDirection.Out)
    TweenService:Create(main, openTi, {Size = UDim2.new(0, width, 0, height), Position = UDim2.new(0.5, -width/2, 0.5, -height/2), BackgroundTransparency = DEFAULT_THEME.BackgroundTransparency}):Play()
    return window
end
return SmileUILib
