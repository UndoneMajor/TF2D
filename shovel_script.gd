extends Node2D

func _ready():
	position = Vector2(0, 20)  # Only Y offset, no X offset
	rotation_degrees = 45

func _draw():
	# Draw shovel/spade
	# Handle (wooden, long)
	draw_rect(Rect2(Vector2(0, -2), Vector2(35, 4)), Color(0.4, 0.3, 0.2))
	
	# Handle grip
	for i in range(6):
		var x = 2 + i * 5
		draw_line(Vector2(x, -1), Vector2(x, 3), Color(0.3, 0.2, 0.15), 1)
	
	# Spade head (metal)
	var spade_points = PackedVector2Array([
		Vector2(35, -8),
		Vector2(50, -8),
		Vector2(50, 8),
		Vector2(35, 8),
		Vector2(35, -8)
	])
	draw_colored_polygon(spade_points, Color(0.4, 0.4, 0.4))
	
	# Spade edge (sharp)
	draw_line(Vector2(50, -8), Vector2(50, 8), Color(0.6, 0.6, 0.6), 2)
	
	# Connection socket
	draw_rect(Rect2(Vector2(33, -4), Vector2(5, 8)), Color(0.3, 0.3, 0.3))
	
	# Metal shine
	draw_line(Vector2(37, -6), Vector2(48, -6), Color(0.5, 0.5, 0.5), 1)
	
	# Handle end knob
	draw_circle(Vector2(0, 0), 3, Color(0.35, 0.25, 0.15))

func swing_animation():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "rotation_degrees", -45, 0.15)
	tween.tween_property(self, "position", Vector2(15, -10), 0.15)
	await tween.finished
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "rotation_degrees", 45, 0.15)
	tween.tween_property(self, "position", Vector2(0, 20), 0.15)
	queue_redraw()
