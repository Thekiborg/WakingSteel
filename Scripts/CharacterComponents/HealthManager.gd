extends Node3D
class_name HealthManager

var _CENTER_THRESHOLD: float = 0.45


var health: float:
	get:
		if lethal_bodypart_destroyed:
			return 0
		
		var sum: float = 0
		for part in parent.get_all_bodyparts():
			sum += part.health
		return sum
var parent:Character
var lethal_bodypart_destroyed:bool = false


@onready var hurtbox: Area3D = $Hurtbox


func _ready() -> void:
	hurtbox.area_entered.connect(_on_area_entered)
	parent = get_parent()
	parent.part_destroyed.connect(_on_part_destroyed)


func _on_area_entered(area: Area3D) -> void:
	if area is not Hitbox:
		return
	var hitbox: Hitbox = area as Hitbox
	
	#if parent.combat_manager.is_blocking && not hitbox.bypasses_block:
	#	return
	#if parent.combat_manager.is_dodging && not hitbox.bypasses_dodge:
	#return

	
	if hitbox.has_hit_character(parent):
		return
		
	if hitbox.parentCharacter != parent:
		print(hitbox.parentCharacter, " hit ", parent)
		try_take_damage(hitbox)
	if (hitbox.parentCharacter == parent && hitbox.canSelfHit):
		print("Self hit")
		try_take_damage(hitbox)
		
	hitbox.register_hit_character(parent)


func try_take_damage(origin: Hitbox):
	var _health_manager: HealthManager = parent.health_manager
	if not _health_manager:
		return
	
	var hit_pos = get_hit_position(origin)
	print(Globals.BodyPartPosition.find_key(hit_pos))
	var hit_bodyparts = parent.get_potentially_hit_bodyparts(origin.height, hit_pos)
	var picked_body: BodyPart
	picked_body = hit_bodyparts.pick_random()
	if picked_body.health <= 0:
		var fallback_hit = parent.get_potentially_hit_bodyparts(origin.height, Globals.BodyPartPosition.CENTER)
		picked_body = fallback_hit.pick_random()
	
	print("Picked to hit: ", picked_body.name)
	for injury in origin.injuries:
		picked_body.add_injury(injury)
	print("Dummy: ", _health_manager.health)
	notify_received_damage()


func get_hit_position(origin: Hitbox) -> Globals.BodyPartPosition:
	var rel_pos
	if parent is PlayerCharacter:
		rel_pos = parent.aimer.to_local(origin.global_position)
	else:
		rel_pos = parent.to_local(origin.global_position)
		
	if rel_pos.x < _CENTER_THRESHOLD && rel_pos.x > -_CENTER_THRESHOLD: 
		return Globals.BodyPartPosition.CENTER
	elif (rel_pos.x < 0):
		return Globals.BodyPartPosition.RIGHT
	else:
		return Globals.BodyPartPosition.LEFT


func notify_received_damage() -> void:
	if health <= 0:
		death()


func death() -> void:
	parent.queue_free()


func _on_part_destroyed(body_part: BodyPart):
	print(body_part.name, " destroyed")
	if body_part.lethal:
		lethal_bodypart_destroyed = true
