--[[
	Stats Display UI
	Place this in StarterPlayer > StarterPlayerScripts
	Shows player stats in the corner of the screen
]]--

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for leaderstats
local leaderstats = player:WaitForChild("leaderstats")
local coins = leaderstats:WaitForChild("Coins")
local digs = leaderstats:WaitForChild("Digs")

-- Create stats UI
local function createStatsUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "StatsDisplay"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	-- Main frame
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 250, 0, 120)
	mainFrame.Position = UDim2.new(0, 20, 0, 20)
	mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui

	-- Rounded corners
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = mainFrame

	-- Title
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 0, 30)
	title.Position = UDim2.new(0, 10, 0, 10)
	title.BackgroundTransparency = 1
	title.Text = "🧠 Brainrot Stats"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextSize = 18
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = mainFrame

	-- Coins display
	local coinsLabel = Instance.new("TextLabel")
	coinsLabel.Name = "CoinsLabel"
	coinsLabel.Size = UDim2.new(1, -20, 0, 25)
	coinsLabel.Position = UDim2.new(0, 10, 0, 45)
	coinsLabel.BackgroundTransparency = 1
	coinsLabel.Text = "💰 Coins: 0"
	coinsLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
	coinsLabel.TextSize = 16
	coinsLabel.Font = Enum.Font.Gotham
	coinsLabel.TextXAlignment = Enum.TextXAlignment.Left
	coinsLabel.Parent = mainFrame

	-- Digs display
	local digsLabel = Instance.new("TextLabel")
	digsLabel.Name = "DigsLabel"
	digsLabel.Size = UDim2.new(1, -20, 0, 25)
	digsLabel.Position = UDim2.new(0, 10, 0, 75)
	digsLabel.BackgroundTransparency = 1
	digsLabel.Text = "⛏️ Digs: 0"
	digsLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
	digsLabel.TextSize = 16
	digsLabel.Font = Enum.Font.Gotham
	digsLabel.TextXAlignment = Enum.TextXAlignment.Left
	digsLabel.Parent = mainFrame

	return {
		CoinsLabel = coinsLabel,
		DigsLabel = digsLabel
	}
end

local statsUI = createStatsUI()

-- Format large numbers
local function formatNumber(num)
	if num >= 1000000 then
		return string.format("%.1fM", num / 1000000)
	elseif num >= 1000 then
		return string.format("%.1fK", num / 1000)
	else
		return tostring(num)
	end
end

-- Update coins display
coins.Changed:Connect(function(value)
	statsUI.CoinsLabel.Text = "💰 Coins: " .. formatNumber(value)
end)

-- Update digs display
digs.Changed:Connect(function(value)
	statsUI.DigsLabel.Text = "⛏️ Digs: " .. formatNumber(value)
end)

-- Initial update
statsUI.CoinsLabel.Text = "💰 Coins: " .. formatNumber(coins.Value)
statsUI.DigsLabel.Text = "⛏️ Digs: " .. formatNumber(digs.Value)

print("Stats display loaded!")
