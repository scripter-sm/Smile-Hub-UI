local SmileUILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/RblxScriptsOG/Smile-Hub-UI/refs/heads/main/lib.lua"))()

local Window = SmileUILib:CreateWindow({
	title = "$mile Hub - UI Showcase",
	width = 700,
	height = 550,
	iconText = "☰"
})

local ElementsTab = Window:AddTab({ name = "Elements" })
local ColorsTab   = Window:AddTab({ name = "Colors"   })
local ThemesTab   = Window:AddTab({ name = "Themes"   })

ElementsTab:AddSection({ title = "Basic Elements" })

ElementsTab:AddLabel({
	text = "This is a standard label. It supports word wrapping and can display longer text across multiple lines automatically.",
	textSize = 13
})

ElementsTab:AddSpacer({ height = 6 })

ElementsTab:AddButton({
	text = "Click Me - Show Notification",
	callback = function()
		SmileUILib:Notify({
			title   = "Button Clicked",
			message = "You clicked the button! This is the notification system.",
			duration = 3
		})
	end
})

ElementsTab:AddButton({
	text = "Click for Success Notification",
	callback = function()
		SmileUILib:Notify({
			title   = "Success",
			message = "Operation completed successfully!",
			duration = 4,
			width   = 320
		})
	end
})

ElementsTab:AddSection({ title = "Toggle Switches" })

local Toggle1 = ElementsTab:AddToggle({
	name    = "Enable Feature A",
	default = false,
	callback = function(state)
		SmileUILib:Notify({
			title   = "Toggle Changed",
			message = "Feature A is now " .. (state and "ENABLED" or "DISABLED"),
			duration = 2
		})
	end
})

local Toggle2 = ElementsTab:AddToggle({
	name    = "Auto-Save Settings",
	default = true,
	callback = function(state)
		print("Auto-save:", state)
	end
})

local Toggle3 = ElementsTab:AddToggle({
	name    = "Show Notifications",
	default = true,
	callback = function(state) end
})

ElementsTab:AddSection({ title = "Sliders" })

local Slider1 = ElementsTab:AddSlider({
	name    = "Volume Level",
	min     = 0,
	max     = 100,
	default = 50,
	step    = 1,
	callback = function(value) end
})

local Slider2 = ElementsTab:AddSlider({
	name    = "Animation Speed",
	min     = 0.1,
	max     = 2,
	default = 0.5,
	step    = 0.1,
	callback = function(value) end
})

local Slider3 = ElementsTab:AddSlider({
	name    = "Opacity",
	min     = 0,
	max     = 1,
	default = 1,
	step    = 0.05,
	callback = function(value) end
})

ElementsTab:AddSection({ title = "Dropdown Selection" })

local Dropdown1 = ElementsTab:AddDropdown({
	name    = "Select Quality",
	options = {"Low", "Medium", "High", "Ultra", "Maximum"},
	default = "High",
	callback = function(choice)
		SmileUILib:Notify({
			title   = "Quality Changed",
			message = "Set to: " .. choice,
			duration = 2
		})
	end
})

local Dropdown2 = ElementsTab:AddDropdown({
	name    = "Language",
	options = {"English", "Spanish", "French", "German", "Japanese"},
	default = "English",
	callback = function(choice) end
})

ElementsTab:AddSection({ title = "Keybind Input" })

local Keybind1 = ElementsTab:AddKeybind({
	name       = "Open Menu Key",
	defaultKey = Enum.KeyCode.RightShift,
	callback   = function(key)
		SmileUILib:Notify({
			title   = "Keybind Set",
			message = "Menu will open with: " .. key.Name,
			duration = 2
		})
	end
})

local Keybind2 = ElementsTab:AddKeybind({
	name       = "Quick Action",
	defaultKey = Enum.KeyCode.F,
	allowMouse = true,
	callback   = function(key)
		SmileUILib:Notify({
			title   = "Quick Action Bound",
			message = "Bound to: " .. (typeof(key) == "EnumItem" and key.Name or tostring(key)),
			duration = 2
		})
	end
})

ElementsTab:AddSection({ title = "Text Input" })

local Textbox1 = ElementsTab:AddTextbox({
	name    = "Username",
	default = "Player123",
	callback = function(text)
		SmileUILib:Notify({
			title   = "Text Entered",
			message = "Hello, " .. text .. "!",
			duration = 2
		})
	end
})

