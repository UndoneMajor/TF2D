extends Sprite2D

func _ready():
	# Create a simple bat texture
	var image = Image.create(60, 10, false, Image.FORMAT_RGBA8)
	image.fill(Color.SADDLE_BROWN)  # Brown bat
	texture = ImageTexture.create_from_image(image)
	
	# Offset so it rotates from the handle (pivot point)
	offset = Vector2(-60, -5)
	
	# Position in scout's hand (adjusted for sprite)
	position = Vector2(35, 5)  # In front, slightly down
	rotation_degrees = 90  # Horizontal

func swing_animation():
	# Swing animation
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Swing up
	tween.tween_property(self, "rotation_degrees", 95,0.5)
	
	# Return to idle position
	await tween.finished
	tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 0,0.5)
