--[[
	Tool Giver Script
	Place this in ServerScriptService
	Automatically gives players the digging tool when they spawn
]]--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Name of your tool in ReplicatedStorage
local TOOL_NAME = "Shovel" -- Change this to match your tool's name

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		-- Wait for character to fully load
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.Died:Connect(function()
			-- Give tool again when player respawns
		end)

		-- Small delay to ensure everything is loaded
		task.wait(0.5)

		-- Find the tool in ReplicatedStorage
		local tool = ReplicatedStorage:FindFirstChild(TOOL_NAME)
		if tool and tool:IsA("Tool") then
			-- Clone the tool and give it to the player
			local toolClone = tool:Clone()
			toolClone.Parent = player.Backpack

			print("Gave " .. TOOL_NAME .. " to " .. player.Name)
		else
			warn("Tool '" .. TOOL_NAME .. "' not found in ReplicatedStorage!")
		end
	end)
end)

print("ToolGiver script loaded - players will receive " .. TOOL_NAME .. " on spawn")
