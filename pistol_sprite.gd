extends Node2D

func _draw():
	# Draw semi-auto pistol (moved back)
	# Slide (top part)
	draw_rect(Rect2(Vector2(5, -4), Vector2(25, 5)), Color(0.2, 0.2, 0.2))
	
	# Frame (main body)
	draw_rect(Rect2(Vector2(5, 1), Vector2(20, 7)), Color(0.25, 0.25, 0.25))
	
	# Barrel
	draw_rect(Rect2(Vector2(25, -3), Vector2(8, 4)), Color(0.15, 0.15, 0.15))
	draw_circle(Vector2(33, -1), 2, Color(0.1, 0.1, 0.1))
	
	# Grip (textured)
	var grip_points = PackedVector2Array([
		Vector2(5, 1),
		Vector2(0, 5),
		Vector2(0, 12),
		Vector2(7, 12),
		Vector2(10, 8),
		Vector2(10, 1)
	])
	draw_colored_polygon(grip_points, Color(0.15, 0.15, 0.15))
	
	# Grip texture lines
	for i in range(3):
		var y = 5 + i * 2
		draw_line(Vector2(2, y), Vector2(8, y), Color(0.1, 0.1, 0.1), 1)
	
	# Trigger guard
	draw_arc(Vector2(8, 6), 4, 0, PI, 12, Color(0.2, 0.2, 0.2), 2)
	
	# Slide serrations (back)
	for i in range(3):
		var x = 8 + i * 3
		draw_line(Vector2(x, -3), Vector2(x, 0), Color(0.15, 0.15, 0.15), 1)
	
	# Highlight
	draw_line(Vector2(5, -3), Vector2(28, -3), Color(0.3, 0.3, 0.3), 1)

func shoot_animation():
	var tween = create_tween()
	# Recoil back
	tween.tween_property(self, "position:x", -5, 0.05)
	await tween.finished
	tween = create_tween()
	# Return to normal position
	tween.tween_property(self, "position:x", 0, 0.1)
	queue_redraw()
