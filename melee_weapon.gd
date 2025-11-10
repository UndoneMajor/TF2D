extends Node2D

var weapon_name = "Melee"
var damage = 65
var attack_rate = 0.8
var range = 80  # Melee range
var can_attack = true
var owner_player = null

func attack(from_position: Vector2, direction: Vector2):
	if not can_attack:
		return false
	
	can_attack = false
	
	# Raycast to find enemies in melee range
	var space_state = owner_player.get_world_2d().direct_space_state
	var end_position = from_position + direction * range
	
	var query = PhysicsRayQueryParameters2D.create(from_position, end_position)
	query.exclude = [owner_player]
	
	var result = space_state.intersect_ray(query)
	
	if result:
		var hit_body = result.collider
		if hit_body != owner_player and hit_body.has_method("take_damage"):
			hit_body.take_damage(damage)
			print("Melee hit: ", hit_body.name, " for ", damage, " damage!")
	else:
		print("Melee swing missed!")
	
	# Attack cooldown
	await get_tree().create_timer(attack_rate).timeout
	can_attack = true
	
	return true

# For compatibility with weapon system
func shoot(from_position: Vector2, direction: Vector2):
	return attack(from_position, direction)

var current_clip = 999
var reserve_ammo = 999
var is_automatic = false

func reload():
	pass  # Melee doesn't reload
