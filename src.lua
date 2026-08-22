-- Healer UI Library v2 (Polished)
-- Added glow edges, animated minimize, and theme switch enhancements

-- [imports and setup remain unchanged]
local Library = {}
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer

-- Themes table remains unchanged...

-- Utility functions remain unchanged...

function Library:Create(name, subname, keybind)
    name = tostring(name or "Healer UI")
    subname = tostring(subname or "")
    keybind = keybind or Enum.KeyCode.RightShift

    local old = game:GetService("CoreGui"):FindFirstChild(name)
    if old then old:Destroy() end

    local ScreenGui = New("ScreenGui", {
        Name = name,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, game:GetService("CoreGui"))

    local Main = New("Frame", {
        Name = "Main",
        BackgroundColor3 = Themes.Purple.Main,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(192, 224),
        Size = UDim2.fromOffset(645, 366),
        ClipsDescendants = true
    }, ScreenGui)
    Corner(Main, 6)

    -- ✨ Glow around edges
    local glow = Instance.new("UIStroke")
    glow.Thickness = 2
    glow.Color = Themes.Purple.Accent
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow.Parent = Main

    local Scale = New("UIScale", {Scale = 1}, Main)

    -- Title, SubTitle, TabsHolder, PageHolder, MinimizeButton, CloseButton, MiniBox setup unchanged...

    local Window = {}
    Window.Main = Main
    Window.ScreenGui = ScreenGui
    Window.Theme = "Purple"
    Window.Minimized = false
    Window.ToggleKey = keybind
    Window._themeObjects = {}
    Window._connections = {}
    Window._destroyed = false

    -- Theme registration functions unchanged...

    function Window:SetTheme(themeName)
        if not Themes[themeName] then
            warn("Unknown theme:", themeName)
            return false
        end
        Window.Theme = themeName
        local theme = Themes[themeName]
        for _, item in ipairs(Window._themeObjects) do
            if item.Object and item.Object.Parent then
                local value = theme[item.Role]
                if value then
                    item.Object[item.Property] = value
                end
            end
        end
        for _, callback in ipairs(Window._themeCallbacks or {}) do
            pcall(callback, themeName, theme)
        end
        return true
    end

    -- Transparency, Scale, ToggleKey, ResetPosition, Notify unchanged...

    -- Draggable setup unchanged...

    local minimizedSize = UDim2.fromOffset(55, 55)

    -- 🎬 Animated minimize
    local function setMinimized(value)
        Window.Minimized = value
        if value then
            local tweenOut = TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(55,55),
                BackgroundTransparency = 1
            })
            tweenOut:Play()
            tweenOut.Completed:Wait()
            Main.Visible = false
            MiniBox.Visible = true
        else
            MiniBox.Visible = false
            Main.Visible = true
            Main.Size = UDim2.fromOffset(645,366)
            Main.BackgroundTransparency = 0
        end
    end

    MinimizeButton.MouseButton1Click:Connect(function()
        setMinimized(true)
    end)

    MiniBox.MouseButton1Click:Connect(function()
        setMinimized(false)
    end)

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = false
    end)

    -- ToggleKey handling unchanged...

    function Window:Destroy()
        if Window._destroyed then return end
        Window._destroyed = true
        for _, connection in ipairs(Window._connections) do
            pcall(function() connection:Disconnect() end)
        end
        if ScreenGui then ScreenGui:Destroy() end
    end

    local tabs = {}
    local firstTab = true

    function Window:tab(tabName, showOnStartup)
        tabName = tostring(tabName)

        local Tab = New("TextButton", {
            Name = "Tab",
            BackgroundColor3 = Themes[Window.Theme].Item,
            BorderSizePixel = 0,
            Size = UDim2.fromOffset(179, 30),
            Font = Enum.Font.Gotham,
            Text = tabName,
            TextColor3 = Themes[Window.Theme].Text,
            TextSize = 14,
            TextTransparency = showOnStartup and 0 or 0.5,
            AutoButtonColor = false
        }, TabsHolder)
        Corner(Tab, 4)
        registerTheme(Tab, "BackgroundColor3", "Item")
        registerTheme(Tab, "TextColor3", "Text")

        local Page = New("Frame", {
            Name = tabName,
            BackgroundColor3 = Themes[Window.Theme].Page,
            BorderSizePixel = 0,
            Size = UDim2.fromScale(1, 1),
            Visible = showOnStartup or (firstTab and showOnStartup == nil)
        }, PageHolder)
        Corner(Page, 4)
        registerTheme(Page, "BackgroundColor3", "Page")

        local Container = New("ScrollingFrame", {
            Name = "PageContainer",
            Active = true,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(6, 6),
            Size = UDim2.new(1, -12, 1, -12),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Themes[Window.Theme].Accent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new()
        }, Page)

        local Layout = New("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        }, Container)

        local Padding = New("UIPadding", {
            PaddingBottom = UDim.new(0, 8)
        }, Container)

        firstTab = false

        -- Tab hover/click handling unchanged...

        local PageAPI = {}
        PageAPI.Page = Page
        PageAPI.Container = Container

        -- Existing PageAPI methods unchanged...

        -- 🎨 Add theme switch button
        function PageAPI:addThemeSwitcher()
            self:button("Switch Theme", function()
                local themeNames = {"Purple","Blue","Green","Red","Orange","Pink","Yellow","White","Black"}
                Window:SetTheme(themeNames[math.random(1,#themeNames)])
            end)
        end

        return PageAPI
    end

    -- Optional pulsing glow effect
    task.spawn(function()
        while Main.Parent do
            TweenService:Create(glow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true), {
                Color = Themes[Window.Theme].Accent
            }):Play()
            task.wait(2)
        end
    end)

    return Window
end

return Library
