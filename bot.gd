extends CharacterBody2D

signal died

# Class stats
enum Class {SCOUT, SOLDIER, PYRO, HEAVY, SPY}
enum Team {RED, BLUE}

var current_class = Class.SOLDIER
var team = Team.RED
var base_class_color = Color.RED
var team_color = Color.RED

var speed = 300
var max_health = 200
var health = 200
var class_color = Color.RED

# Weapons
var primary_weapon = null
var secondary_weapon = null
var melee_weapon = null
var current_weapon = null

# Knockback system
var knockback_velocity = Vector2.ZERO
var knockback_decay = 0.9

# Afterburn system
var is_burning = false
var burn_damage = 4
var burn_duration = 3.0
var burn_timer = 0.0
var burn_tick_rate = 0.5
var burn_tick_timer = 0.0

# AI variables
var target = null
var ai_state = "PATROL"
var patrol_point = Vector2.ZERO
var decision_timer = 0.0
var decision_interval = 0.5
var shoot_timer = 0.0
var shoot_delay = 0.0

# Bot skill (makes them play like real players)
var aim_accuracy = 0.7  # How accurate they aim (0-1)
var reaction_time = 0.3  # How fast they react
var fire_rate_modifier = 1.5  # How often they shoot (higher = slower)

func _ready():
	# Random class using Time for better randomization
	var random_seed = Time.get_ticks_usec() + randi()
	seed(random_seed)
	var class_roll = randi() % 5  # 0, 1, 2, 3, or 4
	
	# Assign class based on roll
	match class_roll:
		0:
			current_class = Class.SCOUT
		1:
			current_class = Class.SOLDIER
		2:
			current_class = Class.PYRO
		3:
			current_class = Class.HEAVY
		4:
			current_class = Class.SPY
	
	var class_names = ["SCOUT", "SOLDIER", "PYRO", "HEAVY", "SPY"]
	print("🎲 Bot rolling class: ", class_roll, " = ", class_names[class_roll])
	
	# Add to bot group
	add_to_group("bots")
	
	# Randomize bot skill to make them more human-like
	aim_accuracy = randf_range(0.5, 0.8)  # Not perfect aim
	reaction_time = randf_range(0.2, 0.5)
	fire_rate_modifier = randf_range(1.2, 2.0)
	
	# Random patrol point
	patrol_point = global_position + Vector2(randf_range(-300, 300), randf_range(-300, 300))
	
	# Initialize class (color will be set later when team is assigned)
	initialize_class()
	
	# Wait one frame for team to be set by main.gd, then update color
	await get_tree().process_frame
	update_team_color()
	
	print("Bot created! Team: ", team, " Class: ", class_names[class_roll], " Accuracy: ", aim_accuracy)

func initialize_class():
	match current_class:
		Class.SCOUT:
			speed = 400
			max_health = 125
			health = 125
			create_weapons("scout")
			
		Class.SOLDIER:
			speed = 240
			max_health = 200
			health = 200
			create_weapons("soldier")
			
		Class.PYRO:
			speed = 300
			max_health = 175
			health = 175
			create_weapons("pyro")
			
		Class.HEAVY:
			speed = 180
			max_health = 300
			health = 300
			create_weapons("heavy")
			
		Class.SPY:
			speed = 320
			max_health = 125
			health = 125
			create_weapons("spy")
	
	# Color will be set by update_team_color() after team is assigned

func update_team_color():
	# Set color based on team
	if team == Team.RED:
		class_color = Color(0.8, 0.2, 0.2)  # RED
	else:  # BLUE
		class_color = Color(0.2, 0.4, 0.9)  # BLUE
	
	queue_redraw()
	var team_name = "RED" if team == Team.RED else "BLUE"
	print("Bot color updated: Team=", team_name, " Color=", class_color)

