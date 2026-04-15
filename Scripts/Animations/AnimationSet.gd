extends InstancedResource
class_name AnimationSet

@export var name: String
@export var steps: Array[AnimationStep]

var steps_count: int:
	get: return steps.size()
