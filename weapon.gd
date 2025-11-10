extends Node2D

# Weapon stats
var weapon_name = "Base Weapon"
var damage = 25
var fire_rate = 0.5
var ammo_per_clip = 6
var max_ammo = 32
var current_clip = 6
var reserve_ammo = 32
var is_automatic = false
var bullet_speed = 400
var bullet_count = 1
var spread = 0.0
var recoil_amount = 2.0  # Camera shake amount

var can_shoot = true
var bullet_scene = preload("res://bullet.tscn")
var owner_player = null

func _ready():
	pass

func shoot(from_position: Vector2, direction: Vector2):
	# Check if we can actually shoot BEFORE animating
	if not can_shoot or current_clip <= 0:
		print(weapon_name, " - Can't shoot! Ammo: ", current_clip)
		return false
	
	can_shoot = false
	current_clip -= 1
	
	# Add recoil/camera shake
	if owner_player and owner_player.has_method("add_camera_shake"):
		owner_player.add_camera_shake(recoil_amount)
	
	# Spawn bullets
	for i in range(bullet_count):
		var bullet = bullet_scene.instantiate()
		bullet.position = from_position
		
		# Add spread
		var spread_angle = randf_range(-spread, spread)
		var bullet_direction = direction.rotated(spread_angle)
		
		bullet.direction = bullet_direction
		bullet.speed = bullet_speed
		bullet.damage = damage
		bullet.shooter = owner_player
		
		get_tree().root.add_child(bullet)
	
	# Fire rate cooldown
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
	
	return true

func reload():
	if reserve_ammo <= 0 or current_clip == ammo_per_clip:
		return
	
	var ammo_needed = ammo_per_clip - current_clip
	var ammo_to_reload = min(ammo_needed, reserve_ammo)
	
	current_clip += ammo_to_reload
	reserve_ammo -= ammo_to_reload
	
	print("Reloaded! Clip: ", current_clip, " Reserve: ", reserve_ammo)
