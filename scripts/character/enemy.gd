extends Character
class_name Enemy


@onready var detection_area: Area3D = $DetectionArea
@onready var detection_area_shape: CollisionShape3D = $DetectionArea/DetectionAreaShape
@onready var enemy_behavior_manager: EnemyBehaviorManager = $EnemyBehaviorManager
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var try_attack_timer: Timer = $TryAttackTimer
@onready var rotation_node: Node3D = $RotationNode
@export var detection_radius: float = 2
@export var animation_scale: Vector3 = Vector3.ONE


signal player_found
signal player_lost

var aggrod_player: Character

func _ready() -> void:
	super._ready()
	detection_area.area_entered.connect(_player_detected)
	detection_area.area_exited.connect(_player_lost)
	enemy_behavior_manager.enemy = self
	enemy_behavior_manager.aggroed_player_changed.connect(_on_aggroed_changed)
	try_attack_timer.timeout.connect(_try_attack)
	(detection_area_shape.shape as CylinderShape3D).radius = detection_radius
	animation_manager.scale = animation_scale
	walking_audio_player.stream_paused = true
	

func _try_attack() -> void:
	if can_input:
		combat_manager.lmb()


func _start_attacking(player: Player) -> void:
	navigation_agent.target_position = player.global_position
	var detectionShape: CylinderShape3D = detection_area_shape.shape
	var detectionArea = detectionShape.radius
	if global_position.distance_to(aggrod_player.global_position) <= (detectionArea / 3) * 2:
		_try_attack()
	try_attack_timer.start()


func _stop_attacking() -> void:
	navigation_agent.target_position = global_position
	try_attack_timer.stop()


func _on_aggroed_changed(player: Character) -> void:
	aggrod_player = player
	if aggrod_player:
		_start_attacking(player)
	else:
		_stop_attacking()


func _player_detected(area: Area3D) -> void:
	player_found.emit(area)


func _player_lost(area: Area3D) -> void:
	player_lost.emit(area)


func _physics_process(delta: float) -> void:
	if not can_move:
		walking_audio_player.stream_paused = true
		return
	
	if aggrod_player:
		var detectionShape: CylinderShape3D = detection_area_shape.shape
		var detectionArea = detectionShape.radius
		if global_position.distance_to(aggrod_player.global_position) <= (detectionArea / 3) * 2:
			_start_attacking(aggrod_player)
			walking_audio_player.stream_paused = true
			return
		else:
			_stop_attacking()
			navigation_agent.target_position = aggrod_player.global_position
	
	var hor_movement_dir: Vector2 = Vector2.ZERO
	var movement_dir:Vector3 = Vector3.ZERO
	
	if not navigation_agent.is_navigation_finished() and enemy_behavior_manager.curState == EnemyBehaviorManager.States.Pursuing:
		var wantedPos: Vector3 = navigation_agent.get_next_path_position()
		movement_dir = global_position.direction_to(wantedPos)
		hor_movement_dir = Vector2(movement_dir.x, movement_dir.z)
		wantedPos.y = global_position.y
		if not rotation_node.global_position.is_equal_approx(wantedPos):
			rotation_node.look_at(wantedPos, Vector3.UP, true)
		#print(navigation_agent.is_target_reachable())
		#print("gp", global_position)
		#print("next",navigation_agent.get_next_path_position())
		#print(navigation_agent.is_navigation_finished())
		#print(navigation_agent.target_position)

	var hor_velocity: Vector2 = hor_movement_dir * speed * delta;

	velocity += Vector3(hor_velocity.x, 0, hor_velocity.y);
	# In theory if movement_dir isn't 0 means we're moving?
	if (not hor_movement_dir.is_equal_approx(Vector2.ZERO)):
		if (hor_movement_dir.x > 0):
			facing_right = true;
		if (hor_movement_dir.x < 0):
			facing_right = false;
		animation_manager.try_play_low_animation(Globals.LowAnimationType.WALK, facing_right)
		if speed > 0:
			walking_audio_player.stream_paused = false
	else:
		animation_manager.try_play_low_animation(Globals.LowAnimationType.IDLE, facing_right)
		walking_audio_player.stream_paused = true
	
	if not is_on_floor():
		velocity += get_gravity() * delta;
	
	move_and_slide()
	velocity = Vector3(
		0. if is_zero_approx(movement_dir.x) else hor_velocity.x,
		velocity.y,
		0. if is_zero_approx(movement_dir.y) else hor_velocity.y);

func get_aimer() -> Node:
	return rotation_node
