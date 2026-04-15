extends Button
class_name HealingItemButton

var item: HealingItem
var health_window: HealthWindow
var injury: Injury


func _init(healing_item: HealingItem, injury_from_button:Injury, window: HealthWindow) -> void:
	item = healing_item
	health_window = window
	injury = injury_from_button
	set_text(healing_item.name)
	icon = healing_item.icon
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	item.use(injury)
	health_window.create_buttons_for_injuries()
