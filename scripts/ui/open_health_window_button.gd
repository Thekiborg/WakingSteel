extends Button

@onready var bridge: PlayerUIBridge = get_parent().get_parent()

func _pressed() -> void:
	if bridge.health_window.visible:
		bridge.health_window.close()
	else:
		bridge.health_window.open()
