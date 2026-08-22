local Library = {}

local Player = game:GetService("Players").LocalPlayer
local TS, UIS, mouse = game:GetService("TweenService"), game:GetService("UserInputService"), Player:GetMouse()

local shit = {
    togglebind = Enum.KeyCode.RightShift,
    accent = Color3.fromRGB(106,90,205)
}

function Library:Create(name,subname,keybind)
    if game.CoreGui:FindFirstChild(name) then
        game.CoreGui:FindFirstChild(name):Destroy()
    end
    local xz = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local SubTitle = Instance.new("TextLabel")
    local TabsHolder = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local PageHolder = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local UICorner_2 = Instance.new("UICorner")
    xz.Name = name
    xz.Parent = Player:WaitForChild("PlayerGui")
    xz.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Main.Name = "Main"
    Main.Parent = xz
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0, 192, 0, 224)
    Main.Size = UDim2.new(0, 645, 0, 366)
    UICorner_2.CornerRadius = UDim.new(0, 4)
    UICorner_2.Parent = Main

    -- ✨ Glow around edges
    local glow = Instance.new("UIStroke")
    glow.Thickness = 2
    glow.Color = shit.accent
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow.Parent = Main

    Title.Name = "Title"
    Title.Parent = Main
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.009, 0, 0, 0)
    Title.Size = UDim2.new(0, 179, 0, 34)
    Title.Font = Enum.Font.GothamBold
    Title.Text = name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.TextXAlignment = Enum.TextXAlignment.Left

    SubTitle.Name = "SubTitle"
    SubTitle.Parent = Main
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.new(0.009, 0, 0.093, 0)
    SubTitle.Size = UDim2.new(0, 179, 0, 18)
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.Text = subname
    SubTitle.TextColor3 = Color3.fromRGB(157, 157, 157)
    SubTitle.TextSize = 12
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left

    TabsHolder.Name = "TabsHolder"
    TabsHolder.Parent = Main
    TabsHolder.BackgroundTransparency = 1
    TabsHolder.Position = UDim2.new(0.009, 0, 0.158, 0)
    TabsHolder.Size = UDim2.new(0, 179, 0, 302)
    UIListLayout.Parent = TabsHolder
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)

    PageHolder.Name = "PageHolder"
    PageHolder.Parent = Main
    PageHolder.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    PageHolder.BorderSizePixel = 0
    PageHolder.Position = UDim2.new(0.298, 0, 0.019, 0)
    PageHolder.Size = UDim2.new(0, 447, 0, 353)
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = PageHolder

    -- Dragging
    local function dragify(Frame)
        local dragToggle, dragInput, dragStart, startPos
        local function updateInput(input)
            local Delta = input.Position - dragStart
            local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
            TS:Create(Frame, TweenInfo.new(0.25), {Position = Position}):Play()
        end
        Frame.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UIS:GetFocusedTextBox() == nil then
                dragToggle = true
                dragStart = input.Position
                startPos = Frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragToggle = false
                    end
                end)
            end
        end)
        Frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if input == dragInput and dragToggle then
                updateInput(input)
            end
        end)
    end
    dragify(Main)

    -- 🎬 Animated minimize
    UIS.InputBegan:Connect(function(key,gp)
        if not gp then
            if key.KeyCode == shit.togglebind then
                if Main.Visible then
                    local tweenOut = TS:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.fromOffset(55,55),
                        BackgroundTransparency = 1
                    })
                    tweenOut:Play()
                    tweenOut.Completed:Wait()
                    Main.Visible = false
                else
                    Main.Visible = true
                    Main.Size = UDim2.fromOffset(645,366)
                    Main.BackgroundTransparency = 0
                end
            end
        end
    end)

    -- Shared click sound
    local clickSound = Instance.new("Sound")
    clickSound.SoundId = "rbxassetid://12222005" -- replace with your preferred sound asset
    clickSound.Volume = 0.5
    clickSound.Parent = Main

    local Window = {}

    function Window:tab(tabname,showonstartup)
        local Tab = Instance.new("TextButton")
        local UICorner = Instance.new("UICorner")
        Tab.Name = "Tab"
        Tab.Parent = TabsHolder
        Tab.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        Tab.BorderSizePixel = 0
        Tab.Size = UDim2.new(0, 179, 0, 26)
        Tab.Font = Enum.Font.Gotham
        Tab.Text = tabname
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        Tab.TextSize = 14
        UICorner.CornerRadius = UDim.new(0, 4)
        UICorner.Parent = Tab

        -- Hover animations for tabs
        Tab.MouseEnter:Connect(function()
            TS:Create(Tab, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35,35,35)}):Play()
        end)
        Tab.MouseLeave:Connect(function()
            TS:Create(Tab, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(22,22,22)}):Play()
        end)

        local Page = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local PageContainer = Instance.new("ScrollingFrame")
        local UIListLayout = Instance.new("UIListLayout")
        Page.Name = tabname
        Page.Parent = PageHolder
        Page.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        Page.BorderSizePixel = 0
        Page.Size = UDim2.new(0, 447, 0, 353)
        UICorner.CornerRadius = UDim.new(0, 4)
        UICorner.Parent = Page
        PageContainer.Name = "PageContainer"
        PageContainer.Parent = Page
        PageContainer.Active = true
        PageContainer.BackgroundTransparency = 1
        PageContainer.Position = UDim2.new(0.013, 0, 0.02, 0)
        PageContainer.Size = UDim2.new(0, 435, 0, 339)
        PageContainer.ScrollBarThickness = 0
        UIListLayout.Parent = PageContainer
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 8)

        if showonstartup then
            Page.Visible = true
