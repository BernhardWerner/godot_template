extends CanvasLayer


enum TYPE { NONE, FADE_BLACK, FADE_TRANSPARENT, FADE_WHITE, JUMP_BLACK, JUMP_TRANSPARENT, JUMP_WHITE, TEAR_BLACK, BURN_BLACK }

const COLORS := {
	TYPE.FADE_BLACK: Color.BLACK,
	TYPE.FADE_WHITE: Color.WHITE,
	TYPE.JUMP_BLACK: Color.BLACK,
	TYPE.JUMP_WHITE: Color.WHITE,
	TYPE.TEAR_BLACK: Color.BLACK,
	TYPE.BURN_BLACK: Color.BLACK
}

var progress := 0.0
var type := TYPE.NONE


signal finished(type)

@onready var color_rect: ColorRect = $ColorRect

func _ready():
	_update_shader()

func _process(delta: float) -> void:
	color_rect.set_instance_shader_parameter("progress", progress)

func _update_shader():
	color_rect.set_instance_shader_parameter("type", type)
	if COLORS.has(type):
		color_rect.set_instance_shader_parameter("color", COLORS[type])

func _fade(type_: TYPE, target: float, duration: float = 0.6):
	type = type_
	_update_shader()
	var tween = create_tween()
	tween.tween_property(self, "progress", target, duration).from_current()
	tween.tween_callback(finished.emit.bind(type_))





func do_nothing() -> void:
	pass




func fade_to_black(duration: float = 1.0) -> void:
	_fade(TYPE.FADE_BLACK, 1.0, duration)

func fade_to_white(duration: float = 1.0) -> void:
	_fade(TYPE.FADE_WHITE, 1.0, duration)

func fade_to_transparent(duration: float = 1.0) -> void:
	_fade(TYPE.FADE_TRANSPARENT, 0.0, duration)





func _jump(type_: TYPE, target: float):
	type = type_
	_update_shader()
	progress = target
	finished.emit.call_deferred(type_)



func jump_to_black() -> void:
	_jump(TYPE.JUMP_BLACK, 1.0)

func jump_to_white() -> void:
	_jump(TYPE.JUMP_WHITE, 1.0)

func jump_to_transparent() -> void:
	_jump(TYPE.JUMP_TRANSPARENT, 0.0)

func tear_to_black() -> void:
	_fade(TYPE.TEAR_BLACK, 1.0)

func burn_to_black() -> void:
	_fade(TYPE.BURN_BLACK, 1.0, 0.8)
