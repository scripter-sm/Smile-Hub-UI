local SmileUILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/RblxScriptsOG/Smile-Hub-UI/refs/heads/main/lib.lua"))()

local Window = SmileUILib:CreateWindow({
    title = "Smile Hub - UI Showcase",
    width = 700,
    height = 550,
    iconText = "☺"
})

local ElementsTab = Window:AddTab({ name = "Elements" })
local ColorsTab = Window:AddTab({ name = "Colors" })
local ThemesTab = Window:AddTab({ name = "Themes" })

ElementsTab:AddSection({ title = "Basic Elements" })

ElementsTab:AddLabel({ 
    text = "This is a standard label. It supports word wrapping and can display longer text across multiple lines automatically.",
    textSize = 13
})

ElementsTab:AddSpacer({ height = 10 })

ElementsTab:AddButton({
    text = "Click Me - I Show Notifications!",
    callback = function()
        SmileUILib:Notify({
            title = "Button Clicked",
            message = "You clicked the button! This is the notification system.",
            duration = 3
        })
    end
})

ElementsTab:AddButton({
    text = "Click for Success Notification",
    callback = function()
        SmileUILib:Notify({
            title = "Success",
            message = "Operation completed successfully!",
            duration = 4,
            width = 350
        })
    end
})

ElementsTab:AddSection({ title = "Toggle Switches" })

local Toggle1 = ElementsTab:AddToggle({
    name = "Enable Feature A",
    default = false,
    callback = function(state)
        SmileUILib:Notify({
            title = "Toggle Changed",
            message = "Feature A is now " .. (state and "ENABLED" or "DISABLED"),
            duration = 2
        })
    end
})

local Toggle2 = ElementsTab:AddToggle({
    name = "Auto-Save Settings",
    default = true,
    callback = function(state)
        print("Auto-save:", state)
    end
})

local Toggle3 = ElementsTab:AddToggle({
    name = "Show Notifications",
    default = true,
    callback = function(state)
    end
})

ElementsTab:AddSection({ title = "Sliders" })

local Slider1 = ElementsTab:AddSlider({
    name = "Volume Level",
    min = 0,
    max = 100,
    default = 50,
    step = 1,
    callback = function(value)
    end
})

local Slider2 = ElementsTab:AddSlider({
    name = "Animation Speed",
    min = 0.1,
    max = 2,
    default = 0.5,
    step = 0.1,
    callback = function(value)
    end
})

local Slider3 = ElementsTab:AddSlider({
    name = "Opacity",
    min = 0,
    max = 1,
    default = 1,
    step = 0.05,
    callback = function(value)
    end
})

ElementsTab:AddSection({ title = "Dropdown Selection" })

local Dropdown1 = ElementsTab:AddDropdown({
    name = "Select Quality",
    options = {"Low", "Medium", "High", "Ultra", "Maximum"},
    default = "High",
    callback = function(choice)
        SmileUILib:Notify({
            title = "Quality Changed",
            message = "Set to: " .. choice,
            duration = 2
        })
    end
})

local Dropdown2 = ElementsTab:AddDropdown({
    name = "Language",
    options = {"English", "Spanish", "French", "German", "Japanese"},
    default = "English",
    callback = function(choice)
    end
})

ElementsTab:AddSection({ title = "Keybind Input" })

local Keybind1 = ElementsTab:AddKeybind({
    name = "Open Menu Key",
    defaultKey = Enum.KeyCode.RightShift,
    callback = function(key)
        SmileUILib:Notify({
            title = "Keybind Set",
            message = "Menu will open with: " .. key.Name,
            duration = 2
        })
    end
})

local Keybind2 = ElementsTab:AddKeybind({
    name = "Quick Action",
    defaultKey = Enum.KeyCode.F,
    allowMouse = true,
    callback = function(key)
        SmileUILib:Notify({
            title = "Quick Action Bound",
            message = "Bound to: " .. (typeof(key) == "EnumItem" and key.Name or tostring(key)),
            duration = 2
        })
    end
})

ElementsTab:AddSection({ title = "Text Input" })

local Textbox1 = ElementsTab:AddTextbox({
    name = "Username",
    default = "Player123",
    callback = function(text)
        SmileUILib:Notify({
            title = "Text Entered",
            message = "Hello, " .. text .. "!",
            duration = 2
        })
    end
})

local Textbox2 = ElementsTab:AddTextbox({
    name = "Search Query",
    default = "",
    callback = function(text)
    end
})

ElementsTab:AddSection({ title = "Progress Indicators" })

local Progress1 = ElementsTab:AddProgressBar({
    name = "Download Progress",
    max = 100,
    value = 65,
    height = 45
})

task.spawn(function()
    while Progress1 do
        task.wait(2)
        local newVal = math.random(0, 100)
        Progress1:SetValue(newVal)
    end
end)

local Progress2 = ElementsTab:AddProgressBar({
    name = "Battery Level",
    max = 100,
    value = 87,
    height = 40
})

ColorsTab:AddSection({ title = "Color Pickers" })

