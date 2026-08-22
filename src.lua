from pathlib import Path

code = r'''-- Healer UI Library v2
-- UI-only library. Designed to be used in Roblox Studio with a normal LocalScript/ModuleScript.
-- Backwards-compatible controls:
--   page:label(text)
--   page:button(text, callback)
--   page:toggle(text, state, callback)
--   page:input(text, placeholder, clearOnReturn, callback)
--
-- New controls:
--   page:dynamiclabel(text)
--   page:paragraph(title, body)
--   page:separator(text)
--   page:dropdown(text, options, callback)
--   page:slider(text, min, max, default, callback)
--   page:keybind(text, defaultKey, callback)
--   page:section(text, defaultOpen)
--
-- Window methods:
--   window:SetTheme(name)
--   window:SetTransparency(value)
--   window:SetScale(value)
--   window:SetToggleKey(keyCode)
--   window:Notify(title, message, duration)
--   window:ResetPosition()
--   window:Destroy()

local Library = {}

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer

local Themes = {
    Purple = {
        Accent = Color3.fromRGB(106, 90, 205),
        Main = Color3.fromRGB(20, 20, 20),
        Page = Color3.fromRGB(22, 22, 22),
        Item = Color3.fromRGB(25, 25, 25),
        Text = Color3.fromRGB(255, 255, 255),
        Muted = Color3.fromRGB(157, 157, 157)
    },
    Blue = {
        Accent = Color3.fromRGB(65, 135, 235),
        Main = Color3.fromRGB(20, 20, 20),
        Page = Color3.fromRGB(22, 22, 22),
        Item = Color3.fromRGB(25, 25, 25),
        Text = Color3.fromRGB(255, 255, 255),
        Muted = Color3.fromRGB(157, 157, 157)
    },
    Green = {
        Accent = Color3.fromRGB(60, 180, 105),
        Main = Color3.fromRGB(20, 20, 20),
        Page = Color3.fromRGB(22, 22, 22),
        Item = Color3.fromRGB(25, 25, 25),
        Text = Color3.fromRGB(255, 255, 255),
        Muted = Color3.fromRGB(157, 157, 157)
    },
    Red = {
        Accent = Color3.fromRGB(220, 70, 70),
        Main = Color3.fromRGB(20, 20, 20),
        Page = Color3.fromRGB(22, 22, 22),
        Item = Color3.fromRGB(25, 25, 25),
        Text = Color3.fromRGB(255, 255, 255),
        Muted = Color3.fromRGB(157, 157, 157)
    },
    Orange = {
        Accent = Color3.fromRGB(235, 145, 55),
        Main = Color3.fromRGB(20, 20, 20),
        Page = Color3.fromRGB(22, 22, 22),
        Item = Color3.fromRGB(25, 25, 25),
        Text = Color3.fromRGB(255, 255, 255),
        Muted = Color3.fromRGB(157, 157, 157)
    },
    Pink = {
        Accent = Color3.fromRGB(225, 90, 165),
        Main = Color3.fromRGB(20, 20, 20),
        Page = Color3.fromRGB(22, 22, 22),
        Item = Color3.fromRGB(25, 25, 25),
        Text = Color3.fromRGB(255, 255, 255),
        Muted = Color3.fromRGB(157, 157, 157)
    },
    Yellow = {
        Accent = Color3.fromRGB(220, 190, 55),
        Main = Color3.fromRGB(20, 20, 20),
        Page = Color3.fromRGB(22, 22, 22),
        Item = Color3.fromRGB(25, 25, 25),
        Text = Color3.fromRGB(255, 255, 255),
        Muted = Color3.fromRGB(157, 157, 157)
    },
    White = {
        Accent = Color3.fromRGB(120, 120, 120),
        Main = Color3.fromRGB(235, 235, 235),
        Page = Color3.fromRGB(245, 245, 245),
        Item = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(25, 25, 25),
        Muted = Color3.fromRGB(100, 100, 100)
    },
    Black = {
        Accent = Color3.fromRGB(125, 125, 125),
        Main = Color3.fromRGB(10, 10, 10),
        Page = Color3.fromRGB(14, 14, 14),
        Item = Color3.fromRGB(18, 18, 18),
        Text = Color3.fromRGB(245, 245, 245),
        Muted = Color3.fromRGB(135, 135, 135)
    }
}

local function New(className, properties, parent)
    local obj = Instance.new(className)
    for property, value in pairs(properties or {}) do
        obj[property] = value
    end
    if parent then
        obj.Parent = parent
    end
    return obj
end

local function Corner(parent, radius)
    return New("UICorner", {
        CornerRadius = UDim.new(0, radius or 4)
    }, parent)
end

local function Tween(object, info, properties)
    local ok, tween = pcall(function()
        return TweenService:Create(object, info, properties)
    end)
    if ok and tween then
        tween:Play()
        return tween
    end
end

local function ClampNumber(value, minimum, maximum)
    return math.clamp(tonumber(value) or minimum, minimum, maximum)
end

function Library:Create(name, subname, keybind)
    name = tostring(name or "Healer UI")
    subname = tostring(subname or "")
    keybind = keybind or Enum.KeyCode.RightShift

    local old = game:GetService("CoreGui"):FindFirstChild(name)
    if old then
        old:Destroy()
    end

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

    local Scale = New("UIScale", {Scale = 1}, Main)

    local Title = New("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(8, 0),
        Size = UDim2.fromOffset(330, 34),
        Font = Enum.Font.GothamBold,
        Text = name,
        TextColor3 = Themes.Purple.Text,
        TextSize = 24,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Main)

    local SubTitle = New("TextLabel", {
        Name = "SubTitle",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(8, 34),
        Size = UDim2.fromOffset(330, 18),
        Font = Enum.Font.Gotham,
        Text = subname,
        TextColor3 = Themes.Purple.Muted,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Main)

    local TabsHolder = New("Frame", {
        Name = "TabsHolder",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(8, 58),
        Size = UDim2.fromOffset(179, 300)
    }, Main)

    local TabLayout = New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    }, TabsHolder)

    local PageHolder = New("Frame", {
        Name = "PageHolder",
        BackgroundColor3 = Themes.Purple.Page,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(192, 7),
        Size = UDim2.fromOffset(447, 353)
    }, Main)
    Corner(PageHolder, 5)

    local MinimizeButton = New("TextButton", {
        Name = "MinimizeButton",
        BackgroundColor3 = Themes.Purple.Item,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -70, 0, 8),
        Size = UDim2.fromOffset(28, 24),
        Font = Enum.Font.GothamBold,
        Text = "−",
        TextColor3 = Themes.Purple.Text,
        TextSize = 18,
        AutoButtonColor = false
    }, Main)
    Corner(MinimizeButton, 4)

    local CloseButton = New("TextButton", {
        Name = "CloseButton",
        BackgroundColor3 = Themes.Purple.Item,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -36, 0, 8),
        Size = UDim2.fromOffset(28, 24),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Themes.Purple.Text,
        TextSize = 18,
        AutoButtonColor = false
    }, Main)
    Corner(CloseButton, 4)

    local MiniBox = New("TextButton", {
        Name = "MiniBox",
        BackgroundColor3 = Themes.Purple.Main,
        BorderSizePixel = 0,
        Position = Main.Position,
        Size = UDim2.fromOffset(55, 55),
        Font = Enum.Font.GothamBold,
        Text = "+",
        TextColor3 = Themes.Purple.Text,
        TextSize = 24,
        Visible = false,
        AutoButtonColor = false
    }, ScreenGui)
    Corner(MiniBox, 8)

    local Window = {}
    Window.Main = Main
    Window.ScreenGui = ScreenGui
    Window.Theme = "Purple"
    Window.Minimized = false
    Window.ToggleKey = keybind
    Window._themeObjects = {}
    Window._connections = {}
    Window._destroyed = false

    local function registerTheme(object, property, role)
        Window._themeObjects[#Window._themeObjects + 1] = {
            Object = object,
            Property = property,
            Role = role
        }
    end

    registerTheme(Main, "BackgroundColor3", "Main")
    registerTheme(PageHolder, "BackgroundColor3", "Page")
    registerTheme(Title, "TextColor3", "Text")
    registerTheme(SubTitle, "TextColor3", "Muted")
    registerTheme(MinimizeButton, "BackgroundColor3", "Item")
    registerTheme(MinimizeButton, "TextColor3", "Text")
    registerTheme(CloseButton, "BackgroundColor3", "Item")
    registerTheme(CloseButton, "TextColor3", "Text")
    registerTheme(MiniBox, "BackgroundColor3", "Main")
    registerTheme(MiniBox, "TextColor3", "Text")

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

    Window._themeCallbacks = {}

    function Window:OnThemeChanged(callback)
        if typeof(callback) == "function" then
            table.insert(Window._themeCallbacks, callback)
        end
    end

    function Window:SetTransparency(value)
        value = math.clamp(tonumber(value) or 0, 0, 0.95)
        Window.Transparency = value
        Main.BackgroundTransparency = value
        PageHolder.BackgroundTransparency = math.min(value + 0.03, 0.98)
    end

    function Window:SetScale(value)
        value = math.clamp(tonumber(value) or 1, 0.75, 1.5)
        Window.Scale = value
        Scale.Scale = value
    end

    function Window:SetToggleKey(newKey)
        if typeof(newKey) == "EnumItem" and newKey.EnumType == Enum.KeyCode then
            Window.ToggleKey = newKey
            return true
        end
        return false
    end

    function Window:ResetPosition()
        Main.Position = UDim2.fromOffset(192, 224)
        MiniBox.Position = Main.Position
    end

    function Window:Notify(title, message, duration)
        duration = tonumber(duration) or 3
        local holder = ScreenGui:FindFirstChild("Notifications")
        if not holder then
            holder = New("Frame", {
                Name = "Notifications",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 1),
                Position = UDim2.new(1, -15, 1, -15),
                Size = UDim2.fromOffset(310, 400)
            }, ScreenGui)
            New("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                Padding = UDim.new(0, 8)
            }, holder)
        end

        local note = New("Frame", {
            BackgroundColor3 = Themes[Window.Theme].Item,
            BackgroundTransparency = 0.05,
            Size = UDim2.fromOffset(300, 65),
            ClipsDescendants = true
        }, holder)
        Corner(note, 6)
        registerTheme(note, "BackgroundColor3", "Item")

        local titleLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(12, 7),
            Size = UDim2.new(1, -24, 0, 20),
            Font = Enum.Font.GothamBold,
            Text = tostring(title),
            TextColor3 = Themes[Window.Theme].Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        }, note)
        local messageLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(12, 28),
            Size = UDim2.new(1, -24, 0, 30),
            Font = Enum.Font.Gotham,
            Text = tostring(message),
            TextColor3 = Themes[Window.Theme].Muted,
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left
        }, note)
        registerTheme(titleLabel, "TextColor3", "Text")
        registerTheme(messageLabel, "TextColor3", "Muted")

        note.BackgroundTransparency = 1
        Tween(note, TweenInfo.new(0.2), {BackgroundTransparency = 0.05})

        task.delay(duration, function()
            if note and note.Parent then
                Tween(note, TweenInfo.new(0.2), {BackgroundTransparency = 1})
                task.wait(0.22)
                if note then note:Destroy() end
            end
        end)
    end

    local function makeDraggable(frame, handle)
        handle = handle or frame
        local dragging = false
        local dragStart
        local startPos

        local began = handle.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            if UIS:GetFocusedTextBox() then return end
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            local changed
            changed = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if changed then changed:Disconnect() end
                end
            end)
        end)

        local changed = UIS.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement
                and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end

            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end)

        table.insert(Window._connections, began)
        table.insert(Window._connections, changed)
    end

    makeDraggable(Main, Title)
    makeDraggable(MiniBox)

    local minimizedSize = UDim2.fromOffset(55, 55)

    local function setMinimized(value)
        Window.Minimized = value
        if value then
            MiniBox.Position = Main.Position
            MiniBox.Visible = true
            Main.Visible = false
        else
            Main.Visible = true
            MiniBox.Visible = false
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

    table.insert(Window._connections, UIS.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Window.ToggleKey then
            if Window.Minimized then
                MiniBox.Visible = not MiniBox.Visible
            else
                Main.Visible = not Main.Visible
            end
        end
    end))

    function Window:Destroy()
        if Window._destroyed then return end
        Window._destroyed = true
        for _, connection in ipairs(Window._connections) do
            pcall(function() connection:Disconnect() end)
        end
        if ScreenGui then
            ScreenGui:Destroy()
        end
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

        Tab.MouseEnter:Connect(function()
            if not Page.Visible then
                Tween(Tab, TweenInfo.new(0.12), {BackgroundColor3 = Themes[Window.Theme].Page})
            end
        end)
        Tab.MouseLeave:Connect(function()
            if not Page.Visible then
                Tween(Tab, TweenInfo.new(0.12), {BackgroundColor3 = Themes[Window.Theme].Item})
            end
        end)

        Tab.MouseButton1Click:Connect(function()
            for _, page in ipairs(PageHolder:GetChildren()) do
                if page:IsA("Frame") then
                    page.Visible = false
                end
            end
            for _, button in ipairs(TabsHolder:GetChildren()) do
                if button:IsA("TextButton") then
                    button.TextTransparency = 0.5
                end
            end
            Page.Visible = true
            Tab.TextTransparency = 0
        end)

        local PageAPI = {}
        PageAPI.Page = Page
        PageAPI.Container = Container

        function PageAPI:label(text)
            local frame = New("Frame", {
                BackgroundColor3 = Themes[Window.Theme].Item,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 32)
            }, Container)
            Corner(frame, 4)
            registerTheme(frame, "BackgroundColor3", "Item")

            local label = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(10, 0),
                Size = UDim2.new(1, -20, 1, 0),
                Font = Enum.Font.Gotham,
                Text = tostring(text),
                TextColor3 = Themes[Window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            }, frame)
            registerTheme(label, "TextColor3", "Text")
            return label
        end

        function PageAPI:dynamiclabel(text)
            local label = self:label(text)
            local object = {}
            function object:SetText(newText)
                if label and label.Parent then
                    label.Text = tostring(newText)
                end
            end
            function object:GetText()
                return label and label.Text or ""
            end
            function object:Destroy()
                if label then label.Parent:Destroy() end
            end
            return object
        end

        function PageAPI:paragraph(title, body)
            local frame = New("Frame", {
                BackgroundColor3 = Themes[Window.Theme].Item,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 62)
            }, Container)
            Corner(frame, 4)
            registerTheme(frame, "BackgroundColor3", "Item")

            local heading = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(10, 6),
                Size = UDim2.new(1, -20, 0, 20),
                Font = Enum.Font.GothamBold,
                Text = tostring(title),
                TextColor3 = Themes[Window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            }, frame)
            local description = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(10, 27),
                Size = UDim2.new(1, -20, 0, 28),
                Font = Enum.Font.Gotham,
                Text = tostring(body),
                TextColor3 = Themes[Window.Theme].Muted,
                TextSize = 12,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left
            }, frame)
            registerTheme(heading, "TextColor3", "Text")
            registerTheme(description, "TextColor3", "Muted")
            return frame
        end

        function PageAPI:separator(text)
            local frame = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 24)
            }, Container)

            local line = New("Frame", {
                BackgroundColor3 = Themes[Window.Theme].Muted,
                BackgroundTransparency = 0.65,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 0, 1)
            }, frame)

            if text and tostring(text) ~= "" then
                local label = New("TextLabel", {
                    BackgroundColor3 = Themes[Window.Theme].Page,
                    Position = UDim2.fromOffset(8, 4),
                    Size = UDim2.fromOffset(120, 16),
                    Font = Enum.Font.GothamBold,
                    Text = tostring(text),
                    TextColor3 = Themes[Window.Theme].Muted,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, frame)
                registerTheme(label, "BackgroundColor3", "Page")
                registerTheme(label, "TextColor3", "Muted")
            end
            return frame
        end

        function PageAPI:button(text, callback)
            callback = callback or function() end

            local frame = New("Frame", {
                BackgroundColor3 = Themes[Window.Theme].Item,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 32)
            }, Container)
            Corner(frame, 4)
            registerTheme(frame, "BackgroundColor3", "Item")

            local button = New("TextButton", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(10, 0),
                Size = UDim2.new(1, -20, 1, 0),
                Font = Enum.Font.Gotham,
                Text = tostring(text),
                TextColor3 = Themes[Window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false
            }, frame)
            registerTheme(button, "TextColor3", "Text")

            button.MouseEnter:Connect(function()
                Tween(frame, TweenInfo.new(0.12), {BackgroundColor3 = Themes[Window.Theme].Page})
            end)
            button.MouseLeave:Connect(function()
                Tween(frame, TweenInfo.new(0.12), {BackgroundColor3 = Themes[Window.Theme].Item})
            end)
            button.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
            return button
        end

        function PageAPI:toggle(text, state, callback)
            callback = callback or function() end
            local toggled = state == true

            local frame = New("Frame", {
                BackgroundColor3 = Themes[Window.Theme].Item,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 32)
            }, Container)
            Corner(frame, 4)
            registerTheme(frame, "BackgroundColor3", "Item")

            local button = New("TextButton", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(10, 0),
                Size = UDim2.new(1, -20, 1, 0),
                Font = Enum.Font.Gotham,
                Text = tostring(text),
                TextColor3 = Themes[Window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false
            }, frame)
            registerTheme(button, "TextColor3", "Text")

            local box = New("Frame", {
                BackgroundColor3 = Themes[Window.Theme].Page,
                Position = UDim2.new(1, -34, 0.5, -10),
                Size = UDim2.fromOffset(24, 20)
            }, frame)
            Corner(box, 4)
            registerTheme(box, "BackgroundColor3", "Page")

            local indicator = New("Frame", {
                BackgroundColor3 = Themes[Window.Theme].Accent,
                Position = UDim2.fromOffset(3, 3),
                Size = UDim2.fromOffset(18, 14),
                Visible = toggled
            }, box)
            Corner(indicator, 3)

            local function refresh()
                indicator.Visible = toggled
                if toggled then
                    Tween(indicator, TweenInfo.new(0.12), {
                        BackgroundColor3 = Themes[Window.Theme].Accent
                    })
                end
            end

            button.MouseButton1Click:Connect(function()
                toggled = not toggled
                refresh()
                pcall(callback, toggled)
            end)

            return {
                Set = function(_, value)
                    toggled = value == true
                    refresh()
                    pcall(callback, toggled)
                end,
                Get = function()
                    return toggled
                end
            }
        end

        function PageAPI:input(text, placeholder, clearOnReturn, callback)
            callback = callback or function() end

            local frame = New("Frame", {
                BackgroundColor3 = Themes[Window.Theme].Item,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 32)
            }, Container)
            Corner(frame, 4)
            registerTheme(frame, "BackgroundColor3", "Item")

            local label = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(10, 0),
                Size = UDim2.new(1, -155, 1, 0),
                Font = Enum.Font.Gotham,
                Text = tostring(text),
                TextColor3 = Themes[Window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            }, frame)
            registerTheme(label, "TextColor3", "Text")

            local box = New("TextBox", {
                BackgroundColor3 = Themes[Window.Theme].Page,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -144, 0.5, -12),
                Size = UDim2.fromOffset(134, 24),
                Font = Enum.Font.Gotham,
                Text = "",
                PlaceholderText = placeholder or "",
                ClearTextOnFocus = false,
                TextColor3 = Themes[Window.Theme].Text,
                PlaceholderColor3 = Themes[Window.Theme].Muted,
                TextSize = 14
            }, frame)
            Corner(box, 4)
            registerTheme(box, "BackgroundColor3", "Page")
            registerTheme(box, "TextColor3", "Text")
            registerTheme(box, "PlaceholderColor3", "Muted")

            box.FocusLost:Connect(function()
                pcall(callback, tostring(box.Text))
                if clearOnReturn then
                    box.Text = ""
                end
            end)
            return box
        end

        function PageAPI:dropdown(text, options, callback)
            callback = callback or function() end
            options = options or {}

            local frame = New("Frame", {
                BackgroundColor3 = Themes[Window.Theme].Item,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 32),
                ClipsDescendants = true
            }, Container)
            Corner(frame, 4)
            registerTheme(frame, "BackgroundColor3", "Item")

            local button = New("TextButton", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(10, 0),
                Size = UDim2.new(1, -20, 0, 32),
                Font = Enum.Font.Gotham,
                Text = tostring(text) .. ": " .. tostring(options[1] or "None"),
                TextColor3 = Themes[Window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false
            }, frame)
            registerTheme(button, "TextColor3", "Text")

            local list = New("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(8, 34),
                Size = UDim2.new(1, -16, 0, math.min(#options * 28, 140)),
                Visible = false
            }, frame)
            local listLayout = New("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 3)
            }, list)

            local open = false
            local selected = options[1]

            local function refresh()
                local height = open and (36 + math.min(#options * 28, 140)) or 32
                Tween(frame, TweenInfo.new(0.16), {
                    Size = UDim2.new(1, 0, 0, height)
                })
                list.Visible = open
            end

            for _, option in ipairs(options) do
                local optionButton = New("TextButton", {
                    BackgroundColor3 = Themes[Window.Theme].Page,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 26),
                    Font = Enum.Font.Gotham,
                    Text = tostring(option),
                    TextColor3 = Themes[Window.Theme].Text,
                    TextSize = 12,
                    AutoButtonColor = false
                }, list)
                Corner(optionButton, 3)
                registerTheme(optionButton, "BackgroundColor3", "Page")
                registerTheme(optionButton, "TextColor3", "Text")

                optionButton.MouseButton1Click:Connect(function()
                    selected = option
                    button.Text = tostring(text) .. ": " .. tostring(option)
                    open = false
                    refresh()
                    pcall(callback, option)
                end)
            end

            button.MouseButton1Click:Connect(function()
                open = not open
                refresh()
            end)

            return {
                Set = function(_, value)
                    for _, option in ipairs(options) do
                        if option == value then
                            selected = value
                            button.Text = tostring(text) .. ": " .. tostring(value)
                            pcall(callback, value)
                            break
                        end
                    end
                end,
                Get = function()
                    return selected
                end
            }
        end

        function PageAPI:slider(text, minimum, maximum, default, callback)
            callback = callback or function() end
            minimum = tonumber(minimum) or 0
            maximum = tonumber(maximum) or 100
            default = ClampNumber(default or minimum, minimum, maximum)

            local frame = New("Frame", {
                BackgroundColor3 = Themes[Window.Theme].Item,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 50)
            }, Container)
            Corner(frame, 4)
            registerTheme(frame, "BackgroundColor3", "Item")

            local label = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(10, 4),
                Size = UDim2.new(1, -20, 0, 18),
                Font = Enum.Font.Gotham,
                Text = tostring(text) .. ": " .. tostring(default),
                TextColor3 = Themes[Window.Theme].Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            }, frame)
            registerTheme(label, "TextColor3", "Text")

            local bar = New("Frame", {
                BackgroundColor3 = Themes[Window.Theme].Page,
                BorderSizePixel = 0,
                Position = UDim2.fromOffset(10, 29),
                Size = UDim2.new(1, -20, 0, 8)
            }, frame)
            Corner(bar, 4)
            registerTheme(bar, "BackgroundColor3", "Page")

            local fill = New("Frame", {
                BackgroundColor3 = Themes[Window.Theme].Accent,
                BorderSizePixel = 0,
                Size = UDim2.new((default - minimum) / (maximum - minimum), 0, 1, 0)
            }, bar)
            Corner(fill, 4)

            local knob = New("TextButton", {
                BackgroundColor3 = Themes[Window.Theme].Accent,
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new((default - minimum) / (maximum - minimum), 0, 0.5, 0),
                Size = UDim2.fromOffset(12, 12),
                Text = "",
                AutoButtonColor = false
            }, bar)
            Corner(knob, 6)

            local value = default
            local dragging = false

            local function setValue(newValue, fire)
                value = ClampNumber(newValue, minimum, maximum)
                local alpha = (value - minimum) / (maximum - minimum)
                fill.Size = UDim2.new(alpha, 0, 1, 0)
                knob.Position = UDim2.new(alpha, 0, 0.5, 0)
                label.Text = tostring(text) .. ": " .. tostring(value)
                if fire then pcall(callback, value) end
            end

            local function fromInput(input)
                local alpha = math.clamp(
                    (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
                    0, 1
                )
                setValue(minimum + (maximum - minimum) * alpha, true)
            end

            knob.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)

            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch) then
                    fromInput(input)
                end
            end)

            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    fromInput(input)
                end
            end)

            return {
                Set = function(_, newValue)
                    setValue(newValue, true)
                end,
                Get = function()
                    return value
                end
            }
        end

        function PageAPI:keybind(text, defaultKey, callback)
            callback = callback or function() end
            local currentKey = defaultKey or Enum.KeyCode.RightShift
            local listening = false

            local frame = New("Frame", {
                BackgroundColor3 = Themes[Window.Theme].Item,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 32)
            }, Container)
            Corner(frame, 4)
            registerTheme(frame, "BackgroundColor3", "Item")

            local label = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(10, 0),
                Size = UDim2.new(1, -150, 1, 0),
                Font = Enum.Font.Gotham,
                Text = tostring(text),
                TextColor3 = Themes[Window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            }, frame)
            registerTheme(label, "TextColor3", "Text")

            local button = New("TextButton", {
                BackgroundColor3 = Themes[Window.Theme].Page,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -144, 0.5, -12),
                Size = UDim2.fromOffset(134, 24),
                Font = Enum.Font.Gotham,
                Text = currentKey.Name,
                TextColor3 = Themes[Window.Theme].Text,
                TextSize = 12,
                AutoButtonColor = false
            }, frame)
            Corner(button, 4)
            registerTheme(button, "BackgroundColor3", "Page")
            registerTheme(button, "TextColor3", "Text")

            button.MouseButton1Click:Connect(function()
                listening = true
                button.Text = "Press a key..."
            end)

            local connection = UIS.InputBegan:Connect(function(input, processed)
                if processed or not listening then return end
                if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
                currentKey = input.KeyCode
                listening = false
                button.Text = currentKey.Name
                pcall(callback, currentKey)
            end)
            table.insert(Window._connections, connection)

            return {
                Set = function(_, key)
                    if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
                        currentKey = key
                        button.Text = key.Name
                        pcall(callback, key)
                    end
                end,
                Get = function()
                    return currentKey
                end
            }
        end

        function PageAPI:section(text, defaultOpen)
            local open = defaultOpen ~= false

            local holder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, open and 38 or 32),
                ClipsDescendants = true
            }, Container)

            local header = New("TextButton", {
                BackgroundColor3 = Themes[Window.Theme].Item,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 32),
                Font = Enum.Font.GothamBold,
                Text = (open and "▼ " or "▶ ") .. tostring(text),
                TextColor3 = Themes[Window.Theme].Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false
            }, holder)
            Corner(header, 4)
            registerTheme(header, "BackgroundColor3", "Item")
            registerTheme(header, "TextColor3", "Text")

            local contents = New("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(0, 38),
                Size = UDim2.new(1, 0, 0, 0)
            }, holder)

            local layout = New("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            }, contents)

            local api = {}

            function api:Add(widget)
                if typeof(widget) == "Instance" then
                    widget.Parent = contents
                end
            end

            local function refresh()
                local contentHeight = layout.AbsoluteContentSize.Y
                local target = open and (38 + contentHeight) or 32
                holder.Size = UDim2.new(1, 0, 0, target)
                contents.Size = UDim2.new(1, 0, 0, contentHeight)
                header.Text = (open and "▼ " or "▶ ") .. tostring(text)
            end

            header.MouseButton1Click:Connect(function()
                open = not open
                refresh()
            end)

            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refresh)
            task.defer(refresh)

            return api
        end

        Window:OnThemeChanged(function(_, theme)
            for _, object in ipairs(Page:GetDescendants()) do
                if object:IsA("ScrollingFrame") then
                    object.ScrollBarImageColor3 = theme.Accent
                end
            end
        end)

        tabs[#tabs + 1] = PageAPI
        return PageAPI
    end

    -- Lightweight live statistics API for Settings pages.
    function Window:GetStats()
        local fps = math.floor(1 / math.max(RunService.RenderStepped:Wait(), 1 / 1000))
        local ping = 0
        pcall(function()
            local network = Stats.Network
            local serverStats = network and network.ServerStatsItem
            local item = serverStats and serverStats["Data Ping"]
            if item then
                ping = math.floor(item:GetValue())
            end
        end)

        return {
            FPS = fps,
            Ping = ping,
            Players = #Players:GetPlayers(),
            MaxPlayers = Players.MaxPlayers,
            PlaceId = game.PlaceId,
            JobId = game.JobId
        }
    end

    Window:OnThemeChanged(function(_, theme)
        for _, item in ipairs(Window._themeObjects) do
            if item.Object and item.Object.Parent then
                local value = theme[item.Role]
                if value then
                    item.Object[item.Property] = value
                end
            end
        end
    end)

    Window:SetTheme("Purple")

    return Window
end

return Library
'''

path = Path("/mnt/data/src_v2.lua")
path.write_text(code, encoding="utf-8")
print(f"Created {path} ({len(code.splitlines())} lines).")