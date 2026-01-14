--[[
	Loot Notification UI Handler
	Place this in StarterPlayer > StarterPlayerScripts
	Displays notifications when player finds loot
]]--

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create notification UI
local function createNotificationUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "LootNotifications"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(0, 300, 0, 500)
	container.Position = UDim2.new(1, -320, 0.5, -250)
	container.BackgroundTransparency = 1
	container.Parent = screenGui

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 10)
	layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	layout.Parent = container

	return container
end

local notificationContainer = createNotificationUI()

-- Show loot notification
local function showLootNotification(loot)
	-- Create notification frame
	local notification = Instance.new("Frame")
	notification.Size = UDim2.new(1, 0, 0, 80)
	notification.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	notification.BorderSizePixel = 0

	-- Rarity color bar
	local rarityBar = Instance.new("Frame")
	rarityBar.Size = UDim2.new(0, 5, 1, 0)
	rarityBar.Position = UDim2.new(0, 0, 0, 0)
	rarityBar.BorderSizePixel = 0
	rarityBar.BackgroundColor3 = BrickColor.new(loot.Color).Color
	rarityBar.Parent = notification

	-- Rounded corners
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = notification

	-- Icon
	local icon = Instance.new("TextLabel")
	icon.Size = UDim2.new(0, 60, 0, 60)
	icon.Position = UDim2.new(0, 15, 0.5, -30)
	icon.BackgroundTransparency = 1
	icon.Text = loot.Icon or "💎"
	icon.TextSize = 40
	icon.Parent = notification

	-- Item name
	local itemName = Instance.new("TextLabel")
	itemName.Size = UDim2.new(1, -90, 0, 30)
	itemName.Position = UDim2.new(0, 80, 0, 10)
	itemName.BackgroundTransparency = 1
	itemName.Text = loot.Name
	itemName.TextColor3 = Color3.new(1, 1, 1)
	itemName.TextSize = 18
	itemName.Font = Enum.Font.GothamBold
	itemName.TextXAlignment = Enum.TextXAlignment.Left
	itemName.Parent = notification

	-- Rarity text
	local rarityText = Instance.new("TextLabel")
	rarityText.Size = UDim2.new(1, -90, 0, 20)
	rarityText.Position = UDim2.new(0, 80, 0, 35)
	rarityText.BackgroundTransparency = 1
	rarityText.Text = loot.Rarity
	rarityText.TextColor3 = BrickColor.new(loot.Color).Color
	rarityText.TextSize = 14
	rarityText.Font = Enum.Font.Gotham
	rarityText.TextXAlignment = Enum.TextXAlignment.Left
	rarityText.Parent = notification

	-- Value text
	local valueText = Instance.new("TextLabel")
	valueText.Size = UDim2.new(1, -90, 0, 20)
	valueText.Position = UDim2.new(0, 80, 0, 55)
	valueText.BackgroundTransparency = 1
	valueText.Text = "+" .. loot.Value .. " Coins"
	valueText.TextColor3 = Color3.fromRGB(255, 215, 0)
	valueText.TextSize = 14
	valueText.Font = Enum.Font.Gotham
	valueText.TextXAlignment = Enum.TextXAlignment.Left
	valueText.Parent = notification

	notification.Parent = notificationContainer

	-- Slide in animation
	notification.Position = UDim2.new(1, 0, 0, 0)
	local slideIn = TweenService:Create(
		notification,
		TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Position = UDim2.new(0, 0, 0, 0)}
	)
	slideIn:Play()

	-- Auto-remove after 3 seconds
	task.delay(3, function()
		local slideOut = TweenService:Create(
			notification,
			TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
			{Position = UDim2.new(1, 0, 0, 0)}
		)
		slideOut:Play()
		slideOut.Completed:Wait()
		notification:Destroy()
	end)
end

-- Listen for loot updates
local updateInventoryEvent = ReplicatedStorage:WaitForChild("UpdateInventory")
updateInventoryEvent.OnClientEvent:Connect(function(loot)
	showLootNotification(loot)
end)

print("Loot notification system loaded!")
