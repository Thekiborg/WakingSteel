extends AspectRatioContainer
class_name InventoryWindow

const BUTTONS_PER_ROW: int = 5

@onready var inventory_gallery: PanelContainer = %InventoryGallery
@onready var y_axis: VBoxContainer = %YAxis
@onready var left_padding: Control = %LeftPadding
@export var action_buttons: PanelContainer
@onready var action_item_label: Label = %ActionItemLabel
@onready var action_item_icon: TextureRect = %ActionItemIcon
@onready var button_drop: Button = %ButtonDrop
var player: Player
var last_picked_item: Item


func _ready() -> void:
	button_drop.pressed.connect(_drop_item)

func display_items(items: Array[Item]) -> void:
	for node in y_axis.get_children():
		node.queue_free()
	
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
	left_padding.show()
	action_buttons.show()
	action_item_label.text = item.name
	action_item_icon.texture = item.icon
	last_picked_item = item

func hide_item_actions() -> void:
	left_padding.hide()
	action_buttons.hide()
	last_picked_item = null
	
func _drop_item():
	if last_picked_item:
		player.inventory_manager.delete(last_picked_item)
		WorldSyncronizer.spawn_item.rpc(player.position, last_picked_item.id)
		hide_item_actions()
		display_items(player.inventory_manager.items)
