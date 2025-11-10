extends Control

signal disguise_selected(class_type)

func _ready():
	# Allow this menu to process even when game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Connect all buttons
	$ScoutButton.pressed.connect(_on_scout_pressed)
	$SoldierButton.pressed.connect(_on_soldier_pressed)
	$HeavyButton.pressed.connect(_on_heavy_pressed)
	$SpyButton.pressed.connect(_on_spy_pressed)
	$RemoveButton.pressed.connect(_on_remove_pressed)
	
	print("Disguise menu loaded with 4 classes + remove option")

func _on_scout_pressed():
	emit_signal("disguise_selected", 0)  # Scout
	queue_free()

func _on_soldier_pressed():
	emit_signal("disguise_selected", 1)  # Soldier
	queue_free()

func _on_heavy_pressed():
	emit_signal("disguise_selected", 2)  # Heavy
	queue_free()

func _on_spy_pressed():
	emit_signal("disguise_selected", 3)  # Spy
	queue_free()

func _on_remove_pressed():
	emit_signal("disguise_selected", -1)  # Remove
	queue_free()
