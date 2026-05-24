extends Character
class_name Enemy


@onready var detection_area: Area3D = $DetectionArea
@onready var detection_area_shape: CollisionShape3D = $DetectionArea/DetectionAreaShape
@onready var enemy_behavior_manager: EnemyBehaviorManager = $EnemyBehaviorManager
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var try_attack_timer: Timer = $TryAttackTimer
@onready var rotation_node: Node3D = $RotationNode
@export var detection_radius: float = 2


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


func _try_attack() -> void:
	combat_manager.lmb()


func _on_aggroed_changed(player: Character) -> void:
	aggrod_player = player
	if aggrod_player:
		navigation_agent.target_position = player.global_position
		try_attack_timer.start()
	else:
		navigation_agent.target_position = global_position
		try_attack_timer.stop()


func _player_detected(area: Area3D) -> void:
	player_found.emit(area)


func _player_lost(area: Area3D) -> void:
	player_lost.emit(area)


func _physics_process(delta: float) -> void:
	if not can_move:
		return
	
	if aggrod_player:
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
		
		var detectionShape: CylinderShape3D = detection_area_shape.shape
		var detectionArea = detectionShape.radius
		if global_position.distance_to(aggrod_player.global_position) <= detectionArea / 2:
			hor_movement_dir = Vector2.ZERO
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
	else:
		animation_manager.try_play_low_animation(Globals.LowAnimationType.IDLE, facing_right)
	
	if not is_on_floor():
		velocity += get_gravity() * delta;
	
	move_and_slide()
	velocity = Vector3(
		0. if is_zero_approx(movement_dir.x) else hor_velocity.x,
		velocity.y,
		0. if is_zero_approx(movement_dir.y) else hor_velocity.y);

func get_aimer() -> Node:
	return rotation_node
