extends "res://weapon.gd"

var sprite = null

func _ready():
	weapon_name = "Scattergun"
	damage = 25
	fire_rate = 0.5
	ammo_per_clip = 6
	max_ammo = 32
	current_clip = 6
	reserve_ammo = 32
	is_automatic = false
	bullet_speed = 750
	bullet_count = 4
	spread = 0.35
	recoil_amount = 20.0  # Medium recoil
	if ResourceLoader.exists("res://scattergun_sprite.tscn"):
		var sprite_scene = load("res://scattergun_sprite.tscn")
		sprite = sprite_scene.instantiate()
		add_child(sprite)

func shoot(from_position: Vector2, direction: Vector2):
	# Only animate if we actually shot
	var did_shoot = await super.shoot(from_position, direction)
	if did_shoot and sprite and sprite.has_method("shoot_animation"):
		sprite.shoot_animation()
