extends Sprite2D

func _ready():
	var image = Image.create(55, 12, false, Image.FORMAT_RGBA8)
	image.fill(Color.SLATE_GRAY)
	texture = ImageTexture.create_from_image(image)
	
	offset = Vector2(-27, -6)
	position = Vector2(35, 0)
	rotation_degrees = 0

func shoot_animation():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(30, 0), 0.08)
	await tween.finished
	tween = create_tween()
	tween.tween_property(self, "position", Vector2(35, 0), 0.15)
