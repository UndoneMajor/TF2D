extends "res://weapon.gd"

var sprite = null

func _ready():
	weapon_name = "Revolver"
	damage = 40
	fire_rate = 0.5
	ammo_per_clip = 6
	max_ammo = 24
	current_clip = 6
	reserve_ammo = 24
	is_automatic = false
	bullet_speed = 2000
	bullet_count = 1
	spread = 0.02
	recoil_amount = 2.5
	
	if ResourceLoader.exists("res://revolver_sprite.tscn"):
		var sprite_scene = load("res://revolver_sprite.tscn")
		sprite = sprite_scene.instantiate()
		add_child(sprite)

func shoot(from_position: Vector2, direction: Vector2):
	var did_shoot = await super.shoot(from_position, direction)
	if did_shoot and sprite and sprite.has_method("shoot_animation"):
		sprite.shoot_animation()
