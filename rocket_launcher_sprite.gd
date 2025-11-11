extends Node2D

func _draw():
	# Draw rocket launcher (moved back closer to player)
	# Main tube (large gray cylinder)
	draw_rect(Rect2(Vector2(5, -10), Vector2(55, 20)), Color(0.3, 0.3, 0.3))
	
	# Barrel opening (dark)
	draw_circle(Vector2(60, 0), 10, Color(0.15, 0.15, 0.15))
	draw_circle(Vector2(60, 0), 8, Color(0.1, 0.1, 0.1))
	
	# Grip/handle (below)
	draw_rect(Rect2(Vector2(0, 10), Vector2(10, 15)), Color(0.2, 0.2, 0.2))
	draw_rect(Rect2(Vector2(-5, 15), Vector2(15, 8)), Color(0.35, 0.25, 0.15))
	
	# Trigger guard
	draw_arc(Vector2(3, 18), 6, 0, PI, 16, Color(0.25, 0.25, 0.25), 2)
	
	# Sight on top
	draw_rect(Rect2(Vector2(15, -14), Vector2(3, 4)), Color(0.2, 0.2, 0.2))
	draw_rect(Rect2(Vector2(35, -14), Vector2(3, 4)), Color(0.2, 0.2, 0.2))
	
	# Side details (vents)
	for i in range(4):
		var x = 10 + i * 12
		draw_line(Vector2(x, -8), Vector2(x, 8), Color(0.2, 0.2, 0.2), 2)
	
	# Stock (back support)
	draw_rect(Rect2(Vector2(-15, -3), Vector2(20, 6)), Color(0.35, 0.25, 0.15))
	
	# Highlights
	draw_line(Vector2(5, -9), Vector2(55, -9), Color(0.4, 0.4, 0.4), 1)
	draw_line(Vector2(5, 9), Vector2(55, 9), Color(0.25, 0.25, 0.25), 1)

func shoot_animation():
	var tween = create_tween()
	# Recoil back
	tween.tween_property(self, "position:x", -10, 0.1)
	await tween.finished
	tween = create_tween()
	# Return to normal position
	tween.tween_property(self, "position:x", 0, 0.2)
	queue_redraw()