ColorsTab:AddLabel({ 
    text = "Click on any color box to open the color picker modal!",
    textSize = 13
})

ColorsTab:AddSpacer({ height = 5 })

local ColorPicker1 = ColorsTab:AddColorPicker({
    name = "Primary Color",
    default = Color3.fromRGB(0, 255, 0),
    callback = function(color)
        SmileUILib:Notify({
            title = "Color Selected",
            message = string.format("RGB: %d, %d, %d", 
                math.floor(color.R * 255),
                math.floor(color.G * 255),
                math.floor(color.B * 255)),
            duration = 3
        })
    end
})

local ColorPicker2 = ColorsTab:AddColorPicker({
    name = "Secondary Color",
    default = Color3.fromRGB(255, 0, 0),
    callback = function(color)
    end
})

local ColorPicker3 = ColorsTab:AddColorPicker({
    name = "Background Color",
    default = Color3.fromRGB(0, 0, 0),
    callback = function(color)
    end
})

local ColorPicker4 = ColorsTab:AddColorPicker({
    name = "Text Highlight",
    default = Color3.fromRGB(255, 255, 0),
    callback = function(color)
    end
})

ColorsTab:AddSection({ title = "Color Combinations" })

local ColorPicker5 = ColorsTab:AddColorPicker({
    name = "Health Color",
    default = Color3.fromRGB(0, 255, 100),
    callback = function(color)
    end
})

local ColorPicker6 = ColorsTab:AddColorPicker({
    name = "Damage Color",
    default = Color3.fromRGB(255, 50, 50),
    callback = function(color)
    end
})

ThemesTab:AddSection({ title = "Preset Themes" })

ThemesTab:AddLabel({ 
    text = "Click any theme button to instantly change the entire UI appearance!",
    textSize = 12
})

ThemesTab:AddSpacer({ height = 5 })

ThemesTab:AddButton({
    text = "Green Theme (Default)",
    callback = function()
        SmileUILib:SetTheme({
            Background = Color3.fromRGB(0, 0, 0),
            Header = Color3.fromRGB(0, 20, 0),
            Accent = Color3.fromRGB(0, 255, 0),
            AccentDark = Color3.fromRGB(0, 120, 0),
            AccentDarker = Color3.fromRGB(0, 60, 0),
            AccentVeryDark = Color3.fromRGB(0, 12, 0),
            Text = Color3.fromRGB(0, 255, 0),
            TextDim = Color3.fromRGB(0, 200, 0),
            StrokeColor = Color3.fromRGB(0, 100, 0)
        })
        SmileUILib:Notify({
            title = "Theme Applied",
            message = "Green Theme - Classic hacker style!",
            duration = 3
        })
    end
})

ThemesTab:AddButton({
    text = "Red Theme",
    callback = function()
        SmileUILib:SetTheme({
            Background = Color3.fromRGB(20, 0, 0),
            Header = Color3.fromRGB(40, 0, 0),
            Accent = Color3.fromRGB(255, 0, 0),
            AccentDark = Color3.fromRGB(180, 0, 0),
            AccentDarker = Color3.fromRGB(100, 0, 0),
            AccentVeryDark = Color3.fromRGB(30, 0, 0),
            Text = Color3.fromRGB(255, 100, 100),
            TextDim = Color3.fromRGB(200, 50, 50),
            StrokeColor = Color3.fromRGB(150, 0, 0)
        })
        SmileUILib:Notify({
            title = "Theme Applied",
            message = "Red Theme - Aggressive style!",
            duration = 3
        })
    end
})

ThemesTab:AddButton({
    text = "Blue Theme",
    callback = function()
        SmileUILib:SetTheme({
            Background = Color3.fromRGB(0, 0, 20),
            Header = Color3.fromRGB(0, 0, 40),
            Accent = Color3.fromRGB(0, 150, 255),
            AccentDark = Color3.fromRGB(0, 100, 200),
            AccentDarker = Color3.fromRGB(0, 50, 150),
            AccentVeryDark = Color3.fromRGB(0, 10, 50),
            Text = Color3.fromRGB(100, 200, 255),
            TextDim = Color3.fromRGB(50, 150, 200),
            StrokeColor = Color3.fromRGB(0, 80, 150)
        })
        SmileUILib:Notify({
            title = "Theme Applied",
            message = "Blue Theme - Cool and calm!",
            duration = 3
        })
    end
})

ThemesTab:AddButton({
    text = "Purple Theme",
    callback = function()
        SmileUILib:SetTheme({
            Background = Color3.fromRGB(20, 0, 20),
            Header = Color3.fromRGB(40, 0, 40),
            Accent = Color3.fromRGB(200, 0, 255),
            AccentDark = Color3.fromRGB(150, 0, 200),
            AccentDarker = Color3.fromRGB(100, 0, 150),
            AccentVeryDark = Color3.fromRGB(30, 0, 50),
            Text = Color3.fromRGB(220, 100, 255),
            TextDim = Color3.fromRGB(180, 50, 220),
            StrokeColor = Color3.fromRGB(150, 0, 180)
        })
        SmileUILib:Notify({
            title = "Theme Applied",
            message = "Purple Theme - Royal elegance!",
            duration = 3
        })
    end
})

