extends InstancedResource
class_name BodyPart

@export var max_health: float:
	set(value):
		max_health = value
		_health = value
@export var name:String
@export var height:Globals.BodyPartHeight
@export var position:Globals.BodyPartPosition
@export var lethal: bool
@export var children:Array[BodyPart]
var _health: float
var health: float:
	get:
		var total_damage = 0
		for injuryE in external_injuries:
			total_damage += injuryE.damage
		for injuryI in internal_injuries:
			total_damage += injuryI.damage
		return max_health - total_damage
	set(value): _health = max(value, 0)
var destroyed:bool:
	get: return health <= 0
var external_injuries:Array[Injury]
var internal_injuries:Array[Injury]

signal part_destroyed(body_part: BodyPart)


func add_injury(injury: Injury) -> void:
	injury.body_part = self
	if injury.internal:
		internal_injuries.append(injury)
	else:
		external_injuries.append(injury)
	check_should_destroy()


func heal_injury(injury: Injury) -> void:
	if injury.internal:
		internal_injuries.erase(injury)
	else:
		external_injuries.erase(injury)


func _damage(amount: float) -> void:
	health -= amount
	check_should_destroy()


func recursively_destroy_children() -> void:
	for child in children:
		child._damage(INF)


func check_should_destroy() -> void:
	if health <= 0:
		part_destroyed.emit(self)
		recursively_destroy_children()
		
