extends Node2D

var weapon_name = "Knife"
var damage = 35
var backstab_damage = 600
var attack_rate = 0.8
var range = 57
var width = 30
var can_attack = true
var owner_player = null

var current_clip = 999
var reserve_ammo = 999
var is_automatic = false

var show_range = false
var swing_direction = Vector2.RIGHT

var sprite = null

# Debug visualization
var debug_lines = []

func _ready():
	if ResourceLoader.exists("res://knife_sprite.tscn"):
		var sprite_scene = load("res://knife_sprite.tscn")
		sprite = sprite_scene.instantiate()
		add_child(sprite)

func _draw():
	if show_range and GameSettings.show_hitboxes:
		var rect_pos = Vector2(0, -width/2)
		var rect_size = Vector2(range, width)
		draw_rect(Rect2(rect_pos, rect_size), Color(1, 0, 0, 0.5))
		draw_rect(Rect2(rect_pos, rect_size), Color.RED, false, 2)
	
	# Draw debug lines (only if debug enabled)
	if GameSettings.show_hitboxes:
		for line_data in debug_lines:
			draw_line(line_data.start, line_data.end, line_data.color, 3)

func shoot(from_position: Vector2, direction: Vector2):
	if not can_attack:
		return false
	
	can_attack = false
	swing_direction = direction
	
	if sprite and sprite.has_method("swing_animation"):
		sprite.swing_animation()
	
	show_range = true
	debug_lines.clear()
	queue_redraw()
	
	var space_state = owner_player.get_world_2d().direct_space_state
	
	var shape = RectangleShape2D.new()
	shape.size = Vector2(range, width)
	
	var melee_center = from_position + direction * (range / 2)
	
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = Transform2D(owner_player.rotation, melee_center)
	query.exclude = [owner_player]
	
	var results = space_state.intersect_shape(query)
	
	if results.size() > 0:
		for result in results:
			var hit_body = result.collider
			if hit_body != owner_player and hit_body.has_method("take_damage"):
				# Check teammates - don't backstab your own team!
				if "team" in hit_body and "team" in owner_player:
					if hit_body.team == owner_player.team:
						print("Knife hit teammate - no damage")
						continue
				
				var is_backstab = check_backstab_with_debug(hit_body)
				
				if is_backstab:
					hit_body.take_damage(backstab_damage)
					print("🔪 BACKSTAB! ", hit_body.name, " - INSTANT KILL!")
					
					# Spawn CRIT effect at enemy position
					spawn_crit_effect(hit_body.global_position)
				else:
					hit_body.take_damage(damage)
					print("Knife hit: ", hit_body.name, " for ", damage, " damage")
	else:
		print("Knife swing missed!")
	
	await get_tree().create_timer(0.5).timeout
	show_range = false
	debug_lines.clear()
	queue_redraw()
	
	await get_tree().create_timer(attack_rate - 0.5).timeout
	can_attack = true
	return true

func check_backstab_with_debug(target) -> bool:
	# Simple approach:
	# 1. Get where the target is facing (their front direction)
	var target_facing = Vector2.RIGHT.rotated(target.rotation)
	
	# 2. Get the vector from target TO spy (where the spy is relative to target)
	var target_to_spy = (owner_player.global_position - target.global_position).normalized()
	
	# 3. If target is facing SAME direction as vector to spy = they're facing you (front)
	#    If target is facing OPPOSITE direction = they're facing away (back)
	var dot = target_facing.dot(target_to_spy)
	
	# Convert to local space for drawing
	var target_local_pos = owner_player.to_local(target.global_position)
	
	# Draw target's facing direction (GREEN = where enemy looks)
	debug_lines.append({
		"start": target_local_pos,
		"end": target_local_pos + target_facing * 80,
		"color": Color.GREEN
	})
	
	# Draw vector from target to spy (RED = where you are)
	debug_lines.append({
		"start": target_local_pos,
		"end": target_local_pos + target_to_spy * 80,
		"color": Color.RED
	})
	
	# If dot > 0.5: target is facing toward you (FRONT) - NOT backstab
	# If dot < -0.5: target is facing away from you (BACK) - BACKSTAB!
	var is_backstab = dot < -0.5
	
	print("\n=== BACKSTAB DEBUG ===")
	print("Target rotation: ", rad_to_deg(target.rotation), " degrees")
	print("Target facing direction: ", target_facing)
	print("Vector from target to spy: ", target_to_spy)
	print("Dot product: ", dot)
	
	if is_backstab:
		print("✅ BACKSTAB! (dot < -0.5) - Target facing AWAY from you")
	else:
		print("❌ Normal hit (dot >= -0.5) - Target facing TOWARD you or side")
	print("===================\n")
	
	queue_redraw()
	return is_backstab

func reload():
	pass

func spawn_crit_effect(pos: Vector2):
	print("🎯 Spawning CRIT effect at ", pos)
	
	# Use the preloaded crit effect script
	var crit_effect = load("res://crit_effect.gd").new()
	crit_effect.global_position = pos
	
	# Try to load crit.png if it exists
	if ResourceLoader.exists("res://crit.png"):
		print("✅ Found crit.png, loading image...")
		var crit_sprite = Sprite2D.new()
		var texture = load("res://crit.png")
		crit_sprite.texture = texture
		crit_sprite.scale = Vector2(0.5, 0.5)
		crit_effect.add_child(crit_sprite)
	
	get_tree().root.add_child(crit_effect)
	print("💥 CRIT effect spawned and will disappear in 1 second!")
