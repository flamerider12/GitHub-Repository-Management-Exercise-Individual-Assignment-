--[[
	Player Data Manager
	Place this in ServerScriptService
	Manages player stats, inventory, and data persistence
]]--

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local PlayerDataManager = {}

-- DataStore (optional - comment out if not using DataStores)
local playerDataStore = DataStoreService:GetDataStore("PlayerData_v1")

-- Player data cache
local playerData = {}

-- Default player data structure
local DEFAULT_DATA = {
	Coins = 0,
	TotalDigs = 0,
	Inventory = {},
	Achievements = {},
	DepthReached = 0,
	TotalValue = 0
}

-- Initialize player data
function PlayerDataManager.InitializePlayer(player)
	local userId = player.UserId
	local data = DEFAULT_DATA

	-- Try to load saved data
	local success, savedData = pcall(function()
		return playerDataStore:GetAsync("Player_" .. userId)
	end)

	if success and savedData then
		data = savedData
		print("Loaded data for " .. player.Name)
	else
		print("Created new data for " .. player.Name)
	end

	-- Store in cache
	playerData[userId] = data

	-- Setup leaderstats
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = data.Coins
	coins.Parent = leaderstats

	local digs = Instance.new("IntValue")
	digs.Name = "Digs"
	digs.Value = data.TotalDigs
	digs.Parent = leaderstats

	return data
end

-- Save player data
function PlayerDataManager.SavePlayer(player)
	local userId = player.UserId
	local data = playerData[userId]

	if not data then return end

	-- Update coins from leaderstats
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local coins = leaderstats:FindFirstChild("Coins")
		if coins then
			data.Coins = coins.Value
		end
		local digs = leaderstats:FindFirstChild("Digs")
		if digs then
			data.TotalDigs = digs.Value
		end
	end

	-- Save to DataStore
	local success, err = pcall(function()
		playerDataStore:SetAsync("Player_" .. userId, data)
	end)

	if success then
		print("Saved data for " .. player.Name)
	else
		warn("Failed to save data for " .. player.Name .. ": " .. tostring(err))
	end
end

-- Add item to player inventory
function PlayerDataManager.AddItem(player, item)
	local userId = player.UserId
	local data = playerData[userId]

	if not data then return end

	-- Add to inventory
	table.insert(data.Inventory, {
		Name = item.Name,
		Value = item.Value,
		Rarity = item.Rarity,
		Timestamp = os.time()
	})

	-- Update stats
	data.TotalValue = data.TotalValue + item.Value
	data.TotalDigs = data.TotalDigs + 1

	-- Update leaderstats
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local digs = leaderstats:FindFirstChild("Digs")
		if digs then
			digs.Value = data.TotalDigs
		end
	end

	-- Check for achievements
	PlayerDataManager.CheckAchievements(player)
end

-- Get player data
function PlayerDataManager.GetData(player)
	return playerData[player.UserId]
end

-- Get player inventory
function PlayerDataManager.GetInventory(player)
	local data = playerData[player.UserId]
	return data and data.Inventory or {}
end

-- Check and award achievements
function PlayerDataManager.CheckAchievements(player)
	local data = playerData[player.UserId]
	if not data then return end

	local achievements = {
		{Id = "first_dig", Name = "First Dig!", Requirement = 1, Stat = "TotalDigs"},
		{Id = "digger", Name = "Digger", Requirement = 100, Stat = "TotalDigs"},
		{Id = "excavator", Name = "Excavator", Requirement = 1000, Stat = "TotalDigs"},
		{Id = "rich", Name = "Getting Rich", Requirement = 10000, Stat = "TotalValue"},
		{Id = "wealthy", Name = "Wealthy", Requirement = 100000, Stat = "TotalValue"},
	}

	for _, achievement in pairs(achievements) do
		if not data.Achievements[achievement.Id] then
			if data[achievement.Stat] >= achievement.Requirement then
				data.Achievements[achievement.Id] = true
				-- Notify player (you can create a UI notification here)
				print(player.Name .. " earned achievement: " .. achievement.Name)
			end
		end
	end
end

-- Initialize on player join
Players.PlayerAdded:Connect(function(player)
	PlayerDataManager.InitializePlayer(player)
end)

-- Save on player leave
Players.PlayerRemoving:Connect(function(player)
	PlayerDataManager.SavePlayer(player)
	playerData[player.UserId] = nil
end)

-- Auto-save every 5 minutes
task.spawn(function()
	while true do
		task.wait(300) -- 5 minutes
		for _, player in pairs(Players:GetPlayers()) do
			PlayerDataManager.SavePlayer(player)
		end
		print("Auto-saved all player data")
	end
end)

return PlayerDataManager
