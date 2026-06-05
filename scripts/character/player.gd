extends Character
class_name Player

@export var dash_speed_mult: int = 100
@export var dash_duration: float = 1
@export var dash_cooldown: float
@onready var _aimer: PlayerAimer = $Aimer
@onready var camera: Camera3D = $Camera3D
@onready var player_uis: PlayerUIBridge = $player_uis
@onready var main_menu: AspectRatioContainer = $ESCmenu
@onready var inventory_window: AspectRatioContainer = $InventoryWindow
@onready var item_interaction_area: Area3D = $ItemInteractionArea
@onready var dash_duration_timer: Timer = $DashDurationTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var essence_meter: EssenceMeter = $EssenceMeter
@onready var revive_window: ReviveWindow = $ReviveWindow
@onready var dash_audio_player: AudioStreamPlayer3D = $DashAudioPlayer
@onready var inventory_manager: InventoryManager = $InventoryManager


var essence_count: int
var dashing: bool:
	get: return dash_duration_timer.time_left != 0
var peer_id: int

func _ready() -> void:
	super._ready()
	add_to_group("player")
	
	if not is_multiplayer_authority():
		set_process(false)
		set_physics_process(false)
		item_interaction_area.monitorable = false
		item_interaction_area.monitoring = false
		walking_audio_player.playing = false
		walking_audio_player.autoplay = false
		walking_audio_player.stream_paused = true
		return
	
	walking_audio_player.stream_paused = true
	essence_meter.player = self
	inventory_window.player = self
	player_uis.player = self
	player_uis.show()
	camera.current = true
	dash_duration_timer.timeout.connect(_dash_duration_ends)
	revive_window.player = self
	health_manager.died.connect(_died)
	health_manager.revived.connect(_revived)
	main_menu.hidden.connect(_main_menu_hidden)

func _main_menu_hidden() -> void:
	can_move = true
	can_input = true
	essence_meter.show()
	
	
func _enter_tree() -> void:
	set_multiplayer_authority(int(name))

func _physics_process(delta: float) -> void:
	if not can_move:
		walking_audio_player.stream_paused = true
		return
	var movement_dir:Vector2 = Input.get_vector("move-west","move-east","move-north","move-south");
	
	# Dash or item grab
	if (Input.is_action_just_pressed("jump")):
		if _try_to_pick_item():
			return
		elif not dashing and dash_cooldown_timer.time_left <= 0 and can_input:
			dash_audio_player.play()
			dash_duration_timer.start(dash_duration)
			combat_manager.is_dodging = true
	
	# In theory if movement_dir isn't 0 means we're moving?
	# Facing and low prio animations
	if (not movement_dir.is_equal_approx(Vector2.ZERO)):
		if (Input.is_action_pressed("move-east")):
			facing_right = true;
		if (Input.is_action_pressed("move-west")):
			facing_right = false;
		animation_manager.try_play_low_animation(Globals.LowAnimationType.WALK, facing_right)
		walking_audio_player.stream_paused = false
	else:
		if dashing:
			var aimer: Node3D = get_aimer()
			movement_dir = Vector2.UP.rotated(-aimer.rotation.y)
		animation_manager.try_play_low_animation(Globals.LowAnimationType.IDLE, facing_right)
		walking_audio_player.stream_paused = true
	
	# Move speed
	var hor_velocity = movement_dir * speed * delta;
	if dashing:
		hor_velocity *= dash_speed_mult
	velocity += Vector3(hor_velocity.x, 0, hor_velocity.y);
	
	if not is_on_floor():
		velocity += get_gravity() * delta;
	
	move_and_slide()
	velocity = Vector3(
		0. if is_zero_approx(movement_dir.x) else hor_velocity.x,
		velocity.y,
		0. if is_zero_approx(movement_dir.y) else hor_velocity.y);
	dashing = false


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

func equip_weapon(new_weapon: Weapon) -> void:
	var weapon_id
	if new_weapon == null:
		weapon_id = "null"
	else:
		weapon_id = new_weapon.name
	InventorySyncronizer.equip_weapon.rpc(self.get_path(), weapon_id)

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
		
	if event.is_action_released("open-esc-menu"):
		can_move = false
		can_input = false
		essence_meter.hide()
		main_menu.show()
	if event.is_action_pressed("open-inventory"):
		inventory_window.hide_item_actions()
		inventory_window.visible = !inventory_window.visible
		if inventory_window.visible:
			inventory_window.display_items(inventory_manager.items)

func get_aimer() -> Node3D:
	return _aimer.rotation_node

func _dash_duration_ends() -> void:
	combat_manager.is_dodging = false
	dash_cooldown_timer.start(dash_cooldown)
	
func increase_essence(count: int):
	InventorySyncronizer.update_essence.rpc_id(
		int(self.name),
		self.get_path(),
		count)

func _died() -> void:
	player_uis.hide()
	inventory_window.hide()
	essence_meter.hide()
	revive_window.show()
	set_process(false)
	set_physics_process(false)
	item_interaction_area.set_deferred("monitorable", false)
	item_interaction_area.set_deferred("monitoring", false)
	can_input = false
	can_move = false

func _revived() -> void:
	player_uis.show()
	essence_meter.show()
	revive_window.hide()
	set_process(true)
	set_physics_process(true)
	item_interaction_area.set_deferred("monitorable", true)
	item_interaction_area.set_deferred("monitoring", true)
	can_input = true
	can_move = true
