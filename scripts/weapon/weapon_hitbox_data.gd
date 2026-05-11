extends InstancedResource
class_name WeaponHitboxData

@export var position:Vector3
@export var size:Vector3
@export var injuries:Array[String]
@export var height:Globals.BodyPartHeight = Globals.BodyPartHeight.MIDDLE
@export var canSelfHit:bool
@export var bypassesDodge:bool
@export var bypassesBlock:bool
