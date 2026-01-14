# 🧠 Digging for Brainrots - Roblox Game Setup Guide

A complete digging mechanics system for your Roblox game featuring brainrot-themed loot, progression system, and player stats!

## 🎮 Features

- ⛏️ **Digging Mechanics** - Click to dig and find treasures
- 💎 **Loot System** - 6 rarity tiers with brainrot-themed items
- 📊 **Stats Tracking** - Coins, digs, and achievements
- 🎨 **UI System** - Notifications and stats display
- 💾 **Data Persistence** - Saves player progress
- 🏆 **Achievements** - Unlockable milestones

## 📁 Project Structure

```
src/
├── ServerScriptService/          # Server-side scripts
│   ├── DiggingHandler.lua        # Main digging logic
│   ├── LootSystem.lua            # Loot tables and rarity system
│   ├── PlayerDataManager.lua    # Data persistence and stats
│   └── BlockGenerator.lua        # Generates diggable blocks
│
├── ReplicatedStorage/            # Shared scripts
│   └── ShovelTool.lua            # Client-side tool script
│
└── StarterPlayer/
    └── StarterPlayerScripts/     # Client UI scripts
        ├── LootNotification.lua  # Loot popup notifications
        └── StatsDisplay.lua      # Stats HUD
```

## 🚀 Installation Instructions

### Step 1: Create the Game Structure

1. Open Roblox Studio
2. Create a new place or open your existing game
3. In the Explorer window, locate these services:
   - ServerScriptService
   - ReplicatedStorage
   - StarterPlayer > StarterPlayerScripts

### Step 2: Add Server Scripts

Copy the following scripts to **ServerScriptService**:

1. **DiggingHandler.lua** - Main server-side digging logic
2. **LootSystem.lua** - Loot table module
3. **PlayerDataManager.lua** - Player data management
4. **BlockGenerator.lua** - Generates diggable blocks (optional)

### Step 3: Add the Digging Tool

1. In **ReplicatedStorage**, create a **Tool** object:
   - Right-click ReplicatedStorage → Insert Object → Tool
   - Name it "Shovel" or "DigTool"

2. Add the tool handle:
   - Insert a Part into the Tool
   - Name it "Handle"
   - Customize its appearance (make it look like a shovel)

3. Add **ShovelTool.lua**:
   - Copy the script from `src/ReplicatedStorage/ShovelTool.lua`
   - Paste it as a LocalScript inside the Tool

### Step 4: Add UI Scripts

Copy to **StarterPlayer > StarterPlayerScripts**:

1. **LootNotification.lua** - Shows loot notifications
2. **StatsDisplay.lua** - Displays player stats

### Step 5: Setup the World

**Option A: Block-Based Digging**
- The BlockGenerator script will automatically create a grid of diggable blocks
- Blocks will spawn at position (0, 0, 0)
- Adjust `START_POSITION` in BlockGenerator.lua to change location

**Option B: Terrain-Based Digging**
1. Use Roblox's Terrain Editor
2. Add terrain to your world (dirt, stone, etc.)
3. Players can dig directly into the terrain

### Step 6: Give Players the Tool

Add this script to **ServerScriptService**:

```lua
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(1) -- Wait for character to load

        -- Give the player the shovel tool
        local tool = ReplicatedStorage:FindFirstChild("Shovel")
        if tool then
            local toolClone = tool:Clone()
            toolClone.Parent = player.Backpack
        end
    end)
end)
```

### Step 7: Configure DataStores (Optional)

To enable data saving:

1. Go to Game Settings → Security
2. Enable "Enable Studio Access to API Services"
3. Publish your game to Roblox
4. DataStores will automatically save player progress

## 🎯 Loot Rarity System

| Rarity | Chance | Example Items |
|--------|--------|---------------|
| Common | 50% | Dirt Clump, Pebble, Stick |
| Uncommon | 25% | Cursed Meme, Brainrot Crystal, Rizz Shard |
| Rare | 15% | Sigma Grindstone, Skibidi Toilet Part |
| Epic | 7% | Gigachad Medallion, Mewing Statue |
| Legendary | 2.5% | Golden Brainrot, Infinite Aura |
| Mythic | 0.5% | Ultimate Sigma Core, Brainrot Singularity |

## ⚙️ Customization

### Adjust Dig Speed
In `ShovelTool.lua`, change:
```lua
local DIG_COOLDOWN = 0.5 -- Time between digs (seconds)
```

### Adjust Dig Range
In `ShovelTool.lua`, change:
```lua
local DIG_RANGE = 10 -- Maximum digging distance
```

### Add New Loot Items
In `LootSystem.lua`, add to the `LOOT_ITEMS` table:
```lua
{Name = "Your Item", Value = 100, Rarity = RARITY.RARE, Icon = "🎁"}
```

### Change Block Generation
In `BlockGenerator.lua`, adjust:
```lua
local AREA_SIZE = 50 -- Grid size
local DEPTH = 30 -- How deep blocks go
local BLOCK_SIZE = 4 -- Size of each block
```

## 🏆 Achievement System

Built-in achievements:
- **First Dig!** - Dig 1 time
- **Digger** - Dig 100 times
- **Excavator** - Dig 1,000 times
- **Getting Rich** - Earn 10,000 coins total
- **Wealthy** - Earn 100,000 coins total

Add more in `PlayerDataManager.lua`!

## 🐛 Troubleshooting

**Tool doesn't work:**
- Make sure the Tool has a Part named "Handle"
- Check that RemoteEvent "DigEvent" exists in ReplicatedStorage
- Verify the LocalScript is inside the Tool

**No loot appears:**
- Check Output window for errors
- Make sure LootSystem module is in ServerScriptService
- Verify UpdateInventory RemoteEvent exists

**Blocks don't generate:**
- Check if BlockGenerator script ran (look for print messages)
- Adjust START_POSITION to spawn blocks in visible area
- Make sure workspace has a "DiggableBlocks" folder

**Data doesn't save:**
- Enable API Services in Game Settings
- Publish game to Roblox (DataStores don't work in local testing)
- Check Output for DataStore errors

## 📝 Remote Events Required

Make sure these RemoteEvents exist in **ReplicatedStorage**:

1. **DigEvent** - Client → Server digging requests
2. **UpdateInventory** - Server → Client loot notifications

These are created automatically by the scripts, but you can create them manually if needed.

## 🎨 UI Customization

All UI elements can be customized in:
- `LootNotification.lua` - Notification appearance
- `StatsDisplay.lua` - Stats HUD design

## 🔧 Advanced Features

### Auto-Block Regeneration
Uncomment in `BlockGenerator.lua`:
```lua
BlockGenerator.StartAutoRegeneration(30) -- Regenerate every 30 minutes
```

### Custom Animations
Add digging animation:
1. Create animation in Roblox Animation Editor
2. Upload to Roblox
3. Add Animation object to the Tool
4. The script will automatically play it

## 📞 Support

If you encounter issues:
1. Check the Output window in Roblox Studio for errors
2. Verify all scripts are in the correct locations
3. Make sure RemoteEvents are created
4. Test in a local server (Test → Start Server & Start Player)

## 🎮 Testing

1. Click "Test" in Roblox Studio
2. Equip the shovel tool from your inventory
3. Click on blocks or terrain to dig
4. Watch notifications appear when you find loot
5. Check stats display in top-left corner

---

**Enjoy your brainrot digging game! 🧠⛏️💎**
