extends InstancedResource
class_name ComboSet

var _steps:Array[ComboStep]
@export var steps:Array[ComboStep]:
	get: return _steps;
	set(value):
		_steps = value
		for step in _steps:
			step.parent = self

@export var primary:bool
