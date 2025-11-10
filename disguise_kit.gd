extends Node2D

var weapon_name = "Disguise Kit"
var current_clip = 999
var reserve_ammo = 999
var is_automatic = false

var owner_player = null
var sprite = null

var disguise_menu_scene = preload("res://disguise_menu.tscn")

func _ready():
	if ResourceLoader.exists("res://disguise_kit_sprite.tscn"):
		var sprite_scene = load("res://disguise_kit_sprite.tscn")
		sprite = sprite_scene.instantiate()
		add_child(sprite)

func shoot(from_position: Vector2, direction: Vector2):
	# Open disguise menu
	if owner_player and owner_player.has_method("open_disguise_menu"):
		owner_player.open_disguise_menu()
	return false

func reload():
	pass
