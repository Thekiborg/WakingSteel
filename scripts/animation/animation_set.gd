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
@export var essence_cost: int
var combo: ComboSet

var steps_count: int:
	get: return steps.size()

var _total_time = -1
var total_time: int :
	get:
		if _total_time == -1:
			var temp = 0
			for step in steps:
				temp += step.time
			_total_time = temp
		return _total_time
			
			
			
			
			
			
			
			
			
			
			
			
			
