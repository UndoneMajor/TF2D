extends Control

signal class_selected(class_type)

func _ready():
	# Allow this menu to process even when game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	$ScoutButton.pressed.connect(_on_scout_pressed)
	$SoldierButton.pressed.connect(_on_soldier_pressed)
	$PyroButton.pressed.connect(_on_pyro_pressed)
	$HeavyButton.pressed.connect(_on_heavy_pressed)
	$SpyButton.pressed.connect(_on_spy_pressed)

func _on_scout_pressed():
	print("🎯 SCOUT button pressed!")
	emit_signal("class_selected", 0)  # Scout = 0
	print("Signal emitted, freeing menu...")
	queue_free()

func _on_soldier_pressed():
	print("🎯 SOLDIER button pressed!")
	emit_signal("class_selected", 1)  # Soldier = 1
	print("Signal emitted, freeing menu...")
	queue_free()

func _on_pyro_pressed():
	print("🎯 PYRO button pressed!")
	emit_signal("class_selected", 2)  # Pyro = 2
	print("Signal emitted, freeing menu...")
	queue_free()

func _on_heavy_pressed():
	print("🎯 HEAVY button pressed!")
	emit_signal("class_selected", 3)  # Heavy = 3
	print("Signal emitted, freeing menu...")
	queue_free()

func _on_spy_pressed():
	print("🎯 SPY button pressed!")
	emit_signal("class_selected", 4)  # Spy = 4
	print("Signal emitted, freeing menu...")
	queue_free()
