extends Sprite2D

func _ready():
	# Create scattergun texture (shotgun shape)
	var image = Image.create(50, 12, false, Image.FORMAT_RGBA8)
	image.fill(Color.DIM_GRAY)  # Gray gun
	texture = ImageTexture.create_from_image(image)
	
	offset = Vector2(-25, -6)
	position = Vector2(35, 0)
	rotation_degrees = 0

func shoot_animation():
	var tween = create_tween()
	# Recoil back
	tween.tween_property(self, "position", Vector2(30, 0), 0.05)
	await tween.finished
	# Return
	tween = create_tween()
	tween.tween_property(self, "position", Vector2(35, 0), 0.1)
