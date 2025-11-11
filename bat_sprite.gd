extends Node2D

func _ready():
	position = Vector2(0, 5)  # Only Y offset, no X offset
	rotation_degrees = 90

func _draw():
	# Draw baseball bat
	# Handle (thin, dark brown)
	draw_rect(Rect2(Vector2(0, -3), Vector2(25, 6)), Color(0.3, 0.2, 0.1))
	
	# Handle grip (wrapped)
	for i in range(5):
		var x = 2 + i * 4
		draw_line(Vector2(x, -2), Vector2(x, 4), Color(0.2, 0.15, 0.08), 1)
	
	# Barrel (thicker, lighter brown)
	draw_rect(Rect2(Vector2(25, -4), Vector2(25, 8)), Color(0.5, 0.35, 0.2))
	
	# Barrel end (rounded)
	draw_circle(Vector2(50, 0), 4, Color(0.5, 0.35, 0.2))
	
	# Wood grain lines
	draw_line(Vector2(28, -2), Vector2(48, -2), Color(0.4, 0.3, 0.15), 1)
	draw_line(Vector2(28, 2), Vector2(48, 2), Color(0.4, 0.3, 0.15), 1)
	
	# Knob at end
	draw_circle(Vector2(0, 0), 3, Color(0.25, 0.18, 0.1))

func swing_animation():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "rotation_degrees", 95, 0.5)
	await tween.finished
	tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 0, 0.5)
	queue_redraw()
