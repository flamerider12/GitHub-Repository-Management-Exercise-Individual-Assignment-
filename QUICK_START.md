# ⚡ Quick Start Guide - Digging for Brainrots

## 🎯 Fastest Setup (5 minutes)

### 1. Copy Scripts to Roblox Studio

**ServerScriptService:**
```
📁 ServerScriptService
├── 📄 DiggingHandler.lua
├── 📄 LootSystem.lua
├── 📄 PlayerDataManager.lua
├── 📄 BlockGenerator.lua (optional)
└── 📄 ToolGiver.lua
```

**ReplicatedStorage:**
```
📁 ReplicatedStorage
└── 🔧 Shovel (Tool)
    ├── 📦 Handle (Part)
    └── 📄 ShovelTool.lua (LocalScript)
```

**StarterPlayer > StarterPlayerScripts:**
```
📁 StarterPlayerScripts
├── 📄 LootNotification.lua
└── 📄 StatsDisplay.lua
```

### 2. Create the Shovel Tool

1. Right-click **ReplicatedStorage** → Insert Object → **Tool**
2. Rename it to "Shovel"
3. Right-click the Tool → Insert Object → **Part**
4. Rename the Part to "Handle"
5. Customize the Handle's appearance (color, size, shape)
6. Right-click the Tool → Insert Object → **LocalScript**
7. Paste the contents of `ShovelTool.lua` into the LocalScript

### 3. Test It!

1. Click **Play** in Roblox Studio
2. You'll spawn with a shovel in your inventory
3. Equip it and click on blocks to dig
4. Watch the loot notifications appear!

## 🎮 What Each Script Does

| Script | Purpose |
|--------|---------|
| **DiggingHandler.lua** | Handles server-side digging, validates requests |
| **LootSystem.lua** | Defines all loot items and rarity chances |
| **PlayerDataManager.lua** | Saves player stats and inventory |
| **BlockGenerator.lua** | Creates diggable blocks in the world |
| **ToolGiver.lua** | Gives players the shovel on spawn |
| **ShovelTool.lua** | Client-side tool controls |
| **LootNotification.lua** | Shows popup when you find items |
| **StatsDisplay.lua** | Shows coins and digs in corner |

## 🔑 Key Configuration Values

### Digging Speed
```lua
-- In ShovelTool.lua
local DIG_COOLDOWN = 0.5 -- Seconds between digs
```

### Loot Drop Rates
```lua
-- In LootSystem.lua
COMMON = 50%
UNCOMMON = 25%
RARE = 15%
EPIC = 7%
LEGENDARY = 2.5%
MYTHIC = 0.5%
```

### World Generation
```lua
-- In BlockGenerator.lua
local AREA_SIZE = 50 -- 50x50 block grid
local DEPTH = 30 -- 30 blocks deep
```

## 💡 Quick Tips

✅ **Make sure to:**
- Name the tool's part exactly "Handle"
- Put scripts in the correct locations
- Enable API Services for data saving

❌ **Common mistakes:**
- Forgetting to create RemoteEvents (scripts auto-create them)
- Tool not working (check if ShovelTool is a LocalScript)
- No blocks appearing (adjust START_POSITION in BlockGenerator)

## 🎨 Brainrot Loot Items

**Mythic Items (0.5% chance):**
- 💫 Ultimate Sigma Core (10,000 coins)
- 🌌 Brainrot Singularity (15,000 coins)
- 👼 Divine Gyat (12,000 coins)

**Legendary Items (2.5% chance):**
- 🧠 Golden Brainrot (2,000 coins)
- 🌟 Infinite Aura (2,500 coins)
- 👑 Rizz Crown (3,000 coins)

**Epic Items (7% chance):**
- 🏆 Gigachad Medallion (750 coins)
- 🗿 Mewing Statue (800 coins)
- 👟 Griddy Shoes (850 coins)

And many more!

## 🐛 Troubleshooting

**Tool doesn't appear:**
→ Check ToolGiver.lua, verify tool name matches

**Can't dig:**
→ Make sure blocks exist or terrain is present

**No loot drops:**
→ Check Output for errors, verify LootSystem.lua is loaded

**Stats don't update:**
→ Check if leaderstats are created in PlayerDataManager

## 📖 Full Documentation

See `ROBLOX_SETUP.md` for complete setup instructions and customization options.

---

**You're ready to dig! 🧠⛏️**
