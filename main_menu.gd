extends Control

func _ready():
	$PlayButton.pressed.connect(_on_play_pressed)
	$SettingsButton.pressed.connect(_on_settings_pressed)
	$QuitButton.pressed.connect(_on_quit_pressed)
	
	# Settings panel
	$SettingsPanel/CloseButton.pressed.connect(_on_close_settings)
	$SettingsPanel/VolumeSlider.value_changed.connect(_on_volume_changed)
	$SettingsPanel/FullscreenCheck.toggled.connect(_on_fullscreen_toggled)
	$SettingsPanel/HitboxCheck.toggled.connect(_on_hitbox_toggled)
	$SettingsPanel/FPSOption.item_selected.connect(_on_fps_selected)
	
	# Load saved settings
	load_settings()
	
	print("Main menu loaded!")

func _on_play_pressed():
	print("Starting game...")
	get_tree().change_scene_to_file("res://main.tscn")

func _on_settings_pressed():
	print("Settings opened!")
	$SettingsPanel.visible = true

func _on_close_settings():
	$SettingsPanel.visible = false

func _on_volume_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	print("Volume set to: ", int(value * 100), "%")

func _on_fullscreen_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		print("Fullscreen enabled (exclusive)")
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		# Set a reasonable window size
		DisplayServer.window_set_size(Vector2i(1280, 720))
		print("Windowed mode (1280x720)")
	save_setting("fullscreen", toggled_on)

func _on_hitbox_toggled(toggled_on):
	# Save to global settings singleton
	GameSettings.show_hitboxes = toggled_on
	save_setting("show_hitboxes", toggled_on)
	
	if toggled_on:
		get_tree().debug_collisions_hint = true
		print("Hitbox debug enabled - all debug visuals will show")
	else:
		get_tree().debug_collisions_hint = false
		print("Hitbox debug disabled - all debug visuals hidden")

func _on_fps_selected(index):
	var fps_values = [30, 60, 120, 144, 0]  # 0 = unlimited
	var fps = fps_values[index]
	
	Engine.max_fps = fps
	save_setting("max_fps", fps)
	
	if fps == 0:
		print("FPS set to: Unlimited")
	else:
		print("FPS set to: ", fps)

func save_setting(key, value):
	var config = ConfigFile.new()
	config.load("user://settings.cfg")
	config.set_value("game", key, value)
	config.save("user://settings.cfg")

func load_settings():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		# Load fullscreen
		if config.has_section_key("game", "fullscreen"):
			var fullscreen = config.get_value("game", "fullscreen")
			$SettingsPanel/FullscreenCheck.button_pressed = fullscreen
			_on_fullscreen_toggled(fullscreen)
		
		# Load hitboxes
		if config.has_section_key("game", "show_hitboxes"):
			var hitboxes = config.get_value("game", "show_hitboxes")
			$SettingsPanel/HitboxCheck.button_pressed = hitboxes
			_on_hitbox_toggled(hitboxes)
		
		# Load FPS
		if config.has_section_key("game", "max_fps"):
			var fps = config.get_value("game", "max_fps")
			var fps_values = [30, 60, 120, 144, 0]
			var index = fps_values.find(fps)
			if index >= 0:
				$SettingsPanel/FPSOption.selected = index
			Engine.max_fps = fps

func _on_quit_pressed():
	print("Quitting game...")
	get_tree().quit()

