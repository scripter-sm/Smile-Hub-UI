# ❄️ Smile Hub UI Library

A **clean, animated, hacker-style Roblox UI Library** made for developers.\
Designed with performance, visuals, and simplicity in mind.

------------------------------------------------------------------------

## 🌊 About

**Smile Hub UI** is an **open-source Roblox UI library** that provides:
- Animated windows with drag and minimize functionality
- Tab-based layout for organized content
- Modern green terminal aesthetic (neon green accents on black background)
- Dynamic theme system - change themes anytime after GUI is loaded
- Built-in notification system with animations
- Easy-to-use API for common UI elements: toggles, sliders, dropdowns, buttons, keybinds, textboxes, progress bars, sections, labels, and spacers
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

## 🎮 Example Showcase

Try the complete interactive demo that showcases all UI elements:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/RblxScriptsOG/Smile-Hub-UI/refs/heads/main/example.lua"))()
```

The example includes:
- All UI elements (buttons, toggles, sliders, dropdowns, keybinds, textboxes, progress bars)
- 8 different preset themes (Green, Red, Blue, Purple, Gold, Pink, Grey variants)
- 6 color pickers to test the color picker modal
- Live progress bar animations
- Interactive notifications demonstrating all features

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
    title = "Smile Hub",
    width = 580,
    height = 420,
    theme = MyCustomTheme,
    iconText = "$",
    tabsWidth = 152,
    contentOffset = 176
})
```

- The window animates in with a back-out easing style.
- Minimize button ("−") hides the window and shows a draggable icon.
- Click the icon to restore the window.

### 3. Create a Tab

Adds a tab button to the sidebar and a scrolling content page.

```lua
local MainTab = Window:AddTab({
    name = "Main",
    theme = MyCustomTheme
})
```

- Tabs have hover animations and switch pages with visibility toggles.
- First tab is active by default.
- Content pages are ScrollingFrames with automatic CanvasSize updates.

------------------------------------------------------------------------

## 🎨 Dynamic Theme System

### Change Theme After GUI Loaded

You can update the theme at any time, even after the GUI has been created. All elements will automatically update their colors.

#### Global Theme Change (All Windows)

```lua
SmileUILib:SetTheme({
    Background = Color3.fromRGB(20, 0, 0),
    Header = Color3.fromRGB(40, 0, 0),
    Accent = Color3.fromRGB(255, 0, 0),
    Text = Color3.fromRGB(255, 50, 50),
    StrokeColor = Color3.fromRGB(150, 0, 0)
})
```

#### Per-Window Theme Change

```lua
Window:SetTheme({
    Accent = Color3.fromRGB(0, 100, 255),
    Text = Color3.fromRGB(100, 200, 255)
})
```

#### Example: Theme Toggle Button

```lua
MainTab:AddButton({
    text = "Switch to Red Theme",
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
            title = "Theme Changed",
            message = "Switched to Red Theme!"
        })
    end
})
```

------------------------------------------------------------------------

## 📄 Documentation

### Global Theme Customization

Customize the default theme before creating windows:

```lua
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
```

- All elements inherit from this theme unless overridden in options.
- **Dynamic Updates**: Use `SmileUILib:SetTheme()` or `Window:SetTheme()` to change colors after creation.

### Notification

Displays an animated bottom-center notification that slides in/out.

```lua
SmileUILib:Notify({
    title = "TITLE",
    message = "Message here",
    duration = 4,
    width = 400,
    theme = MyCustomTheme
})
```

- Animates with back-out/in easing.
- Auto-sizes height based on message length.
- Multiple notifications stack vertically.
- **Note**: Notifications use the theme at creation time. Use global SetTheme before creating notifications for consistent theming.

### Section

Adds a bold header label for grouping elements.

```lua
MainTab:AddSection({
    title = "Section Title",
    textSize = 16,
    textColor = Color3.new(1,1,1)
})
```

- Returns the TextLabel instance for further modification.

### Label

Adds a simple text label.

```lua
MainTab:AddLabel({
    text = "Simple text label",
    textSize = 14,
    textColor = Color3.new(0.5,0.5,0.5)
})
```

- Supports word wrapping and auto-height.
- Returns the TextLabel instance.

### Spacer

