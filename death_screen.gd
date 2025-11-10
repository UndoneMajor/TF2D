extends Control

var killer = null
var respawn_timer = 5.0
var time_left = 5.0
var m_key_pressed = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	print("Death screen active! Press M to change class.")

func _process(delta):
	time_left -= delta
	
	# Update respawn timer
	$RespawnLabel.text = "Press 'M' to change class\nRespawning in: " + str(int(time_left + 1))
	
	# Auto respawn after timer
	if time_left <= 0:
		respawn()
		return
	
	# Check for M key press (not hold)
	var m_pressed_now = Input.is_key_pressed(KEY_M)
	if m_pressed_now and not m_key_pressed:
		print("M key detected - changing class!")
		change_class()
		return
	m_key_pressed = m_pressed_now
	
	# Spectate killer
	if killer and is_instance_valid(killer):
		var camera = get_viewport().get_camera_2d()
		if camera:
			camera.global_position = killer.global_position

func respawn():
	print("Auto-respawning player...")
	var main = get_tree().root.get_node_or_null("Main")
	if main and main.has_method("respawn_player"):
		main.respawn_player()
	queue_free()

func change_class():
	print("Opening class selection...")
	var main = get_tree().root.get_node_or_null("Main")
	if main and main.has_method("show_class_selection_for_respawn"):
		main.show_class_selection_for_respawn()
	else:
		print("ERROR: Main or method not found!")
	queue_free()

