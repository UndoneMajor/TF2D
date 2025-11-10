extends Area2D

var speed = 400
var direction = Vector2.RIGHT
var damage = 25
var shooter = null
var can_hit = false

func _ready():
	queue_redraw()
	body_entered.connect(_on_body_entered)
	
	# Wait a tiny bit before bullet can hit anything
	await get_tree().create_timer(0.05).timeout
	can_hit = true
	
	# Check if we're already overlapping something
	check_overlaps()

func _draw():
	draw_circle(Vector2.ZERO, 5, Color.YELLOW)

func _physics_process(delta):
	position += direction * speed * delta
	
	# Continuously check for overlaps
	if can_hit:
		check_overlaps()

func check_overlaps():
	var overlapping = get_overlapping_bodies()
	for body in overlapping:
		if body != shooter and body.has_method("take_damage"):
			# TF2 style - bullets pass through teammates
			if "team" in body and "team" in shooter:
				if body.team == shooter.team:
					continue  # Pass through teammates
			
			print("Hit detected: ", body.name)
			# Pass shooter as attacker
			if body.has_method("take_damage"):
				if body.get_method_argument_count("take_damage") > 1:
					body.take_damage(damage, shooter)
				else:
					body.take_damage(damage)
			queue_free()
			return

func _on_body_entered(body):
	if not can_hit:
		return
	
	if body == shooter:
		return
	
	# TF2 style - bullets pass through teammates
	if "team" in body and "team" in shooter:
		if body.team == shooter.team:
			return  # Pass through teammates
	
	print("Body entered - dealing damage to: ", body.name)
	if body.has_method("take_damage"):
		if body.get_method_argument_count("take_damage") > 1:
			body.take_damage(damage, shooter)
		else:
			body.take_damage(damage)
	queue_free()

func _on_timer_timeout():
	queue_free()
