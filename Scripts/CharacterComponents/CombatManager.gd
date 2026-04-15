extends Node3D
class_name CombatManager

var character:PlayerCharacter;

var curComboStepIndex:int = 0;
var lmbComboSteps:Array[ComboStep];
var rmbComboSteps:Array[ComboStep];
var is_blocking: bool
var is_dodging: bool

var facing_right: bool:
	get: return Vector3.RIGHT.dot(character.aimer.rotation_node.global_basis.z) >= 0


@onready var comboResetTimer:Timer = $ComboResetTimer


func _ready() -> void:
	character = get_parent()
	lmbComboSteps = character.equippedWeapon.data.lmbCombo.steps
	rmbComboSteps = character.equippedWeapon.data.rmbCombo.steps
	comboResetTimer.timeout.connect(_reset_combo_step)


func lmb():
	if not character.can_input:
		return
	
	var curStep:ComboStep = lmbComboSteps[curComboStepIndex]
	_start_attack(curStep)


func rmb():
	if not character.can_input:
		return
	
	var curStep:ComboStep = rmbComboSteps[min(rmbComboSteps.size() - 1, curComboStepIndex)]
	_start_attack(curStep)


func _start_attack(combo_step:ComboStep):
	character.animation_manager.play_combo_step_animation(combo_step, facing_right)
	character.facing_right = facing_right
	character.can_input = false


func actions_after_combo_step(last_step: ComboStep):
	if last_step.parent.primary:
		curComboStepIndex = (curComboStepIndex + 1) % lmbComboSteps.size()
	else:
		curComboStepIndex = (curComboStepIndex + 1) % rmbComboSteps.size()
	comboResetTimer.start()
	character.can_input = true


func _reset_combo_step():
	curComboStepIndex = 0
