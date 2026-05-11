extends Item
class_name HealingItem

func use(character: NodePath, injury: Injury):
	HealthSyncronizer.heal_injuries.rpc(character, injury.body_part.name, !injury.internal, injury.name)
	InventorySyncronizer.take_item.rpc(character, self.id)
	# late joined characters dont see the items earlier characters have
	# causes take item to error
	# syncronize that when a player joins?
