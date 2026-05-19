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
	if item_ind == -1:
		print("-1? How?")
	else:
		character.inventory_manager.items.remove_at(item_ind)


@rpc("any_peer", "call_local")
func equip_weapon(character_path: NodePath, weapon_id: String):
	var character: Player = get_node(character_path)
	
	if weapon_id == "null":
		character.equippedWeapon = Preloads.WEAPON_FIST
		character.idle_animation = Preloads.PLAYER_DEFAULT_IDLE
		character.walking_animation = Preloads.PLAYER_DEFAULT_WALK
	else:
		var weapon: Weapon = ResourceDictionary.weapons.get(weapon_id)
		character.equippedWeapon = weapon
		character.walking_animation = weapon.walking_animation
		character.idle_animation = weapon.idle_animation
	character.combat_manager.refresh_combos()
	
@rpc("any_peer", "call_local")
func update_essence(character_path: NodePath, count: int):
	var character: Player = get_node(character_path)
	
	character.essence_count = max(0, min(5, character.essence_count + count))
	character.essence_meter.update_fullness_level()
