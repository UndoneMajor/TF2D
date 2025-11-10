extends CharacterBody2D

var health = 200
var bullet_scene = preload("res://bullet.tscn")
var can_shoot = true
var fire_rate = 1.0
var shoot_direction = Vector2.LEFT

var is_sapped = false
var sapper_damage_rate = 20  # Damage per second

func _ready():
	queue_redraw()
	rotation = PI
	start_shooting()

func _process(delta):
	if is_sapped:
		# Take damage over time from sapper
		health -= sapper_damage_rate * delta
		if health <= 0:
			queue_free()

func _draw():
	if is_sapped:
		draw_circle(Vector2.ZERO, 32, Color.PURPLE)  # Purple when sapped
		draw_arc(Vector2.ZERO, 35, 0, TAU, 32, Color.YELLOW, 3)
	else:
		draw_circle(Vector2.ZERO, 32, Color.BLUE)
	
	draw_line(Vector2.ZERO, Vector2(40, 0), Color.WHITE, 3)

func start_shooting():
	while true:
		if can_shoot and not is_sapped:  # Can't shoot when sapped
			shoot()
		await get_tree().create_timer(fire_rate).timeout

func shoot():
	can_shoot = false
	
	var bullet = bullet_scene.instantiate()
	bullet.position = global_position + Vector2.RIGHT.rotated(rotation) * 40
	bullet.direction = Vector2.RIGHT.rotated(rotation)
	bullet.shooter = self
	get_parent().add_child(bullet)
	
	can_shoot = true

func take_damage(amount):
	health -= amount
	print("Enemy hit! Health: ", health)
	if health <= 0:
		queue_free()

func apply_sapper():
	is_sapped = true
	print("⚡ Enemy is SAPPED! Taking damage over time...")
	queue_redraw()
