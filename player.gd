extends CharacterBody2D

signal died

# Class stats
enum Class {SCOUT, SOLDIER, PYRO, HEAVY, SPY}
var current_class = Class.SOLDIER

var speed = 300
var max_health = 200
var health = 200
var class_color = Color.RED

# Team (set by main.gd)
var team = 0  # 0 = RED, 1 = BLUE

# Weapons
var primary_weapon = null
var secondary_weapon = null
var melee_weapon = null
var utility_weapon = null
var current_weapon = null

var can_shoot = true

# Death tracking
var last_attacker = null
var death_screen_scene = preload("res://death_screen.tscn")

# Knockback system
var knockback_velocity = Vector2.ZERO
var knockback_decay = 0.9  # How fast knockback fades

# Afterburn system
var is_burning = false
var burn_damage = 4  # Damage per tick
var burn_duration = 3.0  # Burns for 3 seconds
var burn_timer = 0.0
var burn_tick_rate = 0.5  # Damage every 0.5 seconds
var burn_tick_timer = 0.0

# Camera shake
var camera = null
var shake_amount = 0.0

# Spy cloak system
var is_invisible = false
var max_cloak = 100.0
var current_cloak = 100.0
var cloak_drain_rate = 12.5
var cloak_recharge_rate = 33.3
var can_toggle_cloak = true
var decloak_cooldown = 1.5
var right_click_was_pressed = false

# Class change key
var m_key_was_pressed = false

# Disguise system
var is_disguised = false
var disguise_class = 0
var disguise_color = Color.BLACK
var original_color = Color.BLACK
var disguise_menu_scene = preload("res://disguise_menu.tscn")
var active_disguise_menu = null

func _ready():
	set_class(current_class)
	queue_redraw()
	
	camera = get_node_or_null("Camera2D")

func _process(delta):
	# Spectator camera - follow killer if dead
	if not visible and last_attacker and is_instance_valid(last_attacker):
		if camera:
			camera.global_position = last_attacker.global_position
	
	# Afterburn damage over time
	if is_burning:
		burn_timer += delta
		burn_tick_timer += delta
		
		# Deal damage every tick
		if burn_tick_timer >= burn_tick_rate:
			burn_tick_timer = 0.0
			health -= burn_damage
			print("🔥 Burning! Health: ", health)
			
			if health <= 0:
				die()
		
		# Stop burning after duration
		if burn_timer >= burn_duration:
			is_burning = false
			burn_timer = 0.0
			print("🔥 Afterburn expired")
		
		queue_redraw()
	
	# Camera shake
	if camera and shake_amount > 0:
		camera.offset = Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)
		shake_amount = lerp(shake_amount, 0.0, delta * 10)
	elif camera:
		camera.offset = Vector2.ZERO
	
	# Cloak meter management - ALWAYS runs
	if current_class == Class.SPY:
		if is_invisible:
			# Drain cloak while invisible
			current_cloak -= cloak_drain_rate * delta
			
			if current_cloak <= 0:
				current_cloak = 0
				force_decloak()
			
			queue_redraw()
		else:
			# Recharge cloak while visible
			if current_cloak < max_cloak:
				current_cloak += cloak_recharge_rate * delta
				if current_cloak > max_cloak:
					current_cloak = max_cloak
				
				queue_redraw()

func add_camera_shake(amount: float):
	shake_amount += amount

