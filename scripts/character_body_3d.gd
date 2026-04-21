extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const sensitivity = 0.002

@onready var camera_3d: Camera3D = $Camera3D
@onready var label_3d: Label3D = $Label3D
@onready var panel_container: PanelContainer = $PanelContainer
@onready var button: Button = $PanelContainer/MarginContainer/Button
var peer_id: int

func _ready() -> void:
	panel_container.hide()
	add_to_group("player")
	label_3d.text = name
	
	if not is_multiplayer_authority():
		set_process(false)
		set_physics_process(false)
		return
	
	camera_3d.current = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	button.pressed.connect(_on_press)


func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return

	if event.is_action_pressed("unlock_mouse") and panel_container.visible == false:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		panel_container.show()
	elif event.is_action_pressed("unlock_mouse") and panel_container.visible == true:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		panel_container.hide()


func _on_press() -> void:
	NetworkHandler.leave_server()

func _unhandled_input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
		
	if event is InputEventMouseMotion:
		self.rotate_y(-event.relative.x * sensitivity)
		camera_3d.rotate_x(-event.relative.y * sensitivity)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _enter_tree() -> void:
	set_multiplayer_authority(peer_id)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move-west", "move-east", "move-north", "move-south")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
