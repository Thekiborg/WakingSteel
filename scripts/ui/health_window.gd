extends AspectRatioContainer
class_name HealthWindow

@onready var bridge: PlayerUIBridge = get_parent().get_parent().get_parent()
@onready var injury_container: VBoxContainer = $"InjuriesPanelContainer/InjuriesScrollContainer/InjuryContainer"
@onready var injury_container_wrapper: PanelContainer = $"InjuriesPanelContainer"
@onready var healing_container_wrapper: PanelContainer = $"../HealingContainer"
@onready var healing_container: VBoxContainer = $"../HealingContainer/HBoxContainer/ItemButtonsScrollContainer/ItemButtonsVBoxContainer"
@onready var centering_padding: Control = $"../Padding"
var player: Player:
	get: return bridge.player
var _bodypart: BodyPart
var last_clicked_bodypart:BodyPart:
	get: return _bodypart
	set(value):
		_bodypart = value
		create_buttons_for_injuries()


func create_buttons_for_injuries() -> void:
	clear_previous_injury_buttons()
	for injury in last_clicked_bodypart.internal_injuries:
		create_injury_button(injury)
	for injury in last_clicked_bodypart.external_injuries:
		create_injury_button(injury)


func clear_previous_injury_buttons() -> void:
	for prev in injury_container.get_children():
		prev.queue_free()
	hide_healing_section()


func clear_previous_healing_buttons() -> void:
	for prev in healing_container.get_children():
		prev.queue_free()


func hide_injury_section() -> void:
	injury_container_wrapper.visible = false
	hide_healing_section()
	clear_previous_injury_buttons()


func hide_healing_section() -> void:
	healing_container_wrapper.visible = false
	centering_padding.visible = false
	clear_previous_healing_buttons()


func create_injury_button(injury: Injury) -> void:
	if not injury_container_wrapper.visible:
		injury_container_wrapper.visible = true
	var button:InjuryButton = InjuryButton.new(injury, self)
	injury_container.add_child(button)


func show_owned_healing_for(injury: Injury) -> void:
	healing_container_wrapper.visible = true
	centering_padding.visible = true
	var items: Array[String] = bridge.player.inventory_manager.get_healing_items_for(injury)
	for item in items:
		var button:HealingItemButton = HealingItemButton.new(item, injury, self)
		healing_container.add_child(button)


func open() -> void:
	visible = true


func close() -> void:
	visible = false
	hide_injury_section()


func redraw() -> void:
	queue_redraw()
	injury_container_wrapper.queue_redraw()
	healing_container_wrapper.queue_redraw()
