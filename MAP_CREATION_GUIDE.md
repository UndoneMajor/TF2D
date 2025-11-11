# 🗺️ Map Creation Guide for TF2D

## Quick Overview
There are 3 main ways to create maps in Godot for a top-down 2D game:

### 1. **TileMap** (Best for grid-based maps) ⭐ RECOMMENDED
### 2. **Polygon2D + CollisionPolygon2D** (Best for custom shapes)
### 3. **Sprite2D + CollisionShape2D** (Best for simple rectangular rooms)

---

## Method 1: TileMap (RECOMMENDED) 🎨

### Step 1: Create a Tileset
1. Open Godot
2. Create a new scene
3. Add a `TileMap` node as root
4. In the Inspector, click "TileSet" → "New TileSet"
5. Click the TileSet to edit it

### Step 2: Add Tiles
You can either:
- **Draw tiles in Godot** (simple colored squares)
- **Import tile images** (PNG files with wall textures, floor textures, etc.)

#### Option A: Draw Simple Tiles
1. In TileSet editor, click "+" to add a new tile
2. Select "Create from Scene"
3. Create a ColorRect or Polygon2D with your desired color
4. Add a CollisionShape2D as a child (for walls)
5. Save as a scene

#### Option B: Use Image Tiles
1. Create a PNG file (e.g., `tiles.png`) with a grid of tiles:
   - 32x32 pixels per tile
   - Multiple tiles in one image (e.g., 8x8 grid = 256x256 image)
2. Import the PNG into Godot
3. In TileSet editor, click "+" → "Atlas"
4. Select your PNG file
5. Set tile size (32x32)
6. For wall tiles, add collision shapes

### Step 3: Paint Your Map
1. Select the TileMap node
2. In the bottom panel, you'll see the tile palette
3. Select a tile and click to paint on the map
4. Use different layers for:
   - **Layer 0**: Floor
   - **Layer 1**: Walls
   - **Layer 2**: Details (decorations)

### Example TF2 Map Layout:
```
[RED SPAWN] ═══ [CORRIDOR] ═══ [MIDDLE] ═══ [CORRIDOR] ═══ [BLUE SPAWN]
     │                              │                              │
  [ROOM 1]                    [CONTROL POINT]                  [ROOM 2]
```

---

## Method 2: Polygon2D Walls (Quick & Custom) 🎯

### Step 1: Create Map Scene
1. Create new scene: `File` → `New Scene`
2. Add `Node2D` as root, name it "Map"
3. Save as `map_dustbowl.tscn`

### Step 2: Add Background
1. Add `ColorRect` or `Polygon2D` child
2. Set color (brown for ground, gray for concrete, etc.)
3. Make it large enough for your map

### Step 3: Add Walls
1. Add `StaticBody2D` node (for collision)
2. Add multiple `CollisionPolygon2D` children
3. Draw wall shapes by clicking points
4. Add `Polygon2D` sibling to visualize walls (set color)

### Step 4: Add Spawn Points
1. Add `Node2D` called "SpawnPoints"
2. Add `Marker2D` children:
   - `RedSpawn` at position (-600, 400)
   - `BlueSpawn` at position (600, 400)

---

## Method 3: Simple Rooms (Easiest for Beginners) 📦

### Create a Simple Arena:

```gdscript
# map_simple.gd
extends Node2D

func _ready():
    create_arena()

func create_arena():
    # Floor
    var floor = ColorRect.new()
    floor.color = Color(0.3, 0.25, 0.2)
    floor.size = Vector2(1600, 900)
    floor.position = Vector2(-800, -450)
    add_child(floor)
    
    # Walls (StaticBody2D with CollisionShape2D)
    create_wall(Vector2(0, -500), Vector2(1800, 50))  # Top
    create_wall(Vector2(0, 500), Vector2(1800, 50))   # Bottom
    create_wall(Vector2(-900, 0), Vector2(50, 1000))  # Left
    create_wall(Vector2(900, 0), Vector2(50, 1000))   # Right
    
    # Center obstacle
    create_wall(Vector2(0, 0), Vector2(200, 200))

func create_wall(pos: Vector2, size: Vector2):
    var wall = StaticBody2D.new()
    wall.position = pos
    
    var collision = CollisionShape2D.new()
    var shape = RectangleShape2D.new()
    shape.size = size
    collision.shape = shape
    
    var visual = ColorRect.new()
    visual.color = Color(0.4, 0.4, 0.4)
    visual.size = size
    visual.position = -size / 2
    
    wall.add_child(collision)
    wall.add_child(visual)
    add_child(wall)
```

---

## 🎮 Integrating Maps into Your Game

### Step 1: Create Multiple Map Scenes
- `map_2fort.tscn`
- `map_dustbowl.tscn`
- `map_badwater.tscn`

### Step 2: Load Maps in main.gd

```gdscript
var current_map = null
var maps = [
    "res://map_2fort.tscn",
    "res://map_dustbowl.tscn",
    "res://map_badwater.tscn"
]

func load_map(map_index: int):
    # Remove old map
    if current_map:
        current_map.queue_free()
    
    # Load new map
    var map_scene = load(maps[map_index])
    current_map = map_scene.instantiate()
    add_child(current_map)
    
    # Update spawn positions
    update_spawn_positions()

func update_spawn_positions():
    var spawn_points = current_map.get_node("SpawnPoints")
    if spawn_points:
        var red_spawn = spawn_points.get_node("RedSpawn")
        var blue_spawn = spawn_points.get_node("BlueSpawn")
        
        # Use these positions for spawning players/bots
```

---

## 🎨 Map Design Tips for TF2D

### 1. **Symmetry** (for balanced gameplay)
- Mirror layout for Red vs Blue
- Equal distances to objectives
- Same number of health packs on each side

### 2. **Chokepoints** (strategic bottlenecks)
- Narrow corridors
- Single doorways
- Bridges

### 3. **Height Variation** (even in 2D!)
- Use different floor colors to show "levels"
- Add ramps/stairs (visual only)
- Sniping positions

### 4. **Cover** (obstacles for tactical play)
- Boxes, walls, pillars
- Break line-of-sight
- Create flanking routes

### 5. **Health & Ammo Packs**
- Small packs in safe areas
- Large packs in dangerous areas
- Respawn after 10 seconds

---

## 📏 Recommended Map Sizes

- **Small (2v2)**: 1200x800 pixels
- **Medium (6v6)**: 2400x1600 pixels  ⭐ RECOMMENDED
- **Large (12v12)**: 4000x2400 pixels

---

## 🚀 Quick Start: Create Your First Map NOW!

### In Godot Editor:
1. Open `main.tscn`
2. Right-click on Main node → "Add Child Node"
3. Search for "TileMap" → Add
4. In Inspector: TileSet → "New TileSet"
5. Start painting!

OR

1. Scene → New Scene
2. Add Node2D (root)
3. Add ColorRect (background)
4. Add StaticBody2D (walls)
5. Add CollisionPolygon2D to walls
6. Draw wall shapes
7. Save as `map_test.tscn`
8. In `main.gd`, instance your map!

---

## 🎯 Next Steps

After creating basic maps, add:
- Spawn rooms with team colors
- Control points (circles to capture)
- Intel briefcases (for CTF mode)
- Health/ammo pack locations
- One-way doors (for spawn rooms)
- Respawn visualizers

**Need help with any of these? Just ask!** 🚀

