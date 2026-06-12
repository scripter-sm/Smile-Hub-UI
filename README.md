# ❄️ Smile Hub UI Library

A **clean, animated, hacker-style Roblox UI Library** made for developers.\
Designed with performance, visuals, and simplicity in mind.

------------------------------------------------------------------------

## 🌊 About

**Smile Hub UI** is an **open‑source Roblox UI library** that
provides: - Animated windows - Tab-based layout - Modern green terminal
aesthetic - Built‑in notifications - Easy API for toggles, sliders,
dropdowns, buttons, keybinds

This library is **FREE**, **OPEN SOURCE**, and made for learning & real
usage.

------------------------------------------------------------------------

## 🔗 Raw Library URL

``` lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/RblxScriptsOG/Smile-Hub-UI/refs/heads/main/lib.lua"))()
```

------------------------------------------------------------------------

## 💫 Getting Started

### 1. Load the Library

``` lua
local SmileUILib = loadstring(game:HttpGet("YOUR_RAW_URL"))()
```

### 2. Create a Window

``` lua
local Window = SmileUILib:CreateWindow("Smile Hub", 580, 420)
```

### 3️. Create a Tab

``` lua
local MainTab = Window:AddTab("Main")
```

------------------------------------------------------------------------

## 📄 Documentation

### Notification

``` lua
SmileUILib:Notify("TITLE", "Message here", 4)
```

------------------------------------------------------------------------

### Tabs

``` lua
local tab = Window:AddTab("Tab Name")
```

------------------------------------------------------------------------

### Section

``` lua
tab:AddSection("Section Title")
```

------------------------------------------------------------------------

### Label

``` lua
tab:AddLabel("Simple text label")
```

------------------------------------------------------------------------

### Spacer

``` lua
tab:AddSpacer(10)
```

------------------------------------------------------------------------

### Button

``` lua
tab:AddButton("Click Me", function()
    print("Clicked")
end)
```

------------------------------------------------------------------------

### Toggle

``` lua
tab:AddToggle("God Mode", false, function(state)
    print(state)
end)
```

------------------------------------------------------------------------

### Slider

``` lua
tab:AddSlider("Speed", 1, 100, 16, function(value)
    print(value)
end)
```

------------------------------------------------------------------------

### Dropdown

``` lua
tab:AddDropdown("Mode", {"Easy", "Hard", "Extreme"}, "Easy", function(choice)
    print(choice)
end)
```

------------------------------------------------------------------------

### Keybind

``` lua
tab:AddKeybind("Toggle UI", Enum.KeyCode.RightShift, function(key)
    print("Bound to", key.Name)
end)
```

------------------------------------------------------------------------

## 🎨 Theme Info

Default theme: - Background: Black - Accent: Neon Green - Font: Arcade -
Rounded Corners - Smooth Tween Animations

Theme is **hardcoded** for consistency & performance.

------------------------------------------------------------------------

## ⁉️ FAQ

### Q: Is this safe?

Yes. No backdoors, no obfuscation.

### Q: Can I modify it?

Yes. Fully open source.

### Q: Will it lag?

No. Optimized UI & tweens.

### Q: Can I reupload?
Yes, but **credits required**.

------------------------------------------------------------------------

## 📜 License

**MIT License**\
You are free to: - Use - Modify - Share

Just **credit the original creator**.

------------------------------------------------------------------------

## ❤️ Credits

-   **Creator:** Scripter.SM
-   **Discord:** https://discord.gg/mHJgVNFdN9
-   **GitHub:** https://github.com/RblxScriptsOG
-   **UI Concept & Code:** Smile Hub UI

If you use this library, please ⭐ the repository.

------------------------------------------------------------------------

## Support

If you like this project: - Star the repo ⭐ - Share it - Improve it
