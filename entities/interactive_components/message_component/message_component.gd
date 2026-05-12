@icon("res://assets/icons/chat-dots-blue.svg")
class_name MessageComponent extends InteractibleComponent



@export var message := ""



var typing_speed_base := 30
var _finished_typing := false

@onready var speech_bubble: ColorRect = $CanvasLayer/SpeechBubble
@onready var label: Label = $CanvasLayer/SpeechBubble/Label


func start_interaction():
	super()
	if _running:
		label.visible_ratio = 0
		_finished_typing = false
		speech_bubble.show()

func finish_interaction():
	speech_bubble.hide()
	super()

func _ready() -> void:
	super()
	label.text = message


func _unhandled_input(event: InputEvent) -> void:
	if _running and event.is_action_pressed(&"interact"):
		if _finished_typing:
			finish_interaction()
		else:
			label.visible_ratio = 1
			_finished_typing = true
	else:
		super(event)




func _process(delta: float) -> void:
	if _running:
		if not _finished_typing and label.visible_ratio < 1 and not message.is_empty():
			if Settings.text_speed_multiplier == 1.0:
				label.visible_ratio = 1.0
			else:
				label.visible_ratio = clamp(label.visible_ratio + Settings.text_speed_multiplier * typing_speed_base * delta / message.length(), 0, 1)
			if label.visible_ratio >= 1:
				_finished_typing = true

		
