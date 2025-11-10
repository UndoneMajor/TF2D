extends Sprite2D

func _ready():
	var image = Image.create(70, 20, false, Image.FORMAT_RGBA8)
	image.fill(Color.DARK_SLATE_GRAY)
	texture = ImageTexture.create_from_image(image)
	
	offset = Vector2(-35, -10)
	position = Vector2(40, 0)
	rotation_degrees = 0

func shoot_animation():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(35, 0), 0.1)
	await tween.finished
	tween = create_tween()
	tween.tween_property(self, "position", Vector2(40, 0), 0.2)
