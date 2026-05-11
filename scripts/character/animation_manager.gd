extends Node3D
class_name AnimationManager

@onready var sprite: Sprite3D = $Sprite3D
@onready var animationTimer: Timer = $AnimationTimer
var character: Character


var _animation_set: AnimationSet
var _curAnimationIndex = 0
var _facing_right: bool
var _override_low_animations: bool

var curAnimation:AnimationStep:
	get: return _animation_set.steps[_curAnimationIndex]


signal animation_finished(animation_set: AnimationSet)


func _ready() -> void:
	character = get_parent()
	sprite.texture = character.idle_animation.steps[0].sprite
	animationTimer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	curAnimation.end(character)
	if _curAnimationIndex + 1 < _animation_set.steps_count:
		AnimationSyncronizer.sync_animation_index.rpc(character.get_path(), _curAnimationIndex + 1)
		animationTimer.start(curAnimation.time)
		_start_current_animation()
	else:
		AnimationSyncronizer.sync_animation_index.rpc(character.get_path(), 0)
		_override_low_animations = false
		animation_finished.emit(_animation_set)
		_animation_set = null


func play_high_animation(new_animation_set: AnimationSet, facing_right: bool) -> void:
	_override_low_animations = true
	sync_high_animation(new_animation_set, facing_right, new_animation_set.combo.is_lmb_combo)
	animationTimer.start(curAnimation.time)


func try_play_low_animation(animation_type: Globals.LowAnimationType, facing_right: bool) -> void:
	if _override_low_animations:
		return
	var new_animation_set = get_new_animation_set(animation_type)
	if _animation_set && facing_right == _facing_right && _animation_set.name == new_animation_set.name:
		return
	sync_low_animation(animation_type, facing_right)


func get_new_animation_set(type: Globals.LowAnimationType):
	match type:
		Globals.LowAnimationType.WALK:
			return character.walking_animation
		Globals.LowAnimationType.IDLE:
			return character.idle_animation
	return character.idle_animation


func sync_high_animation(new_animation_set: AnimationSet, facing_right: bool, is_lmb_combo: bool):
	AnimationSyncronizer.sync_high_animation.rpc(character.get_path(), facing_right, is_lmb_combo, new_animation_set.name)
	_start_current_animation()


func sync_low_animation(animation_type: Globals.LowAnimationType, facing_right: bool) -> void:
	AnimationSyncronizer.sync_low_animation.rpc(character.get_path(), animation_type, facing_right)
	_start_current_animation()


func _start_current_animation() -> void:
	AnimationSyncronizer.change_animation_sprite.rpc(character.get_path())
	if curAnimation.animation_set.combo:
		curAnimation.start(
			character,
			_animation_set.combo.is_lmb_combo,
			_animation_set.combo.animations.find(_animation_set),
			_curAnimationIndex
		)
	else:
		curAnimation.start(character, false, 0, 0)
