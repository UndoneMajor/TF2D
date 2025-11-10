extends Node2D

var left_fist = null
var right_fist = null
var current_fist = "left"

func _ready():
	# Hide fists - using player sprite animation instead
	visible = false

func swing_animation():
	# Alternate between fists
	if current_fist == "left":
		# Punch with left fist
		var tween = create_tween()
		tween.tween_property(left_fist, "position", Vector2(45, -15), 0.1)
		await tween.finished
		tween = create_tween()
		tween.tween_property(left_fist, "position", Vector2(25, -15), 0.15)
		current_fist = "right"
	else:
		# Punch with right fist
		var tween = create_tween()
		tween.tween_property(right_fist, "position", Vector2(45, 15), 0.1)
		await tween.finished
		tween = create_tween()
		tween.tween_property(right_fist, "position", Vector2(25, 40), 0.15)
		current_fist = "left"
