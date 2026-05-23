extends AspectRatioContainer

@onready var button_start_game: Button = %ButtonStartGame
@onready var button_join: Button = %ButtonJoin
@onready var button_quit: Button = %ButtonQuit
@onready var ip_field: LineEdit = %IPField
@onready var port_field: LineEdit = %PortField
@onready var button_join_as_client: Button = %ButtonJoinAsClient
@onready var button_back: Button = %ButtonBack
@onready var start_error_label: Label = %StartErrorLabel

var IP_REGEX = RegEx.create_from_string(r"^(((?!25?[6-9])[12]\d|[1-9])?\d\.?\b){4}$")

func _ready() -> void:
	button_start_game.pressed.connect(_start_game)
	button_join.pressed.connect(_join_pressed)
	button_quit.pressed.connect(_on_quit)
	button_join_as_client.pressed.connect(_join_game)
	button_back.pressed.connect(_go_back)
	ip_field.text_changed.connect(_on_required_fields_text_changed)
	port_field.text_changed.connect(_on_required_fields_text_changed)

func _on_required_fields_text_changed(_new_text) -> void:
	button_join_as_client.disabled = _invalid_ip_field() or _invalid_port_field()

func _invalid_ip_field() -> bool:
	return (ip_field.text == ""
			or IP_REGEX.search(ip_field.text) == null)

func _invalid_port_field() -> bool:
	return (port_field.text == ""
			or int(port_field.text) < 1 or int(port_field.text) > 65535)

func _start_game() -> void:
	var err = NetworkHandler.start_server()
	if err == OK:
		hide()
		set_error("")
	elif err == ERR_CANT_CREATE:
		set_error("No se ha podido empezar el juego. El puerto 999 está ocupado.")
	else:
		set_error("Error inesperado al empezar el juego: " + error_string(err))

func set_error(msg: String):
	if msg == "":
		start_error_label.hide()
	else:
		start_error_label.show()
		start_error_label.text = msg

func _join_pressed() -> void:
	button_start_game.hide()
	button_join.hide()
	button_quit.hide()
	ip_field.show()
	port_field.show()
	button_join_as_client.show()
	button_back.show()
	set_error("")


func _join_game() -> void:
	var ip = ip_field.text
	var port = int(port_field.text)
	
	toggle_join_controls(true)
	NetworkHandler.join_server(ip, port)


func toggle_join_controls(disable: bool):
	ip_field.editable = !disable
	port_field.editable = !disable
	button_join_as_client.disabled = disable


func _go_back() -> void:
	NetworkHandler.leave_server()
	button_start_game.show()
	button_join.show()
	button_quit.show()
	ip_field.hide()
	port_field.hide()
	button_join_as_client.hide()
	button_back.hide()
	
func _on_quit() -> void:
	get_tree().quit()
