extends AnimationStep
class_name AnimationStepHitbox

@export var hitboxes:Array[WeaponHitboxData];
var createdHitboxes:Array[Hitbox];


func start(parent: Character, lmb_combo: bool, animation_index: int, step_index: int) -> void:
	if not hitboxes.is_empty():
		spawn_hitboxes(parent, lmb_combo, animation_index, step_index)


func end(_parent: Character) -> void:
	HitboxSpawner.clear_hitboxes.rpc_id(1, _parent.get_path())


func spawn_hitboxes(parent: Character, lmb_combo: bool, animation_index: int, step_index: int) -> void:
	HitboxSpawner.spawn_hitboxes.rpc_id(1, parent.get_path(), lmb_combo, animation_index, step_index)
