extends Node

var preloadedHitbox:PackedScene = preload("res://Scenes/hitbox.tscn")

@onready var player: PlayerCharacter = get_tree().current_scene.get_node("PlayerCharacter")
var _camera:Camera3D;
@onready var camera:Camera3D:
	get:
		if not _camera:
			_camera = get_tree().root.find_child("Camera3D", true, false)
		return _camera;

enum BodyPartHeight {TOP, MIDDLE, BOTTOM}
enum BodyPartPosition {RIGHT, CENTER, LEFT}