ThemesTab:AddButton({
    text = "Gold Theme",
    callback = function()
        SmileUILib:SetTheme({
            Background = Color3.fromRGB(20, 15, 0),
            Header = Color3.fromRGB(40, 30, 0),
            Accent = Color3.fromRGB(255, 200, 0),
            AccentDark = Color3.fromRGB(200, 150, 0),
            AccentDarker = Color3.fromRGB(150, 100, 0),
            AccentVeryDark = Color3.fromRGB(50, 40, 0),
            Text = Color3.fromRGB(255, 220, 100),
            TextDim = Color3.fromRGB(220, 180, 50),
            StrokeColor = Color3.fromRGB(180, 140, 0)
        })
        SmileUILib:Notify({
            title = "Theme Applied",
            message = "Gold Theme - Premium look!",
            duration = 3
        })
    end
})

ThemesTab:AddButton({
    text = "Pink Theme",
    callback = function()
        SmileUILib:SetTheme({
            Background = Color3.fromRGB(20, 0, 10),
            Header = Color3.fromRGB(40, 0, 20),
            Accent = Color3.fromRGB(255, 100, 200),
            AccentDark = Color3.fromRGB(200, 50, 150),
            AccentDarker = Color3.fromRGB(150, 30, 100),
            AccentVeryDark = Color3.fromRGB(50, 10, 30),
            Text = Color3.fromRGB(255, 150, 220),
            TextDim = Color3.fromRGB(220, 100, 180),
            StrokeColor = Color3.fromRGB(180, 50, 120)
        })
        SmileUILib:Notify({
            title = "Theme Applied",
            message = "Pink Theme - Soft and stylish!",
            duration = 3
        })
    end
})

ThemesTab:AddButton({
    text = "Grey Theme",
    callback = function()
        SmileUILib:SetTheme({
            Background = Color3.fromRGB(10, 10, 10),
            Header = Color3.fromRGB(25, 25, 25),
            Accent = Color3.fromRGB(180, 180, 180),
            AccentDark = Color3.fromRGB(130, 130, 130),
            AccentDarker = Color3.fromRGB(80, 80, 80),
            AccentVeryDark = Color3.fromRGB(30, 30, 30),
            Text = Color3.fromRGB(220, 220, 220),
            TextDim = Color3.fromRGB(160, 160, 160),
            StrokeColor = Color3.fromRGB(100, 100, 100)
        })
        SmileUILib:Notify({
            title = "Theme Applied",
            message = "Grey Theme - Professional clean look!",
            duration = 3
        })
    end
})

ThemesTab:AddButton({
    text = "Dark Grey Theme",
    callback = function()
        SmileUILib:SetTheme({
            Background = Color3.fromRGB(5, 5, 5),
            Header = Color3.fromRGB(15, 15, 15),
            Accent = Color3.fromRGB(140, 140, 140),
            AccentDark = Color3.fromRGB(100, 100, 100),
            AccentDarker = Color3.fromRGB(60, 60, 60),
            AccentVeryDark = Color3.fromRGB(20, 20, 20),
            Text = Color3.fromRGB(200, 200, 200),
            TextDim = Color3.fromRGB(120, 120, 120),
            StrokeColor = Color3.fromRGB(70, 70, 70)
        })
        SmileUILib:Notify({
            title = "Theme Applied",
            message = "Dark Grey Theme - Minimalist dark!",
            duration = 3
        })
    end
})

ThemesTab:AddButton({
    text = "Light Grey Theme",
    callback = function()
        SmileUILib:SetTheme({
            Background = Color3.fromRGB(30, 30, 30),
            Header = Color3.fromRGB(45, 45, 45),
            Accent = Color3.fromRGB(220, 220, 220),
            AccentDark = Color3.fromRGB(180, 180, 180),
            AccentDarker = Color3.fromRGB(120, 120, 120),
            AccentVeryDark = Color3.fromRGB(50, 50, 50),
            Text = Color3.fromRGB(255, 255, 255),
            TextDim = Color3.fromRGB(200, 200, 200),
            StrokeColor = Color3.fromRGB(150, 150, 150)
        })
        SmileUILib:Notify({
            title = "Theme Applied",
            message = "Light Grey Theme - Modern light!",
            duration = 3
        })
    end
})

ThemesTab:AddSection({ title = "Dynamic Theme Demo" })

ThemesTab:AddLabel({ 
    text = "Notice how all buttons, toggles, and elements instantly update their colors when you change themes! Try hovering over buttons after changing themes.",
    textSize = 11
})

task.wait(1)
SmileUILib:Notify({
    title = "Smile Hub UI Showcase",
    message = "Welcome! This demonstrates all GUI features. Try clicking everything!",
    duration = 5,
    width = 500
})

task.wait(0.5)
