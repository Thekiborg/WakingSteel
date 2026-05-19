extends AnimationStep
class_name AnimationStepBlock

func start(parent: Character, _lmb_combo: bool, _animation_index: int, _step_index: int) -> void:
	parent.combat_manager.is_blocking = true


func end(_parent: Character) -> void:
	_parent.combat_manager.is_blocking = false
