extends "res://weapon.gd"

var sprite = null

func _ready():
	weapon_name = "Minigun"
	damage = 9
	fire_rate = 0.1
	ammo_per_clip = 200
	max_ammo = 200
	current_clip = 200
	reserve_ammo = 0
	is_automatic = true
	bullet_speed = 800
	bullet_count = 1
	spread = 0.4
	recoil_amount= 3
	if ResourceLoader.exists("res://minigun_sprite.tscn"):
		var sprite_scene = load("res://minigun_sprite.tscn")
		sprite = sprite_scene.instantiate()
		add_child(sprite)

func shoot(from_position: Vector2, direction: Vector2):
	var did_shoot = await super.shoot(from_position, direction)
	if did_shoot and sprite and sprite.has_method("shoot_animation"):
		sprite.shoot_animation()
