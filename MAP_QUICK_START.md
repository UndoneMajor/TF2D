# 🗺️ Map System - Quick Start

## ✅ What I Just Added

### 1. **Simple Arena Map** (`simple_map.gd`)
A functional arena with:
- Brown ground/floor
- Gray boundary walls (top, bottom, left, right)
- Red base area (left side) with red walls
- Blue base area (right side) with blue walls
- Center obstacles for cover
- Proper collision on all walls

### 2. **Map Integration** (updated `main.gd`)
- Map loads automatically when game starts
- Spawn points use map positions
- Red team spawns at (-800, 0)
- Blue team spawns at (800, 0)

### 3. **Documentation**
- `MAP_CREATION_GUIDE.md` - Full guide on creating maps
- `MAP_QUICK_START.md` - This file

---

## 🎮 How to Test It

1. Run the game (F5 in Godot)
2. Select team and class
3. You'll spawn in the new arena map!
4. Notice the walls, colored bases, and obstacles

---

## 🎨 How to Customize the Map

### Option 1: Edit `simple_map.gd` Directly

Open `simple_map.gd` and modify the `create_map()` function:

```gdscript
# Add a new wall
create_wall(Vector2(300, 300), Vector2(150, 150), Color.RED)
#            ↑ position        ↑ size          ↑ color

# Change floor color
floor.color = Color(0.1, 0.5, 0.1)  # Green grass

# Change spawn positions
func get_red_spawn_position() -> Vector2:
    return Vector2(-900, 0)  # Move further left
```

### Option 2: Create a New Map

1. Duplicate `simple_map.gd` → `my_custom_map.gd`
2. Edit the new file
3. In `main.gd`, change line 11:
```gdscript
var map_script = preload("res://my_custom_map.gd")
```

---

## 🏗️ Map Elements You Can Add

### Walls
```gdscript
create_wall(Vector2(x, y), Vector2(width, height), Color(r, g, b))
```

### Different Floor Colors
```gdscript
var floor = ColorRect.new()
floor.color = Color(0.2, 0.6, 0.2)  # Green
floor.size = Vector2(2000, 1200)
add_child(floor)
```

### Spawn Points
```gdscript
func get_red_spawn_position() -> Vector2:
    return Vector2(-800, 0)

func get_blue_spawn_position() -> Vector2:
    return Vector2(800, 0)
```

---

## 🎯 Next Steps

### Easy Additions:
1. **Health Packs** - Add pickups that restore health
2. **Ammo Packs** - Add pickups that restore ammo
3. **Different Rooms** - Create multiple connected areas
4. **One-Way Doors** - Spawn room exits

### Medium Additions:
1. **Control Points** - Circles to capture
2. **Intel Briefcase** - For CTF mode
3. **Multiple Maps** - Create 2-3 different maps
4. **Map Selection** - Let players vote on maps

### Advanced:
1. **TileMap System** - Use tiles instead of code
2. **Destructible Walls** - Walls that break
3. **Moving Platforms** - Elevators, trains
4. **Environmental Hazards** - Pits, spikes, lava

---

## 📐 Map Design Tips

### Good Map Layout:
```
[RED SPAWN] ──── [CHOKE] ──── [MIDDLE] ──── [CHOKE] ──── [BLUE SPAWN]
     │                           │                            │
  [FLANK]                   [OBJECTIVE]                   [FLANK]
```

### Key Principles:
1. **Symmetry** - Mirror layout for balance
2. **Multiple Routes** - Main path + flanks
3. **Cover** - Obstacles to hide behind
4. **Sightlines** - Long corridors for snipers
5. **Chokepoints** - Narrow areas for defense

---

## 🚀 Want to Create a TileMap Instead?

See `MAP_CREATION_GUIDE.md` for full TileMap tutorial!

TileMaps are better for:
- Complex, detailed maps
- Reusable tiles (walls, floors, decorations)
- Visual map editing (paint instead of code)
- Larger maps with many rooms

---

## 🎨 Example: 2Fort-Style Map

```gdscript
# Red fort (left)
create_wall(Vector2(-700, 0), Vector2(200, 600), Color(0.6, 0.2, 0.2))

# Blue fort (right)  
create_wall(Vector2(700, 0), Vector2(200, 600), Color(0.2, 0.3, 0.6))

# Bridge connecting them
create_wall(Vector2(0, 300), Vector2(600, 100), Color(0.4, 0.4, 0.4))

# Water under bridge
var water = ColorRect.new()
water.color = Color(0.1, 0.3, 0.5)
water.size = Vector2(600, 200)
water.position = Vector2(-300, 450)
add_child(water)
```

---

**Need help? Just ask!** 🎮

