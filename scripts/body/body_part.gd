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
var forced_destroy: bool
var _health: float
var health: float:
	get:
		if forced_destroy:
			return 0
		
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


func heal_injury(external: bool, injury: String) -> void:
	var index: int = -1
	if external:
		for i in len(external_injuries):
			if external_injuries.get(i).name == injury:
				index = i
				break
		if index != -1:
			external_injuries.remove_at(index)
	else:
		for i in len(internal_injuries):
			if internal_injuries.get(i).name == injury:
				index = i
				break
		if index != -1:
			internal_injuries.remove_at(index)


func recursively_destroy_children() -> void:
	for child in children:
		child.forced_destroy = true


func check_should_destroy() -> void:
	if health <= 0:
		recursively_destroy_children()
		part_destroyed.emit(self)