local Textbox2 = ElementsTab:AddTextbox({
	name    = "Search Query",
	default = "",
	callback = function(text) end
})

ElementsTab:AddSection({ title = "Progress Indicators" })

local Progress1 = ElementsTab:AddProgressBar({
	name   = "Download Progress",
	max    = 100,
	value  = 65,
	height = 46
})

task.spawn(function()
	while Progress1 do
		task.wait(2)
		local newVal = math.random(0, 100)
		Progress1:SetValue(newVal)
	end
end)

local Progress2 = ElementsTab:AddProgressBar({
	name   = "Battery Level",
	max    = 100,
	value  = 87,
	height = 46
})

ColorsTab:AddSection({ title = "Color Pickers" })

ColorsTab:AddLabel({
	text     = "Click on any color box to open the color picker modal!",
	textSize = 13
})

ColorsTab:AddSpacer({ height = 5 })

local ColorPicker1 = ColorsTab:AddColorPicker({
	name    = "Primary Color",
	default = Color3.fromRGB(120, 80, 220),
	callback = function(color)
		SmileUILib:Notify({
			title   = "Color Selected",
			message = string.format("RGB: %d, %d, %d",
				math.floor(color.R * 255),
				math.floor(color.G * 255),
				math.floor(color.B * 255)),
			duration = 3
		})
	end
})

local ColorPicker2 = ColorsTab:AddColorPicker({
	name    = "Secondary Color",
	default = Color3.fromRGB(255, 80, 80),
	callback = function(color) end
})

local ColorPicker3 = ColorsTab:AddColorPicker({
	name    = "Background Color",
	default = Color3.fromRGB(15, 15, 20),
	callback = function(color) end
})

local ColorPicker4 = ColorsTab:AddColorPicker({
	name    = "Text Highlight",
	default = Color3.fromRGB(200, 160, 255),
	callback = function(color) end
})

ColorsTab:AddSection({ title = "Color Combinations" })

local ColorPicker5 = ColorsTab:AddColorPicker({
	name    = "Health Color",
	default = Color3.fromRGB(80, 220, 120),
	callback = function(color) end
})

local ColorPicker6 = ColorsTab:AddColorPicker({
	name    = "Damage Color",
	default = Color3.fromRGB(220, 60, 60),
	callback = function(color) end
})

ThemesTab:AddSection({ title = "Preset Themes" })

ThemesTab:AddLabel({
	text     = "Click any theme button to instantly change the entire UI appearance!",
	textSize = 12
})

ThemesTab:AddSpacer({ height = 5 })

ThemesTab:AddButton({
	text = "Purple Theme (Default)",
	callback = function()
		SmileUILib:SetTheme({
			Background     = Color3.fromRGB(15,  15,  20 ),
			Surface        = Color3.fromRGB(20,  20,  27 ),
			SurfaceLight   = Color3.fromRGB(27,  27,  36 ),
			SurfaceLighter = Color3.fromRGB(33,  33,  44 ),
			Header         = Color3.fromRGB(18,  18,  25 ),
			Accent         = Color3.fromRGB(120, 80,  220),
			AccentDark     = Color3.fromRGB(90,  55,  170),
			AccentDarker   = Color3.fromRGB(55,  35,  110),
			AccentVeryDark = Color3.fromRGB(28,  18,  55 ),
			AccentHover    = Color3.fromRGB(140, 100, 240),
			Text           = Color3.fromRGB(240, 240, 255),
			TextDim        = Color3.fromRGB(140, 140, 165),
			StrokeColor    = Color3.fromRGB(45,  45,  60 ),
			BorderAccent   = Color3.fromRGB(80,  55,  160),
		})
		SmileUILib:Notify({ title = "Theme Applied", message = "Purple Theme - Linoria style!", duration = 3 })
	end
})

