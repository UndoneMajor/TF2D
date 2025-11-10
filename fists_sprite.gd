extends Node2D

var left_fist = null
var right_fist = null
var current_fist = "left"

func _ready():
	# Create left fist
	left_fist = Sprite2D.new()
	var left_image = Image.create(20, 20, false, Image.FORMAT_RGBA8)
	left_image.fill(Color.TAN)
	left_fist.texture = ImageTexture.create_from_image(left_image)
	left_fist.offset = Vector2(-10, -10)
	left_fist.position = Vector2(30, -15)  # Top position
	add_child(left_fist)
	
	# Create right fist
	right_fist = Sprite2D.new()
	var right_image = Image.create(20, 20, false, Image.FORMAT_RGBA8)
	right_image.fill(Color.TAN)
	right_fist.texture = ImageTexture.create_from_image(right_image)
	right_fist.offset = Vector2(-10, -20)
	right_fist.position = Vector2(25, 40)  # Bottom position
	add_child(right_fist)

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
