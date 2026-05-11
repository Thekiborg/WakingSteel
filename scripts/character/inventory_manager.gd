extends Node
class_name InventoryManager


@onready var parent: Character = get_parent()
var items: Array[Item]


func get_all_healing_items() -> Array[HealingItem]:
	var res: Array[HealingItem] = []
	for item in items:
		if item is HealingItem:
			res.append(item)
	return res


func get_healing_items_for(injury: Injury) -> Array[String]:
	var res: Array[String] = []
	for item in get_all_healing_items():
		if item.id in injury.healed_with:
			res.append(item.id)
	return res


func put(item: Item) -> void:
	InventorySyncronizer.put_item.rpc(parent.get_path(), item.id)


func delete(item: Item) -> void:
	InventorySyncronizer.take_item.rpc(parent.get_path(), item.id)


func find_item(item_id: String) -> int:
	for i in len(items):
		if items.get(i).id == item_id:
			return i
	return -1
