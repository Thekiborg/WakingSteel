extends Character
class_name PlayerCharacter

@onready var aimer: PlayerAimer = $Aimer


func _physics_process(delta: float) -> void:
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
		animation_manager.try_play_low_animation(walking_animation, facing_right)
	else:
		animation_manager.try_play_low_animation(idle_animation, facing_right)
	
	if not is_on_floor():
		velocity += get_gravity() * delta;
			
	move_and_slide()
	velocity = Vector3(
		0. if is_zero_approx(movement_dir.x) else hor_velocity.x,
		velocity.y,
		0. if is_zero_approx(movement_dir.y) else hor_velocity.y);

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("LMB")):
		combat_manager.lmb()
	if (event.is_action_pressed("RMB")):
		combat_manager.rmb()
