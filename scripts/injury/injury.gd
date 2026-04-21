extends InstancedResource
class_name Injury

@export var icon: Texture2D
@export var internal: bool
@export var name: String
@export var description: String
@export var damage: float
@export var healed_with: Array[HealingItem]
var body_part: BodyPart
