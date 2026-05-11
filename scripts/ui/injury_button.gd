extends Button
class_name InjuryButton

var injury: Injury
@onready var health_window: HealthWindow


func _init(button_injury: Injury, window: HealthWindow) -> void:
	injury = button_injury
	health_window = window
	name = "button" + injury.name
	icon = injury.icon
	tooltip_text = injury.name
	if injury.internal:
		var stylebox: StyleBox = get_theme_stylebox("normal").duplicate()
		stylebox.bg_color = "#ffe14d"
		add_theme_stylebox_override("normal", stylebox)
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	health_window.clear_previous_healing_buttons()
	health_window.show_owned_healing_for(injury)
