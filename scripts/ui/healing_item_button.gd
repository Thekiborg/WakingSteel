extends Button
class_name HealingItemButton

var item: HealingItem
var health_window: HealthWindow
var injury: Injury


func _init(healing_item_id: String, injury_from_button:Injury, window: HealthWindow) -> void:
	var itemind = window.bridge.player.inventory_manager.find_item(healing_item_id)
	item = window.bridge.player.inventory_manager.items.get(itemind)
	health_window = window
	injury = injury_from_button
	set_text(item.name)
	icon = item.icon
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	item.use(health_window.bridge.player.get_path(), injury)
	health_window.create_buttons_for_injuries()
