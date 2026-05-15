extends Character
class_name Player

@onready var _aimer: PlayerAimer = $Aimer
@onready var camera: Camera3D = $Camera3D
@onready var player_uis: PlayerUIBridge = $player_uis
@onready var main_menu: AspectRatioContainer = $ESCmenu
@onready var inventory_window: AspectRatioContainer = $InventoryWindow
@onready var item_interaction_area: Area3D = $ItemInteractionArea
var peer_id: int

func _ready() -> void:
	super._ready()
	add_to_group("player")
	
	if not is_multiplayer_authority():
		set_process(false)
		set_physics_process(false)
		item_interaction_area.monitorable = false
		item_interaction_area.monitoring = false
		return
	
	inventory_window.player = self
	player_uis.player = self
	player_uis.show()
	camera.current = true

func _enter_tree() -> void:
	set_multiplayer_authority(int(name))

func _physics_process(delta: float) -> void:
	if not can_move:
		return
	var movement_dir:Vector2 = Input.get_vector("move-west","move-east","move-north","move-south");
	
	var hor_velocity = movement_dir * speed * delta;

	velocity += Vector3(hor_velocity.x, 0, hor_velocity.y);
	if (Input.is_action_just_pressed("jump")):
		if _try_to_pick_item():
			return
		elif is_on_floor():
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

func _try_to_pick_item() -> bool:
	if item_interaction_area.has_overlapping_areas():
		var item: NodeItem = item_interaction_area.get_overlapping_areas()[0] as NodeItem
		inventory_manager.pick_up_item(item)
		return true
	return false

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
		
	if event.is_action_released("open-esc-menu"):
		main_menu.show()
	if event.is_action_pressed("open-inventory"):
		inventory_window.hide_item_actions()
		inventory_window.display_items(inventory_manager.items)
		inventory_window.visible = !inventory_window.visible

func get_aimer() -> Node:
	return _aimer.rotation_node