func create_weapons(class_type):
	match class_type:
		"scout":
			primary_weapon = load("res://scattergun.gd").new()
			secondary_weapon = load("res://pistol.gd").new()
			melee_weapon = load("res://bat.gd").new()
		"soldier":
			primary_weapon = load("res://rocket_launcher.gd").new()
			secondary_weapon = load("res://shotgun.gd").new()
			melee_weapon = load("res://shovel.gd").new()
		"pyro":
			primary_weapon = load("res://flamethrower.gd").new()
			secondary_weapon = load("res://shotgun.gd").new()
			melee_weapon = load("res://fire_axe.gd").new()
		"heavy":
			primary_weapon = load("res://minigun.gd").new()
			secondary_weapon = load("res://shotgun.gd").new()
			melee_weapon = load("res://fists.gd").new()
		"spy":
			primary_weapon = load("res://revolver.gd").new()
			secondary_weapon = load("res://pistol.gd").new()
			melee_weapon = load("res://knife.gd").new()
	
	if primary_weapon:
		add_child(primary_weapon)
		primary_weapon.owner_player = self
		primary_weapon.visible = true
	
	if secondary_weapon:
		add_child(secondary_weapon)
		secondary_weapon.owner_player = self
		secondary_weapon.visible = false
	
	if melee_weapon:
		add_child(melee_weapon)
		melee_weapon.owner_player = self
		melee_weapon.visible = false
	
	current_weapon = primary_weapon

func _draw():
	# Draw bot body
	draw_circle(Vector2.ZERO, 32, class_color)
	
	# Draw direction indicator
	draw_line(Vector2.ZERO, Vector2(40, 0), Color.WHITE, 3)
	
	# Bot antenna (yellow)
	draw_line(Vector2(0, -32), Vector2(0, -45), Color.YELLOW, 2)
	draw_circle(Vector2(0, -45), 5, Color.YELLOW)
	
	# Draw fire if burning
	if is_burning:
		var flame_alpha = 0.7 + sin(Time.get_ticks_msec() * 0.01) * 0.3
		for i in range(6):
			var angle = (TAU / 6.0) * i + Time.get_ticks_msec() * 0.003
			var offset = Vector2(cos(angle), sin(angle)) * 40
			var flame_size = randf_range(8, 14)
			draw_circle(offset, flame_size, Color(1, 0.5, 0, flame_alpha))
			draw_circle(offset, flame_size * 0.6, Color(1, 0.8, 0, flame_alpha))
	
	# Health bar
	var bar_width = 60
	var bar_height = 6
	var bar_offset = Vector2(-30, 40)
	
	draw_rect(Rect2(bar_offset, Vector2(bar_width, bar_height)), Color(0.2, 0.2, 0.2))
	
	var health_percent = float(health) / max_health
	var health_width = health_percent * bar_width
	var health_color = Color.GREEN
	if health_percent < 0.3:
		health_color = Color.RED
	elif health_percent < 0.6:
		health_color = Color.YELLOW
	
	draw_rect(Rect2(bar_offset, Vector2(health_width, bar_height)), health_color)
	draw_rect(Rect2(bar_offset, Vector2(bar_width, bar_height)), Color.WHITE, false, 1)

func _physics_process(delta):
	# Afterburn damage
	if is_burning:
		burn_timer += delta
		burn_tick_timer += delta
		
		if burn_tick_timer >= burn_tick_rate:
			burn_tick_timer = 0.0
			health -= burn_damage
			print("🔥 Bot burning! Health: ", health)
			
			if health <= 0:
				die()
		
		if burn_timer >= burn_duration:
			is_burning = false
			burn_timer = 0.0
			print("🔥 Bot afterburn expired")
		
		queue_redraw()
	
	decision_timer += delta
	shoot_timer += delta
	
	if decision_timer >= decision_interval:
		decision_timer = 0
		make_decision()
	
	match ai_state:
		"PATROL":
			ai_patrol(delta)
		"CHASE":
			ai_chase(delta)
		"ATTACK":
			ai_attack(delta)
	
	# Apply knockback if any
	if knockback_velocity.length() > 10:
		velocity += knockback_velocity
		knockback_velocity *= knockback_decay
	else:
		knockback_velocity = Vector2.ZERO
	
	move_and_slide()

