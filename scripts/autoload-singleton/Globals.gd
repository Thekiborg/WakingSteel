extends Node

enum BodyPartHeight {TOP, MIDDLE, BOTTOM}
enum BodyPartPosition {RIGHT, CENTER, LEFT}
enum LowAnimationType {WALK, IDLE}
var _world_spawner: MultiplayerSpawner
var world_spawner: MultiplayerSpawner:
	get:
		if not is_instance_valid(_world_spawner):
			_world_spawner = get_tree().current_scene.find_child("WorldSpawner", false)
		return _world_spawner
var _spawned_items: Node
var spawned_items: Node:
	get: 
		if not is_instance_valid(_spawned_items):
			_spawned_items = get_tree().current_scene.find_child("SpawnedItems", false)
		return _spawned_items


func _ready() -> void:
	world_spawner = get_tree().current_scene.find_child("WorldSpawner", false)
	spawned_items = get_tree().current_scene.find_child("SpawnedItems", false)
