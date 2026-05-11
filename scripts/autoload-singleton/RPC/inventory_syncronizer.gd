extends Node

@rpc("any_peer", "call_local")
func put_item(character_path: NodePath, item_name: String):
	var character: Character = get_node(character_path)
	var item: Item = ResourceDictionary.items.get(item_name)
	
	character.inventory_manager.items.append(item.duplicate())

@rpc("any_peer", "call_local")
func take_item(character_path: NodePath, item_id: String):
	var character: Character = get_node(character_path)
	var item: Item = ResourceDictionary.items.get(item_id)
	
	var item_ind: int = character.inventory_manager.find_item(item.id)
	character.inventory_manager.items.remove_at(item_ind)
