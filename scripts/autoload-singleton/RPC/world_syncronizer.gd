extends Node

@rpc("any_peer", "call_local")
func despawn(item_path: NodePath):
	var node: Node = get_node(item_path)
	node.queue_free()


@rpc("any_peer", "call_local")
func spawn_item(pos: Vector3, item_id: String):
	var node: NodeItem = Preloads.NODEITEM.instantiate()
	node.data = ResourceDictionary.items.get(item_id)
	node.position = pos
	Globals.spawned_items.add_child(node)
