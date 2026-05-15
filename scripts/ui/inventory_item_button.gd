extends Button
class_name InventoryItemButton

var window: InventoryWindow
var item: Item

func _init(_window: InventoryWindow, _item: Item) -> void:
	self.window = _window
	self.item = _item


func _pressed() -> void:
	window.show_item_actions(item)
