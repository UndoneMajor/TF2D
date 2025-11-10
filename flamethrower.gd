extends Node2D

# Weapon stats
var weapon_name = "Flamethrower"
var damage = 8  # Damage per flame particle per tick
var fire_rate = 0.05  # Very fast fire rate
var ammo_per_clip = 200
var max_ammo = 200
var current_clip = 200
var reserve_ammo = 200
var is_automatic = true
var recoil_amount = 1.0

var can_shoot = true
var owner_player = null
var sprite = null

# Airblast
var can_airblast = true
var airblast_cooldown = 0.75
var airblast_force = 600
var airblast_range = 100

# Flame particles
var flame_particle_scene = preload("res://flame_particle.tscn")

# Debug
var show_airblast_range = false

func _ready():
	if ResourceLoader.exists("res://flamethrower_sprite.tscn"):
		var sprite_scene = load("res://flamethrower_sprite.tscn")
		sprite = sprite_scene.instantiate()
		add_child(sprite)

func _draw():
	if show_airblast_range and GameSettings.show_hitboxes:
		# Draw airblast cone
		draw_circle(Vector2(airblast_range * 0.5, 0), airblast_range, Color(0, 1, 1, 0.3))
		draw_arc(Vector2(airblast_range * 0.5, 0), airblast_range, 0, TAU, 32, Color.CYAN, 2)

func shoot(from_position: Vector2, direction: Vector2):
	if not can_shoot or current_clip <= 0:
		return false
	
	can_shoot = false
	
	# Consume ammo slower (1 ammo per 5 shots instead of every shot)
	if randi() % 5 == 0:
		current_clip -= 1
	
	# Spawn multiple flame particles in a triangle/cone pattern
	var num_particles = 8  # Spawn 8 particles per shot
	var max_spread = 1  # Wide spread (triangle shape)
	
	for i in range(num_particles):
		var flame = flame_particle_scene.instantiate()
		flame.position = from_position
		flame.damage = damage
		flame.shooter = owner_player
		
		# Create triangle spread pattern
		var spread_angle = randf_range(-max_spread, max_spread)
		flame.direction = direction.rotated(spread_angle)
		
		# Vary speed slightly for more natural spread
		flame.speed = randf_range(500, 650)
		
		get_tree().root.add_child(flame)
	
	# Fast fire rate
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
	
	return true

func airblast(from_position: Vector2, direction: Vector2):
	if not can_airblast:
		print("🌪️ Airblast on cooldown!")
		return false
	
	# Check ammo
	if current_clip < 30:
		print("🌪️ Not enough ammo for airblast! Need 30, have ", current_clip)
		return false
	
	can_airblast = false
	current_clip -= 30  # Cost 30 ammo
	print("🌪️ AIRBLAST at ", from_position, " (-30 ammo)")
	
	# Show debug visual
	show_airblast_range = true
	queue_redraw()
	
	var pushed_count = 0
	var deflected_count = 0
	
	# Extinguish yourself if burning! (TF2 style)
	if owner_player and "is_burning" in owner_player and owner_player.is_burning:
		owner_player.is_burning = false
		owner_player.burn_timer = 0.0
		owner_player.burn_tick_timer = 0.0
		owner_player.queue_redraw()
		print("💧🔥 Extinguished yourself! Fire is out!")
	
	# Check for rockets to deflect
	var all_rockets = get_tree().get_nodes_in_group("rockets")
	print("Checking ", all_rockets.size(), " rockets for deflection...")
	for rocket in all_rockets:
		if is_instance_valid(rocket):
			var dist = from_position.distance_to(rocket.global_position)
			print("  Rocket distance: ", dist)
			if dist < airblast_range * 1.5:
				# Deflect rocket!
				var reflect_dir = (rocket.global_position - from_position).normalized()
				rocket.direction = reflect_dir
				rocket.shooter = owner_player  # Now it's YOUR rocket!
				deflected_count += 1
				print("🌪️💥 ROCKET DEFLECTED!")
	
	# Push all nearby players and bots
	var all_entities = []
	all_entities.append_array(get_tree().get_nodes_in_group("player"))
	all_entities.append_array(get_tree().get_nodes_in_group("bots"))
	
	print("Checking ", all_entities.size(), " entities for push...")
	for entity in all_entities:
		if entity != owner_player and is_instance_valid(entity):
			var dist = from_position.distance_to(entity.global_position)
			print("  Entity ", entity.name, " distance: ", dist)
			if dist < airblast_range * 2.0:  # Increased range
				# Check if entity is in front of us (cone check)
				var to_entity = (entity.global_position - from_position).normalized()
				var dot = direction.dot(to_entity)
				
				if dot > 0.3:  # In front cone
					# Check if it's a teammate
					var is_teammate = false
					if "team" in entity and "team" in owner_player:
						is_teammate = (entity.team == owner_player.team)
					
					if is_teammate:
						# Extinguish burning teammates (TF2 style!)
						if "is_burning" in entity and entity.is_burning:
							entity.is_burning = false
							entity.burn_timer = 0.0
							entity.queue_redraw()
							print("💧 Extinguished burning teammate ", entity.name, "!")
						else:
							print("💨 Airblasted teammate (not burning)")
					else:
						# Push enemies
						if "velocity" in entity:
							var knockback_dir = (entity.global_position - from_position).normalized()
							if "knockback_velocity" in entity:
								entity.knockback_velocity = knockback_dir * airblast_force * 1.5
								print("🌪️💥 AIRBLASTED ", entity.name, " - FLYING BACK!")
							else:
								entity.velocity = knockback_dir * airblast_force * 1.5
								print("🌪️ Airblasted ", entity.name, " - PUSHED!")
							pushed_count += 1
				else:
					print("  Entity not in cone (dot: ", dot, ")")
	
	print("Airblast results: ", pushed_count, " pushed, ", deflected_count, " rockets deflected")
	
	# Hide debug visual
	await get_tree().create_timer(0.2).timeout
	show_airblast_range = false
	queue_redraw()
	
	# Cooldown
	await get_tree().create_timer(airblast_cooldown - 0.2).timeout
	can_airblast = true
	print("🌪️ Airblast ready!")
	
	return true

func reload():
	if reserve_ammo <= 0 or current_clip == ammo_per_clip:
		return
	
	var ammo_needed = ammo_per_clip - current_clip
	var ammo_to_reload = min(ammo_needed, reserve_ammo)
	
	current_clip += ammo_to_reload
	reserve_ammo -= ammo_to_reload
	
	print("Reloaded! Clip: ", current_clip, " Reserve: ", reserve_ammo)
