extends "res://weapon.gd"

var sprite = null

func _ready():
	weapon_name = "Pistol"
	damage = 5.5
	fire_rate = 0.1
	ammo_per_clip = 12
	max_ammo = 36
	current_clip = 12
	reserve_ammo = 36
	is_automatic = false
	bullet_speed = 900
	bullet_count = 1
	spread = 0.05
	if ResourceLoader.exists("res://pistol_sprite.tscn"):
		var sprite_scene = load("res://pistol_sprite.tscn")
		sprite = sprite_scene.instantiate()
		add_child(sprite)

func shoot(from_position: Vector2, direction: Vector2):
	var did_shoot = await super.shoot(from_position, direction)
	if did_shoot and sprite and sprite.has_method("shoot_animation"):
		sprite.shoot_animation()
