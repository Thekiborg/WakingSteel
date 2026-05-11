extends Node

var spawned_hitboxes: Dictionary[NodePath, Array]

@rpc("any_peer", "call_local")
func clear_hitboxes(parent_path: NodePath):
	var createdHitboxes: Array = spawned_hitboxes.get(parent_path, [])
	if not createdHitboxes.is_empty():
		for hitbox:Hitbox in createdHitboxes:
			hitbox.queue_free()
		createdHitboxes.clear()


@rpc("any_peer", "call_local")
func spawn_hitboxes(parent_path: NodePath, lmb_combo: bool, animation_index: int, step_index: int):
	var player:Player = get_node(parent_path)
	
	var combo: ComboSet
	if lmb_combo:
		combo = player.equippedWeapon.data.lmbCombo
	else:
		combo = player.equippedWeapon.data.rmbCombo
	
	var stepHitboxes: AnimationStepHitbox = combo.animations[animation_index].steps[step_index] as AnimationStepHitbox
	if not stepHitboxes:
		return
	var hitboxes: Array[WeaponHitboxData] = stepHitboxes.hitboxes

	var createdHitboxes: Array[Hitbox] = []
	for hitboxInfo in hitboxes:
		var hitbox:Hitbox = Preloads.HITBOX.instantiate()
		player.add_child(hitbox)
		hitbox.position = player.get_aimer().basis * hitboxInfo.position
		hitbox.transform.basis = Basis.from_euler(player.get_aimer().transform.basis.get_euler())
		hitbox.set_shape_size(hitboxInfo.size)
		hitbox.parentCharacter = player
		hitbox.data = hitboxInfo
		createdHitboxes.append(hitbox)
	spawned_hitboxes[parent_path] = createdHitboxes
