extends Area3D
class_name PlayerAimer

var character: Character
@onready var rotation_node: Node3D = $rotation_node
@onready var raycast:RayCast3D = $RayCast3D

func _ready() -> void:
	character = get_parent()

func _physics_process(_delta: float) -> void:
	if not character.can_input:
		return
	var mouse_pos = character.combat_manager.get_viewport().get_mouse_position();
	raycast.global_position = Globals.camera.project_ray_origin(mouse_pos);
	raycast.target_position = Globals.camera.project_ray_normal(mouse_pos) * 300;
	if raycast.is_colliding():
		var ray_position:Vector3 = raycast.get_collision_point();
		ray_position.y = rotation_node.global_position.y
		rotation_node.look_at(ray_position, Vector3.UP, true);
