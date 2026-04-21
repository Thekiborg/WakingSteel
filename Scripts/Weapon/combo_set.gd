extends InstancedResource
class_name ComboSet

var _animations:Array[AnimationSet]
@export var animations:Array[AnimationSet]:
	get: return _animations
	set(value):
		_animations = value
		for anim in _animations:
			anim.combo = self

@export var is_lmb_combo:bool
