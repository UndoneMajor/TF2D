extends Node2D

func _draw():
	# Draw revolver (moved back closer to player)
	# Barrel (long, thin)
	draw_rect(Rect2(Vector2(10, -3), Vector2(30, 6)), Color(0.15, 0.15, 0.15))
	
	# Cylinder (silver/gray circle)
	draw_circle(Vector2(5, 0), 7, Color(0.5, 0.5, 0.5))
	draw_circle(Vector2(5, 0), 5, Color(0.4, 0.4, 0.4))
	
	# Grip (brown wood)
	var grip_points = PackedVector2Array([
		Vector2(-5, -2),
		Vector2(-10, 5),
		Vector2(-10, 12),
		Vector2(-3, 12),
		Vector2(0, 8),
		Vector2(0, 0)
	])
	draw_colored_polygon(grip_points, Color(0.4, 0.25, 0.15))
	
	# Trigger guard (dark)
	draw_arc(Vector2(-3, 8), 6, 0, PI, 16, Color(0.2, 0.2, 0.2), 2)
	
	# Hammer (back)
	draw_rect(Rect2(Vector2(-7, -8), Vector2(4, 6)), Color(0.3, 0.3, 0.3))
	
	# Barrel tip (darker)
	draw_circle(Vector2(40, 0), 3, Color(0.1, 0.1, 0.1))
	
	# Details/highlights
	draw_line(Vector2(10, -1), Vector2(37, -1), Color(0.25, 0.25, 0.25), 1)

func shoot_animation():
	var tween = create_tween()
	# Recoil back
	tween.tween_property(self, "position:x", -5, 0.05)
	await tween.finished
	tween = create_tween()
	# Return to normal position
	tween.tween_property(self, "position:x", 0, 0.1)
	queue_redraw()
