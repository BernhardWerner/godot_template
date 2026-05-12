@icon("res://assets/icons/joystick-blue.svg")
class_name PuppeteerComponent extends InteractibleComponent

@export var path_to_animation_player : NodePath
@export var animation_name := ""

@onready var animation_player : AnimationPlayer = get_node(path_to_animation_player)

func start_interaction() -> void:
	super()
	if _running:
		animation_player.play(animation_name)
	


func _ready() -> void:
	super()
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(finished_name: String) -> void:
	if _running and finished_name == animation_name:
		finish_interaction()
