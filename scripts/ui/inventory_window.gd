extends AspectRatioContainer
class_name InventoryWindow

const BUTTONS_PER_ROW: int = 5

@onready var inventory_gallery: PanelContainer = %InventoryGallery
@onready var y_axis: VBoxContainer = %YAxis
@onready var left_padding: Control = %LeftPadding
@export var action_buttons: PanelContainer
@onready var action_item_label: Label = %ActionItemLabel
@onready var action_item_description: Label = %ActionItemDescription
@onready var action_item_icon: TextureRect = %ActionItemIcon
@onready var button_drop: Button = %ButtonDrop
@onready var button_equip: Button = %ButtonEquip
@onready var button_unequip: Button = %ButtonUnequip
var player: Player
var last_picked_item: Item


func _ready() -> void:
	button_drop.pressed.connect(_drop_item)
	button_equip.pressed.connect(_equip_weapon)
	button_unequip.pressed.connect(_unequip_weapon)

func display_items(items: Array[Item]) -> void:
	for node in y_axis.get_children():
		node.free()
	
	for item in items:
		var empty = y_axis.get_child_count() == 0
		var hBox
		if not empty:
			hBox = y_axis.get_child(-1)
		
		if (empty 
			or (hBox == null or hBox.get_child_count() >= BUTTONS_PER_ROW)):
			var newHBox = HBoxContainer.new()
			y_axis.add_child(newHBox)
			create_new_item_button(item, newHBox)
		else:
			create_new_item_button(item, hBox)

func create_new_item_button(item: Item, container: HBoxContainer) -> void:
	var button = InventoryItemButton.new(self, item)
	button.icon = item.icon
	container.add_child(button)

func show_item_actions(item: Item) -> void:
	hide_item_actions()
	left_padding.show()
	action_buttons.show()
	if item is WeaponItem:
		if player.equippedWeapon.name == item.weapon.name:
			button_unequip.show()
		else:
			button_equip.show()
			button_drop.show()
	else:
		button_drop.show()
	action_item_label.text = item.name
	action_item_description.text = item.description
	action_item_icon.texture = item.icon
	last_picked_item = item

func hide_item_actions() -> void:
	left_padding.hide()
	action_buttons.hide()
	button_equip.hide()
	button_unequip.hide()
	button_drop.hide()
	last_picked_item = null
	
func _equip_weapon():
	var wp: WeaponItem = last_picked_item as WeaponItem
	player.equip_weapon(wp.weapon)
	display_items(player.inventory_manager.items)
	show_item_actions(last_picked_item)

func _unequip_weapon():
	player.equip_weapon(null)
	display_items(player.inventory_manager.items)
	show_item_actions(last_picked_item)

func _drop_item():
	if last_picked_item:
		if multiplayer.is_server():
			WorldSyncronizer.spawn_item(player.position, last_picked_item.id)
		else:
			WorldSyncronizer.spawn_item.rpc_id(1, player.position, last_picked_item.id)
		player.inventory_manager.delete(last_picked_item)
		hide_item_actions()
		display_items(player.inventory_manager.items)
