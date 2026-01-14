--[[
	Block Generator
	Place this in ServerScriptService
	Generates diggable blocks in the workspace
	OPTIONAL: Use this if you want block-based digging instead of terrain-based
]]--

local workspace = game:GetService("Workspace")

local BlockGenerator = {}

-- Configuration
local BLOCK_SIZE = 4
local AREA_SIZE = 50 -- 50x50 grid
local DEPTH = 30 -- How deep the blocks go
local START_POSITION = Vector3.new(0, 0, 0)

-- Block types and their properties
local BLOCK_TYPES = {
	{Name = "Dirt", Color = Color3.fromRGB(139, 90, 43), Material = Enum.Material.Ground},
	{Name = "Stone", Color = Color3.fromRGB(163, 162, 165), Material = Enum.Material.Slate},
	{Name = "Clay", Color = Color3.fromRGB(204, 142, 105), Material = Enum.Material.Sand},
	{Name = "Gravel", Color = Color3.fromRGB(136, 140, 141), Material = Enum.Material.Pebble},
	{Name = "Sandstone", Color = Color3.fromRGB(218, 192, 163), Material = Enum.Material.Sandstone},
}

-- Generate diggable blocks
function BlockGenerator.GenerateBlocks()
	-- Create folder for blocks
	local diggableFolder = workspace:FindFirstChild("DiggableBlocks")
	if diggableFolder then
		diggableFolder:ClearAllChildren()
	else
		diggableFolder = Instance.new("Folder")
		diggableFolder.Name = "DiggableBlocks"
		diggableFolder.Parent = workspace
	end

	print("Generating diggable blocks...")

	local blocksCreated = 0

	-- Generate grid of blocks
	for x = 0, AREA_SIZE - 1 do
		for z = 0, AREA_SIZE - 1 do
			for y = 0, DEPTH - 1 do
				-- Random chance to skip some blocks for variation
				if math.random() > 0.1 then
					local block = Instance.new("Part")
					block.Name = "DiggableBlock"
					block.Size = Vector3.new(BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)

					-- Calculate position
					local xPos = START_POSITION.X + (x * BLOCK_SIZE)
					local yPos = START_POSITION.Y - (y * BLOCK_SIZE)
					local zPos = START_POSITION.Z + (z * BLOCK_SIZE)
					block.Position = Vector3.new(xPos, yPos, zPos)

					-- Random block type
					local blockType = BLOCK_TYPES[math.random(1, #BLOCK_TYPES)]
					block.Color = blockType.Color
					block.Material = blockType.Material

					block.Anchored = true
					block.CanCollide = true
					block.Parent = diggableFolder

					blocksCreated = blocksCreated + 1
				end
			end
		end
	end

	print("Generated " .. blocksCreated .. " diggable blocks!")
end

-- Generate platform for players to stand on
function BlockGenerator.GeneratePlatform()
	local platform = Instance.new("Part")
	platform.Name = "SpawnPlatform"
	platform.Size = Vector3.new(AREA_SIZE * BLOCK_SIZE, 1, AREA_SIZE * BLOCK_SIZE)
	platform.Position = START_POSITION + Vector3.new((AREA_SIZE * BLOCK_SIZE) / 2, 5, (AREA_SIZE * BLOCK_SIZE) / 2)
	platform.Anchored = true
	platform.BrickColor = BrickColor.new("Bright green")
	platform.Material = Enum.Material.Grass
	platform.Parent = workspace

	print("Generated spawn platform!")
end

-- Clear all blocks (for resetting)
function BlockGenerator.ClearBlocks()
	local diggableFolder = workspace:FindFirstChild("DiggableBlocks")
	if diggableFolder then
		diggableFolder:ClearAllChildren()
		print("Cleared all diggable blocks!")
	end
end

-- Regenerate blocks every X minutes (optional)
function BlockGenerator.StartAutoRegeneration(intervalMinutes)
	task.spawn(function()
		while true do
			task.wait(intervalMinutes * 60)
			print("Auto-regenerating blocks...")
			BlockGenerator.GenerateBlocks()
		end
	end)
end

-- Auto-generate on server start
BlockGenerator.GeneratePlatform()
BlockGenerator.GenerateBlocks()

-- Optional: Auto-regenerate every 30 minutes
-- BlockGenerator.StartAutoRegeneration(30)

return BlockGenerator
