extends Area2D

var speed = 300
var direction = Vector2.RIGHT
var damage = 90
var explosion_radius = 150
var knockback_force = 400  # Knockback strength
var shooter = null
var lifetime = 1.3  # Explodes after 1.3 seconds
var time_alive = 0.0

func _ready():
	queue_redraw()
	body_entered.connect(_on_body_entered)
	
	# Add to rockets group for airblast deflection
	add_to_group("rockets")
	
	# Make rocket hitbox bigger
	var collision = get_node("CollisionShape2D")
	if collision and collision.shape:
		collision.shape.radius = 12.0  # Bigger hitbox

func _draw():
	# Draw rocket
	draw_circle(Vector2.ZERO, 8, Color.ORANGE)
	draw_circle(Vector2.ZERO, 4, Color.YELLOW)
	
	# Draw flame trail
	draw_line(Vector2.ZERO, Vector2(-15, 0).rotated(rotation), Color.ORANGE, 3)

func _physics_process(delta):
	time_alive += delta
	position += direction * speed * delta
	
	# Rotate to face direction
	rotation = direction.angle()
	
	# Explode after lifetime
	if time_alive >= lifetime:
		explode()

func _on_body_entered(body):
	if body == shooter:
		return
	
	# Check if it's a teammate (TF2 style - rockets pass through teammates)
	if "team" in body and "team" in shooter:
		if body.team == shooter.team:
			return  # Pass through teammates
	
	# Explode on contact with enemies
	explode()

func explode():
	print("💥 ROCKET EXPLODED at ", global_position)
	
	# Create explosion visual
	create_explosion_effect()
	
	# Deal area damage
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = explosion_radius
	query.shape = shape
	query.transform = Transform2D(0, global_position)
	
	var results = space_state.intersect_shape(query)
	
	for result in results:
		var body = result.collider
		if body.has_method("take_damage"):
			# Calculate damage falloff based on distance
			var distance = global_position.distance_to(body.global_position)
			var damage_multiplier = 1.0 - (distance / explosion_radius)
			damage_multiplier = clamp(damage_multiplier, 0.3, 1.0)  # Min 30% damage
			
			var final_damage = damage * damage_multiplier
			body.take_damage(final_damage)
			
			# Apply knockback (including to shooter for rocket jumping!)
			if body.has_method("set") and "velocity" in body:
				var knockback_dir = (body.global_position - global_position).normalized()
				var knockback_strength = knockback_force * damage_multiplier
				body.velocity += knockback_dir * knockback_strength
				print("Explosion hit ", body.name, " for ", int(final_damage), " damage + knockback!")
			else:
				print("Explosion hit ", body.name, " for ", int(final_damage), " damage (", int(damage_multiplier * 100), "%)")
	
	queue_free()

func create_explosion_effect():
	# Create visual explosion effect using a simple Node2D
	var explosion = ExplosionEffect.new()
	explosion.global_position = global_position
	explosion.max_radius = explosion_radius
	get_tree().root.add_child(explosion)

# Simple explosion effect class
class ExplosionEffect extends Node2D:
	var current_radius = 0.0
	var max_radius = 150.0
	var lifetime = 0.3
	var time = 0.0
	
	func _ready():
		queue_redraw()
	
	func _process(delta):
		time += delta
		current_radius = (time / lifetime) * max_radius
		queue_redraw()
		
		if time >= lifetime:
			queue_free()
	
	func _draw():
		# Draw expanding explosion circle
		var alpha = 1.0 - (time / lifetime)
		draw_circle(Vector2.ZERO, current_radius, Color(1, 0.5, 0, alpha * 0.5))
		draw_circle(Vector2.ZERO, current_radius * 0.7, Color(1, 0.8, 0, alpha * 0.7))
		draw_circle(Vector2.ZERO, current_radius * 0.4, Color(1, 1, 0.5, alpha))
