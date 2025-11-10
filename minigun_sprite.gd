extends Sprite2D

var is_spinning = false

func _ready():
	var image = Image.create(80, 25, false, Image.FORMAT_RGBA8)
	image.fill(Color.DARK_SLATE_BLUE)
	texture = ImageTexture.create_from_image(image)
	
	offset = Vector2(-40, -12)
	position = Vector2(45, 0)
	rotation_degrees = 0

func shoot_animation():
	if not is_spinning:
		is_spinning = true
		spin_animation()

func spin_animation():
	while is_spinning:
		var tween = create_tween()
		tween.tween_property(self, "position:y", randf_range(-2, 2), 0.05)
		await tween.finished

func stop_spin():
	is_spinning = false
