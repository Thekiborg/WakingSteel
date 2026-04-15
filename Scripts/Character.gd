extends CharacterBody3D
class_name Character

@export var speed:float = 30;

@export var equippedWeapon:Weapon
@export var walking_animation:AnimationSet
@export var idle_animation:AnimationSet
@export var body:BodyPart

@onready var combat_manager:CombatManager = $CombatManager
@onready var animation_manager:AnimationManager = $AnimationManager
@onready var health_manager: HealthManager = $HealthManager
@onready var inventory_manager: InventoryManager = $InventoryManager

var can_input:bool
var can_move:bool
var facing_right: bool = false;

signal part_destroyed(body_part: BodyPart)

func _ready() -> void:
	can_input = true
	can_move = true
	_connect_to_body_signals()


func _connect_to_body_signals():
	for part in get_all_bodyparts():
		part.part_destroyed.connect(func(body_part: BodyPart):
			self.part_destroyed.emit(body_part)
		)


func find_bodypart(part_name: String) -> BodyPart:
	for part in get_all_bodyparts():
		if part.name == part_name:
			return part
	return null


func get_all_bodyparts() -> Array[BodyPart]:
	var result: Array[BodyPart] = []
	result.append_array(get_child_bodyparts_recursive(body))
	result.append(body)
	return result


func get_child_bodyparts_recursive(root: BodyPart) -> Array[BodyPart]:
	var result: Array[BodyPart] = []
	for child in root.children:
		result.append(child)
		result.append_array(get_child_bodyparts_recursive(child))
	return result


func get_potentially_hit_bodyparts(part_height: Globals.BodyPartHeight, part_position: Globals.BodyPartPosition) -> Array[BodyPart]:
	var result:Array[BodyPart] = []
	
	for part in get_all_bodyparts():
		if part.height == part_height && part.position == part_position && part not in result:
			result.append(part)
	
	return result
