extends TextureRect

@export var body_part_name: String

var mask: Image
var _originalColor: Color
var hoveredColor: Color
var clicking: bool
var linked_part: BodyPart
var health_window: HealthWindow
var unhoveredColor: Color:
	set(value):
		if not _originalColor:
			_originalColor = value
	get:
		if linked_part.health == linked_part.max_health:
			return _originalColor
		if linked_part.destroyed:
			return hoveredColor * hoveredColor
		
		var progress = Maths.normalizeXY(
			0.2,
			0.9,
			linked_part.max_health - linked_part.health,
			0,
			linked_part.max_health
		)
		
		return Color.from_hsv(
			0,
			progress,
			1,
			1
		)

func _ready() -> void:
	mask = texture.get_image()
	unhoveredColor = self_modulate
	hoveredColor = self_modulate.darkened(0.3)
	health_window = get_parent().get_parent()
	linked_part = Globals.player.find_bodypart(body_part_name)
	for i in randi_range(1, 4):
		if randi_range(1, 2) == 1:
			linked_part.add_injury(load("res://Resources/cut2.tres").duplicate())
		else:
			linked_part.add_injury(load("res://Resources/cut.tres").duplicate())


func _on_click() -> void:
	if not linked_part.destroyed:
		health_window.last_clicked_bodypart = linked_part
	else:
		health_window.hide_injury_section()


func _process(_delta: float) -> void:
	if not is_visible_in_tree(): return
	
	if _mouse_in_mask():
		self_modulate = hoveredColor
		if clicking:
			self_modulate *= hoveredColor
	else:
		self_modulate = unhoveredColor
	queue_redraw()


func _input(event: InputEvent) -> void:
	if not is_visible_in_tree(): return
	
	var clickEvent: InputEventMouseButton = event as InputEventMouseButton
	if (clickEvent 
		and clickEvent.button_index == MouseButton.MOUSE_BUTTON_LEFT
		and _mouse_in_mask()):
		
		if clickEvent.is_pressed():
			clicking = true
		elif clickEvent.is_released():
			clicking = false
			_on_click()
			

func _mouse_in_mask() -> bool:
	var point: Vector2 = get_local_mouse_position()
	
	if not Rect2(Vector2.ZERO, size).has_point(point):
		return false
	
	var img_size: Vector2i = mask.get_size()
	var uv = point / size * Vector2(img_size)
	
	return not is_zero_approx(mask.get_pixelv(uv).a)
