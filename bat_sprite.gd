extends Sprite2D

func _ready():
	# Create a simple bat texture
	var image = Image.create(60, 10, false, Image.FORMAT_RGBA8)
	image.fill(Color.SADDLE_BROWN)  # Brown bat
	texture = ImageTexture.create_from_image(image)
	
	# Offset so it rotates from the handle
	offset = Vector2(-20, -30)
	
	# Start at idle position (to the right)
	position = Vector2(-20,-30)  # Right side of player
	rotation_degrees = 90  # Angled down

func swing_animation():
	# Swing animation
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Swing up and forward
	tween.tween_property(self, "rotation_degrees", 90, 0.15)
	tween.tween_property(self, "position", Vector2(50, -10), 0.15)
	
	# Return to idle position
	await tween.finished
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "rotation_degrees", 45, 0.15)
	tween.tween_property(self, "position", Vector2(20, 15), 0.15)
