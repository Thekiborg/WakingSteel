extends AnimationStep
class_name AnimationStepHitbox

@export var hitboxes:Array[WeaponHitboxData];
var createdHitboxes:Array[Hitbox];

func start(parent: PlayerCharacter) -> void:
	if not hitboxes.is_empty():
		spawn_hitboxes(parent)

func end(_parent: PlayerCharacter) -> void:
	for hitbox:Node3D in createdHitboxes:
		hitbox.queue_free()
		
	createdHitboxes.clear()

func spawn_hitboxes(parent: PlayerCharacter) -> void:
	for hitboxInfo in hitboxes:
		var hitbox:Hitbox = Globals.preloadedHitbox.instantiate()
		parent.add_child(hitbox)
		hitbox.position = parent.aimer.rotation_node.basis * hitboxInfo.position
		hitbox.transform.basis = Basis.from_euler(parent.aimer.rotation_node.transform.basis.get_euler())
		hitbox.set_shape_size(hitboxInfo.size)
		hitbox.parentCharacter = parent
		hitbox.data = hitboxInfo
		createdHitboxes.append(hitbox)
