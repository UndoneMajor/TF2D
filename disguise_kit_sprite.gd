extends Sprite2D

func _ready():
	var image = Image.create(30, 20, false, Image.FORMAT_RGBA8)
	image.fill(Color.YELLOW)
	texture = ImageTexture.create_from_image(image)
	
	offset = Vector2(-15, -10)
	position = Vector2(30, 5)
