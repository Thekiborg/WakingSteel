extends Item
class_name HealingItem

func use(injury: Injury):
	injury.body_part.heal_injury(injury)
	print("MAKE ITEMS GET DELETED AGAIN")
	#Globals.player.inventory_manager.delete(self)
