extends AspectRatioContainer

@onready var button_return_to_game: Button = %ButtonReturnToGame
@onready var button_exit_to_menu: Button = %ButtonExitToMenu

func _ready() -> void:
	button_return_to_game.pressed.connect(_return_to_game)
	button_exit_to_menu.pressed.connect(_exit_game)

func _return_to_game() -> void:
	hide()

func _exit_game() -> void:
	NetworkHandler.leave_server()
