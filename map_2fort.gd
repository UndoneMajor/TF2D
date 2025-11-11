extends Node2D

# Simple 2Fort-inspired map
# Red base on left, Blue base on right, bridge in middle

func _ready():
	pass

func _draw():
	# Background
	draw_rect(Rect2(-2000, -2000, 4000, 4000), Color(0.3, 0.25, 0.2))  # Brown ground
	
	# Red spawn room (left)
	draw_rect(Rect2(-800, 200, 400, 400), Color(0.6, 0.2, 0.2))  # Red floor
	draw_rect(Rect2(-800, 200, 400, 400), Color(0.8, 0.3, 0.3), false, 4)  # Red outline
	
	# Blue spawn room (right)
	draw_rect(Rect2(400, 200, 400, 400), Color(0.2, 0.3, 0.6))  # Blue floor
	draw_rect(Rect2(400, 200, 400, 400), Color(0.3, 0.4, 0.8), false, 4)  # Blue outline
	
	# Middle bridge area
	draw_rect(Rect2(-200, 300, 400, 200), Color(0.4, 0.4, 0.4))  # Gray bridge
	draw_rect(Rect2(-200, 300, 400, 200), Color(0.5, 0.5, 0.5), false, 3)  # Bridge outline
	
	# Water under bridge
	draw_rect(Rect2(-200, 550, 400, 150), Color(0.2, 0.4, 0.6, 0.7))  # Water

