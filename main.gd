extends Node2D

var team_selection_scene = preload("res://team_selection.tscn")
var class_selection_scene = preload("res://class_selection.tscn")
var player_scene = preload("res://player.tscn")
var bot_scene = preload("res://bot.tscn")
var player = null

# Team settings - 6v6 (Red vs Blue)
var max_team_size = 6
var spawn_radius = 400
var respawn_delay = 3.0

# Bot ID tracking - each bot gets a unique ID (0-5 for each team)
var red_bot_ids = []  # Available IDs: [0, 1, 2, 3, 4, 5]
var blue_bot_ids = []  # Available IDs: [0, 1, 2, 3, 4, 5]
var active_bots = {}  # Dictionary: bot_instance -> {team: int, id: int}

# Player team
var player_team = 0  # 0 = RED, 1 = BLUE

# M key detection
var m_key_was_pressed = false

func _ready():
	# Initialize bot ID pools (0-5 for each team)
	for i in range(max_team_size):
		red_bot_ids.append(i)
		blue_bot_ids.append(i)
	
	print("Bot ID pools initialized: RED=", red_bot_ids, " BLUE=", blue_bot_ids)
	
	# Remove the player from the scene - we'll spawn it after class selection
	var existing_player = $Player
	if existing_player:
		existing_player.queue_free()
		print("Removed existing player - will spawn after class selection")
	
	# Hide the enemy until class is selected
	var enemy = $Enemy
	if enemy:
		enemy.visible = false
		enemy.set_physics_process(false)
		enemy.set_process(false)
	
	# Show TEAM selection FIRST
	show_team_selection()

func _process(delta):
	# Check for M key when player is dead
	var m_pressed = Input.is_key_pressed(KEY_M)
	if m_pressed and not m_key_was_pressed:
		# Open class selection if player doesn't exist OR is invisible (dead)
		if not player or not is_instance_valid(player) or not player.visible:
			print("M pressed (player dead/invisible) - opening class selection!")
			show_class_selection_for_respawn()
	m_key_was_pressed = m_pressed

func show_team_selection():
	var team_menu = team_selection_scene.instantiate()
	team_menu.team_selected.connect(_on_team_selected)
	
	var canvas_layer = $CanvasLayer
	canvas_layer.add_child(team_menu)
	
	print("Team selection menu loaded!")

func _on_team_selected(team_id):
	player_team = team_id
	var team_name = "RED" if team_id == 0 else "BLUE"
	print("Player selected ", team_name, " team!")
	
	# Now show class selection
	show_class_selection()

func show_class_selection():
	var class_menu = class_selection_scene.instantiate()
	class_menu.class_selected.connect(_on_class_selected)
	
	# Add to the CanvasLayer so it shows on top
	var canvas_layer = $CanvasLayer
	canvas_layer.add_child(class_menu)
	
	print("Class selection menu loaded!")

func _on_class_selected(class_type):
	# Remove old player if exists (including dead spectating player)
	if player and is_instance_valid(player):
		player.queue_free()
	
	# Wait a frame for cleanup
	await get_tree().process_frame
	
	# Spawn new player
	player = player_scene.instantiate()
	add_child(player)
	
	# Set position based on team
	if player_team == 0:
		player.global_position = Vector2(200, 360)
	else:
		player.global_position = Vector2(1080, 360)
	
	player.set_class(class_type)
	player.team = player_team
	
	# Set color based on team
	if player_team == 0:
		player.class_color = Color(0.8, 0.2, 0.2)
	else:
		player.class_color = Color(0.2, 0.4, 0.9)
	
	# Reset ALL effects
	player.is_burning = false
	player.burn_timer = 0.0
	player.burn_tick_timer = 0.0
	player.knockback_velocity = Vector2.ZERO
	player.is_invisible = false
	player.is_disguised = false
	player.current_cloak = player.max_cloak
	
	player.queue_redraw()
	print("All effects reset on spawn")
	
	# Only spawn bots on first spawn
	var existing_bots = get_tree().get_nodes_in_group("bots")
	if existing_bots.size() == 0:
		for i in range(max_team_size):
			spawn_bot(0)
		for i in range(max_team_size):
			spawn_bot(1)
	
	# Show the enemy
	var enemy = $Enemy
	if enemy:
		enemy.visible = true
		enemy.set_physics_process(true)
		enemy.set_process(true)
		print("Enemy activated!")

func show_class_selection_for_respawn():
	show_class_selection()

func respawn_player():
	# Just show class selection
	show_class_selection()

func return_to_main_menu():
	print("Returning to main menu...")
	get_tree().change_scene_to_file("res://main_menu.tscn")

func spawn_bot(team_id):
	# Get available ID from the pool
	var bot_id = -1
	var id_pool = red_bot_ids if team_id == 0 else blue_bot_ids
	
	# Check if there's an available ID
	if id_pool.size() == 0:
		var team_name = "RED" if team_id == 0 else "BLUE"
		print(team_name, " team is FULL - no IDs available")
		return null
	
	# Take the first available ID
	bot_id = id_pool.pop_front()
	
	# Create bot
	var bot = bot_scene.instantiate()
	add_child(bot)
	
	# Set team
	bot.team = team_id
	
	# Spawn position based on team
	var spawn_pos = Vector2.ZERO
	if team_id == 0:  # RED team spawns on left
		spawn_pos = Vector2(200, 360) + Vector2(randf_range(-100, 100), randf_range(-200, 200))
	else:  # BLUE team spawns on right
		spawn_pos = Vector2(1080, 360) + Vector2(randf_range(-100, 100), randf_range(-200, 200))
	
	bot.global_position = spawn_pos
	
	# Store bot info
	active_bots[bot] = {"team": team_id, "id": bot_id}
	
	# Connect death signal
	bot.died.connect(_on_bot_died.bind(bot))
	
	var team_name = "RED" if team_id == 0 else "BLUE"
	print(team_name, " bot #", bot_id, " spawned. IDs left: ", id_pool.size())
	return bot

func _on_bot_died(bot):
	# Get bot info
	if not active_bots.has(bot):
		print("ERROR: Bot not found in active_bots!")
		return
	
	var bot_info = active_bots[bot]
	var team_id = bot_info["team"]
	var bot_id = bot_info["id"]
	var team_name = "RED" if team_id == 0 else "BLUE"
	
	print(team_name, " bot #", bot_id, " died!")
	
	# Remove from active bots
	active_bots.erase(bot)
	
	# Return ID to pool
	if team_id == 0:
		red_bot_ids.append(bot_id)
		print("Returned ID ", bot_id, " to RED pool. Available IDs: ", red_bot_ids)
	else:
		blue_bot_ids.append(bot_id)
		print("Returned ID ", bot_id, " to BLUE pool. Available IDs: ", blue_bot_ids)
	
	# Wait before respawning
	await get_tree().create_timer(respawn_delay).timeout
	
	# Respawn with a new ID from the pool
	print("Respawning ", team_name, " bot...")
	spawn_bot(team_id)
