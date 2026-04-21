extends InstancedResource
class_name AnimationSet

@export var name: String
var _steps: Array[AnimationStep]
@export var steps: Array[AnimationStep]:
	get: return _steps
	set(value):
		_steps = value
		for step in _steps:
			step.animation_set = self
var combo: ComboSet

var steps_count: int:
	get: return steps.size()
