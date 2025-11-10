extends Node2D

var lifetime = 1.0
var time = 0.0
var rise_speed = 50.0

func _ready():
	queue_redraw()

func _process(delta):
	time += delta
	
	# Rise up
	position.y -= rise_speed * delta
	
	# Fade out
	modulate.a = 1.0 - (time / lifetime)
	
	if time >= lifetime:
		queue_free()

func _draw():
	# Draw "CRIT!" text if no image available
	draw_string(ThemeDB.fallback_font, Vector2(-40, 0), "CRIT!", HORIZONTAL_ALIGNMENT_CENTER, -1, 48, Color(1, 0, 0, modulate.a))
