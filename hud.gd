extends Control

func _ready():
	$ChangeClassButton.pressed.connect(_on_change_class_pressed)
	print("TF2-style HUD loaded!")

func _process(delta):
	var player = get_tree().get_first_node_in_group("player")
	
	if player and is_instance_valid(player):
		# Health
		$HealthLabel.text = str(int(player.health))
		
		# Color health based on amount
		if player.health < player.max_health * 0.3:
			$HealthLabel.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
		elif player.health < player.max_health * 0.6:
			$HealthLabel.add_theme_color_override("font_color", Color(1, 1, 0.3))
		else:
			$HealthLabel.add_theme_color_override("font_color", Color(1, 1, 1))
		
		# Ammo
		if player.current_weapon:
			var weapon = player.current_weapon
			if "current_clip" in weapon and "reserve_ammo" in weapon:
				if weapon.current_clip < 999:
					$AmmoClipLabel.text = str(weapon.current_clip)
					$AmmoReserveLabel.text = str(weapon.reserve_ammo)
					
					# Color ammo based on amount
					if weapon.current_clip == 0:
						$AmmoClipLabel.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
					elif weapon.current_clip < weapon.ammo_per_clip * 0.3:
						$AmmoClipLabel.add_theme_color_override("font_color", Color(1, 1, 0.3))
					else:
						$AmmoClipLabel.add_theme_color_override("font_color", Color(1, 1, 1))
				else:
					$AmmoClipLabel.text = ""
					$AmmoReserveLabel.text = ""
					$AmmoSeparator.text = ""
			
			# Weapon name
			if "weapon_name" in weapon:
				$WeaponNameLabel.text = weapon.weapon_name.to_upper()
		
		# Speed meter
		var current_speed = player.velocity.length()
		$SpeedLabel.text = "Speed: " + str(int(current_speed))
		
		# Class name
		var class_names = ["SCOUT", "SOLDIER", "PYRO", "HEAVY", "SPY"]
		if player.current_class < class_names.size():
			$ClassLabel.text = class_names[player.current_class]
			
			# Color based on class
			match player.current_class:
				0:  # Scout
					$ClassLabel.add_theme_color_override("font_color", Color(0.3, 0.7, 1))
				1:  # Soldier
					$ClassLabel.add_theme_color_override("font_color", Color(0.8, 0.2, 0.2))
				2:  # Pyro
					$ClassLabel.add_theme_color_override("font_color", Color(0.9, 0.4, 0.1))
				3:  # Heavy
					$ClassLabel.add_theme_color_override("font_color", Color(0.6, 0.1, 0.1))
				4:  # Spy
					$ClassLabel.add_theme_color_override("font_color", Color(0.2, 0.2, 0.2))
	else:
		$HealthLabel.text = "DEAD"
		$AmmoClipLabel.text = ""
		$AmmoReserveLabel.text = ""
		$SpeedLabel.text = "Speed: 0"

func _on_change_class_pressed():
	print("Menu button pressed - returning to main menu!")
	
	var main = get_tree().root.get_node_or_null("Main")
	
	if main and main.has_method("return_to_main_menu"):
		main.return_to_main_menu()
