extends Sprite2D

func _ready():
	# Load your custom texture
	texture = load("res://knife.png")
	
	# Adjust offset based on your image size
	offset = Vector2(-25, -5)  # Adjust to center your image
	position = Vector2(30, 10)
	rotation_degrees = 30

func swing_animation():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "rotation_degrees", -30, 0.12)
	tween.tween_property(self, "position", Vector2(45, -5), 0.12)
	await tween.finished
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "rotation_degrees", 30, 0.15)
	tween.tween_property(self, "position", Vector2(30, 10), 0.15)
