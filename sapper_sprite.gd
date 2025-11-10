extends Sprite2D

func _ready():
	var image = Image.create(25, 25, false, Image.FORMAT_RGBA8)
	image.fill(Color.DARK_BLUE)
	texture = ImageTexture.create_from_image(image)
	
	offset = Vector2(-12, -12)
	position = Vector2(30, 0)

func place_animation():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(40, 0), 0.1)
	await tween.finished
	tween = create_tween()
	tween.tween_property(self, "position", Vector2(30, 0), 0.1)
