extends Node2D

# Simple arena map with walls and spawn points

func _ready():
	create_map()
	create_navigation()

func create_map():
	# Create floor
	var floor = ColorRect.new()
	floor.color = Color(0.25, 0.22, 0.18)  # Brown ground
	floor.size = Vector2(2000, 1200)
	floor.position = Vector2(-1000, -600)
	floor.z_index = -1
	add_child(floor)
	
	# Create boundary walls
	create_wall(Vector2(0, -650), Vector2(2100, 100), Color(0.3, 0.3, 0.3))  # Top
	create_wall(Vector2(0, 650), Vector2(2100, 100), Color(0.3, 0.3, 0.3))   # Bottom
	create_wall(Vector2(-1050, 0), Vector2(100, 1400), Color(0.3, 0.3, 0.3))  # Left
	create_wall(Vector2(1050, 0), Vector2(100, 1400), Color(0.3, 0.3, 0.3))   # Right
	
	# Red base walls (left side)
	create_wall(Vector2(-600, 0), Vector2(100, 600), Color(0.6, 0.2, 0.2))  # Red wall
	create_wall(Vector2(-750, 250), Vector2(200, 100), Color(0.6, 0.2, 0.2))  # Red cover
	
	# Blue base walls (right side)
	create_wall(Vector2(600, 0), Vector2(100, 600), Color(0.2, 0.3, 0.6))  # Blue wall
	create_wall(Vector2(750, -250), Vector2(200, 100), Color(0.2, 0.3, 0.6))  # Blue cover
	
	# Center obstacles
	create_wall(Vector2(0, -200), Vector2(300, 80), Color(0.4, 0.4, 0.4))  # Top center
	create_wall(Vector2(0, 200), Vector2(300, 80), Color(0.4, 0.4, 0.4))   # Bottom center
	create_wall(Vector2(-200, 0), Vector2(80, 150), Color(0.4, 0.4, 0.4))  # Left center
	create_wall(Vector2(200, 0), Vector2(80, 150), Color(0.4, 0.4, 0.4))   # Right center

func create_wall(pos: Vector2, size: Vector2, color: Color):
	var wall = StaticBody2D.new()
	wall.position = pos
	
	# Collision
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = size
	collision.shape = shape
	wall.add_child(collision)
	
	# Visual
	var visual = ColorRect.new()
	visual.color = color
	visual.size = size
	visual.position = -size / 2
	wall.add_child(visual)
	
	# Outline
	var outline = ColorRect.new()
	outline.color = Color.BLACK
	outline.size = size + Vector2(4, 4)
	outline.position = -size / 2 - Vector2(2, 2)
	outline.z_index = -1
	wall.add_child(outline)
	
	add_child(wall)

func create_navigation():
	# Create navigation region for pathfinding
	var nav_region = NavigationRegion2D.new()
	nav_region.name = "NavigationRegion2D"
	add_child(nav_region)
	
	# Create navigation polygon (walkable area)
	var nav_poly = NavigationPolygon.new()
	
	# Define the entire walkable area as one big rectangle
	var walkable_area = PackedVector2Array([
		Vector2(-950, -550),   # Top-left
		Vector2(950, -550),    # Top-right
		Vector2(950, 550),     # Bottom-right
		Vector2(-950, 550)     # Bottom-left
	])
	nav_poly.add_outline(walkable_area)
	
	# Make the navigation mesh
	nav_poly.make_polygons_from_outlines()
	nav_region.navigation_polygon = nav_poly
	
	print("✅ Navigation mesh created!")
	
	# Wait a frame then enable navigation
	await get_tree().process_frame
	nav_region.enabled = true

func get_red_spawn_position() -> Vector2:
	return Vector2(-800, 0)

func get_blue_spawn_position() -> Vector2:
	return Vector2(800, 0)

