extends AspectRatioContainer
class_name EssenceMeter

@onready var margin_container: MarginContainer = $MarginContainer
var player: Player

@onready var fullness_level = [
		$MarginContainer/Filled1,
		$MarginContainer/Filled2,
		$MarginContainer/Filled3,
		$MarginContainer/Filled4,
		$MarginContainer/Filled5
	]

func update_fullness_level() -> void:
	hide_all_full_textures()
	if player.essence_count == 0:
		return
	
	fullness_level[player.essence_count - 1].show()

func hide_all_full_textures() -> void:
	for node in margin_container.find_children("Filled*"):
		node.hide()