func set_class(class_type):
	current_class = class_type
	
	if primary_weapon:
		primary_weapon.queue_free()
	if secondary_weapon:
		secondary_weapon.queue_free()
	if melee_weapon:
		melee_weapon.queue_free()
	if utility_weapon:
		utility_weapon.queue_free()
	
	match class_type:
		Class.SCOUT:
			speed = 400
			max_health = 125
			health = 125
			# Don't set class_color here - it's set by team in main.gd
			
			primary_weapon = load("res://scattergun.gd").new()
			secondary_weapon = load("res://pistol.gd").new()
			melee_weapon = load("res://bat.gd").new()
			
		Class.SOLDIER:
			speed = 240
			max_health = 200
			health = 200
			# Don't set class_color here - it's set by team in main.gd
			
			primary_weapon = load("res://rocket_launcher.gd").new()
			secondary_weapon = load("res://shotgun.gd").new()
			melee_weapon = load("res://shovel.gd").new()
			
		Class.PYRO:
			speed = 300
			max_health = 175
			health = 175
			# Don't set class_color here - it's set by team in main.gd
			
			primary_weapon = load("res://flamethrower.gd").new()
			secondary_weapon = load("res://shotgun.gd").new()
			melee_weapon = load("res://fire_axe.gd").new()
			
		Class.HEAVY:
			speed = 180
			max_health = 300
			health = 300
			# Don't set class_color here - it's set by team in main.gd
			
			primary_weapon = load("res://minigun.gd").new()
			secondary_weapon = load("res://shotgun.gd").new()
			melee_weapon = load("res://fists.gd").new()
			
		Class.SPY:
			speed = 320
			max_health = 125
			health = 125
			# Don't set class_color here - it's set by team in main.gd
			original_color = class_color
			
			primary_weapon = load("res://revolver.gd").new()
			secondary_weapon = load("res://sapper.gd").new()
			melee_weapon = load("res://knife.gd").new()
			utility_weapon = load("res://disguise_kit.gd").new()
	
	add_child(primary_weapon)
	add_child(secondary_weapon)
	add_child(melee_weapon)
	
	primary_weapon.owner_player = self
	secondary_weapon.owner_player = self
	melee_weapon.owner_player = self
	
	# Position weapons in front of player (in hand)
	primary_weapon.position = Vector2(35, 0)
	secondary_weapon.position = Vector2(35, 0)
	melee_weapon.position = Vector2(35, 0)
	
	if utility_weapon:
		add_child(utility_weapon)
		utility_weapon.owner_player = self
		utility_weapon.visible = false
	
	current_weapon = primary_weapon
	primary_weapon.visible = true
	secondary_weapon.visible = false
	melee_weapon.visible = false
	
	# DON'T load sprite here - it will be loaded after team is set in main.gd
	
	queue_redraw()

func _draw():
	# Don't draw circle anymore - using sprite instead
	
	# Draw fire if burning
	if is_burning:
		var flame_alpha = 0.7 + sin(Time.get_ticks_msec() * 0.01) * 0.3
		# Draw flames around the player
		for i in range(6):
			var angle = (TAU / 6.0) * i + Time.get_ticks_msec() * 0.003
			var offset = Vector2(cos(angle), sin(angle)) * 40
			var flame_size = randf_range(8, 14)
			draw_circle(offset, flame_size, Color(1, 0.5, 0, flame_alpha))
			draw_circle(offset, flame_size * 0.6, Color(1, 0.8, 0, flame_alpha))
	
	if is_disguised and not is_invisible:
		draw_arc(Vector2.ZERO, 38, 0, TAU, 32, Color.YELLOW, 2)
		draw_string(ThemeDB.fallback_font, Vector2(-30, -45), "DISGUISED", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color.YELLOW)
	
	if current_class == Class.SPY:
		var bar_width = 60
		var bar_height = 8
		var bar_offset = Vector2(-30, 45)
		
		draw_rect(Rect2(bar_offset, Vector2(bar_width, bar_height)), Color(0.2, 0.2, 0.2))
		
		var cloak_width = (current_cloak / max_cloak) * bar_width
		var cloak_color = Color.CYAN if current_cloak > 25 else Color.RED
		draw_rect(Rect2(bar_offset, Vector2(cloak_width, bar_height)), cloak_color)
		
		draw_rect(Rect2(bar_offset, Vector2(bar_width, bar_height)), Color.WHITE, false, 1)
		
		var cloak_percent = int((current_cloak / max_cloak) * 100)
		draw_string(ThemeDB.fallback_font, bar_offset + Vector2(bar_width + 5, 6), str(cloak_percent) + "%", HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color.WHITE)

func open_disguise_menu():
	if active_disguise_menu:
		return
	
	active_disguise_menu = disguise_menu_scene.instantiate()
	active_disguise_menu.disguise_selected.connect(_on_disguise_selected)
	
	# Add to the Main scene's CanvasLayer so it stays on screen
	var main = get_tree().root.get_node("Main")
	if main:
		var canvas_layer = main.get_node("CanvasLayer")
		if canvas_layer:
			canvas_layer.add_child(active_disguise_menu)
			print("Disguise menu added to CanvasLayer!")
		else:
			print("ERROR: CanvasLayer not found!")
	else:
		print("ERROR: Main node not found!")
	
	# Don't pause - player can still move!

