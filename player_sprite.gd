extends AnimatedSprite2D

var current_team = 0  # 0 = RED, 1 = BLUE
var current_class = 1  # Default soldier

func _ready():
	# Setup sprite frames
	setup_animations()
	play("idle")
	
	# Make sprite bigger to match circle size (64x64 to match 32 radius circle)
	scale = Vector2(2.0, 2.0)
	
	# Offset rotation so sprite faces right when rotation = 0
	# (sprite looks up by default, so rotate 90 degrees)
	rotation_degrees = 90

func setup_animations():
	# Create sprite frames
	var frames = SpriteFrames.new()
	
	# Walking animation
	frames.add_animation("walk")
	frames.set_animation_speed("walk", 5.0)
	frames.set_animation_loop("walk", true)
	
	# Punch animations (for heavy)
	frames.add_animation("punch_left")
	frames.set_animation_speed("punch_left", 10.0)
	frames.set_animation_loop("punch_left", false)
	
	frames.add_animation("punch_right")
	frames.set_animation_speed("punch_right", 10.0)
	frames.set_animation_loop("punch_right", false)
	
	sprite_frames = frames

func load_class_sprite(class_type, team):
	current_class = class_type
	current_team = team
	
	# Clear existing frames
	sprite_frames.clear("walk")
	sprite_frames.clear("punch_left")
	sprite_frames.clear("punch_right")
	
	# Determine team prefix
	var team_prefix = "red_" if team == 0 else "blue_"
	
	match class_type:
		0:  # Scout
			load_frames(team_prefix + "scout", 6)
			
		1:  # Soldier
			load_frames(team_prefix + "soldier", 6)
			
		2:  # Pyro
			load_frames(team_prefix + "pyro", 6)
			
		3:  # Heavy
			# Walking: 1, 2, 5, 6 (skip 3 and 4 for punching)
			for i in [1, 2, 5, 6]:
				var path = "res://" + team_prefix + "heavy" + str(i) + ".png"
				if ResourceLoader.exists(path):
					sprite_frames.add_frame("walk", load(path))
			
			# Punch animations
			if ResourceLoader.exists("res://" + team_prefix + "heavy3.png"):
				sprite_frames.add_frame("punch_left", load("res://" + team_prefix + "heavy3.png"))
			if ResourceLoader.exists("res://" + team_prefix + "heavy4.png"):
				sprite_frames.add_frame("punch_right", load("res://" + team_prefix + "heavy4.png"))
			
			play("walk")
			print("✅ Heavy loaded!")
			
		4:  # Spy
			load_frames(team_prefix + "spy", 6)
		_:
			print("Class ", class_type, " has no sprite yet")

func load_frames(prefix, count):
	# Try to load with prefix (e.g., red_scout1.png)
	var loaded = false
	for i in range(1, count + 1):
		var path = "res://" + prefix + str(i) + ".png"
		if ResourceLoader.exists(path):
			sprite_frames.add_frame("walk", load(path))
			loaded = true
	
	# If no sprites found, try blue as fallback
	if not loaded and not prefix.begins_with("blue_"):
		var fallback_class = prefix.replace("red_", "")
		print("⚠️ No ", prefix, " sprites found, using blue_", fallback_class, " as fallback")
		for i in range(1, count + 1):
			var fallback_path = "res://blue_" + fallback_class + str(i) + ".png"
			if ResourceLoader.exists(fallback_path):
				sprite_frames.add_frame("walk", load(fallback_path))
	
	if sprite_frames.get_frame_count("walk") > 0:
		play("walk")
		print("✅ Loaded ", prefix, " with ", sprite_frames.get_frame_count("walk"), " frames!")

func play_punch_animation():
	if current_class == 3:  # Heavy only
		# Alternate between left and right punch
		if randi() % 2 == 0:
			play("punch_left")
		else:
			play("punch_right")
		
		# Return to walking after punch
		await animation_finished
		play("walk")
