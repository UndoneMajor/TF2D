extends Node2D

func _draw():
	# Draw fire axe
	# Handle (wooden)
	draw_rect(Rect2(Vector2(0, -3), Vector2(35, 6)), Color(0.4, 0.25, 0.1))
	
	# Axe head (metal with orange/red tint for "fire" axe)
	var axe_points = PackedVector2Array([
		Vector2(30, -12),
		Vector2(45, -8),
		Vector2(45, 8),
		Vector2(30, 12),
		Vector2(30, -12)
	])
	draw_colored_polygon(axe_points, Color(0.7, 0.3, 0.1))
	
	# Blade edge (brighter)
	draw_line(Vector2(45, -8), Vector2(45, 8), Color(0.9, 0.5, 0.2), 3)
	
	# Handle grip lines
	draw_line(Vector2(10, -3), Vector2(10, 3), Color(0.3, 0.2, 0.05), 2)
	draw_line(Vector2(20, -3), Vector2(20, 3), Color(0.3, 0.2, 0.05), 2)

func swing_animation():
	queue_redraw()

