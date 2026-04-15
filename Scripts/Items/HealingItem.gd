extends Item
class_name HealingItem


func use(injury: Injury):
	injury.body_part.heal_injury(injury)
	Globals.player.inventory_manager.delete(self)
