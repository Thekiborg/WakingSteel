extends AspectRatioContainer

@onready var button_join: Button = %ButtonJoin
@onready var button_quit: Button = %ButtonQuit

func _ready() -> void:
	button_join.pressed.connect(_on_join)
	button_quit.pressed.connect(_on_quit)

func _on_join() -> void:
	NetworkHandler.join_server()
	var baseplate = Preloads.FLOOR.instantiate()
	get_tree().current_scene.add_child.call_deferred(baseplate)
	hide()
	
func _on_quit() -> void:
	get_tree().quit()
