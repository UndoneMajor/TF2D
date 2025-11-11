extends Node2D

func _draw():
	# Draw pump-action shotgun (moved back)
	# Main body
	draw_rect(Rect2(Vector2(0, -5), Vector2(40, 10)), Color(0.3, 0.3, 0.3))
	
	# Barrel
	draw_rect(Rect2(Vector2(20, -6), Vector2(25, 12)), Color(0.2, 0.2, 0.2))
	
	# Barrel tip
	draw_circle(Vector2(45, 0), 3, Color(0.1, 0.1, 0.1))
	
	# Pump (wooden)
	draw_rect(Rect2(Vector2(15, -4), Vector2(10, 8)), Color(0.4, 0.3, 0.2))
	
	# Stock (wooden)
	draw_rect(Rect2(Vector2(-12, -3), Vector2(15, 6)), Color(0.4, 0.3, 0.2))
	
	# Trigger area
	draw_rect(Rect2(Vector2(5, 5), Vector2(6, 8)), Color(0.35, 0.25, 0.15))
	draw_arc(Vector2(8, 9), 4, 0, PI, 12, Color(0.25, 0.25, 0.25), 2)
	
	# Metal bands
	draw_line(Vector2(10, -5), Vector2(10, 5), Color(0.4, 0.4, 0.4), 2)
	draw_line(Vector2(30, -5), Vector2(30, 5), Color(0.4, 0.4, 0.4), 2)
	
	# Highlight
	draw_line(Vector2(20, -5), Vector2(43, -5), Color(0.35, 0.35, 0.35), 1)

func shoot_animation():
	var tween = create_tween()
	# Recoil back
	tween.tween_property(self, "position:x", -10, 0.08)
	await tween.finished
	tween = create_tween()
	# Return to normal position
	tween.tween_property(self, "position:x", 0, 0.15)
	queue_redraw()
