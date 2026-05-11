extends Area3D
class_name Hitbox

var hitCharacters: Array[CharacterBody3D] = []
var _parentCharacter: CharacterBody3D
var parentCharacter:
	get: return _parentCharacter
	set(value): _parentCharacter = value
var _data: WeaponHitboxData
var data:WeaponHitboxData:
	get: return _data
	set(value): _data = value
var canSelfHit:bool:
	get: return data.canSelfHit
var injuries:Array[String]:
	get: return data.injuries
var height:Globals.BodyPartHeight:
	get: return data.height
var bypasses_block:bool:
	get: return data.bypassesBlock
var bypasses_dodge:bool:
	get: return data.bypassesDodge

@onready var collisionShape: CollisionShape3D = $CollisionShape3D

func set_shape_size(newSize: Vector3) -> void:
	collisionShape.shape.size = newSize

func has_hit_character(character: CharacterBody3D) -> bool:
	return hitCharacters.has(character)

func register_hit_character(character: CharacterBody3D) -> void:
	hitCharacters.append(character)
