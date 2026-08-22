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

	-- allow a per-window keybind override, fall back to the config default
	local toggleKey = keybind or shit.togglebind

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
	xz.Parent = game.CoreGui
	xz.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	Main.Name = "Main"
	Main.Parent = xz
	Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	Main.BorderSizePixel = 0
	Main.Position = UDim2.new(0, 192, 0, 224)
	Main.Size = UDim2.new(0, 645, 0, 366)
	Title.Name = "Title"
	Title.Parent = Main
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.Position = UDim2.new(0.00930232555, 0, 0, 0)
	Title.Size = UDim2.new(0, 179, 0, 34)
	Title.Font = Enum.Font.GothamBold
	Title.Text = name
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 24.000
	Title.TextXAlignment = Enum.TextXAlignment.Left
	SubTitle.Name = "SubTitle"
	SubTitle.Parent = Main
	SubTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SubTitle.BackgroundTransparency = 1.000
	SubTitle.Position = UDim2.new(0.00930232555, 0, 0.0928961784, 0)
	SubTitle.Size = UDim2.new(0, 179, 0, 18)
	SubTitle.Font = Enum.Font.Gotham
	SubTitle.Text = subname
	SubTitle.TextColor3 = Color3.fromRGB(157, 157, 157)
	SubTitle.TextSize = 12.000
	SubTitle.TextXAlignment = Enum.TextXAlignment.Left
	TabsHolder.Name = "TabsHolder"
	TabsHolder.Parent = Main
	TabsHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabsHolder.BackgroundTransparency = 1.000
	TabsHolder.BorderSizePixel = 0
	TabsHolder.Position = UDim2.new(0.00930232555, 0, 0.158469945, 0)
	TabsHolder.Size = UDim2.new(0, 179, 0, 302)
	UIListLayout.Parent = TabsHolder
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 8)
	PageHolder.Name = "PageHolder"
	PageHolder.Parent = Main
	PageHolder.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	PageHolder.BorderSizePixel = 0
	PageHolder.Position = UDim2.new(0.297674417, 0, 0.0191256832, 0)
	PageHolder.Size = UDim2.new(0, 447, 0, 353)
	UICorner.CornerRadius = UDim.new(0, 4)
	UICorner.Parent = PageHolder
	UICorner_2.CornerRadius = UDim.new(0, 4)
	UICorner_2.Parent = Main

	-- Minimize system
	local Minimized = false

	local MinimizeButton = Instance.new("TextButton")
	MinimizeButton.Name = "MinimizeButton"
	MinimizeButton.Parent = Main
	MinimizeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	MinimizeButton.BorderSizePixel = 0
	MinimizeButton.Position = UDim2.new(1, -38, 0, 8)
	MinimizeButton.Size = UDim2.new(0, 28, 0, 24)
	MinimizeButton.Font = Enum.Font.GothamBold
	MinimizeButton.Text = "-"
	MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	MinimizeButton.TextSize = 18

	local MinimizeCorner = Instance.new("UICorner")
	MinimizeCorner.CornerRadius = UDim.new(0, 4)
	MinimizeCorner.Parent = MinimizeButton

	local MiniBox = Instance.new("TextButton")
	MiniBox.Name = "MiniBox"
	MiniBox.Parent = xz
	MiniBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	MiniBox.BorderSizePixel = 0
	MiniBox.Position = Main.Position
	MiniBox.Size = UDim2.new(0, 55, 0, 55)
	MiniBox.Font = Enum.Font.GothamBold
	MiniBox.Text = "+"
	MiniBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	MiniBox.TextSize = 24
	MiniBox.Visible = false
	MiniBox.AutoButtonColor = true

	local MiniCorner = Instance.new("UICorner")
	MiniCorner.CornerRadius = UDim.new(0, 8)
	MiniCorner.Parent = MiniBox

	-- Dragging for the minimized box
	local dragging = false
	local dragStart
	local startPosition

	MiniBox.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			dragStart = input.Position
			startPosition = MiniBox.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	MiniBox.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			local connection
			connection = UIS.InputChanged:Connect(function(changedInput)
				if not dragging then
					connection:Disconnect()
					return
				end

				if changedInput == input then
					local delta = changedInput.Position - dragStart

					MiniBox.Position = UDim2.new(
						startPosition.X.Scale,
						startPosition.X.Offset + delta.X,
						startPosition.Y.Scale,
						startPosition.Y.Offset + delta.Y
					)
				end
			end)
		end
	end)

	-- Minimize
	MinimizeButton.MouseButton1Click:Connect(function()
		Minimized = true
		Main.Visible = false
		MiniBox.Visible = true
	end)

	-- Restore
	MiniBox.MouseButton1Click:Connect(function()
		Minimized = false
		Main.Visible = true
		MiniBox.Visible = false
	end)


	local function dragify(Frame)
		local dragToggle = nil
		local dragInput = nil
		local dragStart = nil
		local startPos = nil

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
	UIS.InputBegan:Connect(function(key,gp)
		if not gp then
			if key.KeyCode == toggleKey then
				if Minimized then
					MiniBox.Visible = not MiniBox.Visible
				else
					Main.Visible = not Main.Visible
				end
			end
		end
	end)

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
		Tab.TextSize = 14.000
		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Tab

		local Page = Instance.new("Frame")
		local PageCorner = Instance.new("UICorner")
		local PageContainer = Instance.new("ScrollingFrame")
		local PageListLayout = Instance.new("UIListLayout")
		Page.Name = tabname
		Page.Parent = PageHolder
		Page.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
		Page.BorderSizePixel = 0
		Page.Size = UDim2.new(0, 447, 0, 353)
		PageCorner.CornerRadius = UDim.new(0, 4)
		PageCorner.Parent = Page
		PageContainer.Name = "PageContainer"
		PageContainer.Parent = Page
		PageContainer.Active = true
		PageContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		PageContainer.BackgroundTransparency = 1.000
		PageContainer.BorderSizePixel = 0
		PageContainer.Position = UDim2.new(0.0134228189, 0, 0.0198300276, 0)
		PageContainer.Size = UDim2.new(0, 435, 0, 339)
		PageContainer.ScrollBarThickness = 0
		PageContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
		PageContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
		PageListLayout.Parent = PageContainer
		PageListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageListLayout.Padding = UDim.new(0, 8)

		if showonstartup then
			Page.Visible = true
			Tab.TextTransparency = 0
			Tab.TextColor3 = shit.accent
		else
			Page.Visible = false
			Tab.TextTransparency = 0.5
		end

		Tab.MouseButton1Click:Connect(function()
			for i,v in pairs(PageHolder:GetChildren()) do
				if v:IsA("Frame") then
					v.Visible = false
				end
			end
			for x,z in pairs(TabsHolder:GetChildren()) do
				if z:IsA("TextButton") then
					z.TextTransparency = 0.5
					z.TextColor3 = Color3.fromRGB(255, 255, 255)
				end
			end
			Page.Visible = true
			Tab.TextTransparency = 0
			Tab.TextColor3 = shit.accent
		end)

		local pageitems = {}

		function pageitems:label(text)
			local Label = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local LabelText = Instance.new("TextLabel")
			Label.Name = text
			Label.Parent = PageContainer
			Label.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			Label.BorderSizePixel = 0
			Label.Size = UDim2.new(0, 435, 0, 32)
			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Label
			LabelText.Name = "LabelText"
			LabelText.Text = tostring(text)
			LabelText.Parent = Label
			LabelText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			LabelText.BackgroundTransparency = 1.000
			LabelText.Position = UDim2.new(0.0137931034, 0, 0, 0)
			LabelText.Size = UDim2.new(0, 423, 0, 32)
			LabelText.Font = Enum.Font.Gotham
			LabelText.TextColor3 = Color3.fromRGB(255, 255, 255)
			LabelText.TextSize = 14.000
			LabelText.TextXAlignment = Enum.TextXAlignment.Left
		end

		-- NEW: divider, for splitting a tab into labeled sections
		function pageitems:divider(text)
			local Divider = Instance.new("Frame")
			Divider.Name = "Divider_" .. tostring(text)
			Divider.Parent = PageContainer
			Divider.BackgroundTransparency = 1
			Divider.Size = UDim2.new(0, 435, 0, 24)

			local Line = Instance.new("Frame")
			Line.Parent = Divider
			Line.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			Line.BorderSizePixel = 0
			Line.AnchorPoint = Vector2.new(0, 0.5)
			Line.Position = UDim2.new(0, 0, 0.5, 0)
			Line.Size = UDim2.new(1, 0, 0, 1)

			if text and text ~= "" then
				local DividerText = Instance.new("TextLabel")
				DividerText.Parent = Divider
				DividerText.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
				DividerText.Position = UDim2.new(0, 0, 0, 0)
				DividerText.Size = UDim2.new(0, 120, 0, 24)
				DividerText.Font = Enum.Font.GothamBold
				DividerText.Text = tostring(text)
				DividerText.TextColor3 = Color3.fromRGB(157, 157, 157)
				DividerText.TextSize = 12.000
				DividerText.TextXAlignment = Enum.TextXAlignment.Left
			end
		end

		function pageitems:button(text,callback)
			local callback = callback or function() end

			local Button = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local Button_2 = Instance.new("TextButton")
			Button.Name = text
			Button.Parent = PageContainer
			Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			Button.BorderSizePixel = 0
			Button.Size = UDim2.new(0, 435, 0, 32)
			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Button
			Button_2.Name = "Button"
			Button_2.Parent = Button
			Button_2.Text = text
			Button_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Button_2.BackgroundTransparency = 1.000
			Button_2.Position = UDim2.new(0.0140000004, 0, 0, 0)
			Button_2.Size = UDim2.new(0, 423, 0, 32)
			Button_2.Font = Enum.Font.Gotham
			Button_2.TextColor3 = Color3.fromRGB(255, 255, 255)
			Button_2.TextSize = 14.000
			Button_2.TextXAlignment = Enum.TextXAlignment.Left

			Button_2.MouseButton1Click:Connect(function()
				pcall(callback)
			end)
		end

		function pageitems:toggle(text,state,callback)
			local callback = callback or function() end

			local toggled = state

			local Toggle = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local Button = Instance.new("TextButton")
			local Toggle_2 = Instance.new("ImageLabel")
			local UICorner_2 = Instance.new("UICorner")
			Toggle.Name = text
			Toggle.Parent = PageContainer
			Toggle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			Toggle.BorderSizePixel = 0
			Toggle.Size = UDim2.new(0, 435, 0, 32)
			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Toggle
			Button.Name = "Button"
			Button.Parent = Toggle
			Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Button.BackgroundTransparency = 1.000
			Button.Position = UDim2.new(0.0140000004, 0, 0, 0)
			Button.Size = UDim2.new(0, 423, 0, 32)
			Button.Font = Enum.Font.Gotham
			Button.Text = text
			Button.TextColor3 = Color3.fromRGB(255, 255, 255)
			Button.TextSize = 14.000
			Button.TextXAlignment = Enum.TextXAlignment.Left
			Toggle_2.Name = "Toggle"
			Toggle_2.Parent = Toggle
			Toggle_2.BackgroundColor3 = shit.accent
			Toggle_2.Position = UDim2.new(0.935000002, 0, 0.125, 0)
			Toggle_2.Size = UDim2.new(0, 24, 0, 24)
			Toggle_2.Image = "rbxassetid://10449228819"
			Toggle_2.ImageTransparency = 1

			UICorner_2.CornerRadius = UDim.new(0, 4)
			UICorner_2.Parent = Toggle_2

			if toggled == true then
				Toggle_2.ImageTransparency = 0
			elseif toggled == false then
				Toggle_2.ImageTransparency = 1
			end

			Button.MouseButton1Click:Connect(function()
				toggled = not toggled
				if toggled == true then
					Toggle_2.ImageTransparency = 0
				elseif toggled == false then
					Toggle_2.ImageTransparency = 1
				end
				pcall(callback, toggled)
			end)
		end

		function pageitems:input(text,placeholder,clearonreturn,callback)
			local callback = callback or function() end

			local Input = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local LabelText = Instance.new("TextLabel")
			local Input_2 = Instance.new("TextBox")
			local UICorner_2 = Instance.new("UICorner")
			Input.Name = text
			Input.Parent = PageContainer
			Input.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			Input.BorderSizePixel = 0
			Input.Size = UDim2.new(0, 435, 0, 32)
			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Input
			LabelText.Name = "LabelText"
			LabelText.Parent = Input
			LabelText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			LabelText.BackgroundTransparency = 1.000
			LabelText.Position = UDim2.new(0.0137931034, 0, 0, 0)
			LabelText.Size = UDim2.new(0, 290, 0, 32)
			LabelText.Font = Enum.Font.Gotham
			LabelText.Text = text
			LabelText.TextColor3 = Color3.fromRGB(255, 255, 255)
			LabelText.TextSize = 14.000
			LabelText.TextXAlignment = Enum.TextXAlignment.Left
			Input_2.Name = "Input"
			Input_2.Parent = Input
			Input_2.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
			Input_2.Position = UDim2.new(0.680459797, 0, 0.125, 0)
			Input_2.Size = UDim2.new(0, 134, 0, 24)
			Input_2.Font = Enum.Font.Gotham
			Input_2.Text = ""
			Input_2.PlaceholderText = placeholder or ""
			Input_2.ClearTextOnFocus = false
			Input_2.TextColor3 = Color3.fromRGB(255, 255, 255)
			Input_2.TextSize = 14.000
			UICorner_2.CornerRadius = UDim.new(0, 4)
			UICorner_2.Parent = Input_2
			Input_2.FocusLost:Connect(function()
				pcall(callback, tostring(Input_2.Text))
				if clearonreturn then
					Input_2.Text = ""
				end
			end)
		end

		-- NEW: slider, for numeric ranges (speed, jump power, amount, etc.)
		function pageitems:slider(text, min, max, default, callback)
			local callback = callback or function() end
			min = min or 0
			max = max or 100
			default = math.clamp(default or min, min, max)

			local Slider = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local LabelText = Instance.new("TextLabel")
			local ValueText = Instance.new("TextLabel")
			local Bar = Instance.new("Frame")
			local BarCorner = Instance.new("UICorner")
			local Fill = Instance.new("Frame")
			local FillCorner = Instance.new("UICorner")

			Slider.Name = text
			Slider.Parent = PageContainer
			Slider.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			Slider.BorderSizePixel = 0
			Slider.Size = UDim2.new(0, 435, 0, 46)
			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Slider

			LabelText.Name = "LabelText"
			LabelText.Parent = Slider
			LabelText.BackgroundTransparency = 1
			LabelText.Position = UDim2.new(0.0137931034, 0, 0, 4)
			LabelText.Size = UDim2.new(0, 300, 0, 20)
			LabelText.Font = Enum.Font.Gotham
			LabelText.Text = text
			LabelText.TextColor3 = Color3.fromRGB(255, 255, 255)
			LabelText.TextSize = 14.000
			LabelText.TextXAlignment = Enum.TextXAlignment.Left

			ValueText.Name = "ValueText"
			ValueText.Parent = Slider
			ValueText.BackgroundTransparency = 1
			ValueText.Position = UDim2.new(1, -60, 0, 4)
			ValueText.Size = UDim2.new(0, 50, 0, 20)
			ValueText.Font = Enum.Font.GothamBold
			ValueText.Text = tostring(default)
			ValueText.TextColor3 = shit.accent
			ValueText.TextSize = 14.000
			ValueText.TextXAlignment = Enum.TextXAlignment.Right

			Bar.Name = "Bar"
			Bar.Parent = Slider
			Bar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
			Bar.BorderSizePixel = 0
			Bar.Position = UDim2.new(0.014, 0, 0, 28)
			Bar.Size = UDim2.new(0, 411, 0, 8)
			BarCorner.CornerRadius = UDim.new(1, 0)
			BarCorner.Parent = Bar

			Fill.Name = "Fill"
			Fill.Parent = Bar
			Fill.BackgroundColor3 = shit.accent
			Fill.BorderSizePixel = 0
			Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			FillCorner.CornerRadius = UDim.new(1, 0)
			FillCorner.Parent = Fill

			local sliding = false

			local function setFromX(xPos)
				local rel = math.clamp((xPos - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
				local value = math.floor(min + (max - min) * rel)
				Fill.Size = UDim2.new(rel, 0, 1, 0)
				ValueText.Text = tostring(value)
				pcall(callback, value)
			end

			Bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = true
					setFromX(input.Position.X)
				end
			end)
			Bar.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = false
				end
			end)
			UIS.InputChanged:Connect(function(input)
				if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					setFromX(input.Position.X)
				end
			end)
		end

		-- NEW: dropdown, pick one option from a list
		function pageitems:dropdown(text, options, default, callback)
			local callback = callback or function() end
			options = options or {}

			local Dropdown = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local LabelText = Instance.new("TextLabel")
			local SelectButton = Instance.new("TextButton")
			local SelectCorner = Instance.new("UICorner")
			local OptionsHolder = Instance.new("Frame")
			local OptionsCorner = Instance.new("UICorner")
			local OptionsList = Instance.new("UIListLayout")

			Dropdown.Name = text
			Dropdown.Parent = PageContainer
			Dropdown.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			Dropdown.BorderSizePixel = 0
			Dropdown.ClipsDescendants = false
			Dropdown.Size = UDim2.new(0, 435, 0, 32)
			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Dropdown

			LabelText.Name = "LabelText"
			LabelText.Parent = Dropdown
			LabelText.BackgroundTransparency = 1
			LabelText.Position = UDim2.new(0.0137931034, 0, 0, 0)
			LabelText.Size = UDim2.new(0, 200, 0, 32)
			LabelText.Font = Enum.Font.Gotham
			LabelText.Text = text
			LabelText.TextColor3 = Color3.fromRGB(255, 255, 255)
			LabelText.TextSize = 14.000
			LabelText.TextXAlignment = Enum.TextXAlignment.Left

			SelectButton.Name = "SelectButton"
			SelectButton.Parent = Dropdown
			SelectButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
			SelectButton.Position = UDim2.new(0.5, 0, 0.125, 0)
			SelectButton.Size = UDim2.new(0, 210, 0, 24)
			SelectButton.Font = Enum.Font.Gotham
			SelectButton.Text = tostring(default or options[1] or "Select") .. "  ▾"
			SelectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			SelectButton.TextSize = 14.000
			SelectCorner.CornerRadius = UDim.new(0, 4)
			SelectCorner.Parent = SelectButton

			OptionsHolder.Name = "OptionsHolder"
			OptionsHolder.Parent = Dropdown
			OptionsHolder.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
			OptionsHolder.BorderSizePixel = 0
			OptionsHolder.Position = UDim2.new(0.5, 0, 1, 4)
			OptionsHolder.Size = UDim2.new(0, 210, 0, #options * 26)
			OptionsHolder.Visible = false
			OptionsHolder.ZIndex = 5
			OptionsCorner.CornerRadius = UDim.new(0, 4)
			OptionsCorner.Parent = OptionsHolder
			OptionsList.Parent = OptionsHolder
			OptionsList.SortOrder = Enum.SortOrder.LayoutOrder

			local open = false
			SelectButton.MouseButton1Click:Connect(function()
				open = not open
				OptionsHolder.Visible = open
			end)

			for _, option in ipairs(options) do
				local OptionButton = Instance.new("TextButton")
				OptionButton.Parent = OptionsHolder
				OptionButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
				OptionButton.BorderSizePixel = 0
				OptionButton.Size = UDim2.new(1, 0, 0, 26)
				OptionButton.Font = Enum.Font.Gotham
				OptionButton.Text = tostring(option)
				OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				OptionButton.TextSize = 14.000
				OptionButton.ZIndex = 5

				OptionButton.MouseButton1Click:Connect(function()
					SelectButton.Text = tostring(option) .. "  ▾"
					open = false
					OptionsHolder.Visible = false
					pcall(callback, option)
				end)
			end
		end

		-- NEW: keybind, click then press a key to rebind
		function pageitems:keybind(text, defaultKey, callback)
			local callback = callback or function() end
			local currentKey = defaultKey or Enum.KeyCode.Unknown
			local listening = false

			local Keybind = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local LabelText = Instance.new("TextLabel")
			local KeyButton = Instance.new("TextButton")
			local KeyCorner = Instance.new("UICorner")

			Keybind.Name = text
			Keybind.Parent = PageContainer
			Keybind.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			Keybind.BorderSizePixel = 0
			Keybind.Size = UDim2.new(0, 435, 0, 32)
			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Keybind

			LabelText.Name = "LabelText"
			LabelText.Parent = Keybind
			LabelText.BackgroundTransparency = 1
			LabelText.Position = UDim2.new(0.0137931034, 0, 0, 0)
			LabelText.Size = UDim2.new(0, 290, 0, 32)
			LabelText.Font = Enum.Font.Gotham
			LabelText.Text = text
			LabelText.TextColor3 = Color3.fromRGB(255, 255, 255)
			LabelText.TextSize = 14.000
			LabelText.TextXAlignment = Enum.TextXAlignment.Left

			KeyButton.Name = "KeyButton"
			KeyButton.Parent = Keybind
			KeyButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
			KeyButton.Position = UDim2.new(0.680459797, 0, 0.125, 0)
			KeyButton.Size = UDim2.new(0, 134, 0, 24)
			KeyButton.Font = Enum.Font.Gotham
			KeyButton.Text = currentKey.Name
			KeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			KeyButton.TextSize = 14.000
			KeyCorner.CornerRadius = UDim.new(0, 4)
			KeyCorner.Parent = KeyButton

			KeyButton.MouseButton1Click:Connect(function()
				if listening then return end
				listening = true
				KeyButton.Text = "..."
			end)

			UIS.InputBegan:Connect(function(input, gp)
				if not listening then return end
				if input.UserInputType == Enum.UserInputType.Keyboard then
					currentKey = input.KeyCode
					KeyButton.Text = currentKey.Name
					listening = false
					pcall(callback, currentKey)
				end
			end)
		end

		return pageitems

	end

	return Window

end

return Library