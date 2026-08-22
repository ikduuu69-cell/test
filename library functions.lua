local win = lib:Create("wow very cool text","even cooler text")

-- Services
local localplayer = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

-- tabs

local mainmenu = win:tab("Main menu",true)
local charactercat = win:tab("Character",false)
local world = win:tab("World",false)
local settings = win:tab("Settings", false)
local teleportations = win:tab("Teleportations", false)
-- THEME SETTINGS

local CurrentTheme = "Purple"

local Themes = {
	Purple = Color3.fromRGB(106, 90, 205),
	Blue = Color3.fromRGB(65, 105, 225),
	Green = Color3.fromRGB(50, 205, 50),
	Red = Color3.fromRGB(220, 60, 60),
	Orange = Color3.fromRGB(255, 140, 0),
	Pink = Color3.fromRGB(255, 105, 180),
	White = Color3.fromRGB(230, 230, 230),
	Black = Color3.fromRGB(15, 15, 15)
}

local themeNames = {
	"Purple",
	"Blue",
	"Green",
	"Red",
	"Black",
	"Rainbow",
	"Orange",
	"Pink",
	"White"
}

local currentThemeIndex = 1
local rainbowEnabled = false

local themeLabel = settings:label("Theme: Purple")

settings:button("Change Theme", function()

	currentThemeIndex += 1

	if currentThemeIndex > #themeNames then
		currentThemeIndex = 1
	end

	local themeName = themeNames[currentThemeIndex]
	CurrentTheme = themeName

	if themeName == "Rainbow" then
		rainbowEnabled = true
	else
		rainbowEnabled = false
		win:SetAccent(Themes[themeName])
	end

	local textObject = themeLabel:FindFirstChild("LabelText")

	if textObject then
		textObject.Text = "Theme: " .. themeName
	end

end)

-- Rainbow effect

RunService.RenderStepped:Connect(function()

	if rainbowEnabled then
		local hue = (tick() % 5) / 5
		win:SetAccent(Color3.fromHSV(hue, 1, 1))
	end

end)

settings:label("Themes")

for themeName, themeColor in pairs(Themes) do

	settings:button(themeName, function()

		CurrentTheme = themeName
		rainbowEnabled = false

		win:SetAccent(themeColor)

		local textObject = themeLabel:FindFirstChild("LabelText")

		if textObject then
			textObject.Text = "Theme: " .. themeName
		end

	end)

end

-- Rainbow button separately

settings:button("Rainbow", function()

	CurrentTheme = "Rainbow"
	rainbowEnabled = true

	local textObject = themeLabel:FindFirstChild("LabelText")

	if textObject then
		textObject.Text = "Theme: Rainbow"
	end

end)

-- SETTINGS DISPLAY

local fpsLabel = settings:label("FPS: Calculating...")
local pingLabel = settings:label("Ping: Calculating...")
local versionLabel = settings:label("Roblox Version: " .. tostring(version()))

local fps = 0
local frames = 0
local lastFPSUpdate = tick()

RunService.RenderStepped:Connect(function()
	frames += 1

	if tick() - lastFPSUpdate >= 1 then
		fps = frames
		frames = 0
		lastFPSUpdate = tick()

		-- Update the label's text
		if fpsLabel then
			local textObject = fpsLabel:FindFirstChild("LabelText")

			if textObject then
				textObject.Text = "FPS: " .. tostring(fps)
			end
		end

		-- Ping
		local ping = 0

		pcall(function()
			ping = math.floor(
				game:GetService("Stats")
					.Network
					.ServerStatsItem["Data Ping"]
					:GetValue()
			)
		end)

		if pingLabel then
			local textObject = pingLabel:FindFirstChild("LabelText")

			if textObject then
				textObject.Text = "Ping: " .. tostring(ping) .. " ms"
			end
		end
	end
end)


-- Variables used in ui

local antihit = false
local slapaura = false
local antifall = nil


-- Flight
local flying = false
local flyAttachment
local flyVelocity
local flySpeed = 50

--

RunService.Heartbeat:Connect(function()

	local character = localplayer.Character
	if not character then return end

	local rootpart = character:FindFirstChild("HumanoidRootPart")
	if not rootpart then return end

	local ragdolled = character.Ragdolled.value

	-- Anti slap
	if ragdolled and antihit then
		rootpart.Anchored = true
		rootpart.Velocity = Vector3.new()
	else
		rootpart.Anchored = false
	end

	-- Flight
	if flying and flyVelocity then

		local cam = workspace.CurrentCamera
		local dir = Vector3.zero

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			dir += cam.CFrame.LookVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			dir -= cam.CFrame.LookVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			dir -= cam.CFrame.RightVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			dir += cam.CFrame.RightVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			dir += Vector3.yAxis
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			dir -= Vector3.yAxis
		end

		if dir.Magnitude > 0 then
			dir = dir.Unit * flySpeed
		end

		flyVelocity.VectorVelocity = dir

	end

end)

