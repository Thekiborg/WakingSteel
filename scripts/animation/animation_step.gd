extends InstancedResource
class_name AnimationStep

@export var sprite:Texture;
@export var time:float
var animation_set: AnimationSet

func start(_parent: Character, _lmb_combo: bool, _animation_index: int, _step_index: int) -> void:
	pass

func end(_parent: Character) -> void:
	pass
