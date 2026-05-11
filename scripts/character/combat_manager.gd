extends Node
class_name CombatManager

@onready var comboResetTimer:Timer = $ComboResetTimer

var character:Character;

var curComboIndex:int = 0;
var lmbCombo:ComboSet;
var rmbCombo:ComboSet;
var is_blocking: bool
var is_dodging: bool

var facing_right: bool:
	# change rotation node
	get: return Vector3.RIGHT.dot(character.get_aimer().global_basis.z) >= 0


func _ready() -> void:
	character = get_parent()
	refresh_combos()
	print("MAKE NO WEAPON DEFAULT TO FISTS
	THE DEFAULT FIST IS DONE IT NEEDS ASSETS AND A WAY FOR THE PLAYER TO PICK ITEMS")
	comboResetTimer.timeout.connect(_reset_combo_step)
	
	# I need the character to have it's onready variables before connecting
	await character.ready
	character.animation_manager.animation_finished.connect(_on_animation_finished)


func refresh_combos() -> void:
	lmbCombo = character.equippedWeapon.data.lmbCombo
	rmbCombo = character.equippedWeapon.data.rmbCombo


func lmb():
	if not character.can_input:
		return
	
	var animation:AnimationSet = lmbCombo.animations[min(lmbCombo.animations.size() - 1, curComboIndex)]
	_start_attack(animation)


func rmb():
	if not character.can_input:
		return
	
	var animation:AnimationSet = rmbCombo.animations[min(rmbCombo.animations.size() - 1, curComboIndex)]
	_start_attack(animation)


func _start_attack(animation:AnimationSet):
	var r = facing_right
	character.animation_manager.play_high_animation(animation, r)
	character.facing_right = r
	character.can_input = false


func _on_animation_finished(last_anim: AnimationSet):
	if last_anim.combo.is_lmb_combo:
		curComboIndex = (curComboIndex + 1) % lmbCombo.animations.size()
	else:
		curComboIndex = (curComboIndex + 1) % rmbCombo.animations.size()
	comboResetTimer.start()
	character.can_input = true


func _reset_combo_step():
	curComboIndex = 0
