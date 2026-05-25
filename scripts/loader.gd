extends Node

func _ready() -> void:
	var menu = Preloads.MAIN_MENU.instantiate()
	get_tree().current_scene.add_child.call_deferred(menu)
