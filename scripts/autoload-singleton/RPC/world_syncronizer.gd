extends Node

@rpc("any_peer", "call_remote")
func despawn(item_path: NodePath):
	var node: Node = get_node(item_path)
	Globals.spawned_items.remove_child(node)
	node.queue_free()


@rpc("any_peer", "call_remote")
func spawn_item(pos: Vector3, item_id: String):
	var node: NodeItem = Preloads.NODEITEM.instantiate()
	node.data_id = item_id
	node.position = pos
	Globals.spawned_items.add_child(node, true)

@rpc("authority", "call_local")
func spawn_enemy():
	print(multiplayer.get_remote_sender_id())
	print("hi")
	var enemy = Preloads.ENEMY.instantiate()
	var erand_x = randf_range(-3., 3.)
	var erand_z = randf_range(-3., 3.)
	enemy.position = Vector3(erand_x, 2., erand_z)
	Globals.spawned_items.add_child(enemy)
	
	
