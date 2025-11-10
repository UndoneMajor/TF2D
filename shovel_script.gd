extends Sprite2D

func _ready():
	var image = Image.create(50, 15, false, Image.FORMAT_RGBA8)
	image.fill(Color.GRAY)
	texture = ImageTexture.create_from_image(image)
	
	offset = Vector2(-25, -7)
	position = Vector2(35, 20)
	rotation_degrees = 45

func swing_animation():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "rotation_degrees", -45, 0.15)
	tween.tween_property(self, "position", Vector2(50, -10), 0.15)
	await tween.finished
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "rotation_degrees", 45, 0.15)
	tween.tween_property(self, "position", Vector2(35, 20), 0.15)
