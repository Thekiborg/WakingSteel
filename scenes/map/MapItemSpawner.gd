extends Node3D

func _ready():
	WorldSyncronizer.spawn_item(Vector3(31.6, 0.5, -27.5), "weaponitem_pipe")

	WorldSyncronizer.spawn_item(Vector3(15.5, 2.2, -23.75), "plunger")
	WorldSyncronizer.spawn_item(Vector3(15.6, 2.2, -21.4), "masilla")
	WorldSyncronizer.spawn_item(Vector3(12.2, 2.2, -13.2), "plunger")
	WorldSyncronizer.spawn_item(Vector3(22.7, 2.2, -26), "plunger")
	WorldSyncronizer.spawn_item(Vector3(30, 2.2, -15), "masilla")
	WorldSyncronizer.spawn_item(Vector3(28.5, 2.2, -13), "masilla")

	WorldSyncronizer.spawn_item(Vector3(29.5, 2.2, 1.1), "plunger")
	WorldSyncronizer.spawn_item(Vector3(32.7, 3.6, 1), "masilla")
	WorldSyncronizer.spawn_item(Vector3(32.7, 0.7, 1), "masilla")
	WorldSyncronizer.spawn_item(Vector3(36.5, 0.7, 1), "masilla")
	WorldSyncronizer.spawn_item(Vector3(35.1, 3.5, 0.8), "plunger")
	WorldSyncronizer.spawn_item(Vector3(37.3, 3.5, 0.6), "plunger")
