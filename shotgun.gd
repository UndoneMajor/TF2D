extends "res://weapon.gd"

var sprite = null

func _ready():
	weapon_name = "Shotgun"
	damage = 9
	fire_rate = 0.6
	ammo_per_clip = 6
	max_ammo = 32
	current_clip = 6
	reserve_ammo = 32
	is_automatic = false
	bullet_speed = 500
	bullet_count = 6
	spread = 0.5
	
	if ResourceLoader.exists("res://shotgun_sprite.tscn"):
		var sprite_scene = load("res://shotgun_sprite.tscn")
		sprite = sprite_scene.instantiate()
		add_child(sprite)

func shoot(from_position: Vector2, direction: Vector2):
	var did_shoot = await super.shoot(from_position, direction)
	if did_shoot and sprite and sprite.has_method("shoot_animation"):
		sprite.shoot_animation()
