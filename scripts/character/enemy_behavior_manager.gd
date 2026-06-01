extends Node3D
class_name EnemyBehaviorManager

enum States
{
	Idle,
	Pursuing,
}

signal aggroed_player_changed

@onready var cur_state_label: Label3D = $curStateLabel
var curState: States = States.Idle

var enemy: Enemy

func _ready() -> void:
	_delayed_setup.call_deferred()

func _delayed_setup() -> void:
	enemy.player_found.connect(_on_player_found)
	enemy.player_lost.connect(_on_player_lost)
	
func _on_player_found(area: Area3D) -> void:
	if area.get_parent() is HealthManager:
		var health_manager: HealthManager = area.get_parent() as HealthManager
		var player: Character = health_manager.parent
		if player is Player and player != enemy:
			print(player.name, " found")
			update_state(States.Pursuing)
			aggroed_player_changed.emit(player)

func _on_player_lost(area: Area3D) -> void:
	if area.get_parent() is HealthManager:
		var health_manager: HealthManager = area.get_parent() as HealthManager
		var player: Character = health_manager.parent
		print(player.name, " lost")
		update_state(States.Idle)
		aggroed_player_changed.emit(null)

func update_state(new_state: States) -> void:
	curState = new_state
	cur_state_label.text = "State: " + str(States.find_key(new_state))
	
	
	
