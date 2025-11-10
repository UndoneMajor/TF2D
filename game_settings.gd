extends Node

# Global game settings
var show_hitboxes = false

func _ready():
	load_settings()

func load_settings():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		if config.has_section_key("game", "show_hitboxes"):
			show_hitboxes = config.get_value("game", "show_hitboxes")
			print("Loaded hitbox setting: ", show_hitboxes)