func _on_disguise_selected(class_type: int):
	active_disguise_menu = null
	
	if class_type == -1:
		is_disguised = false
		class_color = original_color
		# Restore spy's original speed
		if current_class == Class.SPY:
			speed = 320
		print("🎭 Disguise removed! Speed restored to: ", speed)
	else:
		is_disguised = true
		disguise_class = class_type
		apply_disguise()
	
	queue_redraw()

func apply_disguise():
	match disguise_class:
		0:  # SCOUT
			disguise_color = Color(0.3, 0.7, 1.0)
			class_color = disguise_color
			speed = 400  # Scout speed
			print("🎭 Disguised as SCOUT! Speed: 400")
		1:  # SOLDIER
			disguise_color = Color(0.8, 0.2, 0.2)
			class_color = disguise_color
			speed = 240  # Soldier speed
			print("🎭 Disguised as SOLDIER! Speed: 240")
		2:  # HEAVY
			disguise_color = Color(0.6, 0.1, 0.1)
			class_color = disguise_color
			speed = 180  # Heavy speed (SLOW!)
			print("🎭 Disguised as HEAVY! Speed: 180")
		3:  # SPY
			disguise_color = Color(0.2, 0.2, 0.2)
			class_color = disguise_color
			speed = 320  # Spy speed
			print("🎭 Disguised as SPY! Speed: 320")
	
	queue_redraw()

func _physics_process(delta):
	# Check for M key to change class (single press detection)
	var m_pressed = Input.is_key_pressed(KEY_M)
	if m_pressed and not m_key_was_pressed:
		print("M pressed - opening class selection!")
		var main = get_tree().root.get_node_or_null("Main")
		if main and main.has_method("show_class_selection_for_respawn"):
			main.show_class_selection_for_respawn()
	m_key_was_pressed = m_pressed
	
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	
	# Right click abilities
	var right_click_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
	
	# Spy cloak toggle
	if current_class == Class.SPY:
		# Detect button press (not hold)
		if right_click_pressed and not right_click_was_pressed:
			toggle_cloak()
	
	# Pyro airblast
	elif current_class == Class.PYRO:
		if right_click_pressed and not right_click_was_pressed:
			if current_weapon and current_weapon.has_method("airblast"):
				var airblast_pos = global_position + Vector2.RIGHT.rotated(rotation) * 40
				var airblast_dir = Vector2.RIGHT.rotated(rotation)
				current_weapon.airblast(airblast_pos, airblast_dir)
	
	right_click_was_pressed = right_click_pressed
	
	# Weapon switching
	if Input.is_key_pressed(KEY_1):
		if current_weapon != primary_weapon:
			switch_weapon(primary_weapon)
			
	elif Input.is_key_pressed(KEY_2):
		if current_weapon != secondary_weapon:
			switch_weapon(secondary_weapon)
			
	elif Input.is_key_pressed(KEY_3):
		if current_weapon != melee_weapon:
			switch_weapon(melee_weapon)
	
	elif Input.is_key_pressed(KEY_4):
		if utility_weapon and current_weapon != utility_weapon:
			switch_weapon(utility_weapon)
	
	# Reload
	if Input.is_key_pressed(KEY_R):
		current_weapon.reload()
	
	# Shooting - disabled when cloaked
	if not is_invisible:
		if current_weapon and current_weapon.is_automatic:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				shoot()
		else:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
				shoot()
				can_shoot = false
				await get_tree().create_timer(0.2).timeout
				can_shoot = true
	
	# Movement
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		direction.x += 1
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		direction.x -= 1
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		direction.y += 1
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		direction.y -= 1
	
	if direction.length() > 0:
		direction = direction.normalized()
	
	# Apply knockback if any
	if knockback_velocity.length() > 10:
		velocity = direction * speed + knockback_velocity
		knockback_velocity *= knockback_decay  # Decay over time
	else:
		knockback_velocity = Vector2.ZERO
		velocity = direction * speed
	
	move_and_slide()
	
	# Update sprite animation based on movement
	var sprite = get_node_or_null("AnimatedSprite2D")
	if sprite:
		if velocity.length() > 10:
			if sprite.animation != "walk":
				sprite.play("walk")  # Play walking animation
		else:
			sprite.stop()
			if current_class == 0:  # Scout
				sprite.frame = 4  # Show scout5 when idle
			elif current_class == 1:  # Soldier
				sprite.frame = 4  # Show soldier5 when idle
			elif current_class == 2:  # Pyro
				sprite.frame = 4  # Show pyro5 when idle
			elif current_class == 3:  # Heavy
				sprite.frame = 0  # Show heavy1 when idle
			elif current_class == 4:  # Spy
				sprite.frame = 4  # Show spy5 when idle

