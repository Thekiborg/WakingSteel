extends Node


@rpc("any_peer", "call_local")
func despawn(item_path: NodePath):
	if !multiplayer.is_server():
		return
	var node: Node = get_node(item_path)
	Globals.spawned_items.remove_child(node)
	node.queue_free()


@rpc("any_peer", "call_local")
func spawn_item(pos: Vector3, item_id: String):
	if !multiplayer.is_server():
		return
	
	var node: NodeItem = Preloads.NODEITEM.instantiate()
	node.data_id = item_id
	node.position = pos
	Globals.spawned_items.add_child(node, true)

func spawn_lapa(pos: Vector3):
	if !multiplayer.is_server():
		return
	
	var node: Enemy = Preloads.ENEMY_LAPA.instantiate()
	node.position = pos
	Globals.spawned_items.add_child(node, true)

func spawn_timbo(pos: Vector3):
	if !multiplayer.is_server():
		return
	
	var node: Enemy = Preloads.ENEMY_TIMBO.instantiate()
	node.position = pos
	Globals.spawned_items.add_child(node, true)

func spawn_starfish(pos: Vector3):
	if !multiplayer.is_server():
		return
	
	var node: Enemy = Preloads.ENEMY_STARFISH.instantiate()
	node.position = pos
	Globals.spawned_items.add_child(node, true)


@rpc("authority", "call_local")
func create_world():
	var world = Preloads.MAP.instantiate()
	Globals.spawned_items.add_child(world)


@rpc("any_peer", "call_local")
func sync_character_death(player_path: NodePath):
	var character: Character = get_node(player_path)
	if character is Player:
		var p = character as Player
		p.can_input = false
		p.can_move = false
		p.visible = false
	else:
		character.queue_free()
	character.health_manager.emit_died_signal()
	
@rpc("any_peer", "call_local")
func sync_character_revival(player_path: NodePath):
	var character: Character = get_node(player_path)
	if character is Player:
		var p = character as Player
		p.health_manager.heal_all_bodyparts()
		p.can_input = true
		p.can_move = true
		p.visible = true
	else:
		pass
	character.health_manager.emit_revived_signal()
