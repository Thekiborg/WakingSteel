extends AspectRatioContainer
class_name PlayerUIBridge

@onready var open_health_window: Button = %OpenHealthWindow
@onready var padding: Control = %Padding
@onready var healing_container: PanelContainer = %HealingContainer
@onready var health_window: HealthWindow = %HealthWindow
var player: Player