func switch_weapon(new_weapon):
	if current_weapon:
		current_weapon.visible = false
	5
	current_weapon = new_weapon
	
	if not is_invisible:
		current_weapon.visible = true
	
	print("Switched to: ", current_weapon.weapon_name)

func toggle_cloak():
	if not can_toggle_cloak:
		print("🕵️ Cloak on cooldown!")
		return
	
	if is_invisible:
		decloak()
	else:
		if current_cloak >= 10:
			cloak()
		else:
			print("🕵️ Not enough cloak! Need 10%, have ", int(current_cloak), "%")

func cloak():
	is_invisible = true
	can_toggle_cloak = true
	print("🕵️ CLOAKED! (", int(current_cloak), "% remaining)")
	
	if current_weapon:
		current_weapon.visible = false
	
	queue_redraw()

func decloak():
	is_invisible = false
	can_toggle_cloak = false
	print("🕵️ UNCLOAKED!")
	
	if current_weapon:
		current_weapon.visible = true
	
	if is_disguised:
		class_color = disguise_color
	
	queue_redraw()
	
	await get_tree().create_timer(decloak_cooldown).timeout
	can_toggle_cloak = true
	print("🕵️ Cloak ready!")

func force_decloak():
	is_invisible = false
	can_toggle_cloak = false
	print("🕵️ CLOAK DEPLETED!")
	
	if current_weapon:
		current_weapon.visible = true
	
	if is_disguised:
		class_color = disguise_color
	
	queue_redraw()
	
	await get_tree().create_timer(decloak_cooldown).timeout
	can_toggle_cloak = true

func shoot():
	if is_disguised:
		is_disguised = false
		class_color = original_color
		# Restore spy speed
		if current_class == Class.SPY:
			speed = 320
		print("🎭 Disguise broken by attacking! Speed restored.")
		queue_redraw()
	
	if current_weapon:
		# Adjust weapon position to be in front (in scout's hand)
		var weapon_offset = 50  # Further forward to match hand position
		var shoot_pos = global_position + Vector2.RIGHT.rotated(rotation) * weapon_offset
		var shoot_dir = Vector2.RIGHT.rotated(rotation)
		current_weapon.shoot(shoot_pos, shoot_dir)

func take_damage(amount, attacker = null):
	health -= amount
	print("Player health: ", health)
	
	# Track who hit us
	if attacker:
		last_attacker = attacker
	
	add_camera_shake(5.0)
	
	if is_invisible:
		force_decloak()
	
	if is_disguised:
		is_disguised = false
		class_color = original_color
		# Restore spy speed
		if current_class == Class.SPY:
			speed = 320
		print("🎭 Disguise broken by damage! Speed restored.")
		queue_redraw()
	
	if health <= 0:
		die()

func die():
	print("Player died!")
	
	# Remove from player group so bots don't target the camera
	remove_from_group("player")
	
	# Disable collision
	$CollisionShape2D.disabled = true
	
	# Start spectating killer
	if last_attacker and is_instance_valid(last_attacker):
		start_spectating(last_attacker)
	
	emit_signal("died")
	
	# Hide player but DON'T delete yet
	visible = false
	set_physics_process(false)
	# Keep _process running for spectator camera

func start_spectating(target):
	print("Spectating: ", target.name)
	# Camera will follow the target in _process
