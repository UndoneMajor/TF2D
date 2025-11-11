extends Node2D

func _draw():
	# Draw fire axe (moved back closer to player)
	# Handle (wooden, long)
	draw_rect(Rect2(Vector2(-10, -3), Vector2(35, 6)), Color(0.4, 0.25, 0.1))
	
	# Handle grip lines
	for i in range(4):
		var x = -5 + i * 7
		draw_line(Vector2(x, -2), Vector2(x, 4), Color(0.3, 0.2, 0.05), 2)
	
	# Axe head (metal with orange/red tint for "fire" axe)
	var axe_points = PackedVector2Array([
		Vector2(20, -12),
		Vector2(35, -8),
		Vector2(35, 8),
		Vector2(20, 12),
		Vector2(20, -12)
	])
	draw_colored_polygon(axe_points, Color(0.7, 0.3, 0.1))
	
	# Blade edge (brighter, glowing)
	draw_line(Vector2(35, -8), Vector2(35, 8), Color(0.9, 0.5, 0.2), 3)
	
	# Fire glow effect
	draw_line(Vector2(34, -6), Vector2(34, 6), Color(1.0, 0.6, 0.1), 1)
	
	# Socket connecting head to handle
	draw_rect(Rect2(Vector2(18, -5), Vector2(5, 10)), Color(0.3, 0.3, 0.3))
	
	# Handle end
	draw_circle(Vector2(-10, 0), 3, Color(0.35, 0.2, 0.08))

func swing_animation():
	queue_redraw()