ThemesTab:AddButton({
	text = "Green Theme",
	callback = function()
		SmileUILib:SetTheme({
			Background     = Color3.fromRGB(5,   15,  5  ),
			Surface        = Color3.fromRGB(8,   22,  8  ),
			SurfaceLight   = Color3.fromRGB(12,  30,  12 ),
			SurfaceLighter = Color3.fromRGB(18,  40,  18 ),
			Header         = Color3.fromRGB(8,   20,  8  ),
			Accent         = Color3.fromRGB(0,   220, 80 ),
			AccentDark     = Color3.fromRGB(0,   160, 55 ),
			AccentDarker   = Color3.fromRGB(0,   90,  30 ),
			AccentVeryDark = Color3.fromRGB(0,   30,  12 ),
			AccentHover    = Color3.fromRGB(60,  255, 120),
			Text           = Color3.fromRGB(200, 255, 210),
			TextDim        = Color3.fromRGB(100, 180, 120),
			StrokeColor    = Color3.fromRGB(20,  80,  35 ),
			BorderAccent   = Color3.fromRGB(0,   120, 50 ),
		})
		SmileUILib:Notify({ title = "Theme Applied", message = "Green Theme - Classic hacker style!", duration = 3 })
	end
})

ThemesTab:AddButton({
	text = "Red Theme",
	callback = function()
		SmileUILib:SetTheme({
			Background     = Color3.fromRGB(18,  5,   5  ),
			Surface        = Color3.fromRGB(25,  8,   8  ),
			SurfaceLight   = Color3.fromRGB(35,  12,  12 ),
			SurfaceLighter = Color3.fromRGB(45,  18,  18 ),
			Header         = Color3.fromRGB(22,  6,   6  ),
			Accent         = Color3.fromRGB(230, 50,  50 ),
			AccentDark     = Color3.fromRGB(170, 30,  30 ),
			AccentDarker   = Color3.fromRGB(100, 15,  15 ),
			AccentVeryDark = Color3.fromRGB(40,  5,   5  ),
			AccentHover    = Color3.fromRGB(255, 90,  90 ),
			Text           = Color3.fromRGB(255, 210, 210),
			TextDim        = Color3.fromRGB(180, 110, 110),
			StrokeColor    = Color3.fromRGB(90,  20,  20 ),
			BorderAccent   = Color3.fromRGB(150, 30,  30 ),
		})
		SmileUILib:Notify({ title = "Theme Applied", message = "Red Theme - Aggressive style!", duration = 3 })
	end
})

ThemesTab:AddButton({
	text = "Blue Theme",
	callback = function()
		SmileUILib:SetTheme({
			Background     = Color3.fromRGB(5,   10,  22 ),
			Surface        = Color3.fromRGB(8,   15,  30 ),
			SurfaceLight   = Color3.fromRGB(12,  22,  42 ),
			SurfaceLighter = Color3.fromRGB(18,  30,  55 ),
			Header         = Color3.fromRGB(8,   12,  28 ),
			Accent         = Color3.fromRGB(60,  150, 255),
			AccentDark     = Color3.fromRGB(30,  100, 210),
			AccentDarker   = Color3.fromRGB(15,  55,  140),
			AccentVeryDark = Color3.fromRGB(5,   18,  55 ),
			AccentHover    = Color3.fromRGB(110, 185, 255),
			Text           = Color3.fromRGB(210, 230, 255),
			TextDim        = Color3.fromRGB(110, 150, 210),
			StrokeColor    = Color3.fromRGB(25,  55,  110),
			BorderAccent   = Color3.fromRGB(30,  80,  180),
		})
		SmileUILib:Notify({ title = "Theme Applied", message = "Blue Theme - Cool and calm!", duration = 3 })
	end
})

ThemesTab:AddButton({
	text = "Pink Theme",
	callback = function()
		SmileUILib:SetTheme({
			Background     = Color3.fromRGB(20,  8,   15 ),
			Surface        = Color3.fromRGB(28,  12,  22 ),
			SurfaceLight   = Color3.fromRGB(38,  18,  32 ),
			SurfaceLighter = Color3.fromRGB(50,  25,  42 ),
			Header         = Color3.fromRGB(25,  10,  20 ),
			Accent         = Color3.fromRGB(255, 100, 180),
			AccentDark     = Color3.fromRGB(210, 60,  140),
			AccentDarker   = Color3.fromRGB(140, 30,  90 ),
			AccentVeryDark = Color3.fromRGB(55,  10,  35 ),
			AccentHover    = Color3.fromRGB(255, 150, 210),
			Text           = Color3.fromRGB(255, 220, 240),
			TextDim        = Color3.fromRGB(200, 130, 175),
			StrokeColor    = Color3.fromRGB(100, 35,  75 ),
			BorderAccent   = Color3.fromRGB(170, 50,  120),
		})
		SmileUILib:Notify({ title = "Theme Applied", message = "Pink Theme - Soft and stylish!", duration = 3 })
	end
})

