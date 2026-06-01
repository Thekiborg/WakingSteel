extends Node

@rpc("any_peer", "call_local")
func add_injuries(character_path: NodePath, part_name: String, injuries: Array[String]):
	var character: Character = get_node(character_path)
	var picked_part: BodyPart = character.find_bodypart(part_name)

	for injuryname in injuries:
		print(injuryname)
		var injury: Resource = ResourceDictionary.injuries.get(injuryname)
		picked_part.add_injury(injury.duplicate())


@rpc("any_peer", "call_local")
func heal_injuries(character_path: NodePath, part_name: String, external: bool, injury_name: String):
	var character: Character = get_node(character_path)
	var picked_part: BodyPart = character.find_bodypart(part_name)

	picked_part.heal_injury(external, injury_name)

@rpc("any_peer", "call_local")
func set_move_and_input(character_path: NodePath, active: bool):
	var character: Character = get_node(character_path)
	character.can_input = active
	character.can_move = active
