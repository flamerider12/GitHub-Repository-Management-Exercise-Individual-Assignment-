--[[
	Loot System Module
	Place this in ServerScriptService
	Defines loot tables and rarity system for the digging game
]]--

local LootSystem = {}

-- Rarity tiers (higher weight = more common)
local RARITY = {
	COMMON = {Name = "Common", Color = "Light stone grey", Weight = 50},
	UNCOMMON = {Name = "Uncommon", Color = "Lime green", Weight = 25},
	RARE = {Name = "Rare", Color = "Deep blue", Weight = 15},
	EPIC = {Name = "Epic", Color = "Bright violet", Weight = 7},
	LEGENDARY = {Name = "Legendary", Color = "Bright orange", Weight = 2.5},
	MYTHIC = {Name = "Mythic", Color = "Hot pink", Weight = 0.5}
}

-- Brainrot-themed loot items
local LOOT_ITEMS = {
	-- Common Items
	{Name = "Dirt Clump", Value = 5, Rarity = RARITY.COMMON, Icon = "🪨"},
	{Name = "Pebble", Value = 10, Rarity = RARITY.COMMON, Icon = "⚪"},
	{Name = "Stick", Value = 8, Rarity = RARITY.COMMON, Icon = "🪵"},
	{Name = "Bone Fragment", Value = 12, Rarity = RARITY.COMMON, Icon = "🦴"},

	-- Uncommon Items
	{Name = "Cursed Meme", Value = 50, Rarity = RARITY.UNCOMMON, Icon = "🤡"},
	{Name = "Brainrot Crystal", Value = 75, Rarity = RARITY.UNCOMMON, Icon = "💎"},
	{Name = "Gyat Stone", Value = 60, Rarity = RARITY.UNCOMMON, Icon = "🗿"},
	{Name = "Rizz Shard", Value = 80, Rarity = RARITY.UNCOMMON, Icon = "✨"},

	-- Rare Items
	{Name = "Sigma Grindstone", Value = 200, Rarity = RARITY.RARE, Icon = "⚡"},
	{Name = "Skibidi Toilet Part", Value = 250, Rarity = RARITY.RARE, Icon = "🚽"},
	{Name = "Ohio Artifact", Value = 225, Rarity = RARITY.RARE, Icon = "👽"},
	{Name = "Fanum Tax Receipt", Value = 300, Rarity = RARITY.RARE, Icon = "💸"},

	-- Epic Items
	{Name = "Gigachad Medallion", Value = 750, Rarity = RARITY.EPIC, Icon = "🏆"},
	{Name = "Mewing Statue", Value = 800, Rarity = RARITY.EPIC, Icon = "🗿"},
	{Name = "NPC Energy Drink", Value = 700, Rarity = RARITY.EPIC, Icon = "🥤"},
	{Name = "Griddy Shoes", Value = 850, Rarity = RARITY.EPIC, Icon = "👟"},

	-- Legendary Items
	{Name = "Golden Brainrot", Value = 2000, Rarity = RARITY.LEGENDARY, Icon = "🧠"},
	{Name = "Infinite Aura", Value = 2500, Rarity = RARITY.LEGENDARY, Icon = "🌟"},
	{Name = "Beta to Alpha Potion", Value = 2200, Rarity = RARITY.LEGENDARY, Icon = "🧪"},
	{Name = "Rizz Crown", Value = 3000, Rarity = RARITY.LEGENDARY, Icon = "👑"},

	-- Mythic Items
	{Name = "Ultimate Sigma Core", Value = 10000, Rarity = RARITY.MYTHIC, Icon = "💫"},
	{Name = "Brainrot Singularity", Value = 15000, Rarity = RARITY.MYTHIC, Icon = "🌌"},
	{Name = "Divine Gyat", Value = 12000, Rarity = RARITY.MYTHIC, Icon = "👼"},
}

-- Calculate total weight for weighted random selection
local function calculateTotalWeight()
	local total = 0
	for _, item in pairs(LOOT_ITEMS) do
		total = total + item.Rarity.Weight
	end
	return total
end

-- Get random loot based on weighted chances
function LootSystem.GetRandomLoot()
	local totalWeight = calculateTotalWeight()
	local random = math.random() * totalWeight
	local currentWeight = 0

	for _, item in pairs(LOOT_ITEMS) do
		currentWeight = currentWeight + item.Rarity.Weight
		if random <= currentWeight then
			return {
				Name = item.Name,
				Value = item.Value,
				Rarity = item.Rarity.Name,
				Color = item.Rarity.Color,
				Icon = item.Icon
			}
		end
	end

	-- Fallback to first item
	return {
		Name = LOOT_ITEMS[1].Name,
		Value = LOOT_ITEMS[1].Value,
		Rarity = LOOT_ITEMS[1].Rarity.Name,
		Color = LOOT_ITEMS[1].Rarity.Color,
		Icon = LOOT_ITEMS[1].Icon
	}
end

-- Get loot by rarity tier (for debugging/testing)
function LootSystem.GetLootByRarity(rarityName)
	local matchingItems = {}
	for _, item in pairs(LOOT_ITEMS) do
		if item.Rarity.Name == rarityName then
			table.insert(matchingItems, item)
		end
	end

	if #matchingItems > 0 then
		local randomItem = matchingItems[math.random(1, #matchingItems)]
		return {
			Name = randomItem.Name,
			Value = randomItem.Value,
			Rarity = randomItem.Rarity.Name,
			Color = randomItem.Rarity.Color,
			Icon = randomItem.Icon
		}
	end

	return nil
end

-- Get all loot items (for shop/catalog display)
function LootSystem.GetAllLoot()
	return LOOT_ITEMS
end

-- Get rarity information
function LootSystem.GetRarities()
	return RARITY
end

return LootSystem