ThemesTab:AddButton({
	text = "Gold Theme",
	callback = function()
		SmileUILib:SetTheme({
			Background     = Color3.fromRGB(20,  15,  5  ),
			Surface        = Color3.fromRGB(28,  22,  8  ),
			SurfaceLight   = Color3.fromRGB(38,  30,  12 ),
			SurfaceLighter = Color3.fromRGB(50,  40,  18 ),
			Header         = Color3.fromRGB(25,  18,  6  ),
			Accent         = Color3.fromRGB(255, 195, 30 ),
			AccentDark     = Color3.fromRGB(210, 155, 10 ),
			AccentDarker   = Color3.fromRGB(140, 100, 5  ),
			AccentVeryDark = Color3.fromRGB(55,  40,  5  ),
			AccentHover    = Color3.fromRGB(255, 220, 100),
			Text           = Color3.fromRGB(255, 240, 190),
			TextDim        = Color3.fromRGB(200, 175, 100),
			StrokeColor    = Color3.fromRGB(110, 80,  10 ),
			BorderAccent   = Color3.fromRGB(180, 135, 10 ),
		})
		SmileUILib:Notify({ title = "Theme Applied", message = "Gold Theme - Premium look!", duration = 3 })
	end
})

ThemesTab:AddButton({
	text = "Grey Theme",
	callback = function()
		SmileUILib:SetTheme({
			Background     = Color3.fromRGB(12,  12,  12 ),
			Surface        = Color3.fromRGB(20,  20,  20 ),
			SurfaceLight   = Color3.fromRGB(28,  28,  28 ),
			SurfaceLighter = Color3.fromRGB(38,  38,  38 ),
			Header         = Color3.fromRGB(18,  18,  18 ),
			Accent         = Color3.fromRGB(180, 180, 185),
			AccentDark     = Color3.fromRGB(130, 130, 135),
			AccentDarker   = Color3.fromRGB(80,  80,  85 ),
			AccentVeryDark = Color3.fromRGB(32,  32,  35 ),
			AccentHover    = Color3.fromRGB(220, 220, 225),
			Text           = Color3.fromRGB(230, 230, 235),
			TextDim        = Color3.fromRGB(150, 150, 155),
			StrokeColor    = Color3.fromRGB(55,  55,  60 ),
			BorderAccent   = Color3.fromRGB(100, 100, 110),
		})
		SmileUILib:Notify({ title = "Theme Applied", message = "Grey Theme - Professional clean look!", duration = 3 })
	end
})

ThemesTab:AddButton({
	text = "Cyan Theme",
	callback = function()
		SmileUILib:SetTheme({
			Background     = Color3.fromRGB(5,   18,  20 ),
			Surface        = Color3.fromRGB(8,   25,  28 ),
			SurfaceLight   = Color3.fromRGB(12,  35,  40 ),
			SurfaceLighter = Color3.fromRGB(18,  46,  52 ),
			Header         = Color3.fromRGB(8,   22,  26 ),
			Accent         = Color3.fromRGB(0,   220, 220),
			AccentDark     = Color3.fromRGB(0,   165, 165),
			AccentDarker   = Color3.fromRGB(0,   95,  95 ),
			AccentVeryDark = Color3.fromRGB(0,   35,  38 ),
			AccentHover    = Color3.fromRGB(80,  245, 245),
			Text           = Color3.fromRGB(195, 250, 250),
			TextDim        = Color3.fromRGB(100, 185, 185),
			StrokeColor    = Color3.fromRGB(20,  90,  95 ),
			BorderAccent   = Color3.fromRGB(0,   130, 135),
		})
		SmileUILib:Notify({ title = "Theme Applied", message = "Cyan Theme - Fresh and vibrant!", duration = 3 })
	end
})

ThemesTab:AddSection({ title = "Dynamic Theme Demo" })

ThemesTab:AddLabel({
	text     = "Notice how all buttons, toggles, and elements instantly update their colors when you change themes! Try hovering over buttons after changing themes.",
	textSize = 11
})

task.wait(1)
SmileUILib:Notify({
	title    = "Smile Hub UI Showcase",
	message  = "Welcome! This demonstrates all GUI features. Try clicking everything!",
	duration = 5,
	width    = 320
})
