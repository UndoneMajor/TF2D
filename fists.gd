extends Node2D

var weapon_name = "Fists"
var damage = 65
var attack_rate = 0.8
var range = 70
var width = 60
var can_attack = true
var owner_player = null

var current_clip = 999
var reserve_ammo = 999
var is_automatic = false

var show_range = false
var swing_direction = Vector2.RIGHT

var sprite = null

func _ready():
	if ResourceLoader.exists("res://fists_sprite.tscn"):
		var sprite_scene = load("res://fists_sprite.tscn")
		sprite = sprite_scene.instantiate()
		add_child(sprite)

func _draw():
	if show_range and GameSettings.show_hitboxes:
		var rect_pos = Vector2(0, -width/2)
		var rect_size = Vector2(range, width)
		draw_rect(Rect2(rect_pos, rect_size), Color(1, 1, 0, 0.3))
		draw_rect(Rect2(rect_pos, rect_size), Color.YELLOW, false, 2)

func shoot(from_position: Vector2, direction: Vector2):
	if not can_attack:
		return false
	
	can_attack = false
	swing_direction = direction
	
	# Play punch animation on player sprite (heavy only)
	var player_sprite = owner_player.get_node_or_null("AnimatedSprite2D")
	if player_sprite and player_sprite.has_method("play_punch_animation"):
		player_sprite.play_punch_animation()
	
	show_range = true
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
				# Check teammates
				if "team" in hit_body and "team" in owner_player:
					if hit_body.team == owner_player.team:
						print("Fists hit teammate - no damage")
						continue
				
				hit_body.take_damage(damage)
				print("Fists hit: ", hit_body.name, " for ", damage, " damage!")
	else:
		print("Fists swing missed!")
	
	await get_tree().create_timer(0.15).timeout
	show_range = false
	queue_redraw()
	
	await get_tree().create_timer(attack_rate - 0.15).timeout
	can_attack = true
	return true

func reload():
	pass
