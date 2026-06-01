extends AspectRatioContainer
class_name ReviveWindow

@onready var revive_button: Button = %ReviveButton

var player: Player


func _ready() -> void:
	revive_button.pressed.connect(_revive_pressed)


func _revive_pressed() -> void:
	var rand_x = randf_range(-7, 0)
	var rand_z = randf_range(2., 7.)
	player.position = Vector3(rand_x, 3., rand_z)
	player.health_manager.revive()
