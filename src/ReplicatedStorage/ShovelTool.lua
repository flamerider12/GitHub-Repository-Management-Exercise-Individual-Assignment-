--[[
	Shovel Tool Script
	Place this in ReplicatedStorage
	This script handles the client-side digging tool mechanics
]]--

local Tool = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Configuration
local DIG_RANGE = 10 -- Maximum digging distance
local DIG_COOLDOWN = 0.5 -- Time between digs
local DIG_RADIUS = 4 -- Size of the dig area

-- Remote Events (create these in ReplicatedStorage)
local digEvent = ReplicatedStorage:WaitForChild("DigEvent")

-- Animation
local digAnimation
local animator
local canDig = true
local isEquipped = false

-- Get player and character
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Setup animator
if humanoid then
	animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end
end

-- Tool equipped
Tool.Equipped:Connect(function(mouse)
	isEquipped = true

	-- Change cursor when hovering over diggable terrain
	mouse.Icon = "rbxasset://textures/GunCursor.png"

	mouse.Button1Down:Connect(function()
		if not canDig or not isEquipped then return end

		-- Get mouse target
		local target = mouse.Target
		local hitPosition = mouse.Hit.Position

		-- Check if we're within range
		local distance = (character.HumanoidRootPart.Position - hitPosition).Magnitude
		if distance > DIG_RANGE then
			return
		end

		-- Start dig cooldown
		canDig = false

		-- Play dig animation (if you have one)
		if digAnimation and animator then
			local track = animator:LoadAnimation(digAnimation)
			track:Play()
		end

		-- Fire server event to handle digging
		digEvent:FireServer(hitPosition, target)

		-- Wait for cooldown
		task.wait(DIG_COOLDOWN)
		canDig = true
	end)
end)

-- Tool unequipped
Tool.Unequipped:Connect(function()
	isEquipped = false
end)
