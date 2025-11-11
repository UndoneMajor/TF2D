extends Node2D

func _ready():
	position = Vector2(0, 10)  # Only Y offset, no X offset
	rotation_degrees = 30

func _draw():
	# Draw butterfly knife (moved back)
	# Blade (silver/gray)
	var blade_points = PackedVector2Array([
		Vector2(20, 0),
		Vector2(45, -2),
		Vector2(45, 2),
		Vector2(20, 0)
	])
	draw_colored_polygon(blade_points, Color(0.7, 0.7, 0.75))
	
	# Blade edge (highlight)
	draw_line(Vector2(20, 0), Vector2(45, -2), Color(0.9, 0.9, 0.95), 1)
	
	# Handle (black/dark gray)
	draw_rect(Rect2(Vector2(0, -3), Vector2(20, 6)), Color(0.15, 0.15, 0.15))
	
	# Handle grip (textured)
	for i in range(4):
		var x = 2 + i * 4
		draw_line(Vector2(x, -2), Vector2(x, 4), Color(0.25, 0.25, 0.25), 1)
	
	# Guard (silver)
	draw_circle(Vector2(20, 0), 3, Color(0.5, 0.5, 0.5))
	
	# Pommel (end of handle)
	draw_circle(Vector2(0, 0), 3, Color(0.2, 0.2, 0.2))

func swing_animation():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "rotation_degrees", -30, 0.12)
	tween.tween_property(self, "position", Vector2(15, -5), 0.12)
	await tween.finished
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "rotation_degrees", 30, 0.15)
	tween.tween_property(self, "position", Vector2(0, 10), 0.15)
	queue_redraw()
