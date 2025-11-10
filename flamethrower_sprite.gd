extends Node2D

func _draw():
	# Draw flamethrower body
	# Main body (gray rectangle)
	draw_rect(Rect2(Vector2(0, -8), Vector2(40, 16)), Color(0.3, 0.3, 0.3))
	
	# Barrel (darker gray)
	draw_rect(Rect2(Vector2(35, -6), Vector2(20, 12)), Color(0.2, 0.2, 0.2))
	
	# Gas tank (red cylinder on top)
	draw_circle(Vector2(15, -12), 8, Color(0.8, 0.2, 0.2))
	draw_rect(Rect2(Vector2(7, -12), Vector2(16, 8)), Color(0.8, 0.2, 0.2))
	
	# Handle (below)
	draw_rect(Rect2(Vector2(10, 8), Vector2(8, 12)), Color(0.4, 0.3, 0.2))
	
	# Nozzle tip (orange)
	draw_circle(Vector2(55, 0), 4, Color(0.9, 0.4, 0.1))
	
	# Details
	draw_line(Vector2(0, -8), Vector2(40, -8), Color(0.1, 0.1, 0.1), 2)
	draw_line(Vector2(0, 8), Vector2(40, 8), Color(0.1, 0.1, 0.1), 2)

func shoot_animation():
	# Flash the nozzle when shooting
	queue_redraw()

