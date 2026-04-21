extends Character
class_name Player

@onready var _aimer: PlayerAimer = $Aimer
@onready var camera: Camera3D = $Camera3D
var peer_id: int

func _ready() -> void:
	super._ready()
	add_to_group("player")
	
	if not is_multiplayer_authority():
		set_process(false)
		set_physics_process(false)
		print("Someone exited")
		return
	
	camera.current = true


func _enter_tree() -> void:
	set_multiplayer_authority(int(name))


func _physics_process(delta: float) -> void:
	if not can_move:
		return
	var movement_dir:Vector2 = Input.get_vector("move-west","move-east","move-north","move-south");
	
	var hor_velocity = movement_dir * speed * delta;

	velocity += Vector3(hor_velocity.x, 0, hor_velocity.y);
	if (Input.is_action_just_pressed("jump") && is_on_floor()):
		velocity += up_direction * 2
	
	# In theory if movement_dir isn't 0 means we're moving?
	if (not movement_dir.is_equal_approx(Vector2.ZERO)):
		if (Input.is_action_pressed("move-east")):
			facing_right = true;
		if (Input.is_action_pressed("move-west")):
			facing_right = false;
		animation_manager.try_play_low_animation(Globals.LowAnimationType.WALK, facing_right)
	else:
		animation_manager.try_play_low_animation(Globals.LowAnimationType.IDLE, facing_right)
	
	if not is_on_floor():
		velocity += get_gravity() * delta;
			
	move_and_slide()
	velocity = Vector3(
		0. if is_zero_approx(movement_dir.x) else hor_velocity.x,
		velocity.y,
		0. if is_zero_approx(movement_dir.y) else hor_velocity.y);


func _unhandled_input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
	
	if (event.is_action_pressed("LMB")):
		combat_manager.lmb()
	if (event.is_action_pressed("RMB")):
		combat_manager.rmb()


func get_aimer() -> Node:
	return _aimer.rotation_node
