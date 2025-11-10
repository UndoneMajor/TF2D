extends Node2D

var weapon_name = "Bat"
var damage = 35
var attack_rate = 0.5
var range = 80
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
	# Load and add the sprite
	var sprite_scene = load("res://bat_sprite.tscn")
	sprite = sprite_scene.instantiate()
	add_child(sprite)
	# Sprite positions itself in its own _ready()

func _draw():
	if show_range and GameSettings.show_hitboxes:
		var rect_pos = Vector2(0, -width/2)
		var rect_size = Vector2(range, width)
		draw_rect(Rect2(rect_pos, rect_size), Color(1, 0, 0, 0.3))
		draw_rect(Rect2(rect_pos, rect_size), Color.RED, false, 2)

func shoot(from_position: Vector2, direction: Vector2):
	if not can_attack:
		return false
	
	can_attack = false
	swing_direction = direction
	
	# Play swing animation
	if sprite:
		sprite.swing_animation()
	
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
				hit_body.take_damage(damage)
				print("Bat hit: ", hit_body.name, " for ", damage, " damage!")
	else:
		print("Bat swing missed!")
	
	await get_tree().create_timer(0.15).timeout
	show_range = false
	queue_redraw()
	
	await get_tree().create_timer(attack_rate - 0.15).timeout
	can_attack = true
	return true

func reload():
	pass
