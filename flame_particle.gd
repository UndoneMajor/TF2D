extends Area2D

var speed = 250
var direction = Vector2.RIGHT
var damage = 8
var shooter = null
var lifetime = 0.5  # Stays in air for 0.5 seconds
var time_alive = 0.0

# Damage over time
var damage_interval = 0.1
var damage_timer = 0.0
var damaged_bodies = []  # Track who we've damaged recently

func _ready():
	queue_redraw()
	
	# Start bigger
	scale = Vector2(1.5, 1.5)
	
	# Make hitbox bigger
	var collision = get_node("CollisionShape2D")
	if collision and collision.shape:
		collision.shape.radius = 18.0

func _draw():
	# Draw bigger flame particle with visual hitbox
	var alpha = 1.0 - (time_alive / lifetime)
	
	# Outer glow (hitbox indicator)
	draw_circle(Vector2.ZERO, 18, Color(1, 0.3, 0, alpha * 0.4))
	
	# Main flame
	draw_circle(Vector2.ZERO, 14, Color(1, 0.5, 0, alpha * 0.7))
	draw_circle(Vector2.ZERO, 10, Color(1, 0.8, 0, alpha * 0.9))
	draw_circle(Vector2.ZERO, 6, Color(1, 1, 0.5, alpha))

func _physics_process(delta):
	time_alive += delta
	damage_timer += delta
	
	# Move forward
	position += direction * speed * delta
	
	# Slow down over time
	speed = lerpf(speed, 50.0, delta * 2.0)
	
	# Shrink over time
	var size = 1.0 - (time_alive / lifetime) * 0.5
	scale = Vector2(size, size)
	
	# Damage entities in the flame
	if damage_timer >= damage_interval:
		damage_timer = 0.0
		check_damage()
	
	queue_redraw()
	
	# Die after lifetime
	if time_alive >= lifetime:
		queue_free()

func check_damage():
	var overlapping = get_overlapping_bodies()
	for body in overlapping:
		if body == shooter:
			continue
		
		# TF2 style - flames pass through teammates
		if "team" in body and "team" in shooter:
			if body.team == shooter.team:
				continue
		
		if body.has_method("take_damage"):
			body.take_damage(damage)
			
			# Apply afterburn effect
			if "is_burning" in body:
				body.is_burning = true
				body.burn_timer = 0.0
				body.burn_tick_timer = 0.0
			
			print("🔥 Flame burning ", body.name, " - AFTERBURN APPLIED!")
