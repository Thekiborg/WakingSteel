extends Node

enum BodyPartHeight {TOP, MIDDLE, BOTTOM}
enum BodyPartPosition {RIGHT, CENTER, LEFT}
enum LowAnimationType {WALK, IDLE}
var world_spawner: MultiplayerSpawner
var spawned_items: Node


func _ready() -> void:
	world_spawner = get_tree().current_scene.find_child("WorldSpawner", false)
	spawned_items = get_tree().current_scene.find_child("SpawnedItems", false)
