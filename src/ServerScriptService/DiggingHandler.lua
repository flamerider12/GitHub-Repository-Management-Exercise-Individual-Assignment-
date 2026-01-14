--[[
	Digging Handler (Server)
	Place this in ServerScriptService
	Handles server-side digging mechanics, terrain manipulation, and loot spawning
]]--

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

-- Create Remote Events if they don't exist
local digEvent = ReplicatedStorage:FindFirstChild("DigEvent")
if not digEvent then
	digEvent = Instance.new("RemoteEvent")
	digEvent.Name = "DigEvent"
	digEvent.Parent = ReplicatedStorage
end

local updateInventoryEvent = ReplicatedStorage:FindFirstChild("UpdateInventory")
if not updateInventoryEvent then
	updateInventoryEvent = Instance.new("RemoteEvent")
	updateInventoryEvent.Name = "UpdateInventory"
	updateInventoryEvent.Parent = ReplicatedStorage
end

-- Configuration
local DIG_RANGE = 10
local DIG_RADIUS = 4
local ANTI_SPAM_COOLDOWN = 0.3

-- Player cooldowns (anti-spam)
local playerCooldowns = {}

-- Loot Table Configuration
local LootTable = require(script.Parent.LootSystem)

-- Terrain service
local Terrain = workspace.Terrain

-- Function to check if player can dig
local function canPlayerDig(player)
	local lastDig = playerCooldowns[player.UserId]
	if lastDig and (tick() - lastDig) < ANTI_SPAM_COOLDOWN then
		return false
	end
	return true
end

-- Function to dig terrain
local function digTerrain(position, radius)
	local region = Region3.new(position - Vector3.new(radius, radius, radius), position + Vector3.new(radius, radius, radius))
	region = region:ExpandToGrid(4)

	-- Clear terrain in the region
	Terrain:FillRegion(region, 4, Enum.Material.Air)
end

-- Function to dig blocks (if using block-based system instead of terrain)
local function digBlocks(position, radius)
	local diggableFolder = workspace:FindFirstChild("DiggableBlocks")
	if not diggableFolder then return end

	for _, block in pairs(diggableFolder:GetChildren()) do
		if block:IsA("BasePart") then
			local distance = (block.Position - position).Magnitude
			if distance <= radius then
				-- Create dig particle effect
				local particle = Instance.new("ParticleEmitter")
				particle.Texture = "rbxasset://textures/particles/smoke_main.dds"
				particle.Color = ColorSequence.new(block.Color)
				particle.Size = NumberSequence.new(0.5)
				particle.Lifetime = NumberRange.new(0.5, 1)
				particle.Rate = 100
				particle.SpreadAngle = Vector2.new(180, 180)
				particle.Parent = block
				particle.Enabled = true

				task.wait(0.1)
				particle.Enabled = false
				Debris:AddItem(particle, 2)

				-- Destroy the block
				block.Transparency = 1
				block.CanCollide = false
				Debris:AddItem(block, 0.5)

				return true -- Block was dug
			end
		end
	end
	return false
end

-- Function to spawn loot
local function spawnLoot(position, player)
	local loot = LootTable.GetRandomLoot()
	if not loot then return end

	-- Add to player's inventory
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local coins = leaderstats:FindFirstChild("Coins")
		if coins then
			coins.Value = coins.Value + loot.Value
		end
	end

	-- Update player inventory (if using custom inventory system)
	local PlayerData = require(script.Parent.PlayerDataManager)
	PlayerData.AddItem(player, loot)

	-- Create visual loot pickup
	local lootPart = Instance.new("Part")
	lootPart.Size = Vector3.new(1, 1, 1)
	lootPart.Position = position + Vector3.new(0, 2, 0)
	lootPart.Anchored = true
	lootPart.CanCollide = false
	lootPart.BrickColor = BrickColor.new(loot.Color or "Bright yellow")
	lootPart.Material = Enum.Material.Neon
	lootPart.Shape = Enum.PartType.Ball
	lootPart.Parent = workspace

	-- Add billboard GUI with loot name
	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(4, 0, 1, 0)
	billboard.StudsOffset = Vector3.new(0, 2, 0)
	billboard.Parent = lootPart

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "+" .. loot.Name
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Parent = billboard

	-- Animate loot towards player
	local goal = player.Character.HumanoidRootPart.Position
	local tween = game:GetService("TweenService"):Create(
		lootPart,
		TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{Position = goal}
	)
	tween:Play()

	-- Clean up
	Debris:AddItem(lootPart, 1)

	-- Send notification to player
	updateInventoryEvent:FireClient(player, loot)
end

-- Handle dig event from client
digEvent.OnServerEvent:Connect(function(player, position, target)
	-- Validate player
	if not player or not player.Character then return end

	-- Check cooldown
	if not canPlayerDig(player) then
		return
	end

	-- Update cooldown
	playerCooldowns[player.UserId] = tick()

	-- Check range
	local character = player.Character
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local distance = (hrp.Position - position).Magnitude
	if distance > DIG_RANGE then
		return
	end

	-- Perform digging
	local dugBlock = false

	-- Try block-based digging first
	dugBlock = digBlocks(position, DIG_RADIUS)

	-- If no blocks, try terrain digging
	if not dugBlock then
		digTerrain(position, DIG_RADIUS)
		dugBlock = true
	end

	-- Spawn loot if something was dug
	if dugBlock then
		spawnLoot(position, player)
	end
end)

-- Clean up on player leave
Players.PlayerRemoving:Connect(function(player)
	playerCooldowns[player.UserId] = nil
end)

print("DiggingHandler loaded successfully!")
