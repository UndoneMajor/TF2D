extends Node2D

func _draw():
	# Draw scattergun (double-barrel shotgun, moved back)
	# Main body
	draw_rect(Rect2(Vector2(0, -6), Vector2(45, 12)), Color(0.3, 0.3, 0.3))
	
	# Double barrels
	draw_rect(Rect2(Vector2(15, -8), Vector2(30, 5)), Color(0.2, 0.2, 0.2))
	draw_rect(Rect2(Vector2(15, 3), Vector2(30, 5)), Color(0.2, 0.2, 0.2))
	
	# Barrel tips (dark circles)
	draw_circle(Vector2(45, -5.5), 2.5, Color(0.1, 0.1, 0.1))
	draw_circle(Vector2(45, 5.5), 2.5, Color(0.1, 0.1, 0.1))
	
	# Pump/foregrip (wooden)
	draw_rect(Rect2(Vector2(10, -4), Vector2(12, 8)), Color(0.4, 0.3, 0.2))
	
	# Stock (wooden)
	draw_rect(Rect2(Vector2(-15, -3), Vector2(18, 6)), Color(0.4, 0.3, 0.2))
	
	# Trigger area
	draw_rect(Rect2(Vector2(-3, 6), Vector2(8, 8)), Color(0.35, 0.25, 0.15))
	draw_arc(Vector2(1, 10), 5, 0, PI, 12, Color(0.25, 0.25, 0.25), 2)
	
	# Metal band details
	draw_line(Vector2(5, -6), Vector2(5, 6), Color(0.4, 0.4, 0.4), 2)
	draw_line(Vector2(25, -6), Vector2(25, 6), Color(0.4, 0.4, 0.4), 2)
	
	# Highlights
	draw_line(Vector2(15, -7), Vector2(43, -7), Color(0.35, 0.35, 0.35), 1)
	draw_line(Vector2(15, 2), Vector2(43, 2), Color(0.35, 0.35, 0.35), 1)

func shoot_animation():
	var tween = create_tween()
	# Recoil back
	tween.tween_property(self, "position:x", -10, 0.05)
	await tween.finished
	# Return to normal position
	tween = create_tween()
	tween.tween_property(self, "position:x", 0, 0.1)
	queue_redraw()
