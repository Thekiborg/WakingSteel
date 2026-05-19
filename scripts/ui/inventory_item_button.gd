extends Button
class_name InventoryItemButton

var window: InventoryWindow
var item: Item

func _init(_window: InventoryWindow, _item: Item) -> void:
	self.window = _window
	self.item = _item
	if (item is WeaponItem
		and window.player.equippedWeapon.name == item.weapon.name):
			var stylebox: StyleBox = get_theme_stylebox("normal").duplicate()
			stylebox.bg_color = "#ffe14d"
			add_theme_stylebox_override("normal", stylebox)


func _pressed() -> void:
	window.show_item_actions(item)