--------------------------------------------------
-- MAIN MENU
--------------------------------------------------

mainmenu:label("This is meant to be used against hackers or annoying people")
mainmenu:label("Made by Healer")
mainmenu:label("Enjoy the script!")

world:toggle("Fly", false, function(v)

	local character = localplayer.Character
	if not character then return end

	local rootpart = character:FindFirstChild("HumanoidRootPart")
	if not rootpart then return end

	flying = v

	if v then

		flyAttachment = Instance.new("Attachment")
		flyAttachment.Parent = rootpart

		flyVelocity = Instance.new("LinearVelocity")
		flyVelocity.Attachment0 = flyAttachment
		flyVelocity.MaxForce = math.huge
		flyVelocity.VectorVelocity = Vector3.zero
		flyVelocity.Parent = rootpart

	else

		if flyVelocity then
			flyVelocity:Destroy()
			flyVelocity = nil
		end

		if flyAttachment then
			flyAttachment:Destroy()
			flyAttachment = nil
		end

	end

end)
--------------------------------------------------
-- CHARACTER
--------------------------------------------------
local function myFunction()
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	local tool = character:FindFirstChildOfClass("Tool")
		or player.Backpack:FindFirstChildOfClass("Tool")

	if not humanoid or not tool then
		return
	end

	while humanoid.Health > 0 do
		local localscript = tool:FindFirstChildOfClass("LocalScript")

		if localscript then
			local localscriptclone = localscript:Clone()
			localscript:Destroy()
			localscriptclone.Parent = tool
		end

		task.wait(0.1)
	end
end

charactercat:button("No Slap Cooldown and Ability", function()
	myFunction()
end)
charactercat:button("God Mode", function()

	local pl = game:GetService("Players").LocalPlayer
	local toolClone

	-- Move to the test location
	if pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
		pl.Character.HumanoidRootPart.CFrame = CFrame.new(-909, 328, 3.32)
	end

	task.wait(1)

	-- Find and clone the tool
	local model = workspace:FindFirstChild(pl.Name)

	if model then
		local tool = model:FindFirstChildWhichIsA("Tool")

		if tool then
			toolClone = tool:Clone()
		end
	end

	-- Reset the character
	local humanoid = pl.Character and pl.Character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.Health = 0
	end

	-- Give the cloned tool back after respawn
	if toolClone then
		local connection

		connection = pl.CharacterAdded:Connect(function(char)

			char:WaitForChild("HumanoidRootPart")
			task.wait(0.5)

			if toolClone then
				toolClone.Parent = char
			end

			char.HumanoidRootPart.CFrame = CFrame.new(0, 0, 0)

			connection:Disconnect()
		end)
	end

end)

charactercat:toggle("Anti knockback V1",false,function(v)
	antihit = v
end)

charactercat:toggle("Hide nametag",false,function(v)

	local character = localplayer.Character

	if v then
		character.Head.Nametag.Labels.TopLabel.Text = "Unnamed Chad"
	else
		character.Head.Nametag.Labels.TopLabel.Text = character.Name
	end

end)

--------------------------------------------------
-- WORLD
-- --------------------------------------------------

world:input("WalkSpeed", "16", false, function(v)
	local n = tonumber(v)

	if n and localplayer.Character then
		local humanoid = localplayer.Character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			humanoid.WalkSpeed = n
		end
	end
end)

world:input("JumpPower", "50", false, function(v)
	local n = tonumber(v)

	if n and localplayer.Character then
		local humanoid = localplayer.Character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			humanoid.JumpPower = n
		end
	end
end)


-- Anti void
world:toggle("Anti void", false, function(v)
	if v then
		local part = Instance.new("Part", workspace)
		part.Transparency = 0.5
		part.Anchored = true
		part.Size = Vector3.new(350, 1, 350)
		part.CFrame = CFrame.new(0, -12, 0)
		antifall = part
	else
		if antifall then
			antifall:Destroy()
			antifall = nil
		end
	end
end)
local highlightsEnabled = false

local function updatePlayerHighlight(player)

	if not highlightsEnabled then
		return
	end

	local character = player.Character
	if not character then
		return
	end

	if not character:FindFirstChild("PlayerHighlight") then
		local highlight = Instance.new("Highlight")
		highlight.Name = "PlayerHighlight"
		highlight.FillTransparency = 0.5
		highlight.OutlineTransparency = 0
		highlight.Parent = character
	end

end

