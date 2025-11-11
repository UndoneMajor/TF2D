extends Node2D

var is_spinning = false
var spin_rotation = 0.0

func _process(delta):
	if is_spinning:
		spin_rotation += delta * 20.0
		queue_redraw()

func _draw():
	# Draw minigun (moved back closer to player)
	# Main body (large gray box)
	draw_rect(Rect2(Vector2(-5, -10), Vector2(40, 20)), Color(0.25, 0.25, 0.3))
	
	# Ammo box (below)
	draw_rect(Rect2(Vector2(-10, 10), Vector2(30, 15)), Color(0.3, 0.3, 0.25))
	draw_rect(Rect2(Vector2(-8, 12), Vector2(26, 11)), Color(0.35, 0.35, 0.3))
	
	# Rotating barrels (6 barrels in a circle)
	var barrel_center = Vector2(40, 0)
	for i in range(6):
		var angle = (TAU / 6.0) * i + spin_rotation
		var barrel_pos = barrel_center + Vector2(cos(angle), sin(angle)) * 8
		draw_circle(barrel_pos, 3, Color(0.15, 0.15, 0.15))
		draw_circle(barrel_pos, 2, Color(0.1, 0.1, 0.1))
	
	# Barrel housing (circle around barrels)
	draw_arc(barrel_center, 12, 0, TAU, 32, Color(0.3, 0.3, 0.3), 3)
	
	# Barrel tips (darker)
	draw_circle(Vector2(55, 0), 10, Color(0.2, 0.2, 0.2))
	draw_circle(Vector2(55, 0), 8, Color(0.15, 0.15, 0.15))
	
	# Handles
	draw_rect(Rect2(Vector2(0, -15), Vector2(8, 5)), Color(0.2, 0.2, 0.2))
	draw_rect(Rect2(Vector2(-3, 10), Vector2(8, 8)), Color(0.35, 0.25, 0.15))
	
	# Trigger guard
	draw_arc(Vector2(1, 14), 5, 0, PI, 12, Color(0.25, 0.25, 0.25), 2)
	
	# Details (vents on side)
	for i in range(3):
		var x = 0 + i * 10
		draw_line(Vector2(x, -8), Vector2(x, 8), Color(0.2, 0.2, 0.25), 2)
	
	# Ammo belt
	draw_line(Vector2(5, 10), Vector2(15, -5), Color(0.6, 0.5, 0.2), 3)

func shoot_animation():
	if not is_spinning:
		is_spinning = true

func stop_spin():
	is_spinning = false
	spin_rotation = 0.0
	queue_redraw()
