extends Node
class_name InventoryManager


var items: Array[Item]


func _ready() -> void:
	items.append(load("res://Resources/Bandage.tres"))
	items.append(load("res://Resources/Bandage.tres"))
	items.append(load("res://Resources/Bandage.tres"))


func get_all_healing_items() -> Array[HealingItem]:
	var res: Array[HealingItem] = []
	for item in items:
		if item is HealingItem:
			res.append(item)
	return res


func get_healing_items_for(injury: Injury) -> Array[HealingItem]:
	var res: Array[HealingItem] = []
	for item in get_all_healing_items():
		if item in injury.healed_with:
			res.append(item)
	return res


func put(item: Item) -> void:
	items.append(item)


func delete(item: Item) -> void:
	items.erase(item)