world:toggle("Player Highlights", false, function(v)

	highlightsEnabled = v

	for _, player in ipairs(game.Players:GetPlayers()) do

		if v then
			updatePlayerHighlight(player)
		else
			local character = player.Character

			if character then
				local highlight = character:FindFirstChild("PlayerHighlight")

				if highlight then
					highlight:Destroy()
				end
			end
		end

	end

end)

game.Players.PlayerAdded:Connect(function(player)

	player.CharacterAdded:Connect(function()
		task.wait(0.5)
		updatePlayerHighlight(player)
	end)

end)
--------------------------------------------------
-- TELEPORTATIONS
--------------------------------------------------

-- Click TP
local clickTPEnabled = false
local clickTPConnection
local clickTPMouse = localplayer:GetMouse()

teleportations:button("Click TP", function()

	clickTPEnabled = not clickTPEnabled

	if clickTPEnabled then

		clickTPConnection = clickTPMouse.Button1Down:Connect(function()

			if not clickTPEnabled then
				return
			end

			if not (
				UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
				or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
			) then
				return
			end

			local character = localplayer.Character
			if not character then return end

			local root = character:FindFirstChild("HumanoidRootPart")
			if not root then return end

			local position = clickTPMouse.Hit.Position

			root.CFrame = CFrame.new(
				position + Vector3.new(0, 3, 0)
			)

		end)

	else

		if clickTPConnection then
			clickTPConnection:Disconnect()
			clickTPConnection = nil
		end

	end

end)


--------------------------------------------------
-- PLAYER TELEPORT
--------------------------------------------------

local teleportUsername = ""

teleportations:input(
	"Player Username",
	"Enter username...",
	false,
	function(v)
		teleportUsername = v
	end
)

teleportations:button("Teleport To Player", function()

	local search = teleportUsername:lower():gsub("^%s*(.-)%s*$", "%1")

	if search == "" then
		warn("Enter a username first")
		return
	end

	local target

	for _, player in ipairs(game.Players:GetPlayers()) do

		local username = player.Name:lower()
		local displayName = player.DisplayName:lower()

		if username:sub(1, #search) == search
			or displayName:sub(1, #search) == search then

			target = player
			break
		end

	end

	if not target then
		warn("Player not found")
		return
	end

	local character = localplayer.Character
	local targetCharacter = target.Character

	if not character or not targetCharacter then
		return
	end

	local root = character:FindFirstChild("HumanoidRootPart")
	local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")

	if root and targetRoot then
		root.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
	end

end)


--------------------------------------------------
-- PRESET TELEPORTS
--------------------------------------------------

local Teleports = {

	Slapple = CFrame.new(
		-381.06546, 52.6413078, -16.9044571,
		-0.0396371111, 0, 0.999214113,
		0, 1, 0,
		-0.999214113, 0, -0.0396371111
	),

	Moyai = CFrame.new(
		227.037842, -13.7741156, 1.01922429,
		-0.0659365281, 0, 0.997823834,
		0, 1, 0,
		-0.997823834, 0, -0.0659365281
	),

	Middle = CFrame.new(
		11.3941154, -5.19691324, 7.26540995,
		0.0753517225, 0, -0.997157037,
		0, 1, 0,
		0.997157037, 0, 0.0753517225
	),

	Cannon = CFrame.new(
		264.040833, 31.6759281, 198.584152,
		-0.665308416, 0, -0.74656862,
		0, 1, 0,
		0.74656862, 0, -0.665308416
	),

	VinqHideout = CFrame.new(
		-14643.0605, 3186.70312, -29460.918,
		-0.987815738, 0.000219627065, 0.155627683,
		-4.1199641e-07, 0.999998987, -0.0014138486,
		-0.155627832, -0.00139668607, -0.987814724
	)

}

local modeList = {
	"Slapple",
	"Moyai",
	"Middle",
	"Cannon",
	"VinqHideout"
}

local currentIndex = 1
local currentMode = modeList[currentIndex]

local function getCurrentCFrame()
	return Teleports[currentMode]
end


--------------------------------------------------
-- PRESET SELECTOR
--------------------------------------------------

local presetButton

presetButton = teleportations:button(
	"Preset: " .. currentMode,
	function()

		currentIndex += 1

		if currentIndex > #modeList then
			currentIndex = 1
		end

		currentMode = modeList[currentIndex]

		presetButton:SetText("Preset: " .. currentMode)

	end
)


--------------------------------------------------
-- TELEPORT TO PRESET
--------------------------------------------------

teleportations:button("Teleport To Preset", function()

	local character = localplayer.Character
	if not character then return end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	root.CFrame = getCurrentCFrame() + Vector3.new(0, 3, 0)

end)