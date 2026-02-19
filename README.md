# ❄️ Smile Hub UI Library
A **clean, animated, hacker-style Roblox UI Library** made for developers.\
Designed with performance, visuals, and simplicity in mind.

------------------------------------------------------------------------

## 🌊 About
**Smile Hub UI** is an **open-source Roblox UI library** that provides:
- Animated windows with drag and minimize functionality
- Tab-based layout for organized content
- Modern green terminal aesthetic (neon green accents on black background)
- Built-in notification system with animations
- Easy-to-use API for common UI elements: toggles, sliders, dropdowns, buttons, keybinds, color pickers, textboxes, progress bars, sections, labels, and spacers
- Customizable themes, sizes, colors, and behaviors via options tables
- Smooth tween animations for interactions (e.g., hover effects, open/close)
- Optimized for performance: Uses Roblox's TweenService, avoids unnecessary instances, and supports stateful updates

This library is **FREE**, **OPEN SOURCE**, and designed for Smile Hub scripts. It's lightweight, with no external dependencies beyond Roblox services (TweenService, UserInputService, CoreGui).

------------------------------------------------------------------------

## 🔗 Raw Library URL
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/RblxScriptsOG/Smile-Hub-UI/refs/heads/main/lib.lua"))()
```

------------------------------------------------------------------------

## 💫 Getting Started

### 1. Load the Library
```lua
local SmileUILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/RblxScriptsOG/Smile-Hub-UI/refs/heads/main/lib.lua"))()
```

### 2. Create a Window
Creates a draggable, minimizable window with a header, tabs sidebar, and content area.
```lua
local Window = SmileUILib:CreateWindow({
    title = "Smile Hub",          -- Window title (string, default: "SMILE UI")
    width = 580,                  -- Width in pixels (number, default: 580)
    height = 420,                 -- Height in pixels (number, default: 420)
    theme = MyCustomTheme,        -- Optional custom theme table (overrides SmileUILib.Theme)
    iconText = "$",               -- Minimize icon text (string, default: "$")
    tabsWidth = 152,              -- Width of tabs sidebar (number, default: 152)
    contentOffset = 176           -- Offset for content area (number, default: 176)
})
```
- The window animates in with a back-out easing style.
- Minimize button ("−") hides the window and shows a draggable icon.
- Click the icon to restore the window.

### 3. Create a Tab
Adds a tab button to the sidebar and a scrolling content page.
```lua
local MainTab = Window:AddTab({
    name = "Main",                -- Tab name (string, default: "Tab")
    theme = MyCustomTheme         -- Optional per-tab theme (overrides window theme)
})
```
- Tabs have hover animations and switch pages with visibility toggles.
- First tab is active by default.
- Content pages are ScrollingFrames with automatic CanvasSize updates.

------------------------------------------------------------------------

## 📄 Documentation

### Global Theme Customization
Customize the default theme before creating windows:
```lua
SmileUILib.Theme = {
    Background = Color3.fromRGB(0, 0, 0),          -- Main background color
    Header = Color3.fromRGB(0, 20, 0),             -- Header bar color
    Accent = Color3.fromRGB(0, 255, 0),            -- Primary accent (e.g., buttons, fills)
    AccentDark = Color3.fromRGB(0, 120, 0),        -- Darker accent
    AccentDarker = Color3.fromRGB(0, 60, 0),       -- Even darker
    AccentVeryDark = Color3.fromRGB(0, 12, 0),     -- Darkest accent (e.g., element backgrounds)
    Text = Color3.fromRGB(0, 255, 0),              -- Text color
    TextDim = Color3.fromRGB(0, 200, 0),           -- Dimmed text
    StrokeColor = Color3.fromRGB(0, 100, 0),       -- Border/stroke color
    CornerRadius = UDim.new(0, 6),                 -- General corner radius
    StrokeThickness = 1.8,                         -- Stroke width
    StrokeTransparency = 0.28,                     -- Stroke opacity
    Font = Enum.Font.Arcade,                       -- Font face
    -- Notification-specific
    NotificationCornerRadius = UDim.new(0, 10),
    NotificationHeaderHeight = 34,
    NotificationStrokeThickness = 2.2,
    -- Window-specific
    WindowHeaderHeight = 44,
    WindowMinButtonSize = UDim2.new(0, 40, 0, 40),
    WindowIconSize = UDim2.new(0, 56, 0, 56),
    -- Element sizes
    TabButtonHeight = 38,
    TabButtonCornerRadius = UDim.new(0, 6),
    ElementCornerRadius = UDim.new(0, 5),
    ButtonHeight = 40,
    ToggleHeight = 36,
    SliderHeight = 58,
    DropdownHeight = 40,
    KeybindHeight = 38,
    ColorPickerHeight = 180,                       -- New
    TextboxHeight = 40,                            -- New
    SpacerDefaultHeight = 8,
    -- Animations
    AnimationSpeed = 0.18,                         -- General tween speed
    NotificationInSpeed = 0.58,
    NotificationOutSpeed = 0.52,
    WindowOpenSpeed = 0.7
}
```
- All elements inherit from this theme unless overridden in options.

### Notification
Displays an animated bottom-center notification that slides in/out.
```lua
SmileUILib:Notify({
    title = "TITLE",              -- Notification title (string, default: "INFO")
    message = "Message here",     -- Body text (string, default: "")
    duration = 4,                 -- Display time in seconds (number, default: 3.7)
    width = 400,                  -- Width in pixels (number, default: 400)
    theme = MyCustomTheme         -- Optional custom theme
})
```
- Animates with back-out/in easing.
- Auto-sizes height based on message length.
- Multiple notifications stack vertically.

### Section
Adds a bold header label for grouping elements.
```lua
MainTab:AddSection({
    title = "Section Title",      -- Text (string, default: "Section")
    textSize = 16,                -- Font size (number, default: 16)
    textColor = Color3.new(1,1,1) -- Color (Color3, default: theme.Text)
})
```
- Returns the TextLabel instance for further modification.

### Label
Adds a simple text label.
```lua
MainTab:AddLabel({
    text = "Simple text label",   -- Text (string, default: "Label")
    textSize = 14,                -- Font size (number, default: 14)
    textColor = Color3.new(0.5,0.5,0.5) -- Color (Color3, default: theme.TextDim)
})
```
- Supports word wrapping and auto-height.
- Returns the TextLabel instance.

### Spacer
Adds vertical empty space.
```lua
MainTab:AddSpacer({
    height = 10                   -- Height in pixels (number, default: 8)
})
```
- Returns the Frame instance.

### Button
Adds a clickable button with hover animation.
```lua
MainTab:AddButton({
    text = "Click Me",            -- Button text (string, default: "Button")
    callback = function() print("Clicked") end, -- Function to call on click
    height = 40,                  -- Height (number, default: theme.ButtonHeight)
    bgColor = Color3.new(0,0.5,0),-- Background color (Color3, default: theme.AccentDarker)
    hoverColor = Color3.new(0,1,0)-- Hover color (Color3, default: theme.Accent)
})
```
- Animates background on hover/leave.
- Returns the TextButton instance.

### Toggle
Adds a switch-style toggle with animation.
```lua
MainTab:AddToggle({
    name = "God Mode",            -- Label text (string, default: "Toggle")
    default = false,              -- Initial state (boolean, default: false)
    callback = function(state) print(state) end, -- Function called on change (passes boolean)
    height = 36,                  -- Height (number, default: theme.ToggleHeight)
    bgColor = Color3.new(0,0.1,0) -- Background (Color3, default: theme.AccentVeryDark)
})
```
- Toggle box animates color change.
- Returns the Frame instance.

### Slider
Adds a draggable slider with value display.
```lua
MainTab:AddSlider({
    name = "Speed",               -- Label prefix (string, default: "Slider")
    min = 1,                      -- Minimum value (number, default: 0)
    max = 100,                    -- Maximum value (number, default: 100)
    default = 16,                 -- Starting value (number, clamped to min-max)
    step = 1,                     -- Snap increment (number, default: 1)
    callback = function(value) print(value) end, -- Function called on change (passes number)
    height = 58,                  -- Height (number, default: theme.SliderHeight)
    bgColor = Color3.new(0,0.1,0) -- Background (Color3, default: theme.AccentVeryDark)
})
```
- Supports mouse dragging with real-time updates.
- Value is rounded to nearest step.
- Returns the Frame instance.

### Dropdown
Adds a cycling dropdown selector.
```lua
MainTab:AddDropdown({
    name = "Mode",                -- Label text (string, default: "Dropdown")
    options = {"Easy", "Hard", "Extreme"}, -- Table of strings (default: {"Option 1", "Option 2"})
    default = "Easy",             -- Initial selection (string, must match an option)
    callback = function(choice) print(choice) end, -- Function called on change (passes string)
    height = 40,                  -- Height (number, default: theme.DropdownHeight)
    bgColor = Color3.new(0,0.1,0) -- Background (Color3, default: theme.AccentVeryDark)
})
```
- Clicks cycle through options.
- Returns the Frame instance.

### Keybind
Adds a keybind setter with listener.
```lua
MainTab:AddKeybind({
    name = "Toggle UI",           -- Label text (string, default: "Keybind")
    defaultKey = Enum.KeyCode.RightShift, -- Initial key (Enum.KeyCode or Enum.UserInputType, default: Unknown)
    allowMouse = true,            -- Allow mouse buttons (boolean, default: false)
    callback = function(key) print("Bound to", key.Name) end, -- Function called on set (passes Enum)
    height = 38,                  -- Height (number, default: theme.KeybindHeight)
    bgColor = Color3.new(0,0.1,0) -- Background (Color3, default: theme.AccentVeryDark)
})
```
- Click to enter listening mode ("..."), press key/mouse to set.
- Supports keyboard and mouse (if allowed).
- Disconnects listener on destroy.
- Returns the Frame instance.

### Color Picker
Adds RGB sliders for color selection.
```lua
MainTab:AddColorPicker({
    name = "Color",               -- Label text (string, default: "Color Picker")
    default = Color3.fromRGB(255, 255, 255), -- Initial color (Color3, default: white)
    callback = function(color) print(color) end, -- Function called on change (passes Color3)
    height = 180,                 -- Height (number, default: theme.ColorPickerHeight)
    bgColor = Color3.new(0,0.1,0) -- Background (Color3, default: theme.AccentVeryDark)
})
```
- Includes preview frame and three sliders (R, G, B: 0-255).
- Updates on slider release.
- Returns the Frame instance.

### Textbox
Adds an input field.
```lua
MainTab:AddTextbox({
    name = "Input",               -- Label text (string, default: "Textbox")
    default = "",                 -- Initial text (string, default: "")
    callback = function(text) print(text) end, -- Function called on enter (passes string)
    height = 40,                  -- Height (number, default: theme.TextboxHeight)
    bgColor = Color3.new(0,0.1,0) -- Background (Color3, default: theme.AccentVeryDark)
})
```
- Calls callback on FocusLost with enterPressed=true.
- Returns the Frame instance.

### Progress Bar
Adds a fillable progress bar.
```lua
local progress = MainTab:AddProgressBar({
    name = "Loading",             -- Label prefix (string, default: "Progress")
    max = 100,                    -- Max value (number, default: 100)
    value = 0,                    -- Initial value (number, default: 0)
    height = 40,                  -- Height (number, default: 40)
    bgColor = Color3.new(0,0.1,0) -- Background (Color3, default: theme.AccentVeryDark)
})