func make_decision():
	# Find nearest ENEMY target (different team only!)
	var nearest_target = null
	var nearest_distance = 600.0  # Detection range
	
	# Check player
	var player = get_tree().get_first_node_in_group("player")
	if player and is_instance_valid(player):
		# Only target if player is on different team!
		if "team" in player and player.team != self.team:
			# Don't target invisible spies!
			if "is_invisible" in player and player.is_invisible:
				pass  # Can't see invisible spy
			# Don't target disguised spies! (they look like teammates)
			elif "is_disguised" in player and player.is_disguised:
				pass  # Can't see through disguise
			else:
				var dist = global_position.distance_to(player.global_position)
				if dist < nearest_distance:
					nearest_target = player
					nearest_distance = dist
	
	# Check other bots (only target enemy team!)
	var all_bots = get_tree().get_nodes_in_group("bots")
	for bot in all_bots:
		if bot != self and is_instance_valid(bot):
			# ONLY target bots on DIFFERENT team
			if bot.team != self.team:
				var dist = global_position.distance_to(bot.global_position)
				if dist < nearest_distance:
					nearest_target = bot
					nearest_distance = dist
	
	# Set target and state based on distance
	if nearest_target:
		target = nearest_target
		# Always attack from range, don't rush in
		if nearest_distance < 500:
			ai_state = "ATTACK"
		else:
			ai_state = "CHASE"
	else:
		target = null
		ai_state = "PATROL"

func ai_patrol(delta):
	var direction = (patrol_point - global_position).normalized()
	velocity = direction * speed * 0.5
	
	if direction.length() > 0:
		rotation = direction.angle()
	
	if global_position.distance_to(patrol_point) < 50:
		patrol_point = global_position + Vector2(randf_range(-400, 400), randf_range(-400, 400))

func ai_chase(delta):
	if not target or not is_instance_valid(target):
		ai_state = "PATROL"
		return
	
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * speed
	look_at(target.global_position)

func ai_attack(delta):
	if not target or not is_instance_valid(target):
		ai_state = "PATROL"
		return
	
	var distance = global_position.distance_to(target.global_position)
	
	# Aim with inaccuracy (like a real player)
	var aim_offset = Vector2(randf_range(-50, 50), randf_range(-50, 50)) * (1.0 - aim_accuracy)
	var aim_pos = target.global_position + aim_offset
	look_at(aim_pos)
	
	# Smart movement based on distance and class
	var to_target = (target.global_position - global_position).normalized()
	var strafe = Vector2(-to_target.y, to_target.x) * (1 if randf() > 0.5 else -1)
	
	# Keep optimal distance based on class
	var optimal_distance = 250  # Default
	var min_distance = 100  # Minimum safe distance
	
	match current_class:
		Class.SCOUT:
			optimal_distance = 180
			min_distance = 120
		Class.SOLDIER:
			optimal_distance = 350  # Stay far for rockets
			min_distance = 200
		Class.PYRO:
			optimal_distance = 160  # Close range for flames!
			min_distance = 100
		Class.HEAVY:
			optimal_distance = 220
			min_distance = 150
		Class.SPY:
			optimal_distance = 280
			min_distance = 180
	
	# SMART movement - maintain distance!
	if distance < min_distance:
		# DANGER! Too close - retreat fast!
		velocity = -to_target * speed * 1.2
	elif distance < optimal_distance * 0.8:
		# Too close - back away while strafing
		velocity = (-to_target * 0.8 + strafe * 0.2) * speed
	elif distance > optimal_distance * 1.5:
		# Too far - move closer while strafing
		velocity = (to_target * 0.5 + strafe * 0.5) * speed
	else:
		# Perfect distance - JUST STRAFE, don't move forward!
		velocity = strafe * speed * 0.7
	
	# Check if need to reload
	if current_weapon and "current_clip" in current_weapon:
		if current_weapon.current_clip <= 0:
			print("Bot reloading...")
			current_weapon.reload()
	
	# Shoot with delay (not every frame like before)
	if shoot_timer >= shoot_delay:
		shoot()
		
		# Automatic weapons (like flamethrower) - hold fire longer
		if current_weapon and "is_automatic" in current_weapon and current_weapon.is_automatic:
			shoot_delay = randf_range(0.05, 0.15)  # Very short delay for continuous fire
		else:
			shoot_delay = randf_range(0.3, 0.8) * fire_rate_modifier  # Normal delay
		
		shoot_timer = 0.0

func shoot():
	if current_weapon:
		# Check ammo before shooting
		if "current_clip" in current_weapon and current_weapon.current_clip <= 0:
			current_weapon.reload()
			return
		
		var shoot_pos = global_position + Vector2.RIGHT.rotated(rotation) * 40
		var shoot_dir = Vector2.RIGHT.rotated(rotation)
		current_weapon.shoot(shoot_pos, shoot_dir)

func take_damage(amount):
	health -= amount
	print("Bot hit! Health: ", health)
	queue_redraw()
	
	if health <= 0:
		die()

func die():
	print("Bot died!")
	emit_signal("died")
	queue_free()
