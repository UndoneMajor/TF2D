extends Node2D

# Weapon stats
var weapon_name = "Rocket Launcher"
var damage = 90
var fire_rate = 0.8
var ammo_per_clip = 4
var max_ammo = 20
var current_clip = 4
var reserve_ammo = 20
var is_automatic = false
var recoil_amount = 10.0

var can_shoot = true
var rocket_scene = preload("res://rocket.tscn")
var owner_player = null
var sprite = null

func _ready():
	if ResourceLoader.exists("res://rocket_launcher_sprite.tscn"):
		var sprite_scene = load("res://rocket_launcher_sprite.tscn")
		sprite = sprite_scene.instantiate()
		add_child(sprite)

func shoot(from_position: Vector2, direction: Vector2):
	if not can_shoot or current_clip <= 0:
		print(weapon_name, " - Can't shoot! Ammo: ", current_clip)
		return false
	
	can_shoot = false
	current_clip -= 1
	
	# Add recoil
	if owner_player and owner_player.has_method("add_camera_shake"):
		owner_player.add_camera_shake(recoil_amount)
	
	# Spawn rocket
	var rocket = rocket_scene.instantiate()
	rocket.position = from_position
	rocket.direction = direction
	rocket.damage = damage
	rocket.shooter = owner_player
	
	get_tree().root.add_child(rocket)
	
	print("🚀 ROCKET LAUNCHED!")
	
	# Play animation
	if sprite and sprite.has_method("shoot_animation"):
		sprite.shoot_animation()
	
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
