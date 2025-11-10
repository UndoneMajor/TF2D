extends Control

signal team_selected(team_id)

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	$RedButton.pressed.connect(_on_red_pressed)
	$BlueButton.pressed.connect(_on_blue_pressed)
	
	print("Team selection menu loaded!")

func _on_red_pressed():
	emit_signal("team_selected", 0)  # RED = 0
	queue_free()

func _on_blue_pressed():
	emit_signal("team_selected", 1)  # BLUE = 1
	queue_free()

