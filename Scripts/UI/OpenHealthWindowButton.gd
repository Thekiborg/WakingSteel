extends Button

@onready var health_window: HealthWindow = $"../HBoxContainer/HealthWindow"

func _pressed() -> void:
	if health_window.visible:
		health_window.close()
	else:
		health_window.open()
