extends Area3D
class_name NodeItem

@export var data: Item

@onready var keyboard_icon: Sprite3D = $KeyboardIcon
@onready var item_icon: Sprite3D = $ItemIcon
@onready var item_label: Label3D = $ItemLabel

var stack_size: int

func _ready() -> void:
	area_entered.connect(_player_approaches)
	area_exited.connect(_player_leaves)
	if data:
		item_label.text = _adjust_label_for_stack_size()
		item_icon.texture = data.icon

func _player_approaches(_area: Area3D) -> void:
	keyboard_icon.show()
	item_label.show()
	
func _player_leaves(_area: Area3D) -> void:
	keyboard_icon.hide()
	item_label.hide()

func _adjust_label_for_stack_size() -> String:
	var label = data.name
	if stack_size > 1:
		label += " x" + str(stack_size)
	return label
