local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/laagginq/ui-libraries/main/shit-lib/src.lua"))()

local win = lib:Create("wow very cool text","even cooler text")

-- tabs

local mainmenu = win:tab("Main menu",true)
local charactercat = win:tab("Character",false)
local world = win:tab("World",false)

--

local localplayer = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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
    local tool = character:FindFirstChildOfClass("Tool")
        or player.Backpack:FindFirstChildOfClass("Tool")

    while character.Humanoid.Health ~= 0 do

        local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local tool = character:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")

while character.Humanoid.Health ~= 0 do
    local localscript = tool:FindFirstChildOfClass("LocalScript")
    local localscriptclone = localscript:Clone()
    localscriptclone = localscript:Clone()
    localscriptclone:Clone()
    localscript:Destroy()
    localscriptclone.Parent = tool
    task.wait(0.1)
end

        task.wait(0.1)
    end

end

charactercat:button("No Slap Cooldown and Ability", function()
    myFunction()
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

-- Player teleport
local teleportUsername = ""

world:input("Player Username", "Enter username...", true, function(v)
	teleportUsername = v
end)

world:button("Teleport", function()

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