-- Update later:
progress:SetValue(50)             -- Sets value (clamped 0-max), animates fill, updates label to "%"
```
- Displays percentage.
- SetValue animates the fill bar.
- Returns an API table with SetValue function.

------------------------------------------------------------------------

## 🎨 Theme Info
- **Default Aesthetic**: Hacker-terminal style with neon green text/accents on black.
- **Customization**: Override SmileUILib.Theme globally or pass per-window/tab/element.
- **Performance**: All colors/sizes are Color3/UDim/number for efficiency.
- **Fonts**: Uses Enum.Font.Arcade by default; change to any Roblox font.

------------------------------------------------------------------------

## ⁉️ FAQ
### Q: Is this safe?
Yes. No backdoors, no obfuscation. Pure Lua with Roblox APIs.

### Q: Can I modify it?
Yes. Fully open source. Fork and customize.

### Q: Will it lag?
No. Optimized: Minimal instances, efficient tweens, auto-sizing.

### Q: Can I reupload?
Yes, but **credits required**. Link back to the original repo.

### Q: How to destroy the UI?
UI is parented to CoreGui. To clean up: `screen:Destroy()` (from CreateWindow return).

### Q: Multiple windows?
Yes, call CreateWindow multiple times.

### Q: Mobile support?
Draggable works on PC; touch dragging may need tweaks.

### Q: Errors?
Check console. Common: Invalid options types, missing callbacks.

------------------------------------------------------------------------

## 📜 License
**MIT License**\
You are free to: - Use - Modify - Share\
Just **credit the original creator**.

------------------------------------------------------------------------

## ❤️ Credits
- **Creator:** Scripter.SM
- **Discord:** https://discord.gg/VJH9YUcFDr
- **GitHub:** https://github.com/RblxScriptsOG
- **UI Concept & Code:** Smile Hub UI\
If you use this library, please ⭐ the repository.

------------------------------------------------------------------------

## Support
If you like this project: - Star the repo ⭐ - Share it - Improve it\
For issues, open a GitHub issue or join the Discord.
