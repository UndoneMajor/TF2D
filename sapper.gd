extends Node2D

var weapon_name = "Sapper"
var damage = 0  # Doesn't damage players
var attack_rate = 1.0
var range = 80
var width = 60
var can_attack = true
var owner_player = null

var current_clip = 999
var reserve_ammo = 999
var is_automatic = false

var show_range = false

var sprite = null

func _ready():
	if ResourceLoader.exists("res://sapper_sprite.tscn"):
		var sprite_scene = load("res://sapper_sprite.tscn")
		sprite = sprite_scene.instantiate()
		add_child(sprite)

func _draw():
	if show_range and GameSettings.show_hitboxes:
		var rect_pos = Vector2(0, -width/2)
		var rect_size = Vector2(range, width)
		draw_rect(Rect2(rect_pos, rect_size), Color(0, 0.5, 1, 0.3))  # Blue
		draw_rect(Rect2(rect_pos, rect_size), Color.CYAN, false, 2)

func shoot(from_position: Vector2, direction: Vector2):
	if not can_attack:
		return false
	
	can_attack = false
	
	if sprite and sprite.has_method("place_animation"):
		sprite.place_animation()
	
	show_range = true
	queue_redraw()
	
	var space_state = owner_player.get_world_2d().direct_space_state
	
	var shape = RectangleShape2D.new()
	shape.size = Vector2(range, width)
	
	var sapper_center = from_position + direction * (range / 2)
	
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = Transform2D(owner_player.rotation, sapper_center)
	query.exclude = [owner_player]
	
	var results = space_state.intersect_shape(query)
	
	if results.size() > 0:
		for result in results:
			var hit_body = result.collider
			if hit_body != owner_player and hit_body.has_method("apply_sapper"):
				hit_body.apply_sapper()
				print("⚡ SAPPER PLACED on ", hit_body.name, "!")
			elif hit_body != owner_player:
				print("⚡ Sapper placed but target has no sapper function")
	else:
		print("⚡ Sapper placement failed - no target")
	
	await get_tree().create_timer(0.2).timeout
	show_range = false
	queue_redraw()
	
	await get_tree().create_timer(attack_rate - 0.2).timeout
	can_attack = true
	return true

func reload():
	pass
