extends Node3D

func _ready():
	WorldSyncronizer.spawn_item(Vector3(31.6, 0.5, -27.5), "weaponitem_pipe")
	WorldSyncronizer.spawn_item(Vector3(15.6, 0.5, -25), "plunger")
