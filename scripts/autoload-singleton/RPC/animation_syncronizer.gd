extends Node


@rpc("any_peer", "call_local")
func change_animation_sprite(parent_path: NodePath):
	var character: Character = get_node(parent_path)

	if not character.animation_manager._animation_set:
		return

	character.animation_manager.sprite.texture = character.animation_manager.curAnimation.sprite
	character.animation_manager.sprite.flip_h = !character.animation_manager._facing_right
# THIS SCRIPT MAY BE CALLING TOO MUCH CHECKING RPC SETTINGS ADVISED
# CACHE ALL GET_NODE CALLS TO DICTIONARY


@rpc("any_peer", "call_local")
func sync_low_animation(parent_path: NodePath, animation_type: Globals.LowAnimationType, facing_right: bool):
	var character: Character = get_node(parent_path)
	var animation: AnimationSet = character.animation_manager.get_new_animation_set(animation_type)
	
	character.animation_manager._animation_set = animation
	character.animation_manager._facing_right = facing_right


@rpc("any_peer", "call_local")
func sync_high_animation(parent_path: NodePath, facing_right: bool, is_lmb_combo: bool, animation_name: String):
	var character: Character = get_node(parent_path)
	var combo: ComboSet
	if is_lmb_combo:
		combo = character.equippedWeapon.data.lmbCombo
	else:
		combo = character.equippedWeapon.data.rmbCombo
	var animation: AnimationSet = combo.animations.filter(func(a): return a.name == animation_name)[0]
	
	character.animation_manager._animation_set = animation
	character.animation_manager._facing_right = facing_right


@rpc("any_peer", "call_local")
func sync_animation_index(parent_path: NodePath, new_index: int):
	var character: Character = get_node(parent_path)
	character.animation_manager._curAnimationIndex = new_index
	# make curAnimationIndex a property
	