Adds vertical empty space.

```lua
MainTab:AddSpacer({
    height = 10
})
```

- Returns the Frame instance.

### Button

Adds a clickable button with hover animation.

```lua
MainTab:AddButton({
    text = "Click Me",
    callback = function() print("Clicked") end,
    height = 40,
    bgColor = Color3.new(0,0.5,0),
    hoverColor = Color3.new(0,1,0)
})
```

- Animates background on hover/leave.
- Returns the TextButton instance.

### Toggle

Adds a switch-style toggle with animation.

```lua
local Toggle = MainTab:AddToggle({
    name = "God Mode",
    default = false,
    callback = function(state) print(state) end,
    height = 36,
    bgColor = Color3.new(0,0.1,0)
})
```

- Toggle box animates color change.
- **API**:
  - `Toggle:GetState()` - Returns current boolean state
  - `Toggle:SetState(boolean)` - Updates toggle programmatically

### Slider

Adds a draggable slider with value display.

```lua
local Slider = MainTab:AddSlider({
    name = "Speed",
    min = 1,
    max = 100,
    default = 16,
    step = 1,
    callback = function(value) print(value) end,
    height = 58,
    bgColor = Color3.new(0,0.1,0)
})
```

- Supports mouse dragging with real-time updates.
- Value is rounded to nearest step.
- **API**:
  - `Slider:GetValue()` - Returns current number value
  - `Slider:SetValue(number)` - Updates slider programmatically

### Dropdown

Adds a cycling dropdown selector.

```lua
local Dropdown = MainTab:AddDropdown({
    name = "Mode",
    options = {"Easy", "Hard", "Extreme"},
    default = "Easy",
    callback = function(choice) print(choice) end,
    height = 40,
    bgColor = Color3.new(0,0.1,0)
})
```

- Clicks cycle through options.
- **API**:
  - `Dropdown:GetSelection()` - Returns current string selection
  - `Dropdown:SetSelection(string)` - Updates dropdown programmatically

### Keybind

Adds a keybind setter with listener.

```lua
local Keybind = MainTab:AddKeybind({
    name = "Toggle UI",
    defaultKey = Enum.KeyCode.RightShift,
    allowMouse = true,
    callback = function(key) print("Bound to", key.Name) end,
    height = 38,
    bgColor = Color3.new(0,0.1,0)
})
```

- Click to enter listening mode ("..."), press key/mouse to set.
- Supports keyboard and mouse (if allowed).
- Disconnects listener on destroy.
- **API**:
  - `Keybind:GetKey()` - Returns current Enum.KeyCode or Enum.UserInputType
  - `Keybind:SetKey(Enum)` - Updates keybind programmatically

### Textbox

Adds an input field.

```lua
local Textbox = MainTab:AddTextbox({
    name = "Input",
    default = "",
    callback = function(text) print(text) end,
    height = 40,
    bgColor = Color3.new(0,0.1,0)
})
```

- Calls callback on FocusLost with enterPressed=true.
- **API**:
  - `Textbox:GetText()` - Returns current string text
  - `Textbox:SetText(string)` - Updates textbox programmatically

### Progress Bar

Adds a fillable progress bar.

```lua
local Progress = MainTab:AddProgressBar({
    name = "Loading",
    max = 100,
    value = 0,
    height = 40,
    bgColor = Color3.new(0,0.1,0)
})

Progress:SetValue(50)
```

- Displays percentage.
- SetValue animates the fill bar.
- **API**:
  - `Progress:GetValue()` - Returns current number value
  - `Progress:SetValue(number)` - Updates progress bar with animation

------------------------------------------------------------------------

## 🎨 Theme Info

- **Default Aesthetic**: Hacker-terminal style with neon green text/accents on black.
- **Customization**: Override SmileUILib.Theme globally or pass per-window/tab/element.
- **Dynamic Theming**: Use `SmileUILib:SetTheme()` or `Window:SetTheme()` to change colors live.
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

Yes, call CreateWindow multiple times. Each can have different themes.

### Q: Can I change themes after creating the UI?

**Yes!** Use `SmileUILib:SetTheme(newTheme)` for global changes or `Window:SetTheme(newTheme)` for specific windows. All elements update automatically.

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
