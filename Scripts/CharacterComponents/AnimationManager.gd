extends Node3D
class_name AnimationManager

@onready var sprite: Sprite3D = $Sprite3D
@onready var timer: Timer = $Timer
var character: PlayerCharacter

var _combo_step: ComboStep
var _animation_set: AnimationSet
var _curAnimationIndex = 0
var _facing_right: bool
var _override_low_animations: bool

var curAnimation:AnimationStep:
	get: return _animation_set.steps[_curAnimationIndex]

func _ready() -> void:
	character = get_parent()
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	curAnimation.end(character)
	_curAnimationIndex += 1
	if _curAnimationIndex < _animation_set.steps_count:
		timer.start(curAnimation.time)
		_start_current_animation()
	else:
		_curAnimationIndex = 0
		_override_low_animations = false
		character.combat_manager.actions_after_combo_step(_combo_step)
		_animation_set = null
		_combo_step = null

func play_combo_step_animation(combo_step: ComboStep, facing_right: bool) -> void:
	_combo_step = combo_step
	play_high_animation(_combo_step.animation, facing_right)

func play_high_animation(new_animation_set: AnimationSet, facing_right: bool) -> void:
	_override_low_animations = true
	_play_animation(new_animation_set, facing_right)
	timer.start(curAnimation.time)

func try_play_low_animation(new_animation_set: AnimationSet, facing_right: bool) -> void:
	if _override_low_animations:
		return
	if _animation_set && facing_right == _facing_right && _animation_set.name == new_animation_set.name:
		return
	_play_animation(new_animation_set, facing_right)
	
func _play_animation(new_animation_set: AnimationSet, facing_right: bool) -> void:
	_animation_set = new_animation_set
	_facing_right = facing_right
	_start_current_animation()
	
func _start_current_animation() -> void:
	sprite.texture = curAnimation.sprite
	sprite.flip_h = !_facing_right
	curAnimation.start(character)